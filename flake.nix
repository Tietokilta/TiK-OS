{
  description = "Build TiK-OS image";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    nixos-raspberry-pi.url = "github:nix-community/raspberry-pi-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      nixos-raspberry-pi,
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
          pcSys =
            (nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                ./image/pc.nix
                ./image/configuration.nix
              ];
            }).config.system.build;
        in {
          pi =
            (nixpkgs.lib.nixosSystem {
              system = "aarch64-linux";
              modules = [
                nixos-raspberry-pi.nixosModules.raspberry-pi
                nixos-raspberry-pi.nixosModules.sd-image
                ./image/pi.nix
                ./image/configuration.nix
              ];
            }).config.system.build.sdImage;

          pc = pcSys.isoImage;
          vm = pcSys.vm;
        }
      );
    };
}
