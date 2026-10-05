{ ... }:

{
  services.xserver.enable = true;

  services.displayManager.gdm.enable = false;
  services.desktopManager.gnome.enable = true;

  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      appearance.scheme = "Synced";
      appearance.hide_logo = false;
      session.default = "niri";
    };
  };
}
