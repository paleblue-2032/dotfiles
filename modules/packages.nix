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
    cpufetch
    python3
  ];
}
