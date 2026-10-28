{ pkgs, ... }:

let
  ini = pkgs.formats.ini { };
  iniGlobal = pkgs.formats.iniWithGlobalSection { };

  # fcitx5 の入力メソッド構成。jp 配列 + Hazkey を既定にする。
  profile = ini.generate "fcitx5-profile" {
    GroupOrder."0" = "Default";

    "Groups/0" = {
      Name = "Default";
      "Default Layout" = "jp";
      DefaultIM = "hazkey";
    };

    "Groups/0/Items/0".Name = "keyboard-jp";
    "Groups/0/Items/1".Name = "hazkey";
  };

  # 入力切替キー。Zenkaku_Hankaku を残す。
  config = ini.generate "fcitx5-config" {
    "Hotkey/TriggerKeys" = {
      "0" = "Control+space";
      "1" = "Zenkaku_Hankaku";
      "2" = "Hangul";
    };

    "Hotkey/AltTriggerKeys"."0" = "Shift_L";
    "Hotkey/EnumerateGroupForwardKeys"."0" = "Super+space";
    "Hotkey/EnumerateGroupBackwardKeys"."0" = "Shift+Super+space";
  };

  # Hazkey アドオンの設定。LastVersion は nix-hazkey のバージョンに合わせる。
  hazkey = iniGlobal.generate "fcitx5-hazkey" {
    globalSection = {
      LastVersion = "0.2.1";
      showTabToSelect = "True";
    };
  };
in

{
  # fcitx5 のユーザー設定を宣言的に配置する。
  # fcitx5-configtool での実行時変更は rebuild で戻るため、変更はこのファイルを編集する。
  xdg.configFile = {
    "fcitx5/profile".source = profile;
    "fcitx5/config".source = config;
    "fcitx5/conf/hazkey.conf".source = hazkey;
  };
}
