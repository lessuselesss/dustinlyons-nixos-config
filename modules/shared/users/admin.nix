# Common admin user configuration for both NixOS and Darwin
{
  pkgs,
  lib,
  ...
}: {
  users.users.admin = lib.mkMerge [
    # Common configuration
    {
      description = "System Administrator";
      shell = pkgs.zsh;

      # Basic admin packages
      packages = with pkgs; [
        # System monitoring
        htop
        btop
        iftop

        # File operations
        tree
        wget
        curl
        ripgrep
        fd

        # System management
        jq
        vim
        git

        # Security tools
        gnupg
        age
        age-plugin-yubikey
        pass
      ];
    }

    # NixOS-specific configuration
    (lib.mkIf pkgs.stdenv.isLinux {
      isNormalUser = true;
      extraGroups = ["wheel"];
      # Add any other Linux-specific user attributes here
    })

    # Darwin-specific configuration
    (lib.mkIf pkgs.stdenv.isDarwin {
      # Add any Darwin-specific user attributes here if needed
    })
  ];

  # Basic shell configuration at system level
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    interactiveShellInit = ''
      # Basic admin aliases
      alias ll='ls -la'
      alias df='df -h'
      alias free='free -m'
      alias top='htop'

      # Security-focused aliases
      alias sudo='sudo '  # Allow aliases with sudo
      alias please='sudo $(fc -ln -1)'  # Rerun last command with sudo

      # System maintenance shortcuts
      ${lib.optionalString pkgs.stdenv.isLinux ''
        alias update='sudo nix-channel --update'
        alias upgrade='sudo nixos-rebuild switch'
      ''}
      ${lib.optionalString pkgs.stdenv.isDarwin ''
        alias update='sudo nix-channel --update'
        alias darwin-upgrade='sudo darwin-rebuild switch'
      ''}
    '';
  };
}
