#!/bin/bash

set -e


SRC_DIR=src
VERSION="0.2.0"

PROFILED_DIR="$SRC_DIR/profile.d"
PROFILED_LITE="freetype-envision-normal.sh"
PROFILED_FULL="freetype-envision-full.sh"
DEST_PROFILED_FILE="/etc/profile.d/freetype-envision.sh"

FONTCONFIG_DIR="$SRC_DIR/fontconfig"
FONTCONFIG_GRAYSCALE="freetype-envision-enforce-grayscale.conf"
FONTCONFIG_GRAYSCALE_PRIOR=11
DEST_FONTCONFIG_DIR="/etc/fonts/conf.d"

selected_mode=0


__require_root () {
    if [[ $(/usr/bin/id -u) -ne 0 ]]; then
        echo "This action requires the root privileges"
        exit 1
    fi
}

__read_mode () {
    local selected_mode
    echo "Select the mode."
    echo
    echo "1 - Normal (Default, leave empty to use it)"
    echo "2 - Full"
    echo
    read -p "Input: " selected_mode

    if [[ $selected_mode == 1 || -z $selected_mode ]]; then
        echo "--> 'Normal' mode selected."
    elif [[ $selected_mode == 2 ]]; then
        echo "--> 'Full' mode selected."
    else
        echo "Wrong mode, stopping"
        exit 1
    fi
}

show_header () {
    echo "FreeType Envision, version $VERSION"
}

show_help () {
    echo "Usage: ./freetype-envision.sh [COMMAND]"
    echo
    echo "COMMANDS:"
    echo "  [i]nstall <mode> : Install the project."
    echo "                     <mode>: normal (default)"
    echo "                             full"
    echo "  [r]remove        : Remove the installed project."
    echo "  [h]elp           : Show this help message."
    exit 0
}

project_install () {
    echo "-> Begin project install."
    __require_root
    __read_mode

    echo "--> Installing the profile.d script."
    if (( selected_mode == 1 )); then
        install -v -m 644 "$PROFILED_DIR/$PROFILED_LITE" "$DEST_PROFILED_FILE"
    elif (( selected_mode == 2 )); then
        install -v -m 644 "$PROFILED_DIR/$PROFILED_FULL" "$DEST_PROFILED_FILE"
    fi

    echo "--> Installing the fontconfig configuration."
    install -v -m 644 \
        "$FONTCONFIG_DIR/$FONTCONFIG_GRAYSCALE" \
        "$DEST_FONTCONFIG_DIR/$FONTCONFIG_GRAYSCALE_PRIOR-$FONTCONFIG_GRAYSCALE"

    echo "-> Success! Reboot to apply the changes."
}

project_remove () {
    echo "-> Begin project uninstall."
    __require_root
    __read_mode

    echo "--> Removing the profile.d script"
    rm -fv "$DEST_PROFILED_FILE"

    echo "--> Removing the fontconfig configuration."
    rm -fv "$DEST_FONTCONFIG_DIR/$FONTCONFIG_GRAYSCALE_PRIOR-$FONTCONFIG_GRAYSCALE"

    echo "-> Success! Reboot to apply the changes."
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
        echo "Error: Invalid argument: $1."
        echo "Use \"help\" to get the list of commands."
        exit 1
esac
