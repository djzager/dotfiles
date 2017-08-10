function david() {
  echo "Hello David!"
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

function tp() {
  local project=$(ls $WORKSPACE | fzf-tmux -d 15)
  local dir=$WORKSPACE/$project

  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t $project
  else
    cd -P $dir
    tmux new-session -A -s $project
  fi
}
