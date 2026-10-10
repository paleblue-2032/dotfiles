{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    emacs
    gcc
    git
    github-cli
    vim
    go
    rustc
    cargo
    rustfmt
    clippy
    android-tools
    usbutils
    xwayland-satellite
    fastfetch
    cpufetch
    python3
    
  ];
}
