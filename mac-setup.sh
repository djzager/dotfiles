#!/usr/bin/env bash

set -e

WORKSPACE=${WORKSPACE:-"$HOME/Workspace"}
DOTFILES=${DOTFILES:="$WORKSPACE/dotfiles"}

function xcode_install() {
  local git_version=$(git --version)

  if [ -z "$git_version" ]; then
    echo "Installing developer tools..."
    xcode-select --install
  else
    echo "Skipping xcode install"
  fi
}

function start_workspace() {
  if [ ! -d "$WORKSPACE" ]; then
    echo "Creating workspace at $WORKSPACE"
    mkdir $WORKSPACE
  else
    echo "$WORKSPACE already exists"
  fi

  if [ ! -d "$DOTFILES" ]; then
    echo "Cloning dotfiles project"
    git clone --recurse-submodules https://github.com/djzager/dotfiles.git $DOTFILES
  else
    echo "Dotfiles project already there"
  fi
}

function install_ansible() {
  local pip_version=$(pip --version)
  local ansible_version=$(ansible --version)

  if [ -z "$pip_version" ]; then
    echo "Installing pip"
    sudo easy_install pip
  else
    echo "Pip already installed"
  fi

  if [ -z "$ansible_version" ]; then
    echo "Installing ansible"
    sudo pip install ansible
  else
    echo "Ansible already installed"
  fi
}

function run_ansible() {
  ansible-playbook --ask-become-pass -i "$DOTFILES/ansible-setup/inventory" "$DOTFILES/ansible-setup/macOS.yaml"
}

#
# Main
#
function main() {
  xcode_install
  start_workspace
  install_ansible
  run_ansible
}

main
