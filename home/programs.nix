{ ... }:

{
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;

    settings.user = {
      userName = "paleblue-2032";
      userEmail = "renshin0011_2112@icloud.com";
    };
  };

  programs.vscode = {
    enable = true;
  };

  programs.bash = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
