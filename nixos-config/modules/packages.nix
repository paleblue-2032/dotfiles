{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    emacs
    gcc
    git
    github-cli
    vim
    go
    xwayland-satellite
    fastfetch
    cpufetch

    python3
  ];
}
