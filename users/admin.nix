# Common admin user configuration for both NixOS and Darwin
{pkgs, ...}: {
  users.users.admin = {
    # Common attributes
    description = "System Administrator";
    isNormalUser = true;
    shell = pkgs.zsh;

    # Admin groups (will be merged with system-specific groups)
    extraGroups = ["wheel"];

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
  };

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
      alias update='sudo nix-channel --update'
      alias upgrade='sudo nixos-rebuild switch'  # Will only work on NixOS
      alias darwin-upgrade='sudo darwin-rebuild switch'  # Will only work on Darwin
    '';
  };
}
