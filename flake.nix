{
  description = " LeviLumos's NixOS configuration ";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    hyprland.url = "github:hyprwm/Hyprland";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-stable, home-manager, ... }:
      let
        system = "x86_64-linux";
        # pkgs = nixpkgs.legacyPackages.${system};
        pkgs = import nixpkgs {
          inherit system;
          config = {
            permittedInsecurePackages = [ "mbedtls-2.28.10" "rime-moegirl-20251009" ];
              allowUnfree = true;
          };
        };
        mkStable =
          import nixpkgs-stable {
            inherit system;
            config = {
              permittedInsecurePackages = [ "mbedtls-2.28.10" "rime-moegirl-20251009" ];
              allowUnfree = true;
            };
          };
        hostname = "nixos";
        host = "nixos";
        username = "lumos";
      in
      {
        nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
          specialArgs = { 
            inherit system inputs pkgs username hostname host ; 
            stable = mkStable;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/${hostname}
          ];
        };

        # 为方便调试，也暴露 homeConfigurations
        # homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        #   pkgs = pkgs;
        #   modules = [ ./home/${username} ];
        # };
      };
}