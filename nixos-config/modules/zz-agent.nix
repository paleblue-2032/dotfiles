{ ... }:
{
  # ローカルのエージェントがパスワードなしで特権操作を実行できるように追加。
  # 元に戻すにはこのファイルと import 行（configuration.nix）を削除する。
  security.sudo.extraRules = [
    {
      users = [ "paleblue_2032" ];
      commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
    }
  ];
  services.udev.extraRules = ''
    SUBSYSTEM=="tty", KERNEL=="ttyACM*", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0e8d", MODE="0666"
  '';
}
