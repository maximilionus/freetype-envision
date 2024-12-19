#!/bin/bash

set -e

NAME="freetype-envision"
VERSION="0.7.0"
SRC_DIR=src

# Display the header with project name and version on start
SHOW_HEADER=${SHOW_HEADER:=true}

# environment
ENVIRONMENT_SCRIPT="$SRC_DIR/environment/freetype-envision.sh"
DEST_ENVIRONMENT="/etc/environment"

# fontconfig
FONTCONFIG_DIR="$SRC_DIR/fontconfig"
DEST_FONTCONFIG_DIR="/etc/fonts/conf.d"
#                    ("<NAME>" "<PRIORITY>")
FONTCONFIG_GRAYSCALE=("freetype-envision-grayscale.conf" 11)
FONTCONFIG_DROID_SANS=("freetype-envision-droid-sans.conf" 70)

# Storing the manual (from script) installation info on target system
DEST_INFO_DIR="/etc/freetype-envision"
DEST_STATE_FILE="state"

# Global variables
declare -A local_info  # Associative array to store values from state file


require_root () {
    if [[ $(/usr/bin/id -u) -ne 0 ]]; then
        echo "This action requires the root privileges"
        exit 1
    fi
}

write_state_file () {
    echo "Storing installation info in '$DEST_INFO_DIR/$DEST_STATE_FILE'"

    mkdir -p "$DEST_INFO_DIR"
    cat <<EOF > $DEST_INFO_DIR/$DEST_STATE_FILE
state[version]='$VERSION'
EOF
}

load_state_file () {
    if [[ ! -f $DEST_INFO_DIR/$DEST_STATE_FILE ]]; then
        echo "Note: No state file detected on system."
        return 1
    fi

    while read -r line; do
        if [[ $line =~ ^state\[([a-zA-Z0-9_]+)\]=\'?([^\']*)\'?$ ]]; then
            # Only allow "state[key]='value'"
            local key="${BASH_REMATCH[1]}"
            local value="${BASH_REMATCH[2]}"
            local_info["$key"]="$value"
        else
            echo "Warning: Skipping invalid state file line '$line'" >&2
        fi
    done < "$DEST_INFO_DIR/$DEST_STATE_FILE"
}

verify_ver () {
    if [[ -f $DEST_INFO_DIR/$DEST_STATE_FILE ]]; then
        # State file exists, checking if the version is same
        load_state_file

        if [[ ${local_info[version]} != $VERSION ]]; then
            cat <<EOF
Manually installed project of a previous or newer version already exists on the
system. Remove it with a script from the version corresponding to the installed
one.

Detected version: '${local_info[version]}'.
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
EOF
}

project_install () {
    echo "Setting up"
    verify_ver
    require_root

    echo "  Appending the environment entries"
    local formatted_env_var=$(exec bash -c "source $ENVIRONMENT_SCRIPT && echo \$FREETYPE_PROPERTIES")
    echo "FREETYPE_PROPERTIES=\"$formatted_env_var\"" >> "$DEST_ENVIRONMENT"

    echo "  Installing the fontconfig configurations"
    install -m 644 \
        "$FONTCONFIG_DIR/${FONTCONFIG_GRAYSCALE[0]}" \
        "$DEST_FONTCONFIG_DIR/${FONTCONFIG_GRAYSCALE[1]}-${FONTCONFIG_GRAYSCALE[0]}"

    install -m 644 \
        "$FONTCONFIG_DIR/${FONTCONFIG_DROID_SANS[0]}" \
        "$DEST_FONTCONFIG_DIR/${FONTCONFIG_DROID_SANS[1]}-${FONTCONFIG_DROID_SANS[0]}"

    write_state_file

    echo "Success! Reboot to apply the changes."
}

project_remove () {
    echo "Removing"
    verify_ver
    require_root

    echo "  Cleaning the environment entries"
    local formatted_env_var=$(exec bash -c "source $ENVIRONMENT_SCRIPT && echo \$FREETYPE_PROPERTIES")
    sed -i "/FREETYPE_PROPERTIES=\"$formatted_env_var\"/d" "$DEST_ENVIRONMENT"

    echo "  Removing the fontconfig configurations"
    rm -f "$DEST_FONTCONFIG_DIR/${FONTCONFIG_GRAYSCALE[1]}-${FONTCONFIG_GRAYSCALE[0]}"
    rm -f "$DEST_FONTCONFIG_DIR/${FONTCONFIG_DROID_SANS[1]}-${FONTCONFIG_DROID_SANS[0]}"

    echo "  Removing the configuration directory"
    rm -rf "$DEST_INFO_DIR"

    echo "Success! Reboot to apply the changes."
}


# Main logic below
[[ $SHOW_HEADER = true ]] && show_header

# Deprecate short commands.
# TODO: Remove in 1.0.0
case "$1" in
    i|r|h)
        cat <<EOF
--------
Warning: Arguments 'i', 'r' and 'h' (short commands) are considered deprecated
from version '0.5.0' and will be removed in '1.0.0' project release.
--------
EOF
        ;;
esac

# Deprecate project modes
# TODO: Remove in 1.0.0
if [[ $2 =~ ^(normal|full)$ ]]; then
    cat <<EOF
--------
Warning: Arguments 'normal' and 'full' (mode selection) are considered
deprecated from version '0.7.0' and will be removed in '1.0.0' project release.

Only one mode is available from now on. Please avoid providing the second
argument.

Whatever argument is specified in this call now will result in a normal mode
installation anyway.
--------
EOF
fi

case $1 in
    # "i" is deprecated
    # TODO: Remove in 1.0.0
    i|install)
        # $2 (modes) are deprecated
        # TODO: Remove in 1.0.0
        project_install $2
        ;;
    # "r" is deprecated
    # TODO: Remove in 1.0.0
    r|remove)
        project_remove
        ;;
    # "h" is deprecated
    # TODO: Remove in 1.0.0
    h|help)
        show_help
        ;;
    *)
        echo "Error: Invalid argument: \"$1\"."
        echo "Use \"help\" to get the list of commands"
        exit 1
esac
