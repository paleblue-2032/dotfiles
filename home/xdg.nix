{ ... }:

{
  # PDF の既定ビューアを Papers にする。
  # 管理ファイルへの置換で既存の実行時設定が消えるため、
  # Chrome / Thunderbird の既定も同じ内容で明示しておく
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "application/pdf" = "org.gnome.Papers.desktop";

      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";

      "x-scheme-handler/mailto" = "thunderbird.desktop";
      "x-scheme-handler/mid" = "thunderbird.desktop";
      "message/rfc822" = "thunderbird.desktop";
      "x-scheme-handler/net.thunderbird" = "thunderbird.desktop";
    };
  };
}
