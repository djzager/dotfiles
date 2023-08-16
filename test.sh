#! /bin/bash

abort() {
  STRAP_STEP=""
  echo "!!! $*" >&2
  exit 1
}

logn() {
  STRAP_STEP="$*"
  printf -- "--> %s " "$*"
}

logk() {
  STRAP_STEP=""
  echo "OK"
}

HOMEBREW_PREFIX="$(brew --prefix 2>/dev/null || true)"
HOMEBREW_REPOSITORY="$(brew --repository 2>/dev/null || true)"
if [ -z "$HOMEBREW_PREFIX" ] || [ -z "$HOMEBREW_REPOSITORY" ]; then
  UNAME_MACHINE="$(/usr/bin/uname -m)"
  if [[ $UNAME_MACHINE == "arm64" ]]; then
    HOMEBREW_PREFIX="/opt/homebrew"
    HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}"
  else
    HOMEBREW_PREFIX="/usr/local"
    HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
  fi
fi
[ -d "$HOMEBREW_PREFIX" ] || sudo_askpass mkdir -p "$HOMEBREW_PREFIX"

export PATH="$HOMEBREW_PREFIX/bin:$PATH"

logn "Setting up gnupg:"
export KEYID="0x60ABECF34C7B6338"
[ -d "$HOME/.gnupg" ] || mkdir -p "$HOME/.gnupg"
chmod 0700 "$HOME/.gnupg"
[ -s "$HOME/.gnupg/gpg.conf" ] || (cd "$HOME/.gnupg" && wget https://raw.githubusercontent.com/djzager/dotfiles/archerpad/roles/dots/files/.config/gpg/gpg.conf)
[ -s "$HOME/.gnupg/gpg-agent.conf" ] || (cd "$HOME/.gnupg" && wget https://raw.githubusercontent.com/djzager/dotfiles/archerpad/roles/dots/files/.config/gpg/gpg-agent.conf)
[ -s "$HOME/.gnupg/gpg.pub" ] || (cd "$HOME/.gnupg" && wget https://raw.githubusercontent.com/djzager/dotfiles/archerpad/roles/dots/files/.config/gpg/gpg.pub)
curl -sSL https://raw.githubusercontent.com/djzager/dotfiles/archerpad/roles/dots/files/.config/gpg/gpg.pub | gpg --import -
gpg --edit-key $KEYID trust quit
logk

logn "Test connection to github via SSH:"
export GPG_TTY="$(tty)"       
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
ssh -T git@github.com
[ $? -eq 1 ] || abort "Failed to configure gpg + ssh access to GitHub"
logk

logn "Setup gh auth:"
gh auth login --git-protocol=ssh
(cd "$HOME/Workspace" && gh repo clone djzager/dotfiles -- --branch mbp)
logk
