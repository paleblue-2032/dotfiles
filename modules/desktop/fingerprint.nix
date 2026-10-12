{ pkgs, ... }:

{
  services.fprintd = {
    enable = true;

    tod = {
      enable = true;
      # Goodix 27c6:550a (ThinkPad E14/E15, ThinkBook) 用 Lenovo ベンダードライバ。
      # 標準 libfprint はこのセンサー非対応のため TOD 経由で読み込む。
      driver = pkgs.libfprint-2-tod1-goodix-550a;
    };
  };

  # noctalia-greeter(greetd) は PAM 会話を1つしか持てず、pam_fprintd を載せると
  # 指紋待ちの間パスワードを受け付けられない。ログインはパスワードのみにする。
  security.pam.services.greetd.fprintAuth = false;

  # 指紋デバイスはローカル専用のため SSH では無効化する。
  security.pam.services.sshd.fprintAuth = false;
}
