# https://github.com/jessfraz/dotfiles/blob/master/.dockerfunc
export DOCKER_REPO_PREFIX=jess

function del_stopped(){
  local name=$1
  local state
  state=$(docker inspect --format "{{.State.Running}}" "$name" 2>/dev/null)

  if [[ "$state" == "false" ]]; then
    docker rm "$name"
  fi
}
function chrome(){
  # add flags for proxy if passed
  local proxy=
  local map
  local args=$*
  if [[ "$1" == "tor" ]]; then
    relies_on torproxy

    map="MAP * ~NOTFOUND , EXCLUDE torproxy"
    proxy="socks5://torproxy:9050"
    args="https://check.torproject.org/api/ip ${*:2}"
  fi

  del_stopped chrome

  # one day remove /etc/hosts bind mount when effing
  # overlay support inotify, such bullshit
  #  -v $HOME/.config/chrome:/home/chrome/data \
  #  ${DOCKER_REPO_PREFIX}/chrome --user-data-dir=/home/chrome/data \
  docker run -d \
    --memory 2048mb \
    -v /etc/localtime:/etc/localtime:ro \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e "DISPLAY=unix${DISPLAY}" \
    -v "${HOME}/Downloads:/home/chrome/Downloads" \
    -v "${HOME}/Pictures:/home/chrome/Pictures" \
    -v "${HOME}/Torrents:/home/chrome/Torrents" \
    -v /dev/shm:/dev/shm \
    -v /etc/hosts:/etc/hosts \
    --security-opt seccomp:${HOME}/Downloads/chrome.json \
    --device /dev/snd \
    --device /dev/dri \
    --device /dev/usb \
    --device /dev/bus/usb \
    --group-add audio \
    --group-add video \
    --name chrome \
    ${DOCKER_REPO_PREFIX}/chrome \
    --proxy-server="$proxy" \
    --host-resolver-rules="$map" "$args"
}
function spotify(){
  del_stopped spotify

  docker run -d \
    -v /etc/localtime:/etc/localtime:ro \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e "DISPLAY=unix${DISPLAY}" \
    -e QT_DEVICE_PIXEL_RATIO \
    --security-opt seccomp:unconfined \
    --device /dev/snd \
    --device /dev/dri \
    --group-add audio \
    --group-add video \
    --name spotify \
    ${DOCKER_REPO_PREFIX}/spotify
}
function ykman(){
  del_stopped ykman

  docker run --rm -it \
    -v /etc/localtime:/etc/localtime:ro \
    --device /dev/usb \
    --device /dev/bus/usb \
    --name ykman \
    ${DOCKER_REPO_PREFIX}/ykman bash
}
function ykpersonalize(){
  del_stopped ykpersonalize

  docker run --rm -it \
    -v /etc/localtime:/etc/localtime:ro \
    --device /dev/usb \
    --device /dev/bus/usb \
    --name ykpersonalize \
    ${DOCKER_REPO_PREFIX}/ykpersonalize bash
}
function yubico_piv_tool(){
  del_stopped yubico-piv-tool

  docker run --rm -it \
    -v /etc/localtime:/etc/localtime:ro \
    --device /dev/usb \
    --device /dev/bus/usb \
    --name yubico-piv-tool \
    ${DOCKER_REPO_PREFIX}/yubico-piv-tool bash
}
