{ pkgs, lib, ... }:
{
  nix.settings = {
    substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
        "https://dustinlyons-nixos-config.cachix.org"
        "https://lessuseless-nixos-config.cachix.org"   
    ];
    trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "dustinlyons-nixos-config.cachix.org-1:G+6axanpp47yE5d06WvxpH52qicUc4ym34sMseJBl+E="
        "lessuseless-nixos-config.cachix.org-1:bTpIPie+wvr5stHDRTAicphiCUrwnUgY84q4cRKkjnw="
      ];
  };
}
