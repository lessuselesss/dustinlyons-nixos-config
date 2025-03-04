{ config, 
lib, 
# options, 
pkgs, 
... }:

let
  inherit (lib) mkAliasDefinitions mkOption types;
in {
  # Alias options for user and hm
  options = {
    user = mkOption {
      description = "User configuration";
      type = types.attrs;
      default = {};
    };
    hm = mkOption {
      type = types.attrs;
      default = {};
    };
  };

  # Apply aliasing for each user (admin and lessuseless)
  config = {
    users.users.${config.user.name} = mkAliasDefinitions options.user;
    home-manager.users.${config.user.name} = mkAliasDefinitions options.hm;
  };

  # Enable sudo for the wheel group
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true; # Requires password for sudo commands
  };

  # Other shared settings (e.g., system packages)
  environment.systemPackages = with pkgs; [ git ];
}
  # Ensure sudo privileges for members of the "wheel" group
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true; # Members of the wheel group must provide a password for sudo
  };

  # Nix settings
  nix = {
    package = pkgs.nix;
    settings = {
      trusted-users = [ "@admin" "@nix_staff" ];
      substituters = [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };

    overlays =
      # Apply each overlay found in the /overlays directory
      let path = ../../overlays; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)))

      ++ [(import (builtins.fetchTarball {
               url = "https://github.com/dustinlyons/emacs-overlay/archive/refs/heads/master.tar.gz";
               sha256 = emacsOverlaySha256;
           }))];
  };
}