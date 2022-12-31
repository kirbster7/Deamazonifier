clear
echo "// Welcome to Deamazonifier v1.0"
sleep 1 
echo "// Starting script in 5 seconds... (ctrl+c to abort)"
sleep 5

# uninstall Gapps
echo "// Deamazonifier is removing Google Play services"
echo "Removing Google Play Store Frontend (1/4)"
./adb uninstall com.android.vending
echo "Removing Google Play Service (2/4)"
./adb uninstall com.google.android.gms
echo "Removing Google Play Framework (3/4)"
./adb uninstall com.google.android.gsf
echo "Removing Google Account Manager (4/4)"
./adb uninstall com.google.android.gsf.login

# disable amazon apps
echo "// Deamazonifier is re-enabling Amazon apps"
packages=$(awk '{print $1}' < amazonlist.txt)
./adb shell pm list packages -s > packagelist
for package in ${packages}
do
    ./adb shell pm enable "$package"
done

# change settings
echo "// Deamazonifier is reverting your devices settings"
./adb shell settings put secure limit_ad_tracking 0
./adb shell settings put secure usage_metrics_marketing_enabled 1
./adb shell settings put secure USAGE_METRICS_UPLOAD_ENABLED 1
./adb shell settings put global private_dns_mode -hostname
./adb shell settings put global LOCKSCREEN_AD_ENABLED 1
./adb shell settings put secure search_on_lockscreen_settings 1
./adb shell settings put global always_finish_activities 0
./adb shell settings put global window_animation_scale 1
./adb shell settings put global transition_animation_scale 1
./adb shell settings put global animator_duration_scale 1

# remove lawnchair
echo "// Deamazonifier is reverting the launcher"
./adb shell pm enable com.amazon.firelauncher
./adb shell am start com.amazon.firelauncher
echo "Removing Lawnchair (1/1)"
./adb uninstall ch.deletescape.lawnchair.ci

# finish up
echo "// Please wait"
sleep 5
clear
echo "// Rebooting your device in 15 seconds"
sleep 15
./adb reboot
clear
echo "// Deamazonifier is finished."