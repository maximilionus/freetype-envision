#!/bin/bash

# Wrapper for the freetype-envision project that will download and unpack all
# the necessary files for the latest or user-specified version, and execute the
# script, passing all the provided arguments.
#
# User can specify the project version with VERSION environmental variable.
#
# Example local usage:
# $ sudo ./run.sh install full
# $ sudo VERSION=0.4.0 ./run.sh install
#
# Example web usage:
# $ curl -s -L https://maximilionus.github.io/freetype-envision/run.sh \
#   | sudo bash -s -- install full
#
# $ curl -s -L https://maximilionus.github.io/freetype-envision/run.sh \
#   | sudo VERSION=0.2.0 bash -s -- install full

set -e

NAME="freetype-envision"
SCRIPT_NAME="$NAME.sh"
VERSION="${VERSION:-}"
VERSION_MIN_SUPPORTED="0.2.0"
DOWNLOAD_LATEST_URL="https://api.github.com/repos/maximilionus/$NAME/releases/latest"
DOWNLOAD_SELECTED_URL="https://api.github.com/repos/maximilionus/$NAME/tarball/v$VERSION"
CURL_FLAGS="-s --show-error --fail -L"

# Is version $2 >= $1
verlte() {
    [  "$1" = "`echo -e "$1\n$2" | sort -V | head -n1`" ]
}


echo "Web wrapper for $NAME."

TMP_DIR=$( mktemp -d )

if [ ! -d "$TMP_DIR" ]; then
    echo "[!] Failed to initialize temporary directory."
    exit 1
fi

echo "[+] Using temporary directory $TMP_DIR."
trap 'rm -rf -- "$TMP_DIR" && echo "[+] Temporary directory $TMP_DIR wiped."' EXIT
cd "$TMP_DIR"

download_url=""
if [ -z "$VERSION" ]; then
    echo "[+] Preparing the latest release."

    download_url=$(curl $CURL_FLAGS "$DOWNLOAD_LATEST_URL"  \
        | grep "tarball_url"                                \
        | tr -d ' ",;'                                      \
        | sed 's/tarball_url://')
else
    echo "[+] Preparing the '$VERSION' release."

    if ! verlte $VERSION_MIN_SUPPORTED $VERSION; then
        echo "[!] This version is not supported by wrapper,"
        echo "    minimal supported version is: $VERSION_MIN_SUPPORTED"
        exit 1
    fi

    download_url="$DOWNLOAD_SELECTED_URL"
fi

curl $CURL_FLAGS -o "$NAME.tar.gz" "$download_url"

mkdir unpacked
tar -xzf "$NAME.tar.gz" --strip-components=1 -C unpacked

cd unpacked
./"$SCRIPT_NAME" "$@"
