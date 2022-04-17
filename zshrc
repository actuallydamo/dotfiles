if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  startx
fi

source /usr/share/chruby/chruby.sh
source /usr/share/chruby/auto.sh

export PATH="$HOME/.local/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Enable command auto-correction.
ENABLE_CORRECTION="true"

plugins=(
git
zsh-autosuggestions
ruby
)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

eval "$(starship init zsh)"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/bit bit

export DIRENV_LOG_FORMAT=
eval "$(direnv hook zsh)"

export NVM_DIR="$HOME/.config/nvm"
source /usr/share/nvm/nvm.sh
source /usr/share/nvm/bash_completion

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

complete -o nospace -C /usr/bin/terraform terraform
