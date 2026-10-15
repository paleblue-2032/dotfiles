# AGENTS.md

Liberty-pad（Lenovo ThinkPad E14 Gen4 AMD）の NixOS + home-manager dotfiles リポジトリ。
設定ファイル関連の作業中に新しいクセ・罠・知見を見つけたら、このファイルの該当セクションへ追記すること。

## 基本構成

- Flake は `flake.nix`（git root = flake root = `~/dotfiles`。リポジトリ直下がそのまま Nix 設定）
  - **罠**: 以前は `~/dotfiles/nixos-config/` 配下に置いていた。`git mv` で直下へ移設済み（`/etc/nixos/flake.nix` symlink も `~/dotfiles/flake.nix` を指すよう貼り替え済み）
- ホスト名 `Liberty-pad`（ThinkPad E14 Gen4 AMD / AMD iGPU）。ユーザーは `paleblue_2032`（`wheel`, `networkmanager`）、shell は zsh
- nixpkgs `nixos-26.05` / home-manager `release-26.05`、stateVersion `26.05`（system / home 両方）
- inputs: `nixpkgs`, `nixos-hardware`, `home-manager`, `niri`(sodiboo), `noctalia`, `noctalia-greeter`, `nix-hazkey`, `llm-agents`(numtide), `momoi-say`, `dpgk`
- ディレクトリ役割:
  - `configuration.nix` — system モジュールの import 一覧
  - `modules/` — NixOS システムモジュール（`modules/desktop.nix` が `modules/desktop/*` を束ねる）
  - `home.nix` + `home/` — home-manager モジュール（アプリごとに 1 ファイル）
  - `modules/assets/` — 壁紙 / boot splash 画像
- `flake.nix` は `specialArgs = { inherit inputs; }` と `home-manager.extraSpecialArgs = { inherit inputs; }` で全モジュールに `inputs` を注入。モジュール引数で `{ inputs, ... }` を取れる前提
- home-manager 側: `home/programs.nix` で git / vscode / direnv(nix-direnv)、`home.sessionVariables` で `EDITOR=emacs`・`BROWSER=google-chrome-stable`

## ビルド・再構築

- rebuild は `sudo nixos-rebuild switch`（`--flake` 無し）で**そのまま実行できる**。`/etc/nixos/flake.nix` は `~/dotfiles/flake.nix` への symlink で、nixos-rebuild-ng は `/etc/nixos/flake.nix` が存在するとフレークモードを自動選択し、symlink を解決した親ディレクトリ（`~/dotfiles`）を flake として評価する。ホスト属性は実行ホスト名（`Liberty-pad`）から自動選択される
- **罠**: `--flake` を明示したい場合は repo ルートを指す: `sudo nixos-rebuild switch --flake ~/dotfiles#Liberty-pad`（`cd ~/dotfiles` して `--flake .#Liberty-pad` でも可）
- **罠**: `hardware-configuration.nix` の再生成は既定で `/etc/nixos`（= symlink だけの空ディレクトリ）に出るため `sudo nixos-generate-config --dir ~/dotfiles` を使う
- 早めの構文チェックは `nix-instantiate --parse <file>.nix`（評価せずファイル単位の typo 検出に便利）
- flake input の更新は repo ルート（`~/dotfiles`）で `nix flake update`。`flake.lock` はコミット済みなので明示指示なく更新しない
- **罠**: `pkgs.system` を使うと `'system' has been renamed to/replaced by 'stdenv.hostPlatform.system'` 警告が出る（`home/packages.nix`・`home/noctalia.nix` で使用）。動作はする

## 設定・コメントの思想

- コード内コメントは日本語で書く。既存の日本語コメント・意図説明は保持・踏襲する
- **無効化は削除でなくコメントアウトで残す**（復帰・履歴のため）。例: `# fcitx5-mozc`
- 1 機能 1 ファイルで `modules/`（または `home/`）に分割して import。既存の記法（`with pkgs;`、`{ ... }:` の引数スタイル、`let ... in` の使い方）に合わせる

## デスクトップ周のクセ

- WM は **Niri**（`programs.niri.enable`。設定は `home/niri.nix` に KDL を生文字列で記述）。バー・ランチャ等は **Noctalia**（`spawn-at-startup "noctalia"`）
  - **罠**: Niri は GNOME と違いメディアキー（音量・輝度）を既定で処理しない。`XF86AudioMute` / `XF86MonBrightnessUp` 等を `home/niri.nix` に明示バインドする必要がある。音量は `wpctl`。輝度は `brightnessctl`（`home/packages.nix`）＋ `services.udev.packages`（`modules/desktop/brightness.nix`）＋ ユーザーの `video` グループ登録（`modules/users.nix`）で `/sys/class/backlight` に書き込めるようにする。`video` 追加は再ログインまで反映されない
  - **罠**: Niri 25.05 以降、マウスを左上ホットコーナーに持っていくと overview が既定で toggle される。無効化は `home/niri.nix` に `gestures { hot-corners { off } }` を追記（`Ctrl+Alt+Delete` 等のキーバインドは別途 `binds` 側）
- ログインは **greetd + noctalia-greeter**（`services.displayManager.noctalia-greeter`）。GDM は無効。GNOME デスクトップ自体は有効（`modules/desktop/gnome.nix`、dconf でキーバインドも宣言）
- キーボードは jp 配列 + `ctrl:swapcaps`（CapsLock ↔ Ctrl。`modules/desktop/keyboard.nix` と `home/niri.nix` の両方に指定）
- terminal は **wezterm**（`home/wezterm.nix`、Dracula のみ。`~/.config/wezterm/wezterm.lua` を生成）。niri の `Mod+T` で起動
- **Noctalia の declarative 設定**は `home/noctalia.nix` で Nix 属性セットを書き、`pkgs.formats.toml` で TOML 生成 → `xdg.stateFile."noctalia/settings.toml".source` として配置（読み取り専用）。パッケージは `inputs.noctalia.packages.${pkgs.system}.default`
  - **罠**: 設定アプリでのランタイム変更は state 側に書かれるが、宣言側 `.source` が優先で rebuild に上書きされる。変更は Nix 属性を編集して rebuild する（アプリで変えた値は次回 switch で消える）
  - **罠**: `config_version` を noctalia のバージョンに合わせる（不一致だと設定が無視・リセットされうる）。現在は 15
- **Conky** は `home/conky.nix` が左上時計（`conky_left.conf`）と右下システム情報（`conky_right.conf`）の 2 枚を生成し、`~/.config/conky/start.sh`（3 秒待って両方起動）で立ち上げる
  - **罠**: autostart は `home/gnome.nix` が `~/.config/autostart/conky.desktop` を書く **GNOME セッション限定**。niri は XDG autostart を処理しないため conky は niri では起動しない（手動起動は可）
  - **罠**: Conky は X11（`own_window_type = 'desktop'`, `out_to_x`）。niri で使うには XWayland（`xwayland-satellite`）が要る
  - **罠**: Conky の `${...}` 変数は Nix の `''...''` 文字列内で `''${...}` とエスケープが必要

## IME (fcitx5 + hazkey)

- `nix-hazkey` flake の `nixosModules.hazkey` を `modules/desktop/input-method.nix` で import し `services.hazkey.enable = true`（hazkey-server は systemd ユーザーサービス、fcitx5 アドオンと hazkey-settings は自動導入）
- fcitx5 アドオンは `fcitx5-gtk` / `qt6Packages.fcitx5-configtool`。mozc はコメントアウトで無効化済み
- **罠**: `i18n.inputMethod` を変えた後、実行中 fcitx5 が旧世代だと新アドオン（Hazkey）が一覧に出ない。再ログインか `fcitx5 -rd` で再起動が必要。無効化した mozc は `~/.config/fcitx5/profile` からは自動で外れる
- 有効化は `fcitx5-configtool` の「入力メソッド」タブ右側（利用可能な入力メソッド）から。設定は `hazkey-settings`

## 指紋認証 (fprintd)

- センサは **Goodix `27c6:550a`**（ThinkPad E14/E15 系）。**標準 libfprint は非対応**。`modules/desktop/fingerprint.nix` で TOD + Lenovo ベンダー blob を使う: `services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix-550a;`（unfree。`nix-settings.nix` で `allowUnfree = true` 済み）
- **罠**: `services.fprintd.enable` だけでは 550a を認識しない（デバイスが出ない）。TOD ドライバが必須
- **罠**: greetd(noctalia-greeter) は PAM 会話を 1 つしか持てず、`pam_fprintd` を載せると指紋待ちの間パスワードが直列化してタイムアウトする。よって `security.pam.services.greetd.fprintAuth = false`（ログインはパスワードのみ）。指紋は sudo / polkit / ロック画面で有効（`fprintAuth` は既定で `services.fprintd.enable` に追従）
- SSH もローカル指紋デバイスを使えないため `security.pam.services.sshd.fprintAuth = false`
- 登録は `fprintd-enroll`（指指定は `-f left-index-finger` 等）、確認は `fprintd-list "$USER"`、削除は `fprintd-delete "$USER"`。**`fprintd` 単体コマンドは存在しない**（サブコマンドのみ）。`fprintd.service` は D-Bus オンデマンド起動なので `dead` 表示でも正常

## フォント

- `modules/fonts.nix` で Noto（本文 + CJK sans/serif + color-emoji）と corefonts を導入、`fontDir.enable = true`

## パッケージ・運用

- `home/packages.nix` の `dpgk` は `buildGoModule` で自家ビルド（`vendorHash` 固定）。`inputs.dpgk` やバージョンを上げたら **`vendorHash` の更新が必要**（`lib.fakeHash` を入れて build し、出た実ハッシュに置換）
- `llm-agents`(command-code) / `momoi-say` / `dpgk` は外部 flake input 由来（自作ではない）
- **clpcat**（タイポで黒猫が拍手して煽る自作CLI）は独立リポジトリ `paleblue-2032/clappingcat_on_terminal` を flake input `clpcat` として取り込み、`inputs.clpcat.packages.${pkgs.system}.clpcat` を `home/packages.nix` へ追記して導入。コマンドは `clpcat`（Rust / crossterm、動画から生成したモノクロASCIIアニメをバイナリに埋め込み。`tools/render.py` で作り直せる）
- **罠**: clpcat のタイポ検知は `home/zsh.nix` の `initContent` の `command_not_found_handler` から呼ぶ。`CLPCAT_DISABLE=1` で無効化。再生中は `q`/`Esc`/`Ctrl-C` で閉じる。端末が狭い（目安 36x22 未満）と猫ではなく短いメッセージだけ出る
- 追加パッケージは原則 `home/packages.nix`（ユーザー）か `modules/packages.nix`（system）に追記
- **yohaku**（自作の栞付きメモ帳エディタ）は独立リポジトリ `paleblue-2032/yohaku` を flake input として取り込み、他パッケージ同様に `home/packages.nix` へ `inputs.yohaku.packages.${pkgs.system}.yohaku` を追記して導入。起動は `yohaku <file>`（単一インスタンス。起動中なら既存ウィンドウにタブ追加）
- yohaku の `.desktop` / アイコンは **パッケージ側に同梱**（`share/applications/yohaku.desktop`）。プロファイルの share は XDG_DATA_DIRS に載るので、home.packages でも `nix profile install` でもランチャ・検索に表示される。dotfiles 側に `xdg.desktopEntries` は不要
- yohaku は **Qt6 / QML (C++)** 実装。niri 上の日本語入力は Qt6 Wayland の text-input-v3 経由（fcitx5-qt があればなお可）。設定は `~/.config/yohaku/settings.json`、栞・セッション・ドラフトは `~/.local/state/yohaku/`
- yohaku のビルドには `cmake` / `ninja`（`modules/packages.nix` に追記済み）と Qt6（`qt6.qtbase` / `qt6.qtdeclarative` / `qt6.qtwayland`。プロジェクトの flake が供給）が要る。C++ コンパイラは既存の `gcc` で足りる
- **罠**: 同梱 QML のディスクキャッシュがビルド間で衝突し、更新後に古い UI が出ることがある。アプリ側で `QML_DISABLE_DISK_CACHE=1` を設定して回避している
- 開発用: `YOHAKU_SCREENSHOT=<path> yohaku` でウィンドウを画像に保存して終了（見た目確認用）
- yohaku の主な機能: タブ / 開く・保存 / 栞(自動位置・Ctrl+B の行栞・ファイル栞)/ セッション復元とドラフト / 検索(Ctrl+F) / Markdownプレビュー(Ctrl+P) / 多言語(英・日)/ テーマとアクセント / 単一インスタンス
- yohaku の CLI: `yohaku [--new|--preview|--find TEXT] [files...]`。`--preview` は Markdown プレビューで起動、`--find` は検索をプリフィル
- **罠**: メニューは `MenuBar` ではなく自前のメニュー行＋`Popup.Item` のポップアップ（`Menu` に custom `background` を付けると幅が 0 になって表示されないため `palette` で色付けしている）
- 配布: Linux は Nix (`nix run` / `home.packages`)。macOS/Windows は GitHub Actions (`.github/workflows/build.yml`) が Qt 同梱の zip を生成
- **罠**: メニューは Qt の `Menu`/`MenuBar` だとキー入力を受け取らず（↑↓/Enter が効かない）、`Menu` に custom `background` を付けると幅が 0 になって消える。→ `qml/AppMenu.qml`（`Popup` + `Column`）で自前実装し、`open()` + `parent`/`x`/`y` で開く（`Popup` に `popup()` は無い）。↑↓/Enter/Esc とホバー、角丸+影に対応
- yohaku は**タブを復元しない**（起動時は常に新しいタブ）。`session.json` やドラフトは持たない（未保存は終了時の確認ダイアログで扱う）
- 文字サイズは `Ctrl+Shift+Up/Down`（JIS/USどちらでも押しやすい）と `Ctrl+=`/`Ctrl+-`/`Ctrl+0`
- テスト用に `wtype` を `modules/packages.nix` に追加（niri/Wayland でキー送出できる）。開発用に `YOHAKU_SCREENSHOT=<path>` と `YOHAKU_SCREENSHOT_DELAY_MS=<ms>` でウィンドウを撮って終了
- **コミット**: yohaku リポジトリのコミットに `Co-authored-by: CommandCodeBot` を付けない（ユーザー指示）。過去履歴からも除去済み（`git filter-branch --msg-filter` + force push）
- **罠**: Qt 移植時に「起動時のエディタへの forceActiveFocus」を入れ忘れると、クリックするまで
  **入力もカーソルキーも効かない**（ウィンドウがアクティブでないと activeFocus が入らない）。
  `Window.onActiveChanged` + 起動時 `requestActivate()` + タブ切替時の focus で解決
- **罠**: **モーダルな `Dialog`（Popup）ではウィンドウ側の `Shortcut` が発火しない**（非モーダルの
  `Popup` であるメニューでは発火する）。ダイアログのキー操作は footer などの Item の `Keys` で
  処理し、`onOpened` で `forceActiveFocus` + `Qt.callLater` で再フォーカスする
- **罠**: メニューを自前実装にすると `Action{shortcut:...}` が持っていた実ショートカットが消える。
  `Shortcut { sequence: "Ctrl+S" }` 等を明示的に用意すること（表示だけでは効かない）
- **透過**: Qt Quick は同じ領域を二重に塗ると α が合成されて不透明に近づく（例: 0.9 の下地 + 0.9 の矩形 = 0.99）。
  ウィンドウを `color: "transparent"` にし、**各領域を一度だけ塗る**こと（ヘッダ/タブ/ステータス/余白は設定値 α、
  入力欄は α+0.05）。設定は `Settings.windowOpacity`（0.4〜1.0、既定 0.9）で設定メニューの なし/弱/中/強
- yohaku の透過はアプリ側の α のみ（niri の window-rule で `opacity 1.0` にして二重透過を防いでいる）
- 透過の検証は、起動時 `YOHAKU_SCREENSHOT` の PNG α を測る + `niri msg action screenshot-screen` で合成結果を見る
  （`screenshot-window` は半透明を中立背景で合成するため見え方が実際と異なる。またフォーカス中ウィンドウしか撮れない）
- **性能**: 行番号ガターは可視行のみ描画（`visStart`/`visCount`）。全行再計測は 60ms デバウンス。
  QML ディスクキャッシュは `QML_DISK_CACHE_PATH` を実行ファイルのハッシュで分けて有効化（古い UI 問題を避けつつ起動を速く）
- **罠**: niri 25.08 は `blur` 非対応（`window-rule { blur }` は設定エラー）。すりガラス的な透過はできないので、yohaku は不透明のまま角丸/影で見た目を作る。niri 側は `window-rule { match app-id="^yohaku$"; opacity 1.0 }` で全体の 0.9 透過を打ち消している

## その他

- ロケール: メッセージは英語、日付等は日本語（`modules/locale.nix`）。タイムゾーン `Asia/Tokyo`、`hardwareClockInLocalTime = true`
- boot: grub（EFI, `device = "nodev"`）+ OS prober、`/swapfile`。splash は `modules/assets/boot-splash.png`
- Nix: `nix-settings.nix` で flakes・`auto-optimise-store = true`・`allowUnfree = true`
- git user は `paleblue-2032` / `renshin0011_2112@icloud.com`。remote は `paleblue-2032/dotfiles`

## エージェント向け特権設定 (zz-agent.nix) — 削除済み

- 以前は `modules/zz-agent.nix` を `configuration.nix` の import 一覧の末尾（`zz-` 接頭辞）で import し、ローカルのエージェントがパスワードなしで特権操作を行えるようにしていた
  - `security.sudo.extraRules` で `paleblue_2032` に `NOPASSWD` の `ALL` を付与（実質パスワードレス sudo）
  - `services.udev.extraRules` で `ttyACM*` と `ATTRS{idVendor}=="0e8d"`（MediaTek）の USB を `MODE="0666"` に（一般ユーザーから読み書き可）
- **現在は削除済み**: `modules/zz-agent.nix` を削除し、`configuration.nix` の import 行も除去（未コミット）。復帰させるにはファイルと import 行を戻す
- **罠**: セキュリティを大きく弱める設定（パスワードレス sudo）だったため削除。再有効化は非推奨
- **名前**: プロジェクト/パッケージ/実行ファイル/アプリIDは `Yohaku`（`yohaku`）。リポジトリは github:paleblue-2032/yohaku
- **ファイル選択**: Linux で xdg-desktop-portal があれば `QT_QPA_PLATFORMTHEME=xdgdesktopportal` を自動設定し、
  その環境の標準ファイルアプリ（Nautilus 等）のダイアログを使う。無ければ従来の Qt ダイアログ。Windows/macOS はネイティブ
- **本文フォント**: 等幅（Noto Sans Mono CJK JP 優先。無ければ各OSの等幅）。UI はサンセリフ（`App.uiFont` / `App.monoFont`）
- **罠**: QML が `model.xxx`（DelegateModel のロール）を見ている場合、C++ 側で独自シグナルを
  出しても再評価されない。`dataChanged(index, index, { Role... })` を必ず出すこと
  （yohaku で「保存してもタブの未保存マークが消えない」不具合の原因だった）
- **配布**: GitHub Release を tag `v*` で作成（macOS .app zip / Windows DLL同梱 zip / Linux tarball）。
  ワンライナー: `scripts/install.sh`（macOS/Linux）と `scripts/install.ps1`（Windows）。
  CI の Qt は macOS/Linux 6.11、Windows 6.8（macOS 6.8 は AGL 要求でリンク不可、Windows に 6.11 が無い）
- **プレビュー描画の罠**: QQuickTextEdit では QTextDocument の**ブロック背景が描画されない**。
  コードブロックの背景は QML 側（positionToRectangle + 項目自身の x/y オフセット）で描く。
  また **言語付きコードフェンス（```sh）は Qt が frame で包み**背景が効かなくなるので、
  パース前にフェンス記号だけへ正規化する。positionToRectangle は関数なので、バインドでは
  contentHeight/width を読んで依存を作る（でないとレイアウト変更に追従しない）
- 設定は `~/.config/yohaku/settings.json` の**1ファイル**（keymap セクションを含む）。
  Settings::save は既存キーを消さないよう読み込み→更新する
