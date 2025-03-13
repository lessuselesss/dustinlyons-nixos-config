{config, lib, pkgs, ...}:

with lib;
let
  cfg = config.programs.talon;
in {
  options.programs.talon = {
    enable = mkEnableOption "Talon voice recognition software configuration";
    
    userConfig = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable custom user configuration files";
    };
  };

  config = mkIf cfg.enable {
    home.file = mkIf cfg.userConfig {
      ".talon/user" = {
        source = ./user;
        recursive = true;
      };
    };
  };
} 