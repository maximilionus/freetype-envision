#!/bin/bash

set -e
source config.sh

if [[ $PRESET == "safe" ]]; then
    echo "Uninstalling the profile.d script (safe preset)"
    rm -fv "$DEST_PROFILED_DIR/$PROFILED_SAFE"
elif [[ $PRESET == "unsafe" ]]; then
    echo "Uninstalling the profile.d script (unsafe! preset)"
    rm -fv "$DEST_PROFILED_DIR/$PROFILED_UNSAFE"
fi

echo "Success! Reboot to apply the changes."
