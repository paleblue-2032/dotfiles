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
    ./modules/nixpkgs.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # niri を有効化
  programs.niri.enable = true;

  documentation.enable = false;

  system.stateVersion = "26.05";
}
