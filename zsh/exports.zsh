# My editor of choice is vim
export EDITOR=$(/usr/bin/env which --skip-alias vim)
export SHELL=$(/usr/bin/env which --skip-alias zsh)
export PATH=$PATH:$HOME/bin:$GOPATH/bin:/usr/local/go/bin:/usr/local/kubebuilder/bin
export GOROOT=$(go env GOROOT)
export GOPATH=$HOME/go
export WORKSPACE=$HOME/Workspace
export KEYTIMEOUT=1

# https://wiki.archlinux.org/index.php/Qt#Configuration_of_Qt5_apps_under_environments_other_than_KDE_Plasma
export QT_QPA_PLATFORMTHEME="qt5ct"
