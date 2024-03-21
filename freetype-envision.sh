#!/bin/bash

set -e


SRC_DIR=src
VERSION="0.2.0"

PROFILED_DIR="$SRC_DIR/profile.d"
PROFILED_NORMAL="freetype-envision-normal.sh"
PROFILED_FULL="freetype-envision-full.sh"
DEST_PROFILED_FILE="/etc/profile.d/freetype-envision.sh"

FONTCONFIG_DIR="$SRC_DIR/fontconfig"
FONTCONFIG_GRAYSCALE="freetype-envision-grayscale.conf"
FONTCONFIG_GRAYSCALE_PRIOR=11
DEST_FONTCONFIG_DIR="/etc/fonts/conf.d"

glob_selected_mode="normal"


__require_root () {
    if [[ $(/usr/bin/id -u) -ne 0 ]]; then
        echo "This action requires the root privileges"
        exit 1
    fi
}

__verify_mode () {
    if [[ $1 == "normal" || -z $1 ]]; then
        glob_selected_mode="normal"  # Assign, can be empty
        echo "--> 'Normal' mode selected."
    elif [[ $1 == "full" ]]; then
        glob_selected_mode=$1
        echo "--> 'Full' mode selected."
    else
        echo "Wrong mode, stopping."
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

    echo "--> Installing the profile.d script."
    if [[ $glob_selected_mode == "normal" ]]; then
        install -v -m 644 "$PROFILED_DIR/$PROFILED_NORMAL" "$DEST_PROFILED_FILE"
    elif [[ $glob_selected_mode == "full" ]]; then
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

    echo "--> Removing the profile.d script"
    rm -fv "$DEST_PROFILED_FILE"

    echo "--> Removing the fontconfig configuration."
    rm -fv "$DEST_FONTCONFIG_DIR/$FONTCONFIG_GRAYSCALE_PRIOR-$FONTCONFIG_GRAYSCALE"

    echo "-> Success! Reboot to apply the changes."
}


show_header
arg_1="$1"
arg_2="$2"

case $arg_1 in
    i|install)
        __verify_mode $arg_2
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
