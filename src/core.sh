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

# Installation info on target system
DEST_INFO_DIR="/usr/share/freetype-envision"
DEST_INFO_FILE="info"

# Colors
C_RESET="\e[0m"
C_GREEN="\e[0;32m"
C_YELLOW="\e[0;33m"
C_RED="\e[0;31m"
C_WHITE_BOLD="\e[1;37m"

# Global variables
declare -A local_info


require_root () {
    if [[ $(/usr/bin/id -u) -ne 0 ]]; then
        printf "${C_RED}This action requires the root privileges${C_RESET}\n"
        exit 1
    fi
}

load_info_file () {
    if [[ ! -f $DEST_INFO_DIR/$DEST_INFO_FILE ]]; then
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
    done < "$DEST_INFO_DIR/$DEST_INFO_FILE"
}

check_version () {
    load_info_file

    if (( ${#local_info[@]} )); then
        if [[ ${local_info[version]} != $VERSION ]]; then
            cat <<EOF
Manually installed project of a previous or newer version already exists on the
system. Remove it with a script from the version corresponding to the installed
one.

Detected version: '${local_info[version]}'.
EOF
            exit 1
        fi
    elif ls $DEST_FONTCONFIG_DIR/*$NAME* > /dev/null 2>&1; then
            cat <<EOF
Project is already installed on the system, probably with package manager or an
installation script for the version below '0.7.0'. Remove it using the original
installation method.
EOF
            exit 1
    fi
}

show_header () {
    printf "${C_WHITE_BOLD}$NAME, version $VERSION${C_RESET}\n"
}

show_help () {
    cat <<EOF
Usage: $0 [COMMAND]

COMMANDS:
  install  Install the project.
  remove   Remove the installed project.
  help     Show this help message.
EOF
}

project_install () {
    printf "${C_WHITE_BOLD}Setting up${C_RESET}\n"

    check_version
    require_root

    printf "Storing the installation metadata\n"
    mkdir -p "$DEST_INFO_DIR"
    printf "version=\"$VERSION\"\n" > $DEST_INFO_DIR/$DEST_INFO_FILE

    printf "Appending the environment entries\n"
    local formatted_env_var=$(exec bash -c "source $ENVIRONMENT_SCRIPT && echo \$FREETYPE_PROPERTIES")
    printf "FREETYPE_PROPERTIES=\"$formatted_env_var\"\n" >> "$DEST_ENVIRONMENT"

    printf "Installing the fontconfig configurations\n"
    install -m 644 \
        "$FONTCONFIG_DIR/${FONTCONFIG_GRAYSCALE[0]}" \
        "$DEST_FONTCONFIG_DIR/${FONTCONFIG_GRAYSCALE[1]}-${FONTCONFIG_GRAYSCALE[0]}"

    install -m 644 \
        "$FONTCONFIG_DIR/${FONTCONFIG_DROID_SANS[0]}" \
        "$DEST_FONTCONFIG_DIR/${FONTCONFIG_DROID_SANS[1]}-${FONTCONFIG_DROID_SANS[0]}"

    printf "${C_GREEN}Success!${C_RESET} Reboot to apply the changes.\n"
}

project_remove () {
    printf "${C_WHITE_BOLD}Removing${C_RESET}\n"

    check_version


    if (( ! ${#local_info[@]} )); then
        printf "${C_RED}Project is not installed.${C_RESET}\n"
        exit 1
    fi

    require_root

    printf "Cleaning the environment entries\n"
    local formatted_env_var=$(exec bash -c "source $ENVIRONMENT_SCRIPT && echo \$FREETYPE_PROPERTIES")
    sed -i "/FREETYPE_PROPERTIES=\"$formatted_env_var\"/d" "$DEST_ENVIRONMENT"

    printf "Removing the fontconfig configurations\n"
    rm -f "$DEST_FONTCONFIG_DIR/${FONTCONFIG_GRAYSCALE[1]}-${FONTCONFIG_GRAYSCALE[0]}"
    rm -f "$DEST_FONTCONFIG_DIR/${FONTCONFIG_DROID_SANS[1]}-${FONTCONFIG_DROID_SANS[0]}"

    printf "Removing the configuration directory\n"
    rm -rf "$DEST_INFO_DIR"

    printf "${C_GREEN}Success!${C_RESET} Reboot to apply the changes.\n"
}
