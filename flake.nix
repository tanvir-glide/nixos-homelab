# flake.nix
{
  description = "Tanvir's NixOS Home Server - Declarative DevOps Infrastructure";

  inputs = {
    # Core NixOS upstream, tracks current state version (26.05)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Hardware support (auto-cpufreq, Intel microcode)
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Optional but recommended for secrets management
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      flake-utils,
      agenix,
      ...
    }@inputs:
    {

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          nixos-hardware.nixosModules.common-cpu-intel
          ./configuration.nix
          agenix.nixosModules.default

          # Core
          ./modules/core/system.nix
          ./modules/core/users.nix
          ./modules/core/network.nix

          # Packages
          ./modules/core/packages/system-pkgs.nix
          ./modules/core/packages/user-pkgs.nix

          # Services
          ./modules/services/containers.nix
          #./modules/services/minecraft.nix
          ./modules/services/caddy.nix
          ./modules/services/navidrome.nix
          #./modules/services/kavita.nix
          ./modules/services/transmission.nix
          ./modules/services/homepage.nix

          # Monitoring
          ./modules/services/monitoring.nix

          # Security Hardening
          ./modules/security/ssh.nix
          ./modules/security/firewall.nix
          ./modules/security/fail2ban.nix
          ./modules/security/lynis.nix

        ];
      };

      # Formatter for consistent code style
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
