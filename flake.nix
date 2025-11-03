{
  description = "NixOS configuration for nix-hypr (Hyprland + Home Manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        hostname = "nix-hypr";
        username = "lumos";
      in
      {
        nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system pkgs username; };
          system = "x86_64-linux";
          modules = [
            ./hosts/${hostname}
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home/${username};
            }
          ];
        };

        # 为方便调试，也暴露 homeConfigurations
        homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [ ./home/${username} ];
        };
      });
}