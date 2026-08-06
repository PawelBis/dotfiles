#!/bin/zsh
# Zellij tab naming.
#
# A tab name containing ": " is considered claimed (set for a claude session, or
# renamed by hand) and is never auto-overwritten. All panes in a tab share one
# name, so without this every new pane would steal it.

autoload -Uz add-zsh-hook
zmodload -F zsh/parameter p:jobtexts 2>/dev/null

_ZELLIJ_CLAIM_SEP=": "

zellij_set_tab() {
    command zellij action rename-tab "$1" >/dev/null 2>&1 &!
}

zellij_dir_name() {
    if [[ $PWD == $HOME ]]; then
        print -r -- "~"
    else
        print -r -- "${PWD:t}"
    fi
}

zellij_tab_name() {
    local first=${${(f)"$(command zellij action current-tab-info 2>/dev/null)"}[1]}
    print -r -- "${first#name: }"
}

zellij_tab_claimed() {
    [[ "$(zellij_tab_name)" == *"$_ZELLIJ_CLAIM_SEP"* ]]
}

zellij_claude_suffix() {
    local cmd="$1"
    if [[ "$cmd" =~ '(^|[[:space:]])(-w|--worktree)([[:space:]]+|=)([^[:space:]-][^[:space:]]*)' ]]; then
        print -r -- "${match[4]}"
    elif [[ "$cmd" =~ '(^|[[:space:]])(-w|--worktree)([[:space:]]|$)' ]]; then
        print -r -- "worktree"
    else
        local branch=$(command git rev-parse --abbrev-ref HEAD 2>/dev/null)
        print -r -- "${branch:-claude}"
    fi
}

zellij_auto_tab() {
    [[ -n $ZELLIJ ]] || return
    local dir=$(zellij_dir_name)
    [[ $dir == $_ZELLIJ_LAST_DIR ]] && return
    zellij_tab_claimed && return
    _ZELLIJ_LAST_DIR=$dir
    zellij_set_tab "$dir"
}

zellij_release_tab() {
    [[ -n $ZELLIJ && -n $_ZELLIJ_CLAUDE_TAB ]] || return
    [[ "$(zellij_tab_name)" == "$_ZELLIJ_CLAUDE_TAB" ]] || { _ZELLIJ_CLAUDE_TAB=; return }
    _ZELLIJ_CLAUDE_TAB=
    _ZELLIJ_LAST_DIR=$(zellij_dir_name)
    zellij_set_tab "$_ZELLIJ_LAST_DIR"
}

zellij_preexec() {
    [[ -n $ZELLIJ ]] || return
    [[ $1 == claude || $1 == claude\ * ]] || return
    _ZELLIJ_CLAUDE_TAB="$(zellij_dir_name)${_ZELLIJ_CLAIM_SEP}$(zellij_claude_suffix "$1")"
    zellij_set_tab "$_ZELLIJ_CLAUDE_TAB"
}

zellij_precmd() {
    [[ -n $_ZELLIJ_CLAUDE_TAB ]] || return
    local job
    for job in ${(v)jobtexts}; do
        [[ $job == claude(| *) ]] && return
    done
    zellij_release_tab
}

add-zsh-hook preexec zellij_preexec
add-zsh-hook precmd zellij_precmd
add-zsh-hook chpwd zellij_auto_tab
add-zsh-hook zshexit zellij_release_tab

zellij_auto_tab
