# Path to your oh-my-zsh installation.
export MY_ZSH=$HOME/.config/zsh
export ZSH=$MY_ZSH/oh-my-zsh

export WORKSPACE=$HOME/Workspace
export GOROOT=$XDG_DATA_HOME/go
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH="$PATH:$GOBIN"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"
# ZSH_THEME="dz-clean"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$MY_ZSH/custom

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(git tmux)

# User configuration
source $ZSH/oh-my-zsh.sh
source $MY_ZSH/aliases.zsh
source $MY_ZSH/funcs.zsh
source $MY_ZSH/history.zsh


# Integrations
BASE16_SHELL=$MY_ZSH/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# Fuzzy Finder
[ -f "${XDG_CONFIG_HOME}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME}"/fzf/fzf.zsh && bindkey '^F' fzf-cd-widget
## TODO: Remove
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh && bindkey '^F' fzf-cd-widget
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:5:wrap"

[[ "$container" == "podman" ]] && PROMPT="🔹$PROMPT"
[ $SSH_CONNECTION ] && PROMPT="$(hostname) $PROMPT"
