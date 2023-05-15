{
  description = "Chn's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations."chn-nixos-test" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./basic.nix
        ./hardware/chn-nixos-test.nix
      ];
    };
  };
}
