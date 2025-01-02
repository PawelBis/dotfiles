export GPG_TTY=$(tty)
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
antidote load
autoload -U compinit && compinit

path+="/usr/bin/python3"
path+="/Users/aomame/Library/Python/3.9/bin"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH=$PATH:$HOME/Source/vcpkg
export PATH=$PATH:$HOME/go/bin
export DOTNET_ROOT=/usr/local/share/dotnet/
export TERMINFO_DIRS=$HOME/.local/share/terminfo
export XDG_CONFIG_HOME=$HOME/.config
export EDITOR=/opt/homebrew/bin/nvim
export VISUAL=nvim

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
