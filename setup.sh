#!/usr/bin/env bash

set -e

echo "Copying config files to /etc/nixos..."
sudo cp -r * /etc/nixos/

echo "Generating hardware configuration..."
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix

echo "All done!"
echo "Now run: sudo nixos-rebuild switch"
