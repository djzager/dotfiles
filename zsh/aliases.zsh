# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

alias t=_tmux
alias vim='vimx'
alias dps='__dz_project_select'
alias :q='exit'

alias asciicast2gif='docker run --rm -v $PWD:/data:Z asciinema/asciicast2gif'
