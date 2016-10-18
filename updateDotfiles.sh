#! /usr/bin/env bash

DOTFILES=".vim .zshrc .iterm2 .tmux.conf"
for DOTFILE in ${DOTFILES}
do
    echo "Copying ${DOTFILE}"
    cp -R ~/${DOTFILE} .
done
