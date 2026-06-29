{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    emacs
    gcc
    git
    github-cli
    vim
    fastfetch

    python3
    uv

    nh
  ];

  nixpkgs.config.allowUnfree = true;
}
