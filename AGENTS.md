# AGENTS.md

Liberty-pad（Lenovo ThinkPad E14 Gen4 AMD）の NixOS + home-manager dotfiles リポジトリ。
設定ファイル関連の作業中に新しいクセ・罠・知見を見つけたら、このファイルの該当セクションへ追記すること。

## 基本構成

- Flake は `nixos-config/flake.nix`（git root は `/etc/nixos`、Nix 設定は `nixos-config/` 配下）
- ホスト名 `Liberty-pad`（ThinkPad E14 Gen4 AMD / AMD iGPU）。ユーザーは `paleblue_2032`（`wheel`, `networkmanager`）、shell は zsh
- nixpkgs `nixos-26.05` / home-manager `release-26.05`、stateVersion `26.05`（system / home 両方）
- inputs: `nixpkgs`, `nixos-hardware`, `home-manager`, `niri`(sodiboo), `noctalia`, `noctalia-greeter`, `nix-hazkey`, `llm-agents`(numtide), `momoi-say`, `dpgk`
- ディレクトリ役割:
  - `nixos-config/configuration.nix` — system モジュールの import 一覧
  - `nixos-config/modules/` — NixOS システムモジュール（`modules/desktop.nix` が `modules/desktop/*` を束ねる）
  - `nixos-config/home.nix` + `nixos-config/home/` — home-manager モジュール（アプリごとに 1 ファイル）
  - `nixos-config/modules/assets/` — 壁紙 / boot splash 画像
- `flake.nix` は `specialArgs = { inherit inputs; }` と `home-manager.extraSpecialArgs = { inherit inputs; }` で全モジュールに `inputs` を注入。モジュール引数で `{ inputs, ... }` を取れる前提
- home-manager 側: `home/programs.nix` で git / vscode / direnv(nix-direnv)、`home.sessionVariables` で `EDITOR=emacs`・`BROWSER=google-chrome-stable`

## ビルド・再構築

- flake が `nixos-config/` に移っているため、rebuild は **必ず flake を指定**する: `sudo nixos-rebuild switch --flake /etc/nixos/nixos-config#Liberty-pad`（`cd /etc/nixos/nixos-config` して `--flake .#Liberty-pad` でも可）
- **罠**: 移動前の `sudo nixos-rebuild switch`（`--flake` 無し）は `/etc/nixos/flake.nix` を前提とするため動かない
- 早めの構文チェックは `nix-instantiate --parse <file>.nix`（評価せずファイル単位の typo 検出に便利）
- flake input の更新は `nixos-config/` 内で `nix flake update`。`flake.lock` はコミット済みなので明示指示なく更新しない
- **罠**: `pkgs.system` を使うと `'system' has been renamed to/replaced by 'stdenv.hostPlatform.system'` 警告が出る（`home/packages.nix`・`home/noctalia.nix` で使用）。動作はする

## 設定・コメントの思想

- コード内コメントは日本語で書く。既存の日本語コメント・意図説明は保持・踏襲する
- **無効化は削除でなくコメントアウトで残す**（復帰・履歴のため）。例: `# fcitx5-mozc`
- 1 機能 1 ファイルで `modules/`（または `home/`）に分割して import。既存の記法（`with pkgs;`、`{ ... }:` の引数スタイル、`let ... in` の使い方）に合わせる

## デスクトップ周のクセ

- WM は **Niri**（`programs.niri.enable`。設定は `home/niri.nix` に KDL を生文字列で記述）。バー・ランチャ等は **Noctalia**（`spawn-at-startup "noctalia"`）
  - **罠**: Niri は GNOME と違いメディアキー（音量・輝度）を既定で処理しない。`XF86AudioMute` / `XF86MonBrightnessUp` 等を `home/niri.nix` に明示バインドする必要がある。音量は `wpctl`。輝度は `brightnessctl`（`home/packages.nix`）＋ `services.udev.packages`（`modules/desktop/brightness.nix`）＋ ユーザーの `video` グループ登録（`modules/users.nix`）で `/sys/class/backlight` に書き込めるようにする。`video` 追加は再ログインまで反映されない
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
- 追加パッケージは原則 `home/packages.nix`（ユーザー）か `modules/packages.nix`（system）に追記

## その他

- ロケール: メッセージは英語、日付等は日本語（`modules/locale.nix`）。タイムゾーン `Asia/Tokyo`、`hardwareClockInLocalTime = true`
- boot: grub（EFI, `device = "nodev"`）+ OS prober、`/swapfile`。splash は `modules/assets/boot-splash.png`
- Nix: `nix-settings.nix` で flakes・`auto-optimise-store = true`・`allowUnfree = true`
- git user は `paleblue-2032` / `renshin0011_2112@icloud.com`。remote は `paleblue-2032/dotfiles`

## エージェント向け特権設定 (zz-agent.nix)

- `modules/zz-agent.nix` を `configuration.nix` の import 一覧の末尾（`zz-` 接頭辞）で import。ローカルのエージェントがパスワードなしで特権操作を行えるようにするためのもの
  - `security.sudo.extraRules` で `paleblue_2032` に `NOPASSWD` の `ALL` を付与（実質パスワードレス sudo）
  - `services.udev.extraRules` で `ttyACM*` と `ATTRS{idVendor}=="0e8d"`（MediaTek）の USB を `MODE="0666"` に（一般ユーザーから読み書き可）
- **罠**: セキュリティを大きく弱める設定（パスワードレス sudo）。元に戻すにはファイルと `configuration.nix` の import 行を削除する
