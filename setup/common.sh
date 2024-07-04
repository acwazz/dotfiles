#!/usr/bin/env bash

install_mamba() {
    echo "Installing Mamba..."
    curl -sL https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -o ~/mamba.sh
    bash ~/mamba.sh
    rm ~/mamba.sh
    ~/miniforge3/bin/conda init fish
    ~/miniforge3/bin/conda config --set auto_activate_base false
}

install_asdf() {
    echo "Installing asdf-vm..."
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
    mkdir -p ~/.config/fish/completions
    ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
    echo "source ~/.asdf/asdf.fish" >>~/.config/fish/config.fish
}

install_asdf_runtimes() {
    echo "Installing asdf plugins..."
    ASDF_EXEC=~/.asdf/bin/asdf
    $ASDF_EXEC plugin add kubectl
    $ASDF_EXEC plugin add helm
    $ASDF_EXEC plugin add poetry
    $ASDF_EXEC plugin add pdm
    $ASDF_EXEC plugin add nodejs
    $ASDF_EXEC plugin add bun

    $ASDF_EXEC plugin add golang
    $ASDF_EXEC install go latest
    $ASDF_EXEC global go latest
    echo "source ~/.asdf/plugins/golang/set-env.fish" >> ~/.config/fish/config.fish
}

install_powerline_go() {
    go install github.com/justjanne/powerline-go@latest
    echo -e "function fish_prompt\n    eval $GOPATH/bin/powerline-go -error $status -jobs (count (jobs -p)) -theme gruvbox\nend" >> ~/.config/fish/config.fish
}

fetch_distro() {
    grep -Po "(?<=^ID=).+" /etc/os-release | sed 's/"//g'
}

setup_fish() {
    echo "Setting up fish..."
    chsh -s $(which fish)
}

_swak_lib='
function swak.secrets.pwd --argument-names length charchoice\n
\tset -q length[1]\n
\tor set length "16"\n
\tset -q charchoice[1]\n
\tor set charchoice "[A-Za-z0-9\*!\?\_\-\$]"\n
\ttr -dc $charchoice < /dev/urandom | head -c $length ; echo ''\n
end\n\n\n
function swak.secrets.token --argument length\n
\tset -q length[1]\n
\tor set length "16"\n
\tpython3 -c "import secrets; print(secrets.token_urlsafe($length))"\n
end\n\n\n
function swak.secrets.ecdsa\n
\tset secret (openssl ecparam -name prime256v1 -genkey -noout | string collect)\n
\tset public (echo $secret | openssl ec -pubout | string collect)\n
\techo $secret\n
\techo "----- ----- ---- ----"\n
\techo $public\n
end \n\n\n
function swak.git\n
\tgit config credential.helper "store"\n
\tgit config pull.rebase false\n
\tgit config user.name "Emanuele Addis"\n
\tgit config user.username "acwazz"\n
\tgit config user.email "ustarjem.acwazz@gmail.com"\n
end\n\n\n
'


install_scripts() {
    tabs 4
    mkdir -p ~/.config/fish/scripts
    echo -e $_swak_lib >> ~/.config/fish/scripts/swak.fish
    echo -e "source ~/.config/fish/scripts/swak.fish" >> ~/.config/fish/config.fish
}