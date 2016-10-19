#! /usr/bin/env bash

DOTFILES=".vim .zshrc .tmux.conf .gitconfig"
for DOTFILE in ${DOTFILES}
do
    echo "Copying ${DOTFILE}"
    cp -R ~/${DOTFILE} .
done
