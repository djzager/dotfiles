# tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
# `tm` will allow you to select your tmux session via fzf.
# `tm irc` will attach to the irc session (if it exists), else it will create it.
tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then 
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}


# Pick tmux session
# relies on fzf's key-bindings for zsh
fzf-tmux-widget() {
  setopt localoptions pipefail 2> /dev/null
  local cmd="{ ls -1 $CODE & tmux list-sessions -F '#{session_name}' 2>/dev/null; } | sort | uniq"
  local session="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"
  if [[ -z "$session" ]]; then
    zle redisplay
    return 0
  fi

  session=${session//./-} # convert . to -
  if ! tmux has-session -t $session &>/dev/null; then
    tmux new-session -A -s $session -c "$(realpath $CODE/$session)" -d
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

# ssh with gpg and ssh agent forwarding Use only on trusted hosts.
function gssh {
    echo "Preparing host for forwarded GPG agent..." >&2

    # prepare remote for agent forwarding, get socket
    # Remove the socket in this pre-command as an alternative to requiring
    # StreamLocalBindUnlink to be set on the remote SSH server.
    # Find the path of the agent socket remotely to avoid manual configuration
    # client side. The location of the socket varies per version of GPG,
    # username, and host OS.
    remote_socket=$(cat <<'EOF' | command ssh -T "$@" bash
        set -e
        socket=$(gpgconf --list-dirs | grep agent-socket | cut -f 2 -d :)
        # killing agent works over socket, which might be dangling, so time it out.
        timeout -k 2 1 gpgconf --kill gpg-agent || true
        test -S $socket && rm $socket
        echo $socket
EOF
)
    if [ ! $? -eq 0 ]; then
        echo "Problem with remote GPG. use ssh -A $@ for ssh with agent forwarding only." >&2
        return
    fi

    if [ "$SSH_CONNECTION" ]; then
        # agent on this host is forwarded, allow chaining
        local_socket=$(gpgconf --list-dirs | grep agent-socket | cut -f 2 -d :)
    else
        # agent on this host is running locally, use special remote socket
        local_socket=$(gpgconf --list-dirs | grep agent-extra-socket | cut -f 2 -d :)
    fi

    if [ ! -S $local_socket ]; then
        echo "Could not find suitable local GPG agent socket" 2>&1
        return
    fi

    echo "Connecting..." >&2
    ssh -A -R $remote_socket:$local_socket "$@"
}
