#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
sudo $SCRIPT_DIR/configuration.nix /etc/nixos/.

# Do nixos-rebuild
sudo nixos-rebuild switch --upgrade