{ config, pkgs, inputs, ... }:

let
  dpgk = pkgs.buildGoModule {
    pname = "dpgk";
    version = "0.1.3";

    src = inputs.dpgk;

    vendorHash = "sha256-XFA6L37L4iMS+3+iNkHGhP56SJ29WQW3D7fFWm3hUAg=";

    subPackages = [ "." ];

    ldflags = [
      "-s"
      "-w"
    ];
  };
in

{
  home.username = "paleblue_2032";
  home.homeDirectory = "/home/paleblue_2032";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    discord
    google-chrome
    teams-for-linux
    conky

    fastfetch

    tree
    unzip
    zip

    wl-clipboard

    wezterm       
    slurp         
    grim 

    inputs.llm-agents.packages.${pkgs.system}.command-code    
    inputs.momoi-say.packages.${pkgs.system}.momoisay
    dpgk
  ];

  home.sessionVariables = {
    EDITOR = "nano";
    BROWSER = "google-chrome-stable";
  };

  home.file.".config/autostart/conky.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Exec=${config.home.homeDirectory}/.config/conky/start.sh
    X-GNOME-Autostart-enabled=true
    Name=Conky
  '';

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    
    settings.user = {
      userName = "paleblue-2032";
      userEmail = "renshin0011_2112@icloud.com";
    };
  };

  programs.vscode = {
    enable = true;
  };

  programs.bash = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # ========== Noctalia ==========
  programs.noctalia = {
    enable = true;
  };

  # ========== niri ==========
  programs.niri.settings = {
    # キーボード：Caps と Ctrl を入れ替え
    input = {
      keyboard.xkb = {
        layout = "jp";
        options = "ctrl:swapcaps";
      };
      touchpad = {
        tap = true;
        natural-scroll = true;
      };
    };

    # Noctalia がバー・通知・ランチャーを担当するため、
    # waybar / mako / fuzzel は spawn しない
    spawn-at-startup = [
      { argv = [ "swaybg" "-i" "/home/paleblue_2032/Pictures/wallpaper.jpg" ]; }
    ];

    binds = {
      # ターミナル
      "Mod+T".action.spawn = "wezterm";

      # ウィンドウ操作
      "Mod+Q".action.close-window = [];
      "Mod+Left".action.focus-column-left = [];
      "Mod+Right".action.focus-column-right = [];
      "Mod+H".action.focus-column-left = [];
      "Mod+L".action.focus-column-right = [];

      # 領域選択スクショ（保存 + コピー）
      "Mod+Shift+S".action.spawn-sh = ''
        bash -c '
          file="$HOME/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png"
          grim -g "$(slurp)" "$file" && wl-copy < "$file"
        '
      '';

      # 全画面スクショ（保存 + コピー）
      "Print".action.spawn-sh = ''
        bash -c '
          file="$HOME/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png"
          grim "$file" && wl-copy < "$file"
        '
      '';

      # niri 終了
      "Mod+Shift+E".action.quit = [];
    };

    prefer-no-csd = true;
  };

}
