@echo off
cls
echo Welcome to Deamazonifier v2.0

.\support\platform-win\adb.exe devices -l | find "device product:" >nul
if errorlevel 1 (
    echo No connected devices
    exit
) else (
    echo Device found
)

echo Deamazonifier is installing Google Play services
echo [::::------------] Installing Google Account Manager 
.\support\platform-win\adb.exe install support/Gapps/am.apk >nul
echo [::::::::--------] Installing Google Play Framework 
.\support\platform-win\adb.exe install support/Gapps/fw.apk >nul
echo [::::::::::::----] Installing Google Play Service 
.\support\platform-win\adb.exe install support/Gapps/ps.apk >nul
echo [::::::::::::::::] Installing Aurora Store 
.\support\platform-win\adb.exe install support/Gapps/aurora.apk >nul

echo Deamazonifier is disabling Amazon apps
for /f %%i in (support\amazonlist.txt) do (
    for /f "tokens=*" %%j in ('.\support\platform-win\adb.exe shell pm list packages -s ') do (
        if "%%j" == "package:%%i" (
            .\support\platform-win\adb.exe shell pm disable-user --user 0 "%%i" >nul
        )
    )
)

echo Deamazonifier is enhancing your settings
.\support\platform-win\adb.exe shell settings put secure limit_ad_tracking 1 >nul
.\support\platform-win\adb.exe shell settings put secure usage_metrics_marketing_enabled 0 >nul
.\support\platform-win\adb.exe shell settings put secure USAGE_METRICS_UPLOAD_ENABLED 0 >nul
.\support\platform-win\adb.exe shell pm clear com.amazon.advertisingidsettings >nul
.\support\platform-win\adb.exe shell settings put secure location_providers_allowed -network >nul
.\support\platform-win\adb.exe shell settings put global private_dns_mode hostname >nul
.\support\platform-win\adb.exe shell settings put global private_dns_specifier dns.adguard.com >nul
.\support\platform-win\adb.exe shell settings put global LOCKSCREEN_AD_ENABLED 0 >nul
.\support\platform-win\adb.exe shell settings put secure search_on_lockscreen_settings 0 >nul
.\support\platform-win\adb.exe shell settings put global window_animation_scale 0.50 >nul
.\support\platform-win\adb.exe shell settings put global transition_animation_scale 0.50 >nul
.\support\platform-win\adb.exe shell settings put global animator_duration_scale 0.50 >nul

echo Deamazonifier is replacing the launcher
echo [::::::----------] Installing Lawnchair
.\support\platform-win\adb.exe install support/Launchers/lawnchair.apk >nul
echo [:::::::::::-----] Focusing Lawnchair
.\support\platform-win\adb.exe shell am start ch.deletescape.lawnchair.ci >nul
echo [::::::::::::::::] Disabling stock launcher
.\support\platform-win\adb.exe shell pm disable-user --user 0 com.amazon.firelauncher >nul

echo Please Press 'Allow' to the popup
echo Rebooting your device in 15 seconds
timeout /t 15
.\support\platform-win\adb.exe reboot
cls
echo Deamazonifier is finished
echo Thank you