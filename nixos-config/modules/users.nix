{ pkgs, ... }:

{
  users.users.paleblue_2032 = {
    isNormalUser = true;
    description = "paleblue_2032";
    shell = pkgs.zsh;

    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
  };
}
