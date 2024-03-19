#!/bin/bash

set -e


SRC_DIR=src
VERSION="0.2.0"
PROFILED_DIR="$SRC_DIR/profile.d"
PROFILED_LIGHT="freetype-envision-lite.sh"
PROFILED_FULL="freetype-envision-full.sh"
DEST_PROFILED_FILE="/etc/profile.d/freetype-envision.sh"


require_root () {
    if [[ $(/usr/bin/id -u) -ne 0 ]]; then
        echo "This action requires the root privileges"
        exit 1
    fi
}

show_header () {
    echo "FreeType Envision, version $VERSION"
}

show_help () {
    echo "Abandon hope all ye who enter here"
}

project_install () {
    echo "-> Begin project installation."
    require_root

    local selected_preset_path
    if [[ $2 == "light" || -z $2 ]]; then
        echo "--> 'Light' preset selected."
        selected_preset_path="$PROFILED_DIR/$PROFILED_LIGHT"
    elif [[ $2 == "full" ]]; then
        echo "--> 'Full' preset selected."
        selected_preset_path="$PROFILED_DIR/$PROFILED_FULL"
    fi

    echo "--> Installing the profile.d script."
    install -v -m 644 "$selected_preset_path" "$DEST_PROFILED_FILE"

    echo "-> Success! Reboot to apply the changes."
}

project_remove () {
    echo "-> Begin project uninstall."
    require_root
    rm -fv "$DEST_PROFILED_FILE"
}


show_header
case $1 in
    i|install)
        project_install
        ;;
    r|remove)
        project_remove
        ;;
    h|help)
        show_help
        ;;
    *)
        echo "No arguments provided"
        ;;
esac
