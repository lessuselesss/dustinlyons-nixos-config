{
  pkgs,
  #userConfig,
  lib,
  config,
  ...
}: let
  # inherit (userConfig) username;
  # username = "lessuseless";
in {
  # <yabai />

  services = {
    yabai = {
      enable = true;
      package = pkgs.yabai;
      config = {
        layout = "bsp";
        window_placement = "second_child";
        window_opacity = "off";
        window_shadow = "float";
        window_gap = 6;
        top_padding = 6;
        bottom_padding = 6;
        left_padding = 6;
        right_padding = 6;
        mouse_follows_focus = "off";
        focus_follows_mouse = "off";
        mouse_modifier = "fn";
        mouse_action1 = "move";
        mouse_action2 = "resize";
        mouse_drop_action = "swap";
      };
      extraConfig = '''';
    };
  };

  environment.etc."sudoers.d/yabai".text = ''
    lessuseless ALL = (root) NOPASSWD: ${pkgs.yabai}/bin/yabai --load-sa
  '';
}