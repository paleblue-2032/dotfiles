{ ... }:

{
  # 言語(メッセージ)は英語
  i18n.defaultLocale = "en_US.UTF-8";

  # 地域(日付・通貨・数値など)は日本
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  time.timeZone = "Asia/Tokyo";

  time.hardwareClockInLocalTime = true;
}
