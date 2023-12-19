_: {
  perSystem = {
    system,
    pkgs,
    lib,
    self',
    ...
  }: let
    tmuxconf = ''
      unbind-key C-b
      set-option -g prefix C-Space
      set-option -g status

      # nvim recommendations
      set-option -sg escape-time 10
      set-option -g focus-events on

      set -g default-terminal alacritty
      set-option -sa terminal-features ',alacritty:RGB'


      unbind-key c
      bind-key c new-window -c '#{pane_current_path}'
      unbind-key %
      bind-key % split-window -h -c '#{pane_current_path}'
      unbind-key '"'
      bind-key '"' split-window -v -c '#{pane_current_path}'

      unbind-key h
      bind-key h select-pane -L
      unbind-key j
      bind-key j select-pane -D
      unbind-key k
      bind-key k select-pane -U
      unbind-key l # normally used for last-window
      bind-key l select-pane -R


      # Resizing (mouse also works).
      unbind-key Left
      bind-key -r Left resize-pane -L 5
      unbind-key Right
      bind-key -r Right resize-pane -R 5
      unbind-key Down
      bind-key -r Down resize-pane -D 5
      unbind-key Up
      bind-key -r Up resize-pane -U 5

      bind-key ^space last-window

      bind-key p select-layout -o

      # Intuitive window-splitting keys.
      bind-key | split-window -h -c '#{pane_current_path}' # normally prefix-%
      bind-key - split-window -v -c '#{pane_current_path}' # normally prefix-"

      set-option -g renumber-windows on
      set -g base-index 1
      setw -g pane-base-index 1

      # toggle status bar
      bind-key F8 set-option status #Ctrl+F3 Combo , -g for global

      set-option -g mouse on

      # Set meaningful window titles
      set -g set-titles on
      set -g set-titles-string "#{session_name}:#{window_name}:#{pane_current_path}"
    '';
  in {
    packages.tmux = pkgs.writeScriptBin "tmux" ''
      export TMUX_CONFIG=${pkgs.writeTextDir "/.tmux.conf" tmuxconf}
      exec ${lib.getExe pkgs.tmux} "$@"
    '';
  };
}
