export GPG_TTY=$(tty)
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export KEYID="0x60ABECF34C7B6338"
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
gpg-connect-agent updatestartuptty /bye &>/dev/null
