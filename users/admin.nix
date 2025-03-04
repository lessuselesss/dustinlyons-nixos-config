{ config, lib, options, pkgs, ... }:
{
  user = {
    name = "admin";
    isNormalUser = true;
    home = "/Users/admin";
    extraGroups = [ "wheel" ]; # Grants sudo privileges
    hashedPassword = "<admin-hashed-password>"; # Replace with actual hashed password
    shell = pkgs.zsh;
  };
  hm = {
    home.packages = with pkgs; [ htop vim git ];
    # Add more Home Manager settings here, e.g., dotfiles
  };
}