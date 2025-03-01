{
  config,
  pkgs,
  ...
}: let
  emacsOverlaySha256 = "06413w510jmld20i4lik9b36cfafm501864yq8k4vxl5r4hn0j0h";
  sharedPackages = import ./packages.nix {inherit pkgs;};
in {
  # Define our zsh config with hardened security settings
  programs.zsh = {
    enable = true; # Only enable ZSH at system level

    # Essential security settings and Nix environment
    shellInit = ''
      # Security settings first
      umask 027
      limit coredumpsize 0

      # Disable shell history for root
      if [[ $UID -eq 0 ]]; then
        unset HISTFILE
        SAVEHIST=0
      fi

      # Load nix environment if available - essential for all users
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # Secure path
      typeset -U path
      path=($path[@])
    '';
  };

  environment.systemPackages = sharedPackages;

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
