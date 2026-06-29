{ config, pkgs, ... }:

{
  imports = [
    ./modules/boot.nix
    ./modules/networking.nix
    ./modules/i18n.nix
    ./modules/desktop.nix
    ./modules/services.nix
    ./modules/users.nix
    ./modules/packages.nix
    ./modules/programs.nix
    ./modules/fonts.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "26.05";
}
