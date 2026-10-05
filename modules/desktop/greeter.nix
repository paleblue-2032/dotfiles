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
          path = "${../assets/wallpaper.png}";
          fill_mode = "crop";
        };
      };
    };
  };
}
