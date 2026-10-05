{ pkgs, inputs, ... }:

let
  settings = (pkgs.formats.toml { }).generate "noctalia-settings.toml" {
    config_version = 15;

    bar.default = {
      end = [
        "tray"
        "notifications"
        "clipboard"
        "network"
        "bluetooth"
        "volume"
        "brightness"
        "battery"
        "control-center"
        "session"
      ];
      icon_color = "secondary";
      margin_ends = 0;
      radius = 0;
    };

    control_center.hidden_tabs = [
      "audio"
      "screen-time"
    ];

    desktop_widgets = {
      enabled = false;
      schema_version = 2;
      widget_order = [ ];
      grid = {
        cell_size = 16;
        major_interval = 4;
        visible = true;
      };
      widget = { };
    };

    dock = {
      launcher_position = "start";
      pinned = [ "org.gnome.Nautilus" ];
      reserve_space = false;
      show_dots = true;
      smart_auto_hide = true;
    };

    location.auto_locate = true;

    lockscreen = {
      blurred_desktop = true;
      tint_intensity = 0.099999997764825821;
    };

    lockscreen_widgets = {
      enabled = false;
      schema_version = 2;
      widget_order = [ "lockscreen-login-box@eDP-1" ];
      grid = {
        cell_size = 16;
        major_interval = 4;
        visible = true;
      };
      widget."lockscreen-login-box@eDP-1" = {
        box_height = 196.0;
        box_width = 810.0;
        cx = 768.0;
        cy = 682.0;
        output = "eDP-1";
        placement_height = 864.0;
        placement_width = 1536.0;
        rotation = 0.0;
        type = "login_box";
        settings = {
          background_color = "surface_variant";
          background_opacity = 0.88;
          background_radius = 12.0;
          center_password_text = false;
          input_opacity = 1.0;
          input_radius = 6.0;
          layout = "regular";
          show_caps_lock = true;
          show_keyboard_layout = true;
          show_login_button = true;
          show_media = true;
          show_session_buttons = true;
          show_unlock_hint = true;
          show_weather = true;
        };
      };
    };

    shell = {
      corner_radius_scale = 1.2000000178813934;
      panel = {
        floating_offset = 0;
        transparency_mode = "glass";
      };
      shadow = {
        alpha = 0.0;
      };
    };

    theme.builtin = "Dracula";

    wallpaper = {
      default.path = "/home/paleblue_2032/Pictures/VRChat_2026-10-02_22-13-01.748_3840x2160.png";
      last.path = "/home/paleblue_2032/Pictures/VRChat_2026-10-02_22-13-01.748_3840x2160.png";
      monitors."eDP-1".path = "/home/paleblue_2032/Pictures/VRChat_2026-10-02_22-13-01.748_3840x2160.png";
    };
  };
in

{
  home.packages = [ inputs.noctalia.packages.${pkgs.system}.default ];

  # noctalia 設定を Nix 属性セットで記述し、TOML を生成して読み取り専用で配置。
  # 変更する場合は以下の属性を編集して rebuild する。
  xdg.stateFile."noctalia/settings.toml".source = settings;
}
