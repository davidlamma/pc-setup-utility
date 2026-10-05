<#
.SYNOPSIS
    Uninstaller & Setup Utility v2.0 - guided Windows PC setup from a USB stick.

.DESCRIPTION
    Walks a tech through prepping a new or refurbished Windows PC, one Y/N step
    at a time:
        1. Repair winget       re-register App Installer, reset sources, copy settings
        2. Inventory           save a list of installed apps (to grow the bloat list)
        3. Remove bloatware    everything in config\remove-apps.txt
        4. Install apps        everything in config\install-apps.txt (via winget)
        5. Run installers      every .exe / .msi in the Installs folder
    Answer N to skip any step. A log of the run is saved to the logs folder.

.PARAMETER Auto
    Answer Yes to every step (unattended run).

.PARAMETER DryRun
    Show what would be removed / installed without changing anything.

.EXAMPLE
    Double-click "Run Setup.bat"   (recommended - it handles admin rights)

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\Setup.ps1 -DryRun

.NOTES
    Author : David Lamma
    License: MIT
    Started life as a batch file on a USB stick in 2024 - see the archive folder.
#>
[CmdletBinding()]
param(
    [switch]$Auto,
    [switch]$DryRun
)

$Version    = '2.0'
$Root       = $PSScriptRoot
$ConfigDir  = Join-Path $Root 'config'
$InstallDir = Join-Path $Root 'Installs'
$DropDir    = 'C:\SetupKit'
$Stamp      = Get-Date -Format 'yyyyMMdd-HHmmss'

# winget exit codes we treat as "fine"
$NOT_INSTALLED     = -1978335212   # 0x8A150014  no installed package matched
$ALREADY_INSTALLED = -1978335189   # 0x8A15002B  installed, no upgrade available
$REBOOT_TO_FINISH  = -1978334967   # 0x8A150109  done, needs a restart

# ---------------------------------------------------------------- admin check
$identity  = [Security.Principal.WindowsIdentity]::GetCurrent()
$isAdmin   = ([Security.Principal.WindowsPrincipal]$identity).IsInRole(
                [Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin -and -not $DryRun) {
    Write-Host 'Requesting administrator rights...' -ForegroundColor Yellow
    $argList = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    if ($Auto) { $argList += ' -Auto' }
    try {
        Start-Process powershell.exe -Verb RunAs -ArgumentList $argList
    } catch {
        Write-Host 'Admin rights were declined. Right-click Setup and choose "Run as administrator".' -ForegroundColor Red
        Read-Host 'Press Enter to exit'
    }
    exit
}

# ---------------------------------------------------------------- logging
# Logs go next to the script (the USB stick). If that's read-only, use TEMP.
$LogDir = Join-Path $Root 'logs'
try   { New-Item -ItemType Directory -Path $LogDir -Force -ErrorAction Stop | Out-Null }
catch { $LogDir = Join-Path $env:TEMP 'SetupKit-logs'; New-Item -ItemType Directory -Path $LogDir -Force | Out-Null }
$LogFile = Join-Path $LogDir "setup-$env:COMPUTERNAME-$Stamp.log"
try { Start-Transcript -Path $LogFile -ErrorAction Stop | Out-Null } catch { }

# ---------------------------------------------------------------- helpers
function Write-Header([string]$Text) {
    Write-Host ''
    Write-Host ('=' * 70) -ForegroundColor DarkCyan
    Write-Host "  $Text" -ForegroundColor Cyan
    Write-Host ('=' * 70) -ForegroundColor DarkCyan
}

function Confirm-Step([string]$Question) {
    if ($Auto) { Write-Host "$Question [auto: Y]" -ForegroundColor Magenta; return $true }
    while ($true) {
        $answer = Read-Host "$Question (Y/N)"
        if ($answer -match '^(y|yes)$') { return $true }
        if ($answer -match '^(n|no)$')  { return $false }
    }
}

function Write-Result([string]$Tag, [string]$Text, [string]$Color) {
    Write-Host ('  [{0,-7}] ' -f $Tag) -ForegroundColor $Color -NoNewline
    Write-Host $Text
}

function Format-Code([int]$Code) { '0x{0:X8}' -f $Code }

# Reads a config list: skips blanks and # comments, keeps [Section] headers.
function Read-ConfigList([string]$Path) {
    $section = 'Apps'
    foreach ($raw in Get-Content -Path $Path) {
        $line = $raw.Trim()
        if ($line -eq '' -or $line.StartsWith('#')) { continue }
        if ($line -match '^\[(.+)\]$') { $section = $Matches[1]; continue }
        if ($line -match '^name:\s*(.+)$') {
            [pscustomobject]@{ Section = $section; By = 'name'; Value = $Matches[1].Trim() }
        } else {
            # Accept IDs copied from newer winget's inventory output too:
            #   MSIX\Name_1.2.3.0_x64__hash  -> Name_hash
            #   ARP\Machine\X64\{GUID}       -> {GUID}
            if ($line -match '^MSIX\\(.+)$') {
                $parts = $Matches[1].Split('_'); $line = "$($parts[0])_$($parts[-1])"
            } elseif ($line -match '^ARP\\[^\\]+\\[^\\]+\\(.+)$') {
                $line = $Matches[1]
            }
            [pscustomobject]@{ Section = $section; By = 'id';   Value = $line }
        }
    }
}

# Finds winget even when it isn't on PATH (common in elevated/fresh sessions).
function Get-WingetPath {
    $cmd = Get-Command winget.exe -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    $found = Get-ChildItem "$env:ProgramFiles\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe" -ErrorAction SilentlyContinue |
             Sort-Object FullName | Select-Object -Last 1
    if ($found) { return $found.FullName }
    return $null
}

function Get-WingetVersion([string]$Winget) {
    $text = (& $Winget --version 2>$null | Out-String).Trim()
    if ($text -match '(\d+)\.(\d+)') { return [version]"$($Matches[1]).$($Matches[2])" }
    return [version]'0.0'
}

# Extra flags that only newer winget builds understand.
function Get-QuietArgs([version]$WingetVersion) {
    $quiet = @('--accept-source-agreements')
    if ($WingetVersion -ge [version]'1.4') { $quiet += '--disable-interactivity' }
    return $quiet
}

# Store (MSIX) apps are listed by package family name: Name_publisherhash
function Test-IsStoreId([string]$Value) { $Value -match '^[^\\{\s]+_[a-z0-9]{13}$' }

# Looks an entry up on this PC. Returns $null if it isn't installed.
#   Store apps      -> found with Get-AppxPackage (exact family name)
#   Classic apps    -> found by registry uninstall key name (GUID, VantageSRV_is1, ...)
#   name: entries   -> left to winget's display-name match
# Newer winget lists these as MSIX\<full name> / ARP\Machine\X64\<key>, so the
# IDs people copied from older winget no longer match - this bridges the two.
function Find-App($App) {
    if ($App.By -eq 'name') {
        $listArgs = @('list', '--name', $App.Value, '--exact') + $quiet
        & $winget @listArgs 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { return [pscustomobject]@{ Kind = 'name'; Target = $App.Value } }
        return $null
    }
    if (Test-IsStoreId $App.Value) {
        $pkgs = @(if ($isAdmin) { Get-AppxPackage -AllUsers -ErrorAction SilentlyContinue } else { Get-AppxPackage -ErrorAction SilentlyContinue }) |
                Where-Object { $_.PackageFamilyName -eq $App.Value }
        $prov = @(if ($isAdmin) { Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue }) |
                Where-Object { "$($_.DisplayName)_$($_.PublisherId)" -eq $App.Value }
        if ($pkgs -or $prov) { return [pscustomobject]@{ Kind = 'appx'; Target = $pkgs; Provisioned = $prov } }
        return $null
    }
    $hives = @(
        @{ Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';             Scope = 'Machine\X64' },
        @{ Path = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'; Scope = 'Machine\X86' },
        @{ Path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';             Scope = 'User\X64' }
    )
    foreach ($hive in $hives) {
        if (Test-Path -LiteralPath (Join-Path $hive.Path $App.Value)) {
            return [pscustomobject]@{ Kind = 'arp'; Target = "ARP\$($hive.Scope)\$($App.Value)" }
        }
    }
    return $null
}

# Removes something Find-App found. Returns $true on success.
function Remove-App($Found, $App) {
    switch ($Found.Kind) {
        'appx' {
            $ok = $true
            foreach ($pkg in @($Found.Target)) {
                try { Remove-AppxPackage -Package $pkg.PackageFullName -AllUsers -ErrorAction Stop }
                catch { Write-Verbose $_.Exception.Message; $ok = $false }
            }
            # Also stop it reinstalling for new user profiles
            foreach ($prov in @($Found.Provisioned)) {
                try { Remove-AppxProvisionedPackage -Online -PackageName $prov.PackageName -ErrorAction Stop | Out-Null }
                catch { Write-Verbose $_.Exception.Message }
            }
            return $ok
        }
        default {
            $flag = if ($Found.Kind -eq 'name') { '--name' } else { '--id' }
            $wgArgs = @('uninstall', $flag, $Found.Target, '--exact', '--silent') + $quiet
            & $winget @wgArgs 2>&1 | Out-Null
            $code = $LASTEXITCODE
            # Older winget builds use the bare key instead of ARP\...
            if ($code -eq $NOT_INSTALLED -and $Found.Kind -eq 'arp') {
                $wgArgs = @('uninstall', '--id', $App.Value, '--exact', '--silent') + $quiet
                & $winget @wgArgs 2>&1 | Out-Null
                $code = $LASTEXITCODE
            }
            $script:LastCode = $code
            return ($code -eq 0 -or $code -eq $REBOOT_TO_FINISH)
        }
    }
}

# ---------------------------------------------------------------- banner
Clear-Host
$bannerPath = Join-Path $Root 'banner.txt'
if (Test-Path $bannerPath) { Get-Content $bannerPath | ForEach-Object { Write-Host $_ -ForegroundColor Cyan } }

Write-Header "System Info"
$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem
$bios = Get-CimInstance Win32_BIOS
Write-Host ("  Date/Time : {0}" -f (Get-Date))
Write-Host ("  User      : {0}" -f $identity.Name)
Write-Host ("  Computer  : {0}  ({1} {2})" -f $env:COMPUTERNAME, $cs.Manufacturer, $cs.Model)
Write-Host ("  Serial    : {0}" -f $bios.SerialNumber)
Write-Host ("  OS        : {0}  build {1}" -f $os.Caption, $os.BuildNumber)
Write-Host ("  Log file  : {0}" -f $LogFile)
if ($DryRun) { Write-Host "`n  DRY RUN - nothing on this PC will be changed." -ForegroundColor Magenta }
Write-Host ''
Write-Host '  Each step asks Y or N. Answering N skips to the next step.' -ForegroundColor Yellow

$Summary = [ordered]@{}

# ---------------------------------------------------------------- 1. repair winget
$winget = Get-WingetPath
Write-Header "Step 1 of 5 - Repair winget"
Write-Host '  Pre-loaded copies of winget often fail to list or uninstall apps.'
Write-Host '  This re-registers App Installer, resets its sources and copies settings.'
if (Confirm-Step '  Repair winget now?') {
    if ($DryRun) {
        Write-Result 'dry' 'Would re-register App Installer, reset sources, copy winget-settings.json' Magenta
    } else {
        try {
            Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe -ErrorAction Stop
            Write-Result 'ok' 'App Installer registered' Green
        } catch {
            Write-Result 'warn' "Could not re-register App Installer: $($_.Exception.Message)" Yellow
        }
        $winget = Get-WingetPath
        if ($winget) {
            & $winget source reset --force | Out-Null
            & $winget source update | Out-Null
            Write-Result 'ok' 'winget sources reset and updated' Green

            $settingsDir = Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState'
            if (Test-Path $settingsDir) {
                Copy-Item (Join-Path $ConfigDir 'winget-settings.json') (Join-Path $settingsDir 'settings.json') -Force
                Write-Result 'ok' 'winget settings copied' Green
            }
        }
    }
}

if (-not $winget) {
    Write-Host ''
    Write-Result 'error' 'winget was not found on this PC.' Red
    Write-Host '           Install "App Installer" from the Microsoft Store (or https://aka.ms/getwinget),'
    Write-Host '           then run this again. Skipping the winget steps.'
} else {
    $wingetVersion = Get-WingetVersion $winget
    $quiet = Get-QuietArgs $wingetVersion
    Write-Host "  winget version: $wingetVersion" -ForegroundColor DarkGray

    # ------------------------------------------------------------ 2. inventory
    Write-Header "Step 2 of 5 - Inventory"
    Write-Host '  Saves a list of every installed app and its ID to the logs folder.'
    Write-Host '  Use it to find new bloatware IDs for config\remove-apps.txt.'
    if (Confirm-Step '  Save an inventory of installed apps?') {
        $invFile = Join-Path $LogDir "inventory-$env:COMPUTERNAME-$Stamp.txt"
        & $winget list @quiet | Out-File -FilePath $invFile -Encoding utf8
        Write-Result 'ok' "Saved to $invFile" Green
    }

    # ------------------------------------------------------------ 3. remove bloat
    Write-Header "Step 3 of 5 - Remove bloatware"
    $removeList = @(Read-ConfigList (Join-Path $ConfigDir 'remove-apps.txt'))
    Write-Host "  $($removeList.Count) entries in config\remove-apps.txt. Apps that aren't installed are skipped."
    Write-Host '  Watch for uninstaller pop-ups - a few vendor apps insist on asking.'
    if (Confirm-Step '  Remove bloatware now?') {
        $removed = 0; $skipped = 0; $failed = @()
        $lastSection = ''
        foreach ($app in $removeList) {
            if ($app.Section -ne $lastSection) {
                Write-Host "`n  $($app.Section)" -ForegroundColor Cyan
                $lastSection = $app.Section
            }
            $found = Find-App $app
            if (-not $found) { Write-Result '--' $app.Value DarkGray; $skipped++; continue }
            if ($DryRun)     { Write-Result 'would' "remove $($app.Value)" Magenta; $removed++; continue }

            $script:LastCode = $null
            if (Remove-App $found $app) {
                Write-Result 'removed' $app.Value Green; $removed++
            } else {
                $why = if ($script:LastCode) { "  ($(Format-Code $script:LastCode))" } else { '' }
                Write-Result 'FAIL' "$($app.Value)$why" Red
                $failed += $app.Value
            }
        }
        $Summary[$(if ($DryRun) { 'Would remove' } else { 'Removed' })] = $removed
        $Summary['Not installed'] = $skipped
        $Summary['Remove failed'] = $failed.Count
        if ($failed.Count) {
            Write-Host "`n  These didn't uninstall cleanly - check Settings > Apps:" -ForegroundColor Yellow
            $failed | ForEach-Object { Write-Host "    $_" }
        }
    }

    # ------------------------------------------------------------ 4. install apps
    Write-Header "Step 4 of 5 - Install apps"
    $installList = @(Read-ConfigList (Join-Path $ConfigDir 'install-apps.txt'))
    Write-Host ('  From config\install-apps.txt: ' + (($installList | ForEach-Object Value) -join ', '))
    if ($installList.Count -and (Confirm-Step '  Install these apps with winget?')) {
        $installed = 0; $failed = @()
        foreach ($app in $installList) {
            if ($DryRun) { Write-Result 'dry' $app.Value Magenta; continue }
            Write-Host "  Installing $($app.Value)..." -ForegroundColor DarkGray
            $wgArgs = @('install', '--id', $app.Value, '--exact', '--silent', '--accept-package-agreements') + $quiet
            & $winget @wgArgs | Out-Null
            $code = $LASTEXITCODE
            if ($code -eq 0 -or $code -eq $REBOOT_TO_FINISH) {
                Write-Result 'ok' $app.Value Green; $installed++
            } elseif ($code -eq $ALREADY_INSTALLED) {
                Write-Result 'have' "$($app.Value) (already installed)" DarkGray
            } else {
                Write-Result 'FAIL' "$($app.Value)  ($(Format-Code $code))" Red
                $failed += $app.Value
            }
        }
        $Summary['Installed']      = $installed
        $Summary['Install failed'] = $failed.Count
    }
}

# ---------------------------------------------------------------- 5. local installers
Write-Header "Step 5 of 5 - Run installers from the Installs folder"
$installers = @(Get-ChildItem -Path $InstallDir -File -ErrorAction SilentlyContinue |
                Where-Object { $_.Extension -in '.exe', '.msi' } | Sort-Object Name)
if (-not $installers.Count) {
    Write-Host '  No .exe or .msi files in the Installs folder - skipping.' -ForegroundColor DarkGray
} else {
    Write-Host ('  Found: ' + (($installers | ForEach-Object Name) -join ', '))
    Write-Host "  They'll be copied to $DropDir and run one at a time."
    if (Confirm-Step '  Run these installers?') {
        if ($DryRun) {
            $installers | ForEach-Object { Write-Result 'dry' $_.Name Magenta }
        } else {
            New-Item -ItemType Directory -Path $DropDir -Force | Out-Null
            $ran = 0
            foreach ($file in $installers) {
                $local = Join-Path $DropDir $file.Name
                Copy-Item $file.FullName $local -Force
                Write-Host "  Running $($file.Name) - finish its window to continue..." -ForegroundColor DarkGray
                if ($file.Extension -eq '.msi') {
                    $p = Start-Process msiexec.exe -ArgumentList "/i `"$local`"" -Wait -PassThru
                } else {
                    $p = Start-Process -FilePath $local -Wait -PassThru
                }
                Write-Result 'done' "$($file.Name) (exit $($p.ExitCode))" Green
                $ran++
            }
            $Summary['Installers run'] = $ran
        }
    }
}

# ---------------------------------------------------------------- done
Write-Header "Summary"
if ($Summary.Count) {
    foreach ($key in $Summary.Keys) { Write-Host ("  {0,-15}: {1}" -f $key, $Summary[$key]) }
} else {
    Write-Host '  Nothing was run.'
}
Write-Host "  Log saved to   : $LogFile"
Write-Host ''
Write-Host '  A restart is recommended to finish removals.' -ForegroundColor Yellow
Write-Host '  You are done. Hope you have a great day!! :P' -ForegroundColor Magenta
try { Stop-Transcript | Out-Null } catch { }
if (-not $Auto) { Read-Host "`nPress Enter to exit" | Out-Null }
