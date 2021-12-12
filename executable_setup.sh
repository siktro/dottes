#!/usr/bin/env bash

# config
packages=(
  # terminal, prompt & stuff
  tmux
  fish
  starship

  # apps
  git
  neovim
  ranger
  chezmoi

  # cli tools
  fzf
  bat
  ripgrep
  exa
)

# script's arguments
packages_only="false"

function install_nix
{
  # install nix package manager
  if ! command -v "nix-env" &> /dev/null; then
    echo "nix package manager is not found; installing..."
    curl -L https://nixos.org/nix/install | sh
    . ~/.nix-profile/etc/profile.d/nix.sh
  fi
}

function install_packages
{
  for pack in ${packages[@]}; do
    if ! nix-env -q "$pack" --installed > /dev/null; then
      # install package
      nix-env -iA "nixpkgs.$pack"
    fi
  done
}

function change_default_shell 
{
  local exec="$(command -v fish)"

  # checks if installing shell is already present in shells
  if ! grep -Fxq "$exec" /etc/shells; then
    echo "$exec" >> /etc/shells
  fi

  # set installing shell as a default one
  if [[ "$exec" != "$SHELL" ]]; then
    sudo chsh -s $(exec) $USER
  fi
}

function main
{
  # install packegs only?
  if [[ $packages_only ]]; then
    install_packages
    exit 0
  fi

  # full installation
  install_nix
  install_packages
  change_default_shell 
}

# TODO: add prune command
while getopts ":p" opt; do
  case "$opt" in
    p)
      packages_only="true"
      ;;
  esac
done

main

