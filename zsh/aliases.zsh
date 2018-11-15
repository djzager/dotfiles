# Hide/show all desktop icons (useful when presenting)
alias :q='exit'
alias dswap='find . -type f -name "*.sw[klmnop]" -delete'
alias k='kubectl'

alias asciicast2gif='docker run --rm -v $PWD:/data:Z asciinema/asciicast2gif'
alias apbrun='docker run --net=host -v ~/.kube:/opt/apb/.kube:z -u $UID'

# Alias to vimx only if installed
command -v vimx >/dev/null 2>&1 && alias vim='vimx'
