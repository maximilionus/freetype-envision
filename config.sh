#!/bin/bash

PRESET=${PRESET:-safe}
# Uncomment the line below to enable the unsafe preset.
#PRESET=unsafe

VERSION="0.1.1"

SRC_DIR=src
PROFILED_DIR="$SRC_DIR/profile.d"
PROFILED_SAFE="freetype-envision-safe.sh"
PROFILED_UNSAFE="freetype-envision-unsafe.sh"

DEST_PROFILED_DIR="/etc/profile.d/"
