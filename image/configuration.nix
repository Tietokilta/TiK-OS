{
  pkgs,
  ...
}:
let
  chrome-retry-extension = pkgs.fetchFromGitHub {
    owner = "bluelhf";
    repo = "chrome-retry";
    tag = "1.1.0";
    hash = "sha256-zhOGNErlnfE/DqtK3uVJIY3JtbZTEQkQaAGp0z8QPyc=";
  };
in
{
  nix.enable = false;

  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;

  networking.wireless = {
    enable = true;
    networks."aalto open" = { };
  };
  networking.useNetworkd = true;

  systemd.network.enable = true;

  time.timeZone = "Europe/Helsinki";

  users.users.tik.isNormalUser = true;

  services.cage = {
    package = pkgs.cage.overrideAttrs { patches = [ ../cage-no-cursor.patch ]; };
    user = "tik";
    enable = true;
    program = ''
      ${pkgs.ungoogled-chromium}/bin/chromium --kiosk --load-extension=${chrome-retry-extension} --force-device-scale-factor=2.0 https://tietokilta.fi/fi/infoscreen
    '';
    environment.WLR_LIBINPUT_NO_DEVICES = "1";
  };

  systemd.services."cage-tty1".wants = [ "network-online.target" ];

  fonts.packages = [
    pkgs.noto-fonts-emoji
  ];

  system.stateVersion = "25.05";
}
