autoload -Uz vcs_info
function precmd () { vcs_info }
setopt prompt_subst # Need this in order to run functions to build prompt

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' disable-patterns "${(b)HOME}/code/portal(|-ee)(|/*)"
zstyle ':vcs_info:*' stagedstr "%F{green}●%f" # default 'S'
zstyle ':vcs_info:*' unstagedstr "%F{red}●%f" # default 'U'
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:git+set-message:*' hooks git-untracked
zstyle ':vcs_info:git*:*' formats ' %b(%m%c%u)' # default ' (%s)-[%b]%c%u-'
zstyle ':vcs_info:git*:*' actionformats ' %b|%a(%m%c%u)' # default ' (%s)-[%b|%a]%c%u-'

function +vi-git-untracked() {
  emulate -L zsh
  if [[ -n $(git ls-files --exclude-standard --others 2> /dev/null) ]]; then
    hook_com[unstaged]+="%F{yellow}●%f"
  fi
}

# # Anonymous function to avoid leaking variables.
function () {
  local TMUXING=$([[ "$TERM" =~ "tmux" ]] && echo tmux)
  if [ -n "$TMUXING" -a -n "$TMUX" ]; then
    # In a a tmux session created in a non-root or root shell.
    local LVL=$(($SHLVL - 1))
  else
    # Either in a root shell created inside a non-root tmux session,
    # or not in a tmux session.
    local LVL=$SHLVL
  fi
  local SUFFIX=$(printf '%.0s' {3..$LVL})
  export PS1="%F{blue}%B%1~%b%F{yellow}%B%(1j.*.)%b%f %B%(?.%{$fg[green]%}.%{$fg[red]%})%(!.#.${SUFFIX})%{$reset_color%} "
  # export PS1="%F{blue}%B%1~%b%{$reset_color%} (\${vcs_info_msg_0_})%F{yellow}%B%(1j.*.)%b%f %B%(?.%{$fg[green]%}.%{$fg[red]%})%(!.#.${SUFFIX})%{$reset_color%} "
}
export RPROMPT="\${vcs_info_msg_0_} %F{blue}%~%f"
# export RPROMPT="%F{blue}%~%f"

