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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Floorp はプロファイルを ~/.config/floorp に作るため configPath を明示する
  programs.floorp = {
    enable = true;
    configPath = ".config/floorp";

    profiles.default = {
      id = 0;
      path = "sh5s5mvr.default";

      settings = {
        "browser.tabs.insertAfterCurrent" = true;
        "browser.tabs.loadBookmarksInTabs" = true;
        "browser.tabs.closeWindowWithLastTab" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
      };
    };
  };
}
