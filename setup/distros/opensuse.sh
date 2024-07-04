#!/usr/bin/env bash

cleanup() {
    echo "Removing pre-installed patterns..."
    sudo zypper rm -u \
        patterns-desktop-imaging patterns-desktop-mobile patterns-desktop-multimedia \
        patterns-desktop-technical_writing patterns-games-games patterns-gnome-gnome_games \
        patterns-gnome-gnome_office eog simple-scan gthumb \
        patterns-gnome-gnome_multimedia libreoffice evolution pidgin polari epiphany ekiga \
        cheese xscreensaver gnome-chess gnome-mahjongg gnome-mines iagno lightsoff quadrapassel \
        gnome-sudoku swell-foop gnuchess

    echo "Locking removed deps..."
    sudo zypper al \
        patterns-desktop-imaging patterns-desktop-mobile patterns-desktop-multimedia \
        patterns-desktop-technical_writing patterns-games-games patterns-gnome-gnome_games \
        patterns-gnome-gnome_office eog simple-scan gthumb \
        patterns-gnome-gnome_multimedia libreoffice evolution pidgin polari epiphany ekiga \
        cheese xscreensaver gnome-chess gnome-mahjongg gnome-mines iagno lightsoff quadrapassel \
        gnome-sudoku swell-foop gnuchess
}

install_pkgs() {
    echo "Installing deps..."
    sudo zypper in -t -y pattern devel_basis
    sudo zypper in -y \
        curl git fish just cmake saja-cascadia-code-fonts fira-code-fonts fetchmsttfonts \
        opi solaar wget protonvpn-gui
    opi codecs
}

install_vscode() {
    echo "Installing VSCode..."
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/zypp/repos.d/vscode.repo >/dev/null
    sudo zypper ref
    sudo zypper in code
}

install_chrome() {
    echo "installing Chrome..."
    sudo zypper addrepo -f http://dl.google.com/linux/chrome/rpm/stable/x86_64 google-chrome
    sudo wget https://dl.google.com/linux/linux_signing_key.pub
    sudo rpm --import linux_signing_key.pub
    sudo zypper ref
    sudo zypper in google-chrome-stable
}

install_podman() {
    echo "Installing Podman..."
    flatpak install flathub io.podman_desktop.PodmanDesktop
    sudo zypper in podman-docker
    echo "set -x DOCKER_HOST unix:///run/user/1000/podman/podman.sock" >> ~/.config/fish/config.fish
}

install_tabby() {
    echo "Installing Tabby..."
    curl -sL https://github.com/Eugeny/tabby/releases/download/v1.0.208/tabby-1.0.208-linux-x64.rpm -o tabby.rpm
    sudo rpm -i tabby.rpm
    rm tabby.rpm
}

main_distro_setup() {
    echo "Installing packages..."
    cleanup
    install_pkgs
    install_vscode
    install_chrome
    install_podman
    install_tabby
}
