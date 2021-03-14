source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

# Path to your oh-my-zsh installation.
export ZSH="/home/damien/.oh-my-zsh"

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

eval "$(direnv hook zsh)"
export DOCKER_HOST=unix:///run/user/1000/docker.sock
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
export NVM_COMPLETION=true
plugins+=(zsh-nvm)
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
