{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.modules.talon;
in
{
  options.modules.talon = {
    enable = mkEnableOption "Talon voice recognition configuration";
  };

  config = mkIf cfg.enable {
    home.file = {
      # Copy the talon community repository to the talon user directory
      ".talon/user/community" = {
        source = inputs.talon-source;
        recursive = true;
      };
    };
  };
} 