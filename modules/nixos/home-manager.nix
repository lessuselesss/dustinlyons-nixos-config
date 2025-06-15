{ config, pkgs, lib, inputs, system, ... }:

let
  user = "lessuseless";
  xdg_configHome  = "/home/${user}/.config";
  shared-programs = import ../shared/home-manager.nix { inherit config pkgs lib; };
  shared-files = import ../shared/files.nix { inherit config pkgs; };

  polybar-user_modules = builtins.readFile (pkgs.replaceVars ./config/polybar/user_modules.ini {
    packages = "${xdg_configHome}/polybar/bin/check-nixos-updates.sh";
    searchpkgs = "${xdg_configHome}/polybar/bin/search-nixos-updates.sh";
    launcher = "${xdg_configHome}/polybar/bin/launcher.sh";
    powermenu = "${xdg_configHome}/rofi/bin/powermenu.sh";
    calendar = "${xdg_configHome}/polybar/bin/popup-calendar.sh";
  });

  polybar-config = pkgs.replaceVars ./config/polybar/config.ini {
    font0 = "DejaVu Sans:size=12;3";
    font1 = "feather:size=12;3"; # from overlay
  };

  polybar-modules = builtins.readFile ./config/polybar/modules.ini;
  polybar-bars = builtins.readFile ./config/polybar/bars.ini;
  polybar-colors = builtins.readFile ./config/polybar/colors.ini;

  # Access mcp-servers-nix through the `inputs` argument.
  mcp-server-package = inputs.mcp-servers-nix.lib.mkConfig pkgs {
    programs = {
      filesystem = {
        enable = true;
        # IMPORTANT: Update this to a real directory path on your system
        args = [ "/home/${user}/Documents" ];
       };
       fetch.enable = true;
     };
   };

in
{
  home = {
    enableNixpkgsReleaseCheck = false;
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ./packages.nix {};
    file = shared-files // import ./files.nix { inherit user pkgs; };
    stateVersion = "21.05";
  };

# EXPERIMENTAL
##############################################
#
# # home.activation.linkNanoxKeys = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
#   ${pkgs.ledger-agent}/bin/ledger-agent "$HOME/.ssh/nanox-keys.conf.pub" -s -v
# '';
#
##############################################
#      # Assuming ledger-agent is available as a Nix package.
#      # You might need to find its exact package name (e.g., pkgs.ledger-agent-app or similar).
#      systemd.user.services.nanox-ledger-agent = {
#        enable = true;
#        description = "Nanox Ledger Agent for SSH";
#        # Adjust these targets based on when ledger-agent needs to start.
#        # Often, after network and basic user session is up.
#        after = [ "network-online.target" "graphical-session-pre.target" ];
#        wantedBy = [ "default.target" ];
#        serviceConfig = {
#          # ExecStart needs to point to the ledger-agent executable from its Nix package
#          # and use the full path to the config file managed by home.file
#          ExecStart = "${pkgs.ledger-agent}/bin/ledger-agent ${config.home.homeDirectory}/.ssh/nanox-keys.conf.pub -s";
#          Restart = "on-failure"; # Restart if it crashes
#          # If ledger-agent is meant to run in the background, you might need Type=forking or Type=simple
#          # and potentially other options depending on its behavior.
#          # Refer to `man systemd.service` for details.
#          Type = "simple"; # Or "exec", "forking" depending on how ledger-agent runs
#          StandardOutput = "journal";
#          StandardError = "journal";
#        };
#      };
##############################################


# Use a dark theme
  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-icon-theme;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-icon-theme;
    };
  };

  # Screen lock
  services = {
    screen-locker = {
      enable = false;
      inactiveInterval = 10;
      lockCmd = "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 10 15";
    };

    # Auto mount devices
    udiskie.enable = true;

    polybar = {
      enable = true;
      config = polybar-config;
      extraConfig = polybar-bars + polybar-colors + polybar-modules + polybar-user_modules;
      package = pkgs.polybarFull;
      script = "polybar main &";
    };

    dunst = {
      enable = true;
      package = pkgs.dunst;
      settings = {
        global = {
          monitor = 0;
          follow = "mouse";
          border = 0;
          height = 400;
          width = 320;
          offset = "33x65";
          indicate_hidden = "yes";
          shrink = "no";
          separator_height = 0;
          padding = 32;
          horizontal_padding = 32;
          frame_width = 0;
          sort = "no";
          idle_threshold = 120;
          font = "Noto Sans";
          line_height = 4;
          markup = "full";
          format = "<b>%s</b>\n%b";
          alignment = "left";
          transparency = 10;
          show_age_threshold = 60;
          word_wrap = "yes";
          ignore_newline = "no";
          stack_duplicates = false;
          hide_duplicate_count = "yes";
          show_indicators = "no";
          icon_position = "left";
          icon_theme = "Adwaita-dark";
          sticky_history = "yes";
          history_length = 20;
          history = "ctrl+grave";
          browser = "google-chrome-stable";
          always_run_script = true;
          title = "Dunst";
          class = "Dunst";
          max_icon_size = 64;
        };
      };
    };
  };

  programs = shared-programs // {};

}
