#!/bin/bash

# Source Vars
source $CONFIG

# Change to the Home Directory
cd ~

# A Function to Send Posts to Telegram
telegram_message() {
	curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
	-d chat_id="${TG_CHAT_ID}" \
	-d parse_mode="HTML" \
	-d text="$1"
}

# Clone the Sync Repo
cd $SYNC_PATH
repo init $TWRP_MANIFEST -b $TWRP_BRANCH --depth=1
repo sync

# Clone Trees
git clone $DT_LINK $DT_PATH || { echo "ERROR: Failed to Clone the Device Trees!" && exit 1; }

# Clone the Kernel Sources
# only if the Kernel Source is Specified in the Config
[ ! -z "$KERNEL_SOURCE" ] && git clone --depth=1 --single-branch $KERNEL_SOURCE $KERNEL_PATH

# Cherry-pick gerrit patches
if [ "$TWRP_BRANCH" = "twrp-12.1" ]; then
	if [[ "$TWRP_MANIFEST" == *"faoliveira78"* ]]; then
		git -C bootable/recovery fetch https://gerrit.twrp.me/android_bootable_recovery refs/changes/35/6235/21 && git -C bootable/recovery cherry-pick FETCH_HEAD
		git -C system/vold fetch https://gerrit.twrp.me/android_system_vold refs/changes/36/6236/19 && git -C system/vold cherry-pick FETCH_HEAD
		git -C bootable/recovery fetch https://gerrit.twrp.me/android_bootable_recovery refs/changes/89/6289/1 && git -C bootable/recovery cherry-pick FETCH_HEAD
		git -C device/qcom/twrp-common fetch https://gerrit.twrp.me/android_device_qcom_twrp-common refs/changes/91/6291/1 && git -C device/qcom/twrp-common cherry-pick FETCH_HEAD
	else
		source build/envsetup.sh
		repopick 6235 6236 6289 6291
	fi
fi

# Exit
exit 0