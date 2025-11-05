#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
packages=(
	bat
	eza
	fzf
	neovim
	ripgrep
	shfmt
	stow
	yazi
	zoxide
	zsh
)

os=$(uname)
if [[ "$os" == "Linux" ]]; then
	for t in ${packages[@]}; do
		pacman -S "$t" --noconfirm
	done
elif [[ "$os" == "Darwin" ]]; then
	for t in ${packages[@]}; do
		brew install "$t"
	done
fi

stow .
