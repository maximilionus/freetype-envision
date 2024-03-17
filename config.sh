#!/bin/bash

PRESET=${PRESET:-safe}
# Uncomment the line below to enable the unsafe preset.
#PRESET=unsafe

SRC_DIR=src
VERSION="0.1.0"
PROFILED_DIR="$SRC_DIR/profile.d"
PROFILED_SAFE="freetype-envision-safe.sh"
PROFILED_UNSAFE="freetype-envision-unsafe.sh"

DEST_PROFILED_DIR="/etc/profile.d/"
