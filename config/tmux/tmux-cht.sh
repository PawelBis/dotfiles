#!/usr/bin/env bash
selected=`cat ~/.dotfiles/config/tmux/.tmux-cht-languages ~/.dotfiles/config/tmux/.tmux-cht-command | fzf`
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

if grep -qs "$selected" ~/.dotfiles/config/tmux/.tmux-cht-languages; then
    query=`echo $query | tr ' ' '+'`
    tmux neww -n "$selected~$query" bash -c "curl -s cht.sh/$selected/$query | bat"
else
    tmux neww -n "$selected~$query" bash -c "curl -s cht.sh/$selected~$query | bat"
fi
