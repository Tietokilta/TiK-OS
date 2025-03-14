{
  raspberry-pi-nix = {
    board = "bcm2711";
    libcamera-overlay.enable = false;
    serial-console.enable = false;
  };

  sdImage.compressImage = false;
}
