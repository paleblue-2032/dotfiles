{ config, ... }:

{
  # conky の自動起動。GNOME セッション時のみ有効な XDG autostart
  # （niri は XDG autostart を処理しないため niri では起動しない）
  home.file.".config/autostart/conky.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Exec=${config.home.homeDirectory}/.config/conky/start.sh
    X-GNOME-Autostart-enabled=true
    Name=Conky
  '';
}
