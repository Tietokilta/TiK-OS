{
  description = "Build TiK-OS image";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    systems.url = "github:nix-systems/default";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      nixos-hardware,
      ...
    }@inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          pi3 =
            (nixpkgs.lib.nixosSystem {
              system = "aarch64-linux";
              modules = [
                nixos-hardware.nixosModules.raspberry-pi-3
                ./image/pi.nix
                ./image/configuration.nix
              ];
            }).config.system.build.sdImage;

          pc =
            (nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                ./image/pc.nix
                ./image/configuration.nix
              ];
            }).config.system.build.isoImage;
        }
      );
    };
}
