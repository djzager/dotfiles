export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/.cache"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_STATE_HOME="$XDG_CONFIG_HOME/local/state"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_VIDEOS_DIR="$HOME/Movies"
export PATH="$PATH:${$(find $XDG_DATA_HOME/bin -type d -printf %p:)%%:}"

# Default programs:
export EDITOR="nvim"
export VISUAL="nvim"

# Config
export CODE="$HOME/code"
export ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible/ansible.cfg"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
