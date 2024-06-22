#!/bin/bash

set -e

NAME="freetype-envision"
VERSION="${VERSION:-}"
VERSION_MIN_SUPPORTED="0.2.0"
SCRIPT_NAME="$NAME.sh"
DOWNLOAD_LATEST_URL="https://api.github.com/repos/maximilionus/$NAME/releases/latest"
DOWNLOAD_SELECTED_URL="https://api.github.com/repos/maximilionus/$NAME/tarball/v$VERSION"

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

if [ -z "$VERSION" ]; then
    echo "[+] Preparing the latest release."
    curl -s -L $DOWNLOAD_LATEST_URL \
        | grep "tarball_url"      \
        | tr -d ' ",;'            \
        | sed 's/tarball_url://'  \
        | xargs curl -s -L -o "$NAME.tar.gz"
else
    echo "[+] Preparing the '$VERSION' release."

    if ! verlte $VERSION_MIN_SUPPORTED $VERSION; then
        echo "[!] This version is not supported by wrapper,"
        echo "    minimal supported version is: $VERSION_MIN_SUPPORTED"
        exit 1
    fi

    curl -s -L -o "$NAME.tar.gz" "$DOWNLOAD_SELECTED_URL"
fi

mkdir unpacked
tar -xzf "$NAME.tar.gz" --strip-components=1 -C unpacked

cd unpacked
./"$SCRIPT_NAME" "$@"
