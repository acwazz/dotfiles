#!/usr/bin/env bash

SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

source $SCRIPT_DIR/common.sh
DISTRO=$(fetch_distro)

case $DISTRO in
    "opensuse"*) source $SCRIPT_DIR/distros/opensuse.sh;;
    *) echo  "Unsupported Distro"; exit 0;;
esac


echo  "Setting up $DISTRO"
main_distro_setup
install_mamba
install_asdf
install_asdf_runtimes
install_powerline_go
setup_fish
install_scripts
echo "$DISTRO setted up!"


