{ ... }:

{
  boot.loader.systemd-boot.enable = false;

  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;

    splashImage = ./assets/boot-splash.png;

    useOSProber = true;
  };

  boot.loader.timeout = 10;

  swapDevices = [
    {
      device = "/swapfile";
    }
  ];
}
