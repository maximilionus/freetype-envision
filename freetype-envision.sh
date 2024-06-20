#!/bin/bash

set -e


SRC_DIR=src
VERSION="0.4.0"

PROFILED_DIR="$SRC_DIR/profile.d"
PROFILED_NORMAL="freetype-envision-normal.sh"
PROFILED_FULL="freetype-envision-full.sh"
DEST_PROFILED_FILE="/etc/profile.d/freetype-envision.sh"

FONTCONFIG_DIR="$SRC_DIR/fontconfig"
FONTCONFIG_GRAYSCALE="freetype-envision-grayscale.conf"
DEST_FONTCONFIG_DIR="/etc/fonts/conf.d"

glob_selected_mode=""


__require_root () {
    if [[ $(/usr/bin/id -u) -ne 0 ]]; then
        echo "This action requires the root privileges"
        exit 1
    fi
}

__verify_mode () {
    local sel_mode="${1:-normal}"

    if [[ $sel_mode == "normal" ]]; then
        glob_selected_mode=$sel_mode
        echo "-> \"Normal\" mode selected."
    elif [[ $sel_mode == "full" ]]; then
        glob_selected_mode=$sel_mode
        echo "-> \"Full\" mode selected."
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
    echo "  i,install <mode> : Install the project."
    echo "  r,remove         : Remove the installed project."
    echo "  h,help           : Show this help message."
    echo "OPTIONS:"
    echo "   mode            : \"normal\" (default),"
    echo "                     \"full\"."
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
        "$DEST_FONTCONFIG_DIR/$FONTCONFIG_GRAYSCALE"

    echo "-> Success! Reboot to apply the changes."
}

project_remove () {
    echo "-> Begin project uninstall."
    __require_root

    echo "--> Removing the profile.d script"
    rm -fv "$DEST_PROFILED_FILE"

    echo "--> Removing the fontconfig configuration."
    rm -fv "$DEST_FONTCONFIG_DIR/$FONTCONFIG_GRAYSCALE"

    echo "-> Success! Reboot to apply the changes."
}


# Main logic below
arg_1="$1"
arg_2="$2"

show_header

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
        echo "Error: Invalid argument: \"$1\"."
        echo "Use \"help\" to get the list of commands"
        exit 1
esac
