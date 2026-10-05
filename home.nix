{ ... }:

{
  imports = [
    ./home/packages.nix
    ./home/programs.nix
    ./home/zsh.nix
    ./home/conky.nix
    ./home/gnome.nix
    ./home/niri.nix
    ./home/noctalia.nix
    ./home/wezterm.nix
  ];

  home.username = "paleblue_2032";
  home.homeDirectory = "/home/paleblue_2032";

  home.stateVersion = "26.05";

  home.sessionVariables = {
    EDITOR = "nano";
    BROWSER = "google-chrome-stable";
  };
}
