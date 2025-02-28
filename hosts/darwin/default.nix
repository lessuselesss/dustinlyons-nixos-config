{
  agenix,
  config,
  pkgs,
  ...
}: let
  user = "admin";
in {
  imports = [
    ../../modules/darwin/secrets.nix
    ../../modules/darwin/home-manager.nix
    ../../modules/shared
    agenix.darwinModules.default
  ];

  # Setup user, packages, programs
  nix = {
    package = pkgs.nix;

    settings = {
      trusted-users = ["@admin" "${user}"];
      substituters = ["https://nix-community.cachix.org" "https://cache.nixos.org"];
      trusted-public-keys = ["cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="];
    };

    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  # Load configuration that is shared across systems
  environment.systemPackages = with pkgs;
    [
      emacs-unstable
      agenix.packages."${pkgs.system}".default
    ]
    ++ (import ../../modules/shared/packages.nix {inherit pkgs;});

  launchd.user.agents = {
    emacs = {
      path = [config.environment.systemPath];
      serviceConfig = {
        KeepAlive = true;
        ProgramArguments = [
          "/bin/sh"
          "-c"
          "{ osascript -e 'display notification \"Attempting to start Emacs...\" with title \"Emacs Launch\"'; /bin/wait4path ${pkgs.emacs}/bin/emacs && { ${pkgs.emacs}/bin/emacs --fg-daemon; if [ $? -eq 0 ]; then osascript -e 'display notification \"Emacs has started.\" with title \"Emacs Launch\"'; else osascript -e 'display notification \"Failed to start Emacs.\" with title \"Emacs Launch\"' >&2; fi; } } &> /tmp/emacs_launch.log"
        ];
        StandardErrorPath = "/tmp/emacs.err.log";
        StandardOutPath = "/tmp/emacs.out.log";
      };
    };
  };

  system = {
    stateVersion = 4;

    defaults = {
      LaunchServices = {
        LSQuarantine = false;
      };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = false;
        show-recents = false;
        launchanim = true;
        mouse-over-hilite-stack = true;
        orientation = "bottom";
        tilesize = 48;
      };

      finder = {
        _FXShowPosixPathInTitle = false;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    NSGlobalDomain = {
      AppleShowAllExtensions = true;

      # Enable press-and-hold repeating
      ApplePressAndHoldEnabled = false;

      # 120, 90, 60, 30, 12, 6, 2
      KeyRepeat = 2;

      # 120, 94, 68, 35, 25, 15
      InitialKeyRepeat = 15;

      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.sound.beep.volume" = 0.0;
      "com.apple.sound.beep.feedback" = 0;

      # Auto hide the menubar
      _HIHideMenuBar = true;

      # Enable full keyboard access for all controls
      #AppleKeyboardUIMode = 3;

      # Disable "Natural" scrolling
      "com.apple.swipescrolldirection" = false;

      # Disable smart dash/period/quote substitutions
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;

      # Disable automatic capitalization
      NSAutomaticCapitalizationEnabled = false;

      # Using expanded "save panel" by default
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;

      # Increase window resize speed for Cocoa applications
      NSWindowResizeTime = 0.001;

      # Save to disk (not to iCloud) by default
      NSDocumentSaveNewDocumentsToCloud = true;
    };
  };
}
