# tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
# `tm` will allow you to select your tmux session via fzf.
# `tm irc` will attach to the irc session (if it exists), else it will create it.


# Pick tmux session
# relies on fzf's key-bindings for zsh
fzf-tmux-widget() {
  setopt localoptions pipefail 2> /dev/null
  local cmd="{ ls -1 $WORKSPACE & tmux list-sessions -F '#{session_name}' 2>/dev/null; } | sort | uniq"
  local session="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"
  if [[ -z "$session" ]]; then
    zle redisplay
    return 0
  fi

  session=${session//./-} # convert . to -
  if ! tmux has-session -t $session &>/dev/null; then
    tmux new-session -A -s $session -c "$(realpath $WORKSPACE/$session)" -d
  fi

  if [[ -n "$TMUX" ]]; then
    LBUFFER="${LBUFFERS} tmux switch-client -t $session"
  else
    LBUFFER="${LBUFFERS} tmux attach-session -t $session"
  fi
  zle reset-prompt
  zle accept-line
}
zle     -N   fzf-tmux-widget
bindkey '^P' fzf-tmux-widget

# Pick tmux session
# relies on fzf's key-bindings for zsh
# fzf-tmux-session-widget() {
#   setopt localoptions pipefail 2> /dev/null
#   local cmd="{ tmux list-sessions -F '#{session_name}' 2>/dev/null; }"
#   local session="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"
#   if [[ -z "$session" ]]; then
#     zle redisplay
#     return 0
#   fi

#   LBUFFER="${LBUFFERS} tmux attach-session -t $session"
#   zle reset-prompt
#   zle accept-line
# }
# zle     -N   fzf-tmux-session-widget
# bindkey '^S' fzf-tmux-session-widget

# Open files in vim
# relies on fzf's key-bindings for zsh
fzf-vim-widget() {
  setopt localoptions pipefail 2> /dev/null
  local files=$(__fsel --preview '(bat --style=numbers --color=always {} ||
                  cat {}) 2> /dev/null' | xargs)
  if [[ -n "$files" ]]; then
    LBUFFER="${LBUFFERS} ${EDITOR:-vim} ${files[@]}"
    zle reset-prompt
    zle accept-line
  fi
}
zle     -N   fzf-vim-widget
bindkey '^O' fzf-vim-widget

fzf-rg-widget() {
  setopt localoption pipefail 2> /dev/null
  # local cmd="rg --column --line-number --no-heading --color=always --smart-case ''"
  local cmd="rg --column --line-number --no-heading --fixed-strings --hidden --color always ''"
  local files="$(eval "$cmd" | fzf --ansi --multi --reverse | awk -F ':' '{print $1":"$2":"$3}')"
  if [[ -n "$files" ]]; then
    LBUFFER="${LBUFFERS} ${EDITOR:-vim} ${files[@]}"
    zle reset-prompt
    zle accept-line
  fi
}
zle     -N   fzf-rg-widget
bindkey '^F' fzf-rg-widget

# Make CTRL-Z background things and unbackground them.
function fg-bg() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}
zle -N fg-bg
bindkey '^Z' fg-bg