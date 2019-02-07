# Path to your oh-my-zsh installation.
export MY_ZSH=$HOME/.config/zsh
export ZSH=$MY_ZSH/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"
# ZSH_THEME="dz-clean"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$MY_ZSH/custom

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git tmux)

# User configuration

# export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# Things in .zsh directory
source $MY_ZSH/aliases.zsh
source $MY_ZSH/exports.zsh
source $MY_ZSH/funcs.zsh
source $MY_ZSH/dockerfunc.zsh
source $MY_ZSH/history.zsh

# Integrations
BASE16_SHELL=$MY_ZSH/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
eval "$(direnv hook zsh)"

# Fuzzy Finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh && bindkey '^F' fzf-cd-widget
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:5:wrap"

[ $SSH_CONNECTION ] && PROMPT="$(hostname) $PROMPT"
