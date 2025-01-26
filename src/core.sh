NAME="lucidglyph"
VERSION="0.7.0"
SRC_DIR=src

# Display the header with project name and version on start
SHOW_HEADER=${SHOW_HEADER:=true}

# environment
ENVIRONMENT_SCRIPT="$SRC_DIR/environment/lucidglyph.sh"
DEST_ENVIRONMENT="/etc/environment"

# fontconfig
FONTCONFIG_DIR="$SRC_DIR/fontconfig"
DEST_FONTCONFIG_DIR="/etc/fonts/conf.d"
#                    ("<NAME>" "<PRIORITY>")
FONTCONFIG_GRAYSCALE=("lucidglyph-grayscale.conf" 11)
FONTCONFIG_DROID_SANS=("lucidglyph-droid-sans.conf" 70)

# Metadata location
DEST_SHARED_DIR="/usr/share/lucidglyph"
DEST_INFO_FILE="info"
DEST_UNINSTALL_FILE="uninstaller.sh"

# Colors
C_RESET="\e[0m"
C_BOLD="\e[1m"
C_DIM="\e[2m"
C_GREEN="\e[0;32m"
C_YELLOW="\e[0;33m"
C_RED="\e[0;31m"

# Global variables
declare -A local_info


require_root () {
    if [[ $(/usr/bin/id -u) -ne 0 ]]; then
        printf "${C_RED}This action requires the root privileges${C_RESET}\n"
        exit 1
    fi
}

# Parse and load the installation information
load_info_file () {
    if [[ ! -f $DEST_SHARED_DIR/$DEST_INFO_FILE ]]; then
        return 0
    fi

    while read -r line; do
        # Parse all key="value"
        regex='^([a-zA-Z_][a-zA-Z0-9_]*)="([^"]*)"$'

        if [[ $line =~ $regex ]]; then
            local key="${BASH_REMATCH[1]}"
            local value="${BASH_REMATCH[2]}"
            local_info["$key"]="$value"
        else
            printf "${C_YELLOW}Warning: Skipping invalid info file line '$line'${C_RESET}\n"
        fi
    done < "$DEST_SHARED_DIR/$DEST_INFO_FILE"
}

# Check for old versions that use deprecated formats and notify user
check_for_old () {
    if (( ! ${#local_info[@]} )); then
        if ls $DEST_FONTCONFIG_DIR/*$NAME* > /dev/null 2>&1; then
            cat <<EOF
Project is already installed on the system, presumably with package manager or
an installation script of the version below '0.7.0', that does not support the
automatic removal. You have to uninstall it using the original installation
method first.
EOF
exit 1
        fi
    fi
}

check_system () {
    if [[ $( uname -s ) != Linux* ]]; then
        printf "$C_YELLOW"
        cat <<EOF
You are trying to run this script on the unsupported platform.
Proceed at your own risk.

EOF
        printf "$C_RESET"
        read -p "Do you wish to continue? (y/n): "
        printf "\n"
        [[ $REPLY =~ ^[Nn]$ ]] && exit 1
    fi
}

# Call the locally stored uninstaller from target machine
call_uninstaller () {
    if [[ ! -f "$DEST_SHARED_DIR/$DEST_UNINSTALL_FILE" ]]; then
        printf "${C_RED}Uninstaller script not found, installation corrupted${C_RESET}"
        exit 1
    fi

    printf "$C_DIM"
    "$DEST_SHARED_DIR/$DEST_UNINSTALL_FILE"
    printf "$C_RESET"
}

show_header () {
    printf "${C_BOLD}$NAME, version $VERSION${C_RESET}\n"
}

cmd_help () {
    cat <<EOF
Usage: $0 [COMMAND]

COMMANDS:
  install  Install the project.
  remove   Remove the installed project.
  help     Show this help message.
EOF
}

cmd_install () {
    printf "Setting up\n"

    load_info_file
    check_for_old

    if [[ ${local_info[version]} == "$VERSION" ]]; then
        printf "${C_GREEN}Current version is already installed.${C_RESET}\n"
        exit 1
    elif [[ ! -z ${local_info[version]} ]]; then
        printf "${C_GREEN}Detected $NAME version ${local_info[version]} on the target system.${C_RESET}\n"
        require_root
        read -p "Do you wish to upgrade to version $VERSION? (y/n): "
        printf "\n"
        [[ $REPLY =~ ^[Yy]$ ]] && call_uninstaller || exit 1
    fi

    require_root

    printf "$C_DIM"

    printf "Storing the installation metadata\n"
    mkdir -p "$DEST_SHARED_DIR"
    touch "$DEST_SHARED_DIR/$DEST_INFO_FILE"
    touch "$DEST_SHARED_DIR/$DEST_UNINSTALL_FILE"
    chmod +x "$DEST_SHARED_DIR/$DEST_UNINSTALL_FILE"

    cat <<EOF >> "$DEST_SHARED_DIR/$DEST_INFO_FILE"
version="$VERSION"
EOF
    cat <<EOF >> "$DEST_SHARED_DIR/$DEST_UNINSTALL_FILE"
#!/bin/bash
set -e
echo "Using uninstaller for version $VERSION"
EOF

    printf "Appending the environment entries\n"
    local fmt_env=$(exec bash -c "source $ENVIRONMENT_SCRIPT && echo \$FREETYPE_PROPERTIES")
    cat <<EOF >> "$DEST_ENVIRONMENT"
FREETYPE_PROPERTIES="$fmt_env"
EOF
    cat <<EOF >> "$DEST_SHARED_DIR/$DEST_UNINSTALL_FILE"
echo "Cleaning the environment entries"
sed -i '/FREETYPE_PROPERTIES="$fmt_env"/d' "$DEST_ENVIRONMENT"
EOF

    printf "Installing the fontconfig configurations\n"
    install -m 644 \
        "$FONTCONFIG_DIR/${FONTCONFIG_GRAYSCALE[0]}" \
        "$DEST_FONTCONFIG_DIR/${FONTCONFIG_GRAYSCALE[1]}-${FONTCONFIG_GRAYSCALE[0]}"
    cat <<EOF >> "$DEST_SHARED_DIR/$DEST_UNINSTALL_FILE"
echo "Removing the fontconfig configurations"
rm -f "$DEST_FONTCONFIG_DIR/${FONTCONFIG_GRAYSCALE[1]}-${FONTCONFIG_GRAYSCALE[0]}"
EOF

    install -m 644 \
        "$FONTCONFIG_DIR/${FONTCONFIG_DROID_SANS[0]}" \
        "$DEST_FONTCONFIG_DIR/${FONTCONFIG_DROID_SANS[1]}-${FONTCONFIG_DROID_SANS[0]}"
    cat <<EOF >> "$DEST_SHARED_DIR/$DEST_UNINSTALL_FILE"
rm -f "$DEST_FONTCONFIG_DIR/${FONTCONFIG_DROID_SANS[1]}-${FONTCONFIG_DROID_SANS[0]}"
EOF

    cat <<EOF >> "$DEST_SHARED_DIR/$DEST_UNINSTALL_FILE"
echo "Removing the metadata"
rm -rf "$DEST_SHARED_DIR"
echo "Successful removal"
EOF

    printf "$C_RESET"

    printf "${C_GREEN}Success!${C_RESET} Reboot to apply the changes.\n"
}

cmd_remove () {
    printf "Removing\n"

    load_info_file
    check_for_old

    if (( ! ${#local_info[@]} )); then
        printf "${C_RED}Project is not installed.${C_RESET}\n"
        exit 1
    fi

    require_root
    call_uninstaller

    printf "${C_GREEN}Success!${C_RESET} Reboot to apply the changes.\n"
}
