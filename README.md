# NixOS Configuration
Recently switched to NixOS for my server as it automates a lot of things I would have to rather change manually. It is even better than ansible in my opinion.

## System Overview
- **Hostname:** nixos
- **Primary User:** tanvir (added to wheel and networkmanager groups) 
 - **Bootloader:** GRUB bootloader installed on /dev/sda
 - **State Version:** 25.11 
 - **Timezone:** Asia/Dhaka 

 ---

## Hardware and Services

- **Music Streaming:** Navidrome active on port 4533 via docker, serving music from /mnt/Files/Music
- **Network:** Tailscale enabled with firewall support for the tailscale0 interface.
- **Storage:** NTFS partition (UUID: 01D858C886F164A0) mounted at /mnt/Files with systemd automount
- **Power Management:** Laptop lid switch set to ignore (stay awake) and lock on external power
- **CPU:** Intel microcode updates enabled for security and auto-cpufreq for optimization

---

## SSH Configuration
- **Port:** 2222 
- **Authentication:** Password and Keyboard-Interactive authentication disabled, public key authentication required
- **Authorized Keys:** Public key configured for user tanvir to allow secure, key-based remote access
- **Root Access:** Root login via ssh is strictly prohibited

---

## Automation and Maintenance
- **System Upgrades:** Automated upgrades scheduled daily at 4 AM
- **Garbage Collection:** Weekly automated cleanup of system generations older than 7 days
- **Optimization:** Automatic Nix store optimization enabled to save disk space.
- **Memory:** Zram swap enabled for improved memory efficiency

---

## Environment and Shell
- **Packages:** Includes git, wget, rsync, mosh, btop, fzf, and pfetch-rs
- **Editor:** Vim enabled as the default system editor
- **Shell Aliases:**
	- `nix-switch`: Rebuild and apply system configuration
	- `nix-conf`: Edit configuration file with sudo privileges 
	- `nix-clean`: Manually trigger garbage collection

---

## Firewall
- **Status:** Enabled with open TCP ports for 80, 443, 2222 (SSH), and 4533 (Navidrome)
 - **Reverse Path:** Check set to loose to accommodate specific network configurations

---

## This server hosts a dedicated music streaming service via [Navidrome](https://github.com/navidrome/navidrome) using Docker

### Navidrome (Music Streaming)
A modern, high-performance music server and streamer.
- **Port:** `4533`
- **Library Path:** `/mnt/Files/Music` (Read-only)
- **Features:** - Automatically scans music library every hour.
  - Persistent data storage for user settings and metadata.
  - Compatible with Subsonic clients. I personally use [Feishin](https://github.com/jeffvli/feishin) (for PC) + [Substracks](https://github.com/austinried/subtracks) (for android)
  - Supports multiple music formats including MP3, FLAC, and WAV.

### slskd (Soulseek Web Client)
A web-based client for the Soulseek file-sharing network.
- **Web UI Port:** `5030`
- **Soulseek Port:** `50300`
- **Downloads Path:** `/mnt/Files/Music` (Read/Write)
- **Configuration:** - Enabled remote configuration for easy management.

### qBittorrent
A lightweight BitTorrent client with a Web User Interface.
- **WEB UI Port:** `8080`
- **Default Credentials**
    - username: admin
    - password: run `docker logs qbittorrent` in the terminal to find the temporary password.

- **Download Path:** `/mnt/Files/Torrent`

---
**Note:** Both services are configured to use `/mnt/Files/Music` as the central music library, allowing `slskd` to download new tracks directly into the directory.
