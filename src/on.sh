!# /bin/bash

if pwd

clear
echo "Welcome to Deamazonifier v2.0"

if ./support/adb get-state 1>/dev/null 2>&1
  then
    echo "Device found"
  else
    echo "No connected devices"
    exit
fi

# install Gapps
echo "Deamazonifier is installing Google Play services"
echo "Installing Google Account Manager (1/4)"
./support/adb install support/Gapps/am.apk
echo "Installing Google Play Framework (2/4)"
./support/adb install support/Gapps/fw.apk
echo "Installing Google Play Service (3/4)"
./support/adb install support/Gapps/ps.apk
echo "Installing Google Play Store Frontend (4/4)"
./support/adb install support/Gapps/store.apk

# disable amazon apps
echo "Deamazonifier is disabling Amazon apps"
packages=$(awk '{print $1}' < support/amazonlist.txt)
./support/adb shell pm list packages -s > packagelist
for package in ${packages}
do
    ./support/adb shell pm disable-user --user 0 "$package"
done

# change settings
echo "Deamazonifier is changing your devices settings"
./support/adb shell settings put secure limit_ad_tracking 1
./support/adb shell settings put secure usage_metrics_marketing_enabled 0
./support/adb shell settings put secure USAGE_METRICS_UPLOAD_ENABLED 0
./support/adb shell pm clear com.amazon.advertisingidsettings
./support/adb shell settings put secure location_providers_allowed -network
./support/adb shell settings put global private_dns_mode hostname
./support/adb shell settings put global private_dns_specifier dns.adguard.com
./support/adb shell settings put global LOCKSCREEN_AD_ENABLED 0
./support/adb shell settings put secure search_on_lockscreen_settings 0
./support/adb shell settings put global window_animation_scale 0.50
./support/adb shell settings put global transition_animation_scale 0.50
./support/adb shell settings put global animator_duration_scale 0.50

# install lawnchair
echo "Deamazonifier is replacing the launcher"
echo "Installing Lawnchair (1/1)"
./support/adb install support/Launchers/lawnchair.apk
./support/adb shell am start ch.deletescape.lawnchair.ci
./support/adb shell pm disable-user --user 0 com.amazon.firelauncher

# finish up
echo "Please Press 'Allow' to the popup"
echo "Rebooting your device in 15 seconds"
sleep 15
./support/adb reboot
clear
echo "Deamazonifier is finished"
echo "Thank you"