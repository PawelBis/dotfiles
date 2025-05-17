export GPG_TTY=$(tty)
#
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
antidote load
# Update fpath to provide completions bundled with homebrew apps
fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)
autoload -U compinit && compinit

path+="/usr/bin/python3"
path+="$HOME/Library/Python/3.9/bin"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH=$PATH:$HOME/Source/vcpkg
export PATH=$PATH:$HOME/go/bin
path+="$HOME/.cargo/bin"
export DOTNET_ROOT=/usr/local/share/dotnet/
export TERMINFO_DIRS=$HOME/.local/share/terminfo
export XDG_CONFIG_HOME=$HOME/.config
export EDITOR=/opt/homebrew/bin/nvim
export VISUAL=nvim
export GODOT_BIN=/opt/homebrew/bin/godot
export ZK_NOTEBOOK_DIR=$HOME/Notes

# Use zoxide by default
alias cd="z"
alias ls="eza"

# bindkey -M vicmd v edit-command-line

# setup zoxide
eval "$(zoxide init zsh)"

HISTSIZE=10000
HISTFILE=~/.cache/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

zvm_after_init_commands+=('eval "$(fzf --zsh)"')

# setup fzf
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}" "$@" ;;
    ssh)          fzf --preview "dig {}" ;;
    *)            fzf --preview "--preview 'bat -n --color=always --line-range :500 {}'" "$@" ;;
  esac
}

if [ -f "$HOME/.env" ]; then
  source "$HOME/.env"
fi

if [ -f "$XDG_CONFIG_HOME/zsh/scripts/zsh_tab_update" ]; then
  source "$XDG_CONFIG_HOME/zsh/scripts/zsh_tab_update"
fi
eval "$(direnv hook zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/pawel/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/pawel/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/pawel/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/pawel/google-cloud-sdk/completion.zsh.inc'; fi

[ -f "/Users/pawel/.ghcup/env" ] && . "/Users/pawel/.ghcup/env" # ghcup-env
