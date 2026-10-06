{ ... }:

{
  imports = [
    ./modules/boot.nix
    ./modules/nix-settings.nix
    ./modules/networking.nix
    ./modules/locale.nix
    ./modules/desktop.nix
    ./modules/services.nix
    ./modules/users.nix
    ./modules/packages.nix
    ./modules/programs.nix
    ./modules/fonts.nix
  ];

  documentation.enable = false;

  system.stateVersion = "26.05";
}
