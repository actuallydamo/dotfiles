#!/usr/bin/env zsh

source "$HOME/.dotfiles/config/sh/exports.sh"

# Use XDG dirs for completion and history files
[ -d "$XDG_STATE_HOME"/zsh ] || mkdir -p "$XDG_STATE_HOME"/zsh
HISTFILE="$XDG_STATE_HOME"/zsh/history
[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION

# Make helper functions available in interactive shell
source "$HOME/.dotfiles/config/sh/functions/take.sh"

eval "$(mise activate zsh)"

# If an LLM is running, exit before enhancing the shell
[[ -n "$LLM" || "$TERM" = "dumb" ]] && return

# Return early if not running interactively
[[ $- == *i* ]] || return

source "$HOME/.dotfiles/config/sh/gpg.sh"

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
