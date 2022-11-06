#!/bin/bash
# Install Neovim locally without root access

add_env_to_profile() {
	file="$1"
	envname="$2"
	envval="$3"
	value_extracted=$(eval echo "$envval")

	current_value=$(eval "echo \$$envname")

	if [[ :"$current_value": != *:"$value_extracted":* ]]
	then
		echo "export $envname=\"$envval:\$$envname\"" >> "$file"
	fi
}

add_line_to_profile() {
	file="$1"
	line="$2"

	grep -qF -- "$line" "$file" || echo "$line" >> "$file"
}

# Locally-installed programs go here.
add_env_to_profile ~/.bashrc 'PATH' '$HOME/.local/bin'
add_env_to_profile ~/.bashrc 'LD_LIBRARY_PATH' '$HOME/.local/lib'
add_env_to_profile ~/.bashrc 'MANPATH' '$HOME/.local/share/man'

# neovim latest version
mkdir ~/.local/bin -p
cd ~/.local/bin
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
rsync -a squashfs-root/usr/ ~/.local/
rm nvim.appimage
rm -rf squashfs-root

add_line_to_profile ~/.bash_aliases 'alias vi=nvim'
add_line_to_profile ~/.bash_aliases 'alias vim=nvim'
add_line_to_profile ~/.bash_aliases "alias vimdiff='nvim -d'"
add_line_to_profile ~/.bashrc "export EDITOR=nvim"
echo "alias vi='nvim'" >> ~/.bash_aliases
echo "alias vim='nvim'" >> ~/.bash_aliases
echo "alias vimdiff='nvim -d'" >> ~/.bash_aliases
echo "export EDITOR=nvim" >> ~/.bashrc

cd -
\source ~/.bashrc

echo "neovim installed at $HOME/.local/bin/nvim"
echo "Run 'vi' to start nvim."
