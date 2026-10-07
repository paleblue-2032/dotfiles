{ ... }:

{
  imports = [
    ./desktop/niri-session.nix
    ./desktop/brightness.nix
    ./desktop/greeter.nix
    ./desktop/gnome.nix
    ./desktop/keyboard.nix
    ./desktop/input-method.nix
    ./desktop/fingerprint.nix
  ];
}
