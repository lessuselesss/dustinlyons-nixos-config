{
  config,
  pkgs,
  ...
}: let
  emacsOverlaySha256 = "06413w510jmld20i4lik9b36cfafm501864yq8k4vxl5r4hn0j0h";
in {
  # Define our zsh config with hardened
  # security settings and sane defaults
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    histSize = 10000;
    histFile = "$HOME/.zsh_history";

    setOptions = [
      "HIST_FCNTL_LOCK"
      "HIST_IGNORE_DUPS"
      "HIST_IGNORE_SPACE"
      "HIST_EXPIRE_DUPS_FIRST"
      "HIST_FIND_NO_DUPS"
      "HIST_VERIFY"
      "EXTENDED_HISTORY"
      "INC_APPEND_HISTORY"
      "SHARE_HISTORY"
      "NO_CLOBBER"
      "BANG_HIST"
      "INTERACTIVE_COMMENTS"
      "HASH_CMDS"
      "MAIL_WARNING"
      "PATH_DIRS"
      "PRINT_EXIT_VALUE"
      "RM_STAR_WAIT"
      "NO_FLOW_CONTROL"
    ];

    shellInit = ''
      # Security settings
      umask 027
      limit coredumpsize 0

      # Disable shell history for root
      if [[ $UID -eq 0 ]]; then
        unset HISTFILE
        SAVEHIST=0
      fi

      # Secure path
      typeset -U path
      path=($path[@])
    '';
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      #cudaSupport = true;
      #cudaCapabilities = ["8.0"];
      allowBroken = true;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };

    overlays =
      # Apply each overlay found in the /overlays directory
      let
        path = ../../overlays;
      in
        with builtins;
          map (n: import (path + ("/" + n)))
          (filter (n:
            match ".*\\.nix" n
            != null
            || pathExists (path + ("/" + n + "/default.nix")))
          (attrNames (readDir path)))
          ++ [
            (import (builtins.fetchTarball {
              url = "https://github.com/dustinlyons/emacs-overlay/archive/refs/heads/master.tar.gz";
              sha256 = emacsOverlaySha256;
            }))
          ];
  };
}
