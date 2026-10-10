{ ... }:

{
  programs.niri.config = ''
    // ログイン時のキーバインド一覧を表示しない
    hotkey-overlay {
      skip-at-startup
    }

    // discord用
    xwayland-satellite {
      path "/run/current-system/sw/bin/xwayland-satellite"
    }

    input {
      keyboard {
        xkb {
          layout "jp"
          // caps <-> ctrl
          options "ctrl:swapcaps"
        }
      }
      // ThinkPadなので...
      touchpad {
        off
      }
    }

    // カーソルテーマ（エク_Cursor.zip の .ani を Xcursor に変換したもの）
    cursor {
      xcursor-theme "EkCursor"
      xcursor-size 32
    }

    spawn-at-startup "noctalia"

    // 透過, 角丸
    window-rule {
      opacity 0.9
      geometry-corner-radius 12
      clip-to-geometry true
    }

    // 隙間調整
    layout {
      gaps 8
    }

    // 左上ホットコーナーでオーバービューになるのを無効化
    // (niri 25.05 以降、既定で有効)
    gestures {
      hot-corners {
        off
      }
    }

    binds {
      // Launcher
      "Mod+Space" { spawn "noctalia" "msg" "panel-toggle" "launcher"; }

      // ターミナル
      "Mod+T" { spawn "wezterm"; }

      // カラム及びウィンドウのフォーカス
      "Mod+Left" { focus-column-left; }
      "Mod+Right" { focus-column-right; }
      "Mod+Up" { focus-window-up; }
      "Mod+Down" { focus-window-down; }
      "Mod+J" { focus-column-left; }
      "Mod+L" { focus-column-right; }
      "Mod+I" { focus-window-up; }
      "Mod+K" { focus-window-down; }

      // カラム及びウィンドウの移動
      "Mod+Shift+Left" { move-column-left; }
      "Mod+Shift+Right" { move-column-right; }
      "Mod+Shift+Up" { move-window-up; }
      "Mod+Shift+Down" { move-window-down; }
      "Mod+Shift+J" { move-column-left; }
      "Mod+Shift+L" { move-column-right; }
      "Mod+Shift+I" { move-window-up; }
      "Mod+Shift+K" { move-window-down; }

      // カラムの最大化
      "Mod+M" { maximize-column; }

      // ウィンドウの粛清
      "Alt+F4" { close-window; }

      // カラムの結合及び分離
      "Mod+BracketLeft"  { consume-window-into-column; }
      "Mod+BracketRight" { expel-window-from-column; }

      // いっぱいみえる
      "Alt+Tab" { toggle-overview; }

      // スクショまわり
      "Print" { screenshot-screen; }
      "Mod+Shift+S" { screenshot; }

      // 音量・画面輝度 (ThinkPad の Fn キー)
      // niri は既定でメディアキーを処理しないため明示的にバインドする
      "XF86AudioMute" { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      "XF86AudioLowerVolume" { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
      "XF86AudioRaiseVolume" { spawn "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_AUDIO_SINK@" "5%+"; }
      "XF86MonBrightnessDown" { spawn "brightnessctl" "set" "5%-"; }
      "XF86MonBrightnessUp" { spawn "brightnessctl" "set" "5%+"; }

      // ワークスペースのフォーカス
      "Mod+1" { focus-workspace 1; }
      "Mod+2" { focus-workspace 2; }
      "Mod+3" { focus-workspace 3; }
      "Mod+4" { focus-workspace 4; }
      "Mod+5" { focus-workspace 5; }

      // カラムを各ワークスペースへ移動
      "Mod+Shift+1" { move-column-to-workspace 1; }
      "Mod+Shift+2" { move-column-to-workspace 2; }
      "Mod+Shift+3" { move-column-to-workspace 3; }
      "Mod+Shift+4" { move-column-to-workspace 4; }
      "Mod+Shift+5" { move-column-to-workspace 5; }

      // ログアウト確認: niri標準ダイアログの代わりにnoctaliaのセッションメニュー
      "Ctrl+Alt+Delete" { spawn "noctalia" "msg" "panel-toggle" "session"; }
    }

    prefer-no-csd
  '';
}
