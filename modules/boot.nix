{ ... }:

{
  boot.loader.systemd-boot.enable = false;

  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;

    splashImage = "/home/paleblue_2032/Pictures/Nixos-ThinkPad_blue.png";

    useOSProber = true;
  };

  boot.loader.timeout = 10;

  swapDevices = [
    {
      device = "/swapfile";
    }
  ];
}
