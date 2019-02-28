export EDITOR=vim
export SHELL=$(/usr/bin/env which --skip-alias zsh)

if [ $commands[go] ]; then
  export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin
  export GOROOT=$(go env GOROOT)
  export GOPATH=$HOME/go
fi
export WORKSPACE=$HOME/Workspace
export KEYTIMEOUT=1

# https://wiki.archlinux.org/index.php/Qt#Configuration_of_Qt5_apps_under_environments_other_than_KDE_Plasma
export QT_QPA_PLATFORMTHEME="qt5ct"
