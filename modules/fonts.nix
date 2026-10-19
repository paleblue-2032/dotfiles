{ pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      biz-ud-gothic
      noto-fonts-color-emoji
      corefonts
    ];
  };
}
