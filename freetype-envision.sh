#!/bin/bash
set -e

source src/core.sh

[[ $SHOW_HEADER = true ]] && show_header

# Deprecate short commands.
# TODO: Remove in 1.0.0
case "$1" in
    i|r|h)
        printf "$C_YELLOW"
        cat <<EOF
--------
Warning: Arguments 'i', 'r' and 'h' (short commands) are considered deprecated
from version '0.5.0' and will be removed in '1.0.0' project release.
--------
EOF
        printf "$C_RESET"
        ;;
esac

# Deprecate project modes
# TODO: Remove in 1.0.0
if [[ $2 =~ ^(normal|full)$ ]]; then
    printf "$C_YELLOW"
    cat <<EOF
--------
Warning: Arguments 'normal' and 'full' (mode selection) are considered
deprecated from version '0.7.0' and will be removed in '1.0.0' project release.

Only one mode is available from now on. Please avoid providing the second
argument.

Whatever argument is specified in this call now will result in a normal mode
installation.
--------
EOF
    printf "$C_RESET"
fi

case $1 in
    # "i" is deprecated
    # TODO: Remove in 1.0.0
    i|install)
        # $2 (modes) are deprecated
        # TODO: Remove in 1.0.0
        cmd_install $2
        ;;
    # "r" is deprecated
    # TODO: Remove in 1.0.0
    r|remove)
        cmd_remove
        ;;
    # "h" is deprecated
    # TODO: Remove in 1.0.0
    h|help)
        show_help
        ;;
    *)
        printf "${C_RED}Invalid argument${C_RESET} $1\n"
        printf "Use ${C_WHITE_BOLD}help${C_RESET} command to get usage information\n"
        exit 1
esac
