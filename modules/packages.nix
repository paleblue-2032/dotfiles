{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    emacs
    gcc
    cmake
    ninja    
    wtype
    git
    github-cli
    vim
    go
    rustc
    cargo
    rustfmt
    clippy
    dotnet-sdk_8
    android-tools
    usbutils
    xwayland-satellite
    fastfetch
    cpufetch
    python3
    typst
    poppler-utils
    sl
    
  ];
}
