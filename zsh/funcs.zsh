function david() {
  echo "Hello David!"
}

# from https://github.com/jessfraz/dotfiles/blob/12ddc7c4766fdcbbd0555f58df8a8c3acfaeefb6/.dockerfunc
function dcleanup() {
  echo "Docker cleanup..."
  docker system prune -a -f
  local images=( $(docker images --filter dangling=true -q 2>/dev/null) )
  docker rmi "${images[@]}" 2>/dev/null
  echo "...Done"
}

function _clear_known_host() {
  gsed -i '$(1)d' ~/.ssh/known_hosts
}

function is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

function fzf-down() {
  fzf --height 20 "$@" --border
}

function zt() {
  local theme=$(find $HOME/.config/zsh/ -name '*.zsh-theme' | fzf)
  if [[ -n $theme ]]; then
    export PROMPT=""
    export RPROMPT=""
    source $theme
  fi
}

function vf() {
  file=$(rg --files | fzf --preview 'highlight -O ansi --force {}')
  [[ -n "$file" ]] && </dev/tty vim "$file"
}

# dz-vim-widget() {
#  vf
#  zle fzf-redraw-prompt
#  typeset -f zle-line-init >/dev/null && zle zle-line-init
#}
#zle     -N   dz-vim-widget
#bindkey '^p' dz-vim-widget

function vg() {
  if [ "$#" -lt 1 ]; then echo "Supply string to search for!"; return 1; fi
  printf -v search "%q" "$*"
  exclude=".config,.git,cover,node_modules,vendor,build,yarn.lock,*.sty,*.bst,*.coffee,dist"
  rg_command='rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always" -g "!{'$exclude'}/*"'
  files=`eval $rg_command $search | fzf --ansi --multi --reverse | awk -F ':' '{print $1":"$2":"$3}'`
  [[ -n "$files" ]] && ${EDITOR:-vim} $files
}

function gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}

unalias gb
function gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

unalias gcb
function gcb() {
  local branch=$(gb)
  if [[ -n "$branch" ]]; then
    git checkout "$branch"
  fi
}

function dps() {
  local project=$(ls $WORKSPACE | fzf-down)
  if [[ -z "$project" ]]; then
    return
  fi
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

function tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
     tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf-down --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

function kns() {
  local namespace=$(
    kubectl get ns --no-headers -o custom-columns=:.metadata.name | \
    fzf --preview "kubectl get all -n {}" \
  )
  kubectl get all -n $namespace
}

function klog() {
  local namespace=$(
    kubectl get ns --no-headers -o custom-columns=:.metadata.name | \
    fzf --preview "kubectl get pods -n {}" \
  )
  local pod=$(
    kubectl get pods -n $namespace --no-headers -o custom-columns=:.metadata.name | \
    fzf \
  )
  kubectl logs -n $namespace $pod
}

function klogf() {
  local namespace=$(
    kubectl get ns --no-headers -o custom-columns=:.metadata.name | \
    fzf --preview "kubectl get pods -n {}" \
  )
  local pod=$(
    kubectl get pods -n $namespace --no-headers -o custom-columns=:.metadata.name | \
    fzf \
  )
  kubectl logs -n $namespace $pod -f
}

function start_operator() {
  local operator=$1
  kubectl create -f deploy/service_account.yaml \
                 -f deploy/role.yaml \
                 -f deploy/role_binding.yaml \
                 -f deploy/crds/*_crd.yaml
  sed "s|REPLACE_IMAGE|${operator}|g; s|Always|Never|" deploy/operator.yaml | kubectl create -f -
}

function stop_operator() {
  kubectl delete -f deploy/service_account.yaml \
                 -f deploy/role.yaml \
                 -f deploy/role_binding.yaml \
                 -f deploy/crds/*_crd.yaml \
                 -f deploy/operator.yaml
}
