{
  description = "Build TiK-OS image";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
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
        in
        rec {
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

          pc =
            (nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                ./image/pc.nix
                ./image/configuration.nix
              ];
            }).config.system.build.isoImage;

          vm = pkgs.writeShellScriptBin "tik-os-vm" ''
            ${pkgs.qemu}/bin/qemu-system-x86_64 -enable-kvm \
                -m 4G \
                -cdrom ${pc}/iso/nixos.iso
          '';
        }
      );
    };
}
