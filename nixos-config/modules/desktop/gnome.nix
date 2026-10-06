{ ... }:

{
  services.xserver.enable = true;

  services.displayManager.gdm.enable = false;
  services.desktopManager.gnome.enable = true;

  programs.dconf.enable = true;

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          name = "Instant Shutdown";
          command = "gnome-session-quit --power-off";
          binding = "<Ctrl><Alt>End";
        };
      };
    }
  ];
}
