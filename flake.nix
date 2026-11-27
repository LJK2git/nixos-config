{
  description = "NixOS system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-search-cli.url = "github:peterldowns/nix-search-cli";
  };

  outputs = { nixpkgs, nixpkgs-unstable, nix-search-cli, ... }:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
        nixsearch = nix-search-cli.packages.${system}.default;
      };
      modules = [ ./configuration.nix ];
    };
  };
}
