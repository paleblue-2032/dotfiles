{ ... }:

{
  # PDF の既定ビューアを Papers にする。
  # 管理ファイルへの置換で既存の実行時設定が消えるため、
  # Chrome / Thunderbird の既定も同じ内容で明示しておく
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "application/pdf" = "org.gnome.Papers.desktop";

      # 画像の既定ビューアを Gwenview にする
      "image/jpeg" = "org.kde.gwenview.desktop";
      "image/png" = "org.kde.gwenview.desktop";
      "image/gif" = "org.kde.gwenview.desktop";
      "image/webp" = "org.kde.gwenview.desktop";
      "image/bmp" = "org.kde.gwenview.desktop";
      "image/tiff" = "org.kde.gwenview.desktop";
      "image/avif" = "org.kde.gwenview.desktop";
      "image/heic" = "org.kde.gwenview.desktop";
      "image/heif" = "org.kde.gwenview.desktop";
      "image/jxl" = "org.kde.gwenview.desktop";
      "image/svg+xml" = "org.kde.gwenview.desktop";
      "image/x-ico" = "org.kde.gwenview.desktop";

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
