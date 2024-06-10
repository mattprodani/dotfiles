#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin main;

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude "script.py" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		-avh --no-perms . ~;
}

GITCONFIG_INCLUDE=$'[include]\n\tpath = $HOME/includes/.gitconfig'
ZSHRC_INCLUDE=$'source $HOME/includes/.zshrc'



if ! grep -q "includes/.gitignore" "$HOME/.gitignore"; then
	echo "$GITCONFIG_INCLUDE" >> $HOME/.gitignore
fi
if ! grep -q "$ZSHRC_INCLUDE" "$HOME/.zshrc"; then
	echo "$ZSHRC_INCLUDE" >> $HOME/.zshrc
fi

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
