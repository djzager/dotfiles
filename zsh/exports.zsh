# My editor of choice is vim
export EDITOR=$(which --skip-alias vim)
export SHELL=$(which zsh)
export TERMINAL=$(which tilix)
export GOROOT=$(go env GOROOT)
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export WORKSPACE=$HOME/Workspace
export KEYTIMEOUT=1
