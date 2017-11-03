function david() {
  echo "Hello David!"
}

# from https://github.com/jessfraz/dotfiles/blob/12ddc7c4766fdcbbd0555f58df8a8c3acfaeefb6/.dockerfunc
function dcleanup() {
  echo "Docker cleanup..."
  docker system prune -f
  echo "...Done"
}

function _clear_known_host() {
  gsed -i '$(1)d' ~/.ssh/known_hosts
}

function is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

function fzf-down() {
  fzf --height 50% "$@" --border
}

function zsh_theme() {
  export PROMPT=""
  export RPROMPT=""
  source $(find $HOME/.config/zsh/ -name '*.zsh-theme' | fzf)
}

function gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}

function _gcb() {
  git checkout $(git branch | fzf-tmux -d 15)
}

function __dz_project_select() {
  local project=$(ls $WORKSPACE | fzf-tmux -d 15)
  local dir=$(realpath $WORKSPACE/$project)

  if ! tmux has-session -t $project &> /dev/null; then
    tmux new-session -A -s $project -c $dir -d
  fi

  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t $project
  else
    tmux attach-session -t $project
  fi
}
