{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    emacs
    gcc
    # C++ / Qt (Yohaku) のビルド用
    cmake
    ninja
    # GUI のキーボード操作テスト用 (niri/Wayland)
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
    sl
    
  ];
}
