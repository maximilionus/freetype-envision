#!/bin/bash

# Wrapper for the lucidglyph project that will download and unpack all the
# necessary files for the latest or user-specified version, and execute the
# script, passing all the provided arguments.
#
# User can specify the project version with VERSION environmental variable.
#
# Usage:
# ------
# $ curl -s -L [LINK]/wrapper.sh \
#       | sudo bash -s -- [COMMAND]
#
# Examples:
# --------
# $ curl -s -L [LINK]/wrapper.sh \
#       | sudo bash -s -- install
#
# $ curl -s -L [LINK]/wrapper.sh \
#       | sudo VERSION=0.2.0 bash -s -- install

set -e

NAME="lucidglyph"
NAME_OLD="freetype-envision"
VERSION="${VERSION:-}"
VERSION_MIN_SUPPORTED="0.2.0"
DOWNLOAD_LATEST_URL="https://api.github.com/repos/maximilionus/$NAME/releases/latest"
DOWNLOAD_SELECTED_URL="https://api.github.com/repos/maximilionus/$NAME/tarball/v$VERSION"
CURL_FLAGS="-s --show-error --fail -L"

# Check if version $2 >= $1
verlte() {
    [  "$1" = "`echo -e \"$1\n$2\" | sort -V | head -n1`" ]
}

# Check if version $2 > $1
verlt() {
    [ "$1" = "$2" ] && return 1 || verlte $1 $2
}


TMP_DIR=$( mktemp -d )
if [[ ! -d $TMP_DIR ]]; then
    cat <<EOF
[Wrapper] Critical Error
    Failed to initialize temporary directory.

    Please check if "mktemp" command is available and functions properly on
    your system.
EOF
    exit 1
else
    trap 'rm -rf -- "$TMP_DIR"' EXIT
fi

cd "$TMP_DIR"

download_url=""
if [[ -z $VERSION ]]; then
    download_url=$(curl $CURL_FLAGS "$DOWNLOAD_LATEST_URL"  \
        | grep "tarball_url"                                \
        | tr -d ' ",;'                                      \
        | sed 's/tarball_url://')
else
    if verlt $VERSION $VERSION_MIN_SUPPORTED; then
        cat <<EOF
[Wrapper] This version is not supported by wrapper script,
          minimal supported version is: $VERSION_MIN_SUPPORTED"
EOF
        exit 1
    elif verlt $VERSION "0.8.0"; then
        # Backwards compatibility for versions below 0.8.0
        # TODO: Remove after 1.0.0 release
        NAME="$NAME_OLD"
    fi

    download_url="$DOWNLOAD_SELECTED_URL"
fi

curl $CURL_FLAGS -o "$NAME.tar.gz" "$download_url"

mkdir unpacked
tar -xzf "$NAME.tar.gz" --strip-components=1 -C unpacked
cd unpacked

sudo ./"$NAME.sh" "$@"
