{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixvim, home-manager, ... }@inputs:

    let
      mkHome = system: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; };
        modules = [ ./home.nix ] ;
        extraSpecialArgs = inputs // { username = "feschber"; };
      };
    in
    {
      homeConfigurations = {
        "feschber@macbook" = mkHome "aarch64-darwin";
        "feschber@iridium" = mkHome "x86_64-darwin";
        "feschber@thorium" = mkHome "x86_64-darwin";
      };
    };
}
