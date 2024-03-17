#!/bin/bash

set -e
source config.sh

if [[ $PRESET == "safe" ]]; then
    echo "Installing the profile.d script (safe preset)"
    install -v -m 644 "$PROFILED_DIR/$PROFILED_SAFE" $DEST_PROFILED_DIR
elif [[ $PRESET == "unsafe" ]]; then
    echo "Installing the profile.d script (unsafe! preset)"
    install -v -m 644 "$PROFILED_DIR/$PROFILED_UNSAFE" $DEST_PROFILED_DIR
fi

echo "Success! Reboot to apply the changes."
