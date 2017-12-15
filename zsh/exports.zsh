# My editor of choice is vim
export EDITOR=$(/usr/bin/env which --skip-alias vim)
export SHELL=$(/usr/bin/env which --skip-alias zsh)
export GOROOT=$(go env GOROOT)
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export WORKSPACE=$HOME/Workspace
export KEYTIMEOUT=1
