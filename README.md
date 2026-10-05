# Uninstaller & Setup Utility

A USB-stick tool that takes a new or refurbished Windows PC from "covered in OEM bloatware" to "ready to hand over". It walks you through it one Y/N step at a time.

```
1  Repair winget      fixes the broken winget that ships on a lot of new PCs
2  Inventory          saves a list of every installed app + its ID
3  Remove bloatware   Dell / HP / Lenovo / Microsoft / trialware, from a list you control
4  Install apps       Chrome, Firefox, 7-Zip, Adobe Reader... whatever you list
5  Run installers     any .exe / .msi you drop in the Installs folder
```

Answer **N** to skip any step. Every run is logged.

## Why this exists

I built this in 2024 while doing PC deployments for a small managed IT shop that had no RMM and no imaging. Every new machine got set up by hand: click through Dell, HP or Lenovo's pre-loaded apps one at a time, uninstall McAfee, then download Chrome and Reader again.

So I put a batch file on the flash drive. It started as about 60 lines in v0.8 and went through five versions as new bloatware turned up on new hardware. The original versions are kept as they were in [`archive/`](archive/v1-cnsi-usb). v2.0 is a clean rewrite in PowerShell that keeps the same step-by-step flow.

## Quick start

1. Download this repo (green **Code** button → **Download ZIP**) and unzip it onto a USB stick.
2. *(Optional)* Put any extra installers in the `Installs` folder, such as a Ninite bundle or Office.
3. On the PC, double-click **`Run Setup.bat`** and approve the admin prompt.
4. Answer Y or N at each step. Restart when it's done.

Want to see what it would do first? Run a **dry run**. It changes nothing:

```powershell
powershell -ExecutionPolicy Bypass -File .\Setup.ps1 -DryRun
```

For an unattended run that answers Yes to everything, use `-Auto`.

## Make it yours

Everything it removes or installs lives in plain text files, so you never have to edit the script.

| File | What it controls |
|---|---|
| `config/remove-apps.txt` | Bloatware to remove. One winget ID per line, or `name: Display Name`. Put `#` in front of a line to switch it off. |
| `config/install-apps.txt` | Apps to install from the internet with winget (`winget search <app>` finds the IDs). |
| `config/winget-settings.json` | winget settings copied onto the PC during step 1. |
| `Installs/` | Installers to copy to `C:\SetupKit` and run one at a time. |
| `banner.txt` | The banner at the top. Put your shop's name on it. |

**Finding new bloatware:** run step 2 (Inventory) on a fresh machine. It saves `logs/inventory-<PC>-<date>.txt` with every app's ID. Copy the junk IDs into `remove-apps.txt`, and the next machine gets them removed too. That loop is how the original list was built.

## Good to know

- **Safe by default.** Apps some people actually use (OneDrive, new Outlook, Snipping Tool, Quick Assist, Microsoft Update Health Tools) are in the list but switched off. Uncomment them if you want them gone. The Windows Security app is deliberately not on the list.
- **Apps that aren't installed are skipped**, so one list covers every brand.
- **Works with old and new winget.** Newer winget renamed its IDs (`MSIX\…`, `ARP\Machine\X64\…`), which broke lists like the original's. v2.0 finds apps directly (Store packages, then the registry uninstall keys) and accepts IDs in either format.
- **Store apps are deprovisioned too**, so they don't come back when a new user signs in.
- **It's for fresh machines.** The default list removes the Xbox apps, so on a gaming PC, comment those lines out first.
- **A few vendor uninstallers pop up a window anyway**, mostly HP Wolf Security and some Lenovo apps. Click through them.
- **Logs** go to the `logs` folder on the USB stick, or `%TEMP%\SetupKit-logs` if the stick is read-only.
- Needs Windows 10 or 11 with winget (App Installer). Step 1 repairs it if it's there but broken.

## Version history

| Version | What changed |
|---|---|
| v0.8 | First batch file: about 55 winget uninstalls, then Ninite and Reader copied from the flash drive |
| v1.0 | Y/N prompt at each step, a banner with instructions, the list grouped by vendor |
| v1.3 | Step that reinstalls winget, plus a settings.json push; list grows to about 90 apps |
| v1.4 | Beta that expanded the HP and Lenovo coverage (about 110 apps) |
| v1.5 | Uses the stick's own drive letter (`%~d0`) instead of a hard-coded `D:`/`E:`, system info header, about 120 apps |
| **v2.0** | PowerShell rewrite. Works with newer winget, whose ID format change had made the old lists quietly match nothing. Store apps are removed natively and deprovisioned for new users. Also: lists moved to config files, requests admin rights itself, dry-run and auto modes, logging, a removed / skipped / failed summary, safer defaults |

## License

MIT. Use it, change it, put your own name on the banner. If it saves you an afternoon, that's the whole point.

*by David Lamma*
