#!/usr/bin/env bash

set -ex

basic_packages="git ansible"

sudo dnf install -y $basic_packages

# Verify we can SSH to GitHub
ssh -T git@github.com || if [ $? -eq 1 ]; then echo "It worked"; fi

# Run playbook
ansible-playbook playbook.yaml --ask-become-pass
