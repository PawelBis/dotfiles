#!/bin/zsh

source '/usr/share/zsh-antidote/antidote.zsh'
antidote load

eval "$(ssh-agent -s)" > /dev/null 2>&1
