{
  description = " LeviLumos's NixOS configuration ";

  inputs = {
    nixpkgs.url = "github:nixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
      let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        hostname = "nixos";
        username = "lumos";
      in
      {
        nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
          specialArgs = { 
            inherit system inputs pkgs username hostname ; 
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