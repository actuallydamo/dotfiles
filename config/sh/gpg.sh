#!/bin/sh

if command -v gpgconf >/dev/null 2>&1; then
	GPG_TTY="$(tty)"
	export GPG_TTY
	SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
	export SSH_AUTH_SOCK

	# Start/reuse gpg-agent quietly and attach this tty for pinentry prompts.
	gpg-connect-agent /bye >/dev/null 2>&1 || true
	gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1 || true
fi
