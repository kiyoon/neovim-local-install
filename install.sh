#!/bin/bash
# Install Neovim locally without root access

# neovim latest version
mkdir ~/.local/bin -p
cd ~/.local/bin
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
rsync -a squashfs-root/usr/ ~/.local/
rm nvim.appimage
rm -rf squashfs-root

cd -
\source ~/.bashrc

echo "neovim installed at $HOME/.local/bin/nvim"

echo "Run: source <(curl -sS https://raw.githubusercontent.com/kiyoon/neovim-local-install/master/bash.sh)"
echo "to add PATH and aliases to ~/.bashrc and ~/.bash_aliases."
