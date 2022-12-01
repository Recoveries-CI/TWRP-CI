#!/bin/bash

# Device
export TWRP_MANIFEST="https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp"
export TWRP_BRANCH="twrp-12.1"
#export TWRP_BRANCH="twrp-test"
export DT_LINK="https://github.com/ebluees/Mt6781 -b A12"

export DEVICE="viva"
export OEM="xiaomi"
#export PLATFORM="mt6781"
export TARGET="bootimage"
export TW_DEVICE_VERSION="2"
export OUTPUT="boot.img"
export FILENAME="twrp*.img"

# Extra Command
export EXTRA_CMD="RizalEf"

# Not Recommended to Change
if [ ! -e $HOME/work ]; then
mkdir $HOME/work
fi

export SYNC_PATH="$HOME/work" # Full (absolute) path.
export USE_CCACHE=1
export CCACHE_SIZE="50G"
export CCACHE_DIR="$HOME/work/.ccache"
export J_VAL=16
