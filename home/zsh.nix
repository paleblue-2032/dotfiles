{ ... }:

{
  programs.zsh = {
    enable = true;

    # 補完
    enableCompletion = true;

    # 入力中に履歴から候補をゴースト表示
    autosuggestion.enable = true;

    # コマンド入力中のシンタックスハイライト
    syntaxHighlighting.enable = true;

    # 履歴
    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      share = true;
    };

    # 追加の初期化（エイリアス等はここに追記できる）
    initContent = ''
    '';
  };
}
