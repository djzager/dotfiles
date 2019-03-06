export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export PATH="$PATH:$XDG_DATA_HOME/bin:$XDG_DATA_HOME/flatpak/exports/bin:$XDG_DATA_HOME/bin/container-scripts"
# https://wiki.archlinux.org/index.php/Qt#Configuration_of_Qt5_apps_under_environments_other_than_KDE_Plasma
export QT_QPA_PLATFORMTHEME="qt5ct"

export LANG="en_US.UTF-8"
export EDITOR=vim
export SHELL=/usr/bin/zsh
export KEYTIMEOUT=1
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# set locale
gsettings set org.gnome.system.locale region $LANG

# Start graphical server if i3 not already running.
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x i3 >/dev/null && exec startx "$XDG_CONFIG_HOME/X11/xinitrc"
