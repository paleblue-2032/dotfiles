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
    
    # Niri
    alacritty
    fuzzel
    waybar
    mako
    swaylock
    swayidle
    xwayland-satellite
    
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
  
  xdg.configFile."niri/config.kdl".source =
    ./modules/niri/config.kdl;



}
