@echo off

echo:
echo:
echo:

type e:\banner.txt

echo:

echo [33mThroughout the process, you will have the opportunity to select either Y or N. Pressing the N key will allow you to bypass the current step.[0m

echo:
echo:
echo:

:SETUP

choice /C YN /M "Setup: We are uninstalling Winget and reinstalling the latest version. Do you want to continue?"
if %errorlevel%==1 goto REINSTALL
if %errorlevel%==2 goto LIST

echo:
echo:
echo:

:REINSTALL
echo [33mSetting up... Please be patient.[0m
echo:
echo:
echo:

winget source remove winget

powershell -command "Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe"

xcopy e:\settings.json %LOCALAPPDATA%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState

goto :LIST

echo:
:LIST
choice /C YN /M "List: Would you like to see a list of programs?"
if %errorlevel%==1 goto :LISTER
if %errorlevel%==2 goto :UNINSTALL

echo:
echo:
echo:
:LISTER
echo [33mGetting your list ready... Please be patient.[0m

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
echo:
echo:
:UNINSTALLER

echo:
echo:
echo:
echo [33mUninstalling pre-loaded Dell applications[0m
echo:
echo [34m      Dell[0m
echo -----------------------------------------
echo [33mPlease be patient. This can take some time. Watch for any uninstaller pop-ups.[0m
echo:
echo [33mUninstalling.......[0m
@echo on


winget uninstall --id DellInc.DellCustomerConnect_htrsf667h5k
winget uninstall --id DellInc.DellDigitalDelivery_htrsf667h5k
winget uninstall --id DellInc.MyDell_htrsf667h5kn2

echo:
echo:
echo:
echo [33mUninstalling pre-loaded HP applications[0m
echo:
echo [34m      HP[0m
echo -----------------------------------------
echo [33mPlease be patient. This can take some time. Watch for any uninstaller pop-ups.[0m
echo:
echo [33mUninstalling.......[0m
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
winget uninstall --id AD2F1837.HPDesktopSupportUtilities_v10z8vjag6ke6
winget uninstall --id "{7D786AA9-518E-4AC7-97FD-D889A4102B0D}"
winget uninstall --id HP_Documentation


@echo off
echo:
echo:
echo:
echo [33mUninstalling pre-loaded Lenovo applications[0m
echo:
echo [31m      Lenovo[0m
echo -----------------------------------------
echo [33mPlease be patient. This can take some time. Watch for any uninstaller pop-ups.[0m
echo:
echo [33mUninstalling.......[0m
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
winget uninstall --id E046963F.LenovoSettingsforEnterprise_k1h2ywk1493x8


@echo off
echo:
echo:
echo:
echo [33mUninstalling pre-loaded Microsoft applications[0m
echo:
echo [32m      Microsoft[0m
echo -----------------------------------------
echo [33mPlease be patient. This can take some time. Watch for any uninstaller pop-ups.[0m
echo:
echo [33mUninstalling.......[0m
@echo on

winget uninstall --id Microsoft.Advertising.Xaml_8wekyb3d8bbwe
winget uninstall --id MSC
winget uninstall --id Microsoft.OneConnect_8wekyb3d8bbwe
winget uninstall --id Microsoft.MinecraftEducationEdition_8we
winget uninstall --id Microsoft.549981C3F5F10_8wekyb3d8bbwe
winget uninstall --id Microsoft.MicrosoftJournal_8wekyb3d8bbwe
winget uninstall --id Microsoft.OutlookForWindows_8wekyb3d8bbwe
winget uninstall --id Microsoft.ScreenSketch_8wekyb3d8bbwe
winget uninstall --id Microsoft.SecHealthUI_8wekyb3d8bbwe
winget uninstall --id Microsoft.549981C3F5F10_8wekyb3d8bbwe
winget uninstall --id Microsoft.BingNews_8wekyb3d8bbwe
winget uninstall --id Microsoft.BingWeather_8wekyb3d8bbwe
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
winget uninstall --id Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe
winget uninstall --id Microsoft.XboxIdentityProvider_8wekyb3d8bbwe
winget uninstall --id Microsoft.YourPhone_8wekyb3d8bbwe
winget uninstall --id MicrosoftTeams_8wekyb3d8bbwe
winget uninstall --id Microsoft.SkypeApp_kzf8qxf38zg5c
winget uninstall --id Microsoft.ZuneVideo_8wekyb3d8bbwe
winget uninstall --id Microsoft.ZuneMusic_8wekyb3d8bbwe 
winget uninstall --id Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe
winget uninstall --id microsoft.windowscommunicationsapps_8wekyb3d8bbwe
winget uninstall --id Clipchamp.Clipchamp_yxz26nhyzhsrt
winget uninstall --id Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe
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

echo [33mUninstalling Other applications[0m
echo:
echo [35m      Other[0m
echo -----------------------------------------
echo [33mPlease be patient. This can take some time. Watch for any uninstaller pop-ups.[0m
echo:
echo [33mUninstalling.......[0m
@echo on


winget uninstall --id Adobe Flash Player PPAPI
winget uninstall --id king.com.CandyCrushSodaSaga_kgqvnymyfvs32
winget uninstall --id A278AB0D.MarchofEmpires_h6adky7gbf63m
winget uninstall --id McAfee.WPS
winget uninstall --id McAfeeWPSSparsePackage_1ez856j3kr9ae
winget uninstall --id "{35ED3F83-4BDC-4c44-8EC6-6A8301C7413A}"
winget uninstall --id SpotifyAB.SpotifyMusic_zpdnekdrzrea0
winget uninstall --id C27EB4BA.DropboxOEM_xbfy0k16fey96
winget uninstall --id "{ABAF0FD5-B68C-4932-B72E-7B7D40B6DA40}_is1"
winget uninstall --id "{31F6BAA-A986-45A4-8936-7C3AAAAA760B}"
winget uninstall --id {"0ebb04c1-1fe8-4092-98b8-60acd20c184b"}
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
winget uninstall --id "{6E176115-6EB6-4D5D-948F-A6347E3DAB56}"
winget uninstall --id "{0C0B6015-DAED-49EF-B16A-D43000F279FD}"
winget uninstall --id "{18A8E78B-9EF2-496E-B310-BCD8E4C1DAB3}"
winget uninstall --id "{D5C69738-B486-402E-85AC-2456D98A64E4}"

@echo off

echo:
echo:
echo:
:INSTALL
choice /C YN /M "Install: About to copy and install programs off the flash drive. Would you like to continue?"
if %errorlevel%==1 goto :INSTALLER
if %errorlevel%==2 goto :EOF

echo:
echo:
echo:
:INSTALLER
echo [33mCopying and starting the installers... Please look out for pop-ups[0m

xcopy D:\Installs C:\CNSI


start C:\CNSI\Ninite.exe
start C:\CNSI\Reader.exe

echo:
echo:
echo [35mYou are done. Hope you have a great day!! :P[0m

echo:


goto :EOF

:EOF



