{
  config,
  pkgs,
  lib,
  home-manager,
  ...
}: let
  user = "lessuseless";
  # Define the content of your file as a derivation
  myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
    #!/bin/sh
      emacsclient -c -n &
  '';
  sharedFiles = import ../shared/files.nix {inherit config pkgs;};
  additionalFiles = import ./files.nix {inherit user config pkgs;};
in {
  imports = [
    ./dock
  ];

  # its lessuseless
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = lib.mkForce pkgs.zsh;
  };

  homebrew = {
    # This is a module from nix-darwin
    # Homebrew is *installed* via the flake input nix-homebrew
    enable = true;
    casks = pkgs.callPackage ./casks.nix {};

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    masApps = {
      "Gordian Seed Tool" = 1545088229;
      "DuckDuckGo" = 663592361;
      "Pure Paste" = 1611378436;
      "Shareful" = 1522267256;
      "Command X" = 6448461551;
      "One Thing" = 1604176982;
      "Folder Peek" = 1615988943;
      "Seed Tool" = 1545088229;
      # "Today" = 6443714928;
      "Refined GitHub" = 1519867270;
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = false;
    users.${user} = {
      pkgs,
      config,
      lib,
      ...
    }: {
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        file = lib.mkMerge [
          sharedFiles
          additionalFiles
          {"emacs-launcher.command".source = myEmacsLauncher;}
        ];

        stateVersion = "24.11";
      };

      programs = lib.mkMerge [
        (import ../shared/home-manager.nix {inherit config pkgs lib;}).programs
      ];

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };

  # System-level Nix settings
  nix.settings = {
    substituters = [
      "https://lessuseless.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "lessuselesss.cachix.org-1:nwRzA1J+Ze2nJAcioAfp77ifk8sncUi963WW2RExOwA="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  # Fully declarative dock using the latest from Nix Store
  local = {
    dock.enable = true;
    dock.entries = [
      {path = "/Applications/Slack.app/";}
      {path = "/System/Applications/Messages.app/";}
      {path = "/System/Applications/Facetime.app/";}
      {path = "/Applications/Telegram.app/";}
      {path = "${pkgs.alacritty}/Applications/Alacritty.app/";}
      {path = "/System/Applications/Music.app/";}
      {path = "/System/Applications/News.app/";}
      {path = "/System/Applications/Photos.app/";}
      {path = "/System/Applications/Photo Booth.app/";}
      {path = "/System/Applications/TV.app/";}
      {path = "${pkgs.jetbrains.phpstorm}/Applications/PhpStorm.app/";}
      {path = "/Applications/TablePlus.app/";}
      {path = "/Applications/Asana.app/";}
      {path = "/Applications/Drafts.app/";}
      {path = "/System/Applications/Home.app/";}
      {path = "/Applications/iPhone Mirroring.app/";}
      {
        path = toString myEmacsLauncher;
        section = "others";
      }
      {
        path = "${config.users.users.${user}.home}/.local/share/";
        section = "others";
        options = "--sort name --view grid --display folder";
      }
      {
        path = "${config.users.users.${user}.home}/.local/share/downloads";
        section = "others";
        options = "--sort name --view grid --display stack";
      }
    ];
  };
}
