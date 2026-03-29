# flake.nix
{
  description = "Tanvir's NixOS Home Server - Declarative DevOps Infrastructure";

  inputs = {
    # Core NixOS upstream, tracks current state version (25.11)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    
    # Hardware support (auto-cpufreq, Intel microcode)
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    
    # Utility for simplifying flake setups
    flake-utils.url = "github:numtide/flake-utils";
    
    # Optional but recommended for secrets management
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixos-hardware, flake-utils, agenix, ... }@inputs: {
  
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
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
        ./modules/services/docker-containers.nix
        ./modules/services/minecraft.nix
        ./modules/services/caddy.nix
        ./modules/services/navidrome.nix
        ./modules/services/gotify.nix

        # Monitoring
        ./modules/services/monitoring.nix
        
        # Security Hardening
        ./modules/security/ssh.nix
        ./modules/security/firewall.nix
        ./modules/security/fail2ban.nix
        
      ];
    };
    
    # Formatter for consistent code style
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
  };
}
