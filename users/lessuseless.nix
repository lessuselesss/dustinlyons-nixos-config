{ config, lib, options, pkgs, ... }:
{
  user = {
    name = "lessuseless";
    isNormalUser = true;
    home = "/Users/lessuseless";
    hashedPassword = "<lessuseless-hashed-password>"; # Replace with actual hashed password
    shell = pkgs.zsh;
  };
  hm = {
    home.packages = with pkgs; [ firefox emacs curl ];
    # Add more Home Manager settings here
  };
}