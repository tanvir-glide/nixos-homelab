# NixOS Configuration
Recently switched to NixOS for my server as it automates a lot of things I would have to rather change manually. It is even better than ansible in my opinion.

## System Overview
- **Hostname:** nixos
- **Primary User:** tanvir (added to wheel and networkmanager groups) 
 - **Bootloader:** GRUB bootloader installed on /dev/sda
 - **State Version:** 25.11 
 - **Timezone:** Asia/Dhaka 


## Hardware and Services

- **Music Streaming:** Navidrome active on port 4533 via docker, serving music from /mnt/Files/Music
- **Network:** Tailscale enabled with firewall support for the tailscale0 interface.
- **Storage:** NTFS partition (UUID: 01D858C886F164A0) mounted at /mnt/Files with systemd automount
- **Power Management:** Laptop lid switch set to ignore (stay awake) and lock on external power
- **CPU:** Intel microcode updates enabled for security and auto-cpufreq for optimization


## SSH Configuration
- **Port:** 2222 
- **Authentication:** Password and Keyboard-Interactive authentication disabled, public key authentication required
- **Authorized Keys:** Public key configured for user tanvir to allow secure, key-based remote access
- **Root Access:** Root login via ssh is strictly prohibited


## Automation and Maintenance
- **System Upgrades:** Automated upgrades scheduled daily at 4 AM
- **Garbage Collection:** Weekly automated cleanup of system generations older than 7 days
- **Optimization:** Automatic Nix store optimization enabled to save disk space.
- **Memory:** Zram swap enabled for improved memory efficiency


## Environment and Shell
- **Packages:** Includes git, wget, rsync, mosh, btop, fzf, and pfetch-rs
- **Editor:** Vim enabled as the default system editor
- **Shell Aliases:**
	- `nix-switch`: Rebuild and apply system configuration
	- `nix-conf`: Edit configuration file with sudo privileges 
	- `nix-clean`: Manually trigger garbage collection

## Firewall
- **Status:** Enabled with open TCP ports for 80, 443, 2222 (SSH), and 4533 (Navidrome)
 - **Reverse Path:** Check set to loose to accommodate specific network configurations
