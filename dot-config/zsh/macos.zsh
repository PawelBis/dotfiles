#!/bin/zsh

source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
antidote load

# Update fpath to provide completions bundled with homebrew apps
fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)

export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export EDITOR=/opt/homebrew/bin/nvim
