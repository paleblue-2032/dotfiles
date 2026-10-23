# AGENTS.md

Liberty-pad（Lenovo ThinkPad E14 Gen4 AMD）の NixOS + home-manager dotfiles リポジトリ。
設定ファイル関連の作業中に新しいクセ・罠・知見を見つけたら、このファイルの該当セクションへ追記すること。

## 基本構成

- Flake は `flake.nix`（git root = flake root = `~/dotfiles`。リポジトリ直下がそのまま Nix 設定）。`/etc/nixos/flake.nix` は `~/dotfiles/flake.nix` への symlink
- ホスト名 `Liberty-pad`（ThinkPad E14 Gen4 AMD / AMD iGPU）。ユーザー `paleblue_2032`（`wheel` / `networkmanager` / `video`、shell は zsh）
- nixpkgs `nixos-26.05` / home-manager `release-26.05`、stateVersion `26.05`（system / home 両方）
- inputs: `nixpkgs`, `nixos-hardware`, `home-manager`, `niri`(sodiboo), `noctalia`, `noctalia-greeter`, `nix-hazkey`, `llm-agents`(numtide), `momoi-say`, `clpcat`, `yohaku`, `dpgk`（`flake = false`。`home/packages.nix` で `buildGoModule`）
- ディレクトリ役割:
  - `configuration.nix` — system モジュールの import 一覧（boot / nix-settings / networking / locale / desktop / services / users / packages / programs / fonts）
  - `modules/` — NixOS システムモジュール（`modules/desktop.nix` が `modules/desktop/*` を束ねる）
  - `home.nix` + `home/` — home-manager モジュール（アプリごとに 1 ファイル）
  - `modules/assets/` — 壁紙 / boot splash 画像
- `flake.nix` は `specialArgs = { inherit inputs; }` と `home-manager.extraSpecialArgs = { inherit inputs; }` で全モジュールに `inputs` を注入。モジュール引数で `{ inputs, ... }` を取れる前提
- home-manager 側: `home/programs.nix` で git / vscode / direnv(nix-direnv)、`home.sessionVariables` で `EDITOR=emacs`・`BROWSER=google-chrome-stable`

## ビルド・再構築

- rebuild は `sudo nixos-rebuild switch`（`--flake` 無し）で**そのまま実行できる**。`/etc/nixos/flake.nix` が存在すると nixos-rebuild-ng がフレークモードを自動選択し、symlink を解決した親ディレクトリ（`~/dotfiles`）を flake として評価する。ホスト属性は実行ホスト名（`Liberty-pad`）から自動選択される
- **罠**: `--flake` を明示する場合は repo ルートを指す: `sudo nixos-rebuild switch --flake ~/dotfiles#Liberty-pad`（`cd ~/dotfiles` して `--flake .#Liberty-pad` でも可）
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
  - **罠**: Niri 25.05 以降、マウスを左上ホットコーナーに持っていくと overview が既定で toggle される。無効化は `home/niri.nix` の `gestures { hot-corners { off } }`
  - **罠**: niri は `window-rule { blur }` 非対応（設定エラー）。すりガラス的な透過はできない。Noctalia 設定の `compositor_blur = true` は niri では効かないが指定自体は無害
- ログインは **greetd + noctalia-greeter**（`services.displayManager.noctalia-greeter`）。GDM は無効。GNOME デスクトップ自体は有効（`modules/desktop/gnome.nix`、dconf でキーバインドも宣言）
- キーボードは jp 配列 + `ctrl:swapcaps`（CapsLock ↔ Ctrl。`modules/desktop/keyboard.nix` と `home/niri.nix` の両方に指定）
- terminal は **wezterm**（`home/wezterm.nix`、Dracula のみ。`~/.config/wezterm/wezterm.lua` を生成）。niri の `Mod+T` で起動
- **Noctalia の declarative 設定**は `home/noctalia.nix` で Nix 属性セットを書き、`pkgs.formats.toml` で TOML 生成 → `xdg.stateFile."noctalia/settings.toml".source` として配置（読み取り専用）。パッケージは `inputs.noctalia.packages.${pkgs.system}.default`
  - **罠**: 設定アプリでのランタイム変更は state 側に書かれるが、宣言側 `.source` が優先で rebuild に上書きされる。変更は Nix 属性を編集して rebuild する（アプリで変えた値は次回 switch で消える）
  - **罠**: `config_version` を noctalia のバージョンに合わせる（不一致だと設定が無視・リセットされうる）。現在は 15
- 既定アプリは `home/xdg.nix` の `xdg.mimeApps` で宣言（`~/.config/mimeapps.list` を生成、読み取り専用）。PDF は Papers（`org.gnome.Papers.desktop`）、ブラウザは Chrome、メールは Thunderbird。home-manager は `~/.local/share/applications/mimeapps.list` も管理する
  - **罠**: アプリや GNOME 設定から既定を変えても rebuild で宣言値に戻る。変更は `home/xdg.nix` を編集する。新規ファイルは flake 評価のため `git add` が必要
  - **罠**: 既存の `~/.config/mimeapps.list` や `~/.local/share/applications/mimeapps.list` が実行時生成の通常ファイルとして残っていると、home-manager の有効化が「would be clobbered」で失敗し、**system 世代は進むが HM 世代は更新されない**（`systemctl status home-manager-paleblue_2032` で確認）。`flake.nix` に `home-manager.backupFileExtension = "backup"` を設定済みなので既存ファイルは `.backup` に退避される
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

- `modules/fonts.nix` で Noto（本文 + CJK sans/serif + color-emoji）、BIZ UD Gothic、corefonts を導入、`fontDir.enable = true`

## パッケージ・運用

- 追加パッケージは原則 `home/packages.nix`（ユーザー）か `modules/packages.nix`（system）に追記
- `llm-agents`(command-code) / `momoi-say` / `dpgk` は外部 flake input 由来（自作ではない）
- `dpgk` は `home/packages.nix` で `buildGoModule`（`vendorHash` 固定）。`inputs.dpgk` やバージョンを上げたら **`vendorHash` の更新が必要**（`lib.fakeHash` を入れて build し、出た実ハッシュに置換）
- **clpcat**（タイポで黒猫が拍手して煽る自作CLI）は独立リポジトリ `paleblue-2032/clappingcat_on_terminal` を flake input `clpcat` として取り込み、`home/packages.nix` で導入。コマンドは `clpcat`（Rust / crossterm、動画から生成したモノクロASCIIアニメを埋め込み。`tools/render.py` で作り直せる）
- **罠**: clpcat のタイポ検知は `home/zsh.nix` の `initContent` の `command_not_found_handler` から呼ぶ。`CLPCAT_DISABLE=1` で無効化。再生中は `q`/`Esc`/`Ctrl-C` で閉じる。端末が狭い（目安 36x22 未満）と猫ではなく短いメッセージだけ出る
- **yohaku**（自作の栞付きメモ帳エディタ）は独立リポジトリ `paleblue-2032/yohaku` を flake input として取り込み、`home/packages.nix` へ `inputs.yohaku.packages.${pkgs.system}.yohaku` を追記して導入
  - CLI: `yohaku [--new|--preview|--find TEXT] [files...]`。単一インスタンスで、起動中なら既存ウィンドウにタブ追加
  - `.desktop` / アイコンは**パッケージ側に同梱**（`share/applications/yohaku.desktop`）。プロファイルの share は XDG_DATA_DIRS に載るので `nix profile install` でもランチャ・検索に出る。dotfiles 側に `xdg.desktopEntries` は不要
  - 設定は `~/.config/yohaku/settings.json`、栞・状態は `~/.local/state/yohaku/`
  - **罠**: niri の全体 `opacity 0.9` を打ち消すため、`home/niri.nix` の `window-rule { match app-id="^yohaku$"; opacity 1.0 }` で yohaku だけ不透明にしている
  - ビルド / テスト用に `cmake`・`ninja`・`wtype` を `modules/packages.nix` に追加済み（`wtype` は niri/Wayland でのキー送出に使う）
  - アプリ実装の詳細（QML のメニュー・透過・性能など）は yohaku リポジトリ側の AGENTS.md を参照

## その他

- ロケール: 言語(メッセージ)は英語、地域設定（通貨・数値等）は日本（`modules/locale.nix`）。ただし `LC_TIME` は `en_US` なので日時表示も英語。タイムゾーン `Asia/Tokyo`、`hardwareClockInLocalTime = true`
- boot: grub（EFI, `device = "nodev"`）+ OS prober、`boot.loader.timeout = 10`、`/swapfile`。systemd-boot は無効。splash は `modules/assets/boot-splash.png`
- Nix: `nix-settings.nix` で flakes・`auto-optimise-store = true`・`allowUnfree = true`。`configuration.nix` で `documentation.enable = false`
- git user は `paleblue-2032` / `renshin0011_2112@icloud.com`。remote は `paleblue-2032/dotfiles`
- `.commandcode/`（taste / plans など）は `.gitignore` 済みで管理対象外
