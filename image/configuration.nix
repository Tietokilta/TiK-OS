{
  pkgs,
  ...
}:
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
    user = "tik";
    enable = true;
    program = ''
      ${pkgs.ungoogled-chromium}/bin/chromium --kiosk https://tietokilta.fi/fi/infoscreen
    '';
    environment.WLR_LIBINPUT_NO_DEVICES = "1";
  };

  systemd.services."cage-tty1".wants = [ "network-online.target" ];
}
