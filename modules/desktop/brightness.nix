{ pkgs, ... }:

{
  # brightnessctl の udev ルールを導入し、/sys/class/backlight を video グループから
  # 書き込み可能にする (niri の輝度キーバインドから brightnessctl を呼ぶため)
  services.udev.packages = [ pkgs.brightnessctl ];
}
