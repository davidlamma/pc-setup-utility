@echo off

echo:
echo:

type E:\banner.txt

echo:
echo:
echo Throughout the process, you will have the opportunity to select either Y or N. Pressing the N key will allow you to bypass the current step.

echo:
:SETUP

choice /C YN /M "Setup: We are uninstalling Winget and reinstalling the latest version. Do you want to continue?"
if %errorlevel%==1 goto REINSTALL
if %errorlevel%==2 goto LIST

echo:
 
:REINSTALL
echo Setting up... Please be patient.

winget source remove winget

powershell -command "Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe"

goto :LIST

echo:
:LIST
choice /C YN /M "List: Would you like to see a list of programs?"
if %errorlevel%==1 goto :LISTER
if %errorlevel%==2 goto :UNINSTALL

echo:
:LISTER
echo Getting your list ready... Please be patient.

winget list
winget --accept-package-agreements
winget --accept-source-agreements

goto :UNINSTALL

echo:
:UNINSTALL
choice /C YN /M "Uninstall: About to uninstall programs using winget. Would you like to continue?"
if %errorlevel%==1 goto :UNINSTALLER
if %errorlevel%==2 goto :INSTALL

echo:
:UNINSTALLER
@echo on
echo Please be patient. This can take some time. Watch for uninstaller pop-ups.
echo Uninstalling.......

winget uninstall --id AD2F1837.HPAudioCenter_v10z8vjag6ke6
winget uninstall --id AD2F1837.myHP_v10z8vjag6ke6
winget uninstall --id AD2F1837.HPSystemInformation_v10z8vjag6ke6
winget uninstall --id AD2F1837.HPSupportAssistant_v10z8vjag6ke6
winget uninstall --id AD2F1837.HPPowerManager_v10z8vjag6ke6
winget uninstall --id AD2F1837.HPPCHardwareDiagnosticsWindows_v10z8vjag6ke6
winget uninstall --id AD2F1837.HPInc.EnergyStar_v10z8vjag6ke6
winget uninstall --id AD2F1837.HPPCHardwareDiagnosticsWindows_v10z8vjag6ke6
winget uninstall --id AD2F1837.HPPrinterControl_v10z8vjag6ke6
winget uninstall --id AD2F1837.HPPrivacySettings_v10z8vjag6ke6
winget uninstall --id AD2F1837.HPQuickDrop_v10z8vjag6ke6
winget uninstall --id AD2F1837.HPSupportAssistant_v10z8vjag6ke6
winget uninstall --id AD2F1837.HPSystemEventUtility_v10z8vjag6ke6
winget uninstall --id AD2F1837.myHP_v10z8vjag6ke6
winget uninstall --id C27EB4BA.DropboxOEM_xbfy0k16fey96
winget uninstall --id Clipchamp.Clipchamp_yxz26nhyzhsrt
winget uninstall --id HP_Documentation
winget uninstall --id VantageSRV_is1
winget uninstall --id MSC
winget uninstall --id Microsoft.OutlookForWindows_8wekyb3d8bbwe
winget uninstall --id Microsoft.ScreenSketch_8wekyb3d8bbwe
winget uninstall --id Microsoft.SecHealthUI_8wekyb3d8bbwe 
winget uninstall --id McAfeeWPSSparsePackage_1ez856j3kr9ae
winget uninstall --id Microsoft.549981C3F5F10_8wekyb3d8bbwe
winget uninstall --id Microsoft.BingNews_8wekyb3d8bbwe
winget uninstall --id Microsoft.GamingApp_8wekyb3d8bbwe
winget uninstall --id Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe
winget uninstall --id Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe
winget uninstall --id Microsoft.MixedReality.Portal_8wekyb3d8bbwe
winget uninstall --id Microsoft.Todos_8wekyb3d8bbwe
winget uninstall --id Microsoft.Whiteboard_8wekyb3d8bbwe
winget uninstall --id Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe
winget uninstall --id Microsoft.WindowsMaps_8wekyb3d8bbwe
winget uninstall --id Microsoft.Xbox.TCUI_8wekyb3d8bbwe
winget uninstall --id Microsoft.XboxGameOverlay_8wekyb3d8bbwe
winget uninstall --id Microsoft.XboxGamingOverlay_8wekyb3d8bbwe
winget uninstall --id Microsoft.YourPhone_8wekyb3d8bbwe
winget uninstall --id MicrosoftTeams_8wekyb3d8bbwe
winget uninstall --id McAfee.WPS
winget uninstall --id "O365HomePremRetail - en-us"
winget uninstall --id OneDriveSetup.exe
winget uninstall --id SpotifyAB.SpotifyMusic_zpdnekdrzrea0
winget uninstall --id microsoft.windowscommunicationsapps_8wekyb3d8bbwe
winget uninstall --id MicrosoftCorporationII.QuickAssist_8wekyb3d8bbwe
winget uninstall --id MicrosoftCorporationII.MicrosoftFamily_8wekyb3d8bbwe
winget uninstall --id Microsoft.ZuneVideo_8wekyb3d8bbwe
winget uninstall --id Microsoft.ZuneMusic_8wekyb3d8bbwe 
winget uninstall --id Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe
winget uninstall --id "OneNoteFreeRetail - en-us"
winget uninstall --id {"0ebb04c1-1fe8-4092-98b8-60acd20c184b"}
winget uninstall --id "{35ED3F83-4BDC-4c44-8EC6-6A8301C7413A}"
winget uninstall --id {6468C4A5-E47E-405F-B675-A70A70983EA6}
winget uninstall --id {"DE19530B-11E5-4F64-BAFF-751F9182E593"}
winget uninstall --id {"2439AE5C-1F6E-4AD4-A403-D1BD8C6945B4"}
winget uninstall --id "{2A23BD00-9533-11EE-9C02-3863BB3CB5A8}"
winget uninstall --id {"5CD25FCD-D218-46D0-B405-E5A488969BDF"}
winget uninstall --id "{6468C4A5-E47E-405F-B675-A70A70983EA6}"
winget uninstall --id {"84937F28-9CB4-49E7-A2CF-E32D97E6DAE6"}
winget uninstall --id "{91E2255E-7422-404F-83F5-B18641499B68}" 
winget uninstall --id {"C2F1EB22-02EB-4B5A-82F5-62C83BEF6626"}
winget uninstall --id "{C6FD611E-7EFE-488C-A0E0-974C09EF6473}"

@echo off
echo:
:INSTALL
choice /C YN /M "Install: About to copy and install programs off the flash drive. Would you like to continue?"
if %errorlevel%==1 goto :INSTALLER
if %errorlevel%==2 goto :EOF

echo:
:INSTALLER
echo Copying and starting the installers... Please look out for pop-ups

xcopy E:\Installs C:\CNSI


start C:\CNSI\Ninite.exe
start C:\CNSI\Reader.exe

echo:

goto :EOF

:EOF

echo:

echo You are done. Hope you have a great day!! :)

echo: