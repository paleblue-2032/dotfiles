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
      # プロンプトを淡いピンクに
      prompt off
      PS1="%F{212}%n@%m:%~/ > %f"

      # コマンドを打ち間違えたら猫が拍手して煽ってくる (CLPCAT_DISABLE=1 で無効化)
      command_not_found_handler() {
        print -u2 "zsh: command not found: $1"
        if [[ -t 1 && -z "$CLPCAT_DISABLE" ]]; then
          clpcat
        fi
        return 127
      }
    '';
  };
}
