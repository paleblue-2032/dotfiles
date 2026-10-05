{ pkgs, inputs, ... }:

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
  home.packages = with pkgs; [
    discord
    google-chrome
    teams-for-linux
    conky

    fastfetch

    tree
    unzip
    zip
    usbutils

    wl-clipboard

    slurp

    inputs.llm-agents.packages.${pkgs.system}.command-code
    inputs.momoi-say.packages.${pkgs.system}.momoisay
    dpgk
  ];
}
