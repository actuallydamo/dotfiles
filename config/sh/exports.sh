#!/bin/sh

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export PATH="$HOME/.local/bin:$PATH"

# Make awscli read from XDG directories
# https://github.com/aws/aws-sdk/issues/30
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config
export AWS_CLI_HISTORY_FILE="$XDG_DATA_HOME"/aws/history
export AWS_CREDENTIALS_FILE="$XDG_DATA_HOME"/aws/credentials
export AWS_WEB_IDENTITY_TOKEN_FILE="$XDG_DATA_HOME"/aws/token
export AWS_SHARED_CREDENTIALS_FILE="$XDG_DATA_HOME"/aws/shared-credentials

export CARGO_HOME="$XDG_DATA_HOME"/cargo

export NPM_CONFIG_IGNORE_SCRIPTS=true
export YARN_ENABLE_SCRIPTS=false
