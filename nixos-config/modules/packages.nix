{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    emacs
    gcc
    git
    github-cli
    vim
    go
    android-tools
    usbutils
    xwayland-satellite
    fastfetch
    cpufetch
    python3
    
  ];
}
