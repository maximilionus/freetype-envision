#!/bin/bash

set -e

NAME="freetype-envision"
SRC_DIR=src
VERSION="0.7.0"

# profile.d
PROFILED_DIR="$SRC_DIR/profile.d"
PROFILED_SCRIPT="freetype-envision.sh"
DEST_PROFILED_FILE="/etc/profile.d/freetype-envision.sh"

# fontconfig
FONTCONFIG_DIR="$SRC_DIR/fontconfig"
DEST_FONTCONFIG_DIR="/etc/fonts/conf.d"
#                    ("<NAME>" "<PRIORITY>")
FONTCONFIG_GRAYSCALE=("freetype-envision-grayscale.conf" 11)
FONTCONFIG_DROID_SANS=("freetype-envision-droid-sans.conf" 70)

# Storing the manual (from script) installation info on target system.
# Disable by setting the STORE_STATE env variable to false, but only do it when
# using some other tool (package manager, etc) for project management, where
# this script is only used to install the project files to target system.
STORE_STATE="${STORE_STATE:-true}"
DEST_CONF_DIR="/etc/freetype-envision"
DEST_STATE_FILE="state"

# Global variables
declare -A g_state      # Associative array to store values from state file


__require_root () {
    if [[ $(/usr/bin/id -u) -ne 0 ]]; then
        echo "This action requires the root privileges"
        exit 1
    fi
}

# Load the local state file into global var safely, allowing only the valid
# values to be parsed.
__load_state_file () {
    while read -r line; do
        if [[ $line =~ ^state\[([a-zA-Z0-9_]+)\]=\'?([^\']*)\'?$ ]]; then
            # Only allow "state[key]='value'"
            local key="${BASH_REMATCH[1]}"
            local value="${BASH_REMATCH[2]}"
            g_state["$key"]="$value"
        else
            echo "Warning: Skipping invalid state file line '$line'" >&2
        fi
    done < "$DEST_CONF_DIR/$DEST_STATE_FILE"
}

# Check the state file values to decide if user is allowed to install the project
__verify_ver () {
    if [[ -f $DEST_CONF_DIR/$DEST_STATE_FILE ]]; then
        # State file exists, checking if the version is same
        __load_state_file

        if [[ ${g_state[version]} != $VERSION ]]; then
            cat <<EOF
Manually installed project of a previous or newer version already exists on the
system. Remove it with a script from the version corresponding to the installed
one.

Detected version: '${g_state[version]}'.
EOF
            exit 1
        fi

        unset state
    else
        if [[ -f $DEST_PROFILED_FILE ]]; then
            # Project files exist on the taget system, but no state file.
            # ? Checking only for one profile.d script should be enough, but
            #   something weird may happen. Anyway... ( ͡° ͜ʖ ͡°)
            cat <<EOF
Project is already installed on the system, probably with package manager or an
installation script for the version below '0.5.0'. Remove it using the original
installation method.
EOF
            exit 1
        fi
    fi
}

show_header () {
    echo "$NAME, version $VERSION"
}

show_help () {
    cat <<EOF
Usage: $0 [COMMAND]

COMMANDS:
  install            : Install the project.
  remove             : Remove the installed project.
  help               : Show this help message.

ENV:
  STORE_STATE <bool> : Storing the manual (from script) installation info on
                       target system. (true by default)
EOF
}

project_install () {
    echo "-> Begin project install."
    __verify_ver
    __require_root

    echo "--> Installing the profile.d scripts:"
    install -v -m 644 "$PROFILED_DIR/$PROFILED_SCRIPT" "$DEST_PROFILED_FILE"

    echo "--> Installing the fontconfig configurations:"
    install -v -m 644 \
        "$FONTCONFIG_DIR/${FONTCONFIG_GRAYSCALE[0]}" \
        "$DEST_FONTCONFIG_DIR/${FONTCONFIG_GRAYSCALE[1]}-${FONTCONFIG_GRAYSCALE[0]}"

    install -v -m 644 \
        "$FONTCONFIG_DIR/${FONTCONFIG_DROID_SANS[0]}" \
        "$DEST_FONTCONFIG_DIR/${FONTCONFIG_DROID_SANS[1]}-${FONTCONFIG_DROID_SANS[0]}"

    if [[ $STORE_STATE = true ]]; then
        echo "--> Storing installation info to '$DEST_CONF_DIR/$DEST_STATE_FILE':"
        mkdir -pv "$DEST_CONF_DIR"

        tee "$DEST_CONF_DIR/$DEST_STATE_FILE" <<EOF
state[version]='$VERSION'
state[mode]='$g_selected_mode'
EOF
    fi

    echo "-> Success! Reboot to apply the changes."
}

project_remove () {
    echo "-> Begin project removal."
    __verify_ver
    __require_root

    echo "--> Removing the profile.d scripts:"
    rm -fv "$DEST_PROFILED_FILE"

    echo "--> Removing the fontconfig configurations:"
    rm -fv "$DEST_FONTCONFIG_DIR/${FONTCONFIG_GRAYSCALE[1]}-${FONTCONFIG_GRAYSCALE[0]}"
    rm -fv "$DEST_FONTCONFIG_DIR/${FONTCONFIG_DROID_SANS[1]}-${FONTCONFIG_DROID_SANS[0]}"

    echo "--> Removing the configurations directory:"
    rm -rfv "$DEST_CONF_DIR"

    echo "-> Success! Reboot to apply the changes."
}


# Main logic below
arg_1="$1"
arg_2="$2"

show_header

# Deprecate short commands.
# ! Remove on 1.0.0
case "$1" in
    i|r|h)
        cat <<EOF
--------
Warning: Argument '$1' (short command) is considered deprecated from version
'0.5.0' and will be removed in '1.0.0' project release.
--------
EOF
        ;;
esac

if [[ $2 =~ ^(normal|full)$ ]]; then
    cat <<EOF
--------
Warning: Argument '$2' (mode selection) is considered deprecated from version
'0.7.0' and will be removed in '1.0.0' project release.

There are now only one mode available, please avoid providing the second
argument.
--------
EOF
fi

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
        echo "Error: Invalid argument: \"$1\"."
        echo "Use \"help\" to get the list of commands"
        exit 1
esac
