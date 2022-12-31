clear
echo "// Welcome to Deamazonifier v1.0"
sleep 1 
echo "// Starting script in 5 seconds... (ctrl+c to abort)"
sleep 5

# install Gapps
echo "// Deamazonifier is installing Google Play services"
echo "Installing Google Account Manager (1/4)"
./adb install Gapps/am.apk
echo "Installing Google Play Framework (2/4)"
./adb install Gapps/fw.apk
echo "Installing Google Play Service (3/4)"
./adb install Gapps/ps.apk
echo "Installing Google Play Store Frontend (4/4)"
./adb install Gapps/store.apk

# disable amazon apps
echo "// Deamazonifier is disabling Amazon apps"
packages=$(awk '{print $1}' < amazonlist.txt)
./adb shell pm list packages -s > packagelist
for package in ${packages}
do
    ./adb shell pm disable-user --user 0 "$package"
done

# change settings
echo "// Deamazonifier is changing your devices settings"
./adb shell settings put secure limit_ad_tracking 1
./adb shell settings put secure usage_metrics_marketing_enabled 0
./adb shell settings put secure USAGE_METRICS_UPLOAD_ENABLED 0
./adb shell pm clear com.amazon.advertisingidsettings
./adb shell settings put secure location_providers_allowed -network
./adb shell settings put global private_dns_mode hostname
./adb shell settings put global private_dns_specifier dns.adguard.com
./adb shell settings put global LOCKSCREEN_AD_ENABLED 0
./adb shell settings put secure search_on_lockscreen_settings 0
./adb shell settings put global window_animation_scale 0.50
./adb shell settings put global transition_animation_scale 0.50
./adb shell settings put global animator_duration_scale 0.50

# install lawnchair
echo "// Deamazonifier is replacing the launcher"
echo "Installing Lawnchair (1/1)"
./adb install Launchers/lawnchair.apk
./adb shell am start ch.deletescape.lawnchair.ci
./adb shell pm disable-user --user 0 com.amazon.firelauncher

# finish up
echo "// Please wait"
sleep 5
clear
echo "// Please Press 'Allow' to the popup"
echo "// Rebooting your device in 15 seconds"
sleep 15
./adb reboot
clear
echo "// Deamazonifier is finished, enjoy your newly debloated device!"