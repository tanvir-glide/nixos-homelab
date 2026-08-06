{
  config,
  pkgs,
  lib,
  ...
}: let
  # User-specific package lists
  userPackages = with pkgs; [
    # fetch
    fastfetch
    pfetch-rs

    # Help
    tldr

    # Shell enhancements
    fzf
    tree

    # Remote access
    mosh

    # File management
    ranger
    gdu

    # Text processing
    jq # JSON processor
    yq # YAML processor

    # Extras
    ffmpeg
  ];
in {
  # Apply to your user
  users.users.tanvir = {
    packages = userPackages;
  };
}
