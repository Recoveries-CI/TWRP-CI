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
if [ "$TWRP_BRANCH" = "twrp-test" ]; then
	source build/envsetup.sh
	repopick 5826 5827 5828 5829 5831 5832 5848 5872 5874 5889 5890 5896
	cd vendor/twrp
	git fetch https://github.com/LineageOS/android_vendor_lineage.git lineage-20.0 && git cherry-pick eb72c64757f85add0a8ac927abb8d400fd20d928
	cd $SYNC_PATH
else
	source build/envsetup.sh
	repopick 5917
fi

# Exit
exit 0
