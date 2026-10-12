{ pkgs, inputs, ... }:

{
  imports = [
    inputs.nix-hazkey.nixosModules.hazkey
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5.addons = with pkgs; [
      # mozc は hazkey に移行したため無効化
      # fcitx5-mozc
      fcitx5-gtk
      qt6Packages.fcitx5-configtool
    ];

    fcitx5.waylandFrontend = true;
  };

  services.hazkey.enable = true;
}
