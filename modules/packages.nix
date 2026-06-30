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
  ];

  nixpkgs.config.allowUnfree = true;
}
