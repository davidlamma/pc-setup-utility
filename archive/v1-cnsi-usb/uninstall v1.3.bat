@echo off

echo:
echo:
echo:

:INTRO
Color 0F

type D:\banner.txt

:INFO
Color 0D
echo:

echo Throughout the process, you will have the opportunity to select either Y or N. Pressing the N key will allow you to bypass the current step.

echo:
echo:
echo:

:SETUP
Color 0E

choice /C YN /M "Setup: We are uninstalling Winget and reinstalling the latest version. Do you want to continue?"
if %errorlevel%==1 goto REINSTALL
if %errorlevel%==2 goto LIST

echo:
echo:
echo:

:REINSTALL
Color 0D
echo Setting up... Please be patient.

Color 0F

echo:
echo:
echo:

winget source remove winget

powershell -command "Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe"


xcopy D:\settings.json %LOCALAPPDATA%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState

goto :LIST

echo:
:LIST
Color 0E
choice /C YN /M "List: Would you like to see a list of programs?"
if %errorlevel%==1 goto :LISTER
if %errorlevel%==2 goto :UNINSTALL

echo:
echo:
echo:

:LISTER
Color 0D
echo Getting your list ready... Please be patient.

Color 0F
winget list
winget --accept-package-agreements
winget --accept-source-agreements

goto :UNINSTALL

echo:
:UNINSTALL
Color 0E

choice /C YN /M "Uninstall: About to uninstall programs using winget. Would you like to continue?"
if %errorlevel%==1 goto :UNINSTALLER
if %errorlevel%==2 goto :INSTALL

echo:
echo:
echo:

:UNINSTALLER

echo:
echo:
echo:
echo Uninstalling pre-loaded HP applications
echo:
Color 09
echo 		HP
Color 0F
echo -----------------------------------------
Color 0D
echo Please be patient. This can take some time. Watch for uninstaller pop-ups.
echo:
Color 0F
echo Uninstalling.......
@echo on

winget uninstall --id AD2F1837.HPEasyClean_v10z8vjag6ke6
winget uninstall --id AD2F1837.HPDesktopSupportUtilities_v10z8vjag6ke6
winget uninstall --id AD2F1837.HPJumpStart_v10z8vjag6ke6 
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
winget uninstall --id HP_Documentation


@echo off
echo:
echo:
echo:
echo Uninstalling pre-loaded Lenovo applications
echo:
Color 04
echo 		Lenovo
Color 0F
echo -----------------------------------------
Color 0D
echo Please be patient. This can take some time. Watch for uninstaller pop-ups.
echo:
Color 0F
echo Uninstalling.......
@echo on

winget uninstall --id VantageSRV_is1
winget uninstall --id E046963F.LenovoCompanion_k1h2ywk1493x8
winget uninstall --id E0469640.SmartAppearance_5grkq8ppsgwt4
winget uninstall --id E0469640.LenovoSmartCommunication_5grkq8ppsgwt4  
winget uninstall --id E0469640.LenovoUtility_5grkq8ppsgwt4
winget uninstall --id "Lenovo Now"
winget uninstall --id CyberLinkCorp.th.Power2GoforLenovo_m916jedk64snt
winget uninstall --id CyberLinkCorp.th.PowerDVDforLenovo_m916jedk64snt
winget uninstall --id E046963F.LenovoSettingsforEnterprise_k1h2ywk1493x8
winget uninstall --id "ElevocTechnologyCo.Ltd.SmartMicrophoneSetting"
winget uninstall --id "ElevocTechnologyCo.Ltd.SmartMicrophoneSettings_tt"


@echo off
echo:
echo:
echo:
echo Uninstalling pre-loaded Microsoft applications
echo:
Color 03
echo 		Microsoft
Color 0F
echo -----------------------------------------
Color 0D
echo Please be patient. This can take some time. Watch for uninstaller pop-ups.
echo:
Color 0F
echo Uninstalling.......
@echo on

winget uninstall --id MSC
winget uninstall --id Microsoft.MinecraftEducationEdition_8we
winget uninstall --id Microsoft.549981C3F5F10_8wekyb3d8bbwe
winget uninstall --id Microsoft.MicrosoftJournal_8wekyb3d8bbwe
winget uninstall --id Microsoft.OutlookForWindows_8wekyb3d8bbwe
winget uninstall --id Microsoft.ScreenSketch_8wekyb3d8bbwe
winget uninstall --id Microsoft.SecHealthUI_8wekyb3d8bbwe
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
winget uninstall --id Microsoft.SkypeApp_kzf8qxf38zg5c
winget uninstall --id Microsoft.ZuneVideo_8wekyb3d8bbwe
winget uninstall --id Microsoft.ZuneMusic_8wekyb3d8bbwe 
winget uninstall --id Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe
winget uninstall --id microsoft.windowscommunicationsapps_8wekyb3d8bbwe
winget uninstall --id Clipchamp.Clipchamp_yxz26nhyzhsrt
winget uninstall --id "O365HomePremRetail - en-us"
winget uninstall --id "O365ProPlusRetail - es-mx"
winget uninstall --id "O365ProPlusRetail - fr-ca"
winget uninstall --id OneDriveSetup.exe
winget uninstall --id MicrosoftCorporationII.QuickAssist_8wekyb3d8bbwe
winget uninstall --id MicrosoftCorporationII.MicrosoftFamily_8wekyb3d8bbwe
winget uninstall --id "OneNoteFreeRetail - en-us"
winget uninstall --id "OneNoteFreeRetail - es-mx"
winget uninstall --id "OneNoteFreeRetail - fr-ca"


@echo off
echo:
echo:
echo:
echo Performing a deep scan for other applications
echo:
Color 02
echo 		Other
Color 0F
echo -----------------------------------------
Color 0D
echo Please be patient. This can take some time. Watch for uninstaller pop-ups.
echo:
Color 0F
echo Uninstalling.......
@echo on

winget uninstall --id C27EB4BA.DropboxOEM_xbfy0k16fey96
winget uninstall --id McAfee.WPS
winget uninstall --id SpotifyAB.SpotifyMusic_zpdnekdrzrea0
winget uninstall --id McAfeeWPSSparsePackage_1ez856j3kr9ae
winget uninstall --id "{31F6BAA-A986-45A4-8936-7C3AAAAA760B}"
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
winget uninstall --id {"BEFF0728-1E80-441E-9E23-2142634046C8"}
winget uninstall --id "{BF261888-27EC-401C-A0B4-D7362794D8B8}"
winget uninstall --id {"91E2255E-7422-404F-83F5-B18641499B68"}
winget uninstall --id "{84937F28-9CB4-49E7-A2CF-E32D97E6DAE6}"
winget uninstall --id "{25FB0D7A-ED1B-4663-809E-A54E8A4274B0}_is1"
winget uninstall --id "{13E9CBF6-6E32-40D0-874A-018DFEFB0851}_is1"

@echo off

echo:
echo:
echo:
:INSTALL
Color 0E
choice /C YN /M "Install: About to copy and install programs off the flash drive. Would you like to continue?"
if %errorlevel%==1 goto :INSTALLER
if %errorlevel%==2 goto :EOF

echo:
echo:
echo:
:INSTALLER
Color 0D
echo Copying and starting the installers... Please look out for pop-ups

Color 0F
xcopy D:\Installs C:\CNSI

Color 0D
echo:
echo:
echo You are done. Hope you have a great day!! :P

Color 0F

start C:\CNSI\Ninite.exe
start C:\CNSI\Reader.exe



goto :EOF

:EOF



