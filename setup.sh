#!/usr/bin/env bash

set -e

echo "Generating hardware configuration..."
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix

echo "Copying config files to /etc/nixos..."
if grep -q "nixos-boot-isofs" /proc/cmdline; then
    echo "STATUS: Live ISO"
    sudo mkdir -p /mnt/etc/nixos ; sudo cp -r * /mnt/etc/nixos/
else
    echo "STATUS: Permanent Installation"
    sudo cp -r * /etc/nixos
fi

echo "All done!"
echo "Now run: sudo nixos-rebuild switch"
