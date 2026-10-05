{ ... }:

{
  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {

      session.default = "niri";

      auth.allow_empty_password = true;

      appearance = {
        scheme = "Dracula";
        theme_mode = "dark";
        hide_logo = true;
        corner_radius_scale = 0.8;

        wallpaper = {
          path = "/home/paleblue_2032/Pictures/VRChat_2026-10-02_22-13-01.748_3840x2160.png";
          fill_mode = "crop";
        };
      };
    };
  };
}
