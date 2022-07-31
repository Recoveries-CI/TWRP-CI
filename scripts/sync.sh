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

# Cherry-pick Fscrypt patches
source build/envsetup.sh
repopick 5405 5540
#git -C system/vold fetch https://gerrit.twrp.me/android_system_vold refs/changes/40/5540/9
#git -C system/vold cherry-pick FETCH_HEAD
#git -C system/vold fetch https://github.com/faoliveira78/android_system_vold.git
#git -C system/vold cherry-pick 7bf70fdcbed7254c4f27a56ed2d83d74b76114c2

# Exit
exit 0
