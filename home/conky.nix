{ pkgs, ... }:

let
  left = ''
    conky.config = {
        alignment = 'top_left',
        background = false,
        border_width = 1,
        default_color = 'white',
        double_buffer = true,
        draw_borders = false,
        font = 'DejaVu Sans Mono:size=15',
        gap_x = 35,
        gap_y = 60,
        minimum_height = 7,
        minimum_width = 250,
        no_buffers = true,
        own_window = true,
        own_window_class = 'Conky',
        own_window_type = 'desktop',
        own_window_argb_visual = true,
        own_window_argb_value = 0,
        update_interval = 1.0,
        use_xft = true,
    }

    conky.text = [[
    ''${alignc}''${color #ff33f4}''${font DejaVu Sans Mono:size=45}''${time %H:%M}''${font}
    ''${voffset 10}''${alignc}''${color #ff66f7}''${font DejaVu Sans Mono:size=18}''${time %Y / %m / %d (%a)}''${font}
    $hr
    ''${color #ff33f4}User:$color ''${execi 3600 whoami}
    ''${color #ff33f4}NixOS:$color ''${execi 3600 nixos-version --print-id --short}
    ''${color #ff33f4}Kernel:$color $kernel
    ''${color #ff33f4}Machine:$color ThinkPad E14 Gen4
    ''${color #ff33f4}Architecture:$color $machine
    ]]
  '';

  right = ''
    conky.config = {
        alignment = 'bottom_right',
        background = false,
        border_width = 1,
        cpu_avg_samples = 2,
        default_color = 'white',
        default_outline_color = 'white',
        default_shade_color = 'white',
        double_buffer = true,
        draw_borders = false,
        draw_graph_borders = true,
        draw_outline = false,
        draw_shades = false,
        extra_newline = false,
        font = 'DejaVu Sans Mono:size=12.7',
        gap_x = 10,
        gap_y = 8,
        minimum_height = 7,
        minimum_width = 7,
        net_avg_samples = 2,
        no_buffers = true,
        out_to_console = false,
        out_to_ncurses = false,
        out_to_stderr = false,
        out_to_x = true,
        own_window = true,
        own_window_class = 'Conky',
        own_window_type = 'desktop',
        own_window_argb_visual = true,
        own_window_argb_value = 0,
        show_graph_range = false,
        show_graph_scale = false,
        stippled_borders = 0,
        update_interval = 1.0,
        uppercase = false,
        use_spacer = 'none',
        use_xft = true,
    }

    conky.text = [[
    ''${color #ff33f4}Info:$color ''${scroll 32 Conky $conky_version - $sysname $nodename $kernel $machine}
    $hr
    ''${color #ff33f4}Uptime:$color $uptime
    ''${color #ff33f4}Frequency:$color $freq_g GHz
    ''${color #ff33f4}RAM Usage:$color $mem/$memmax - $memperc% ''${membar 4}
    ''${color #ff33f4}CPU Usage:$color $cpu% ''${cpubar 4}
    ''${color #ff33f4}Processes:$color $processes  ''${color #ff33f4}Running:$color $running_processes
    ''${color #ff33f4}File systems:
     / $color''${fs_used /}/''${fs_size /} ''${fs_bar 6 /}
    $hr
    ''${color #ff33f4}Name              PID    CPU%   MEM%
    ''${color #ff66f7} ''${top name 1} ''${top pid 1} ''${top cpu 1} ''${top mem 1}
    ''${color #ff66f7} ''${top name 2} ''${top pid 2} ''${top cpu 2} ''${top mem 2}
    ''${color #ff66f7} ''${top name 3} ''${top pid 3} ''${top cpu 3} ''${top mem 3}
    ''${color #ff66f7} ''${top name 4} ''${top pid 4} ''${top cpu 4} ''${top mem 4}
    ]]
  '';
in

{
  home.packages = [ pkgs.conky ];

  xdg.configFile."conky/conky_left.conf".text = left;
  xdg.configFile."conky/conky_right.conf".text = right;

  xdg.configFile."conky/start.sh" = {
    text = ''
      sleep 3
      conky -c "$HOME/.config/conky/conky_left.conf" &
      conky -c "$HOME/.config/conky/conky_right.conf" &
    '';
    executable = true;
  };
}
