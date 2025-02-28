{pkgs}:
with pkgs; let
  shared-packages = import ../shared/packages.nix {inherit pkgs;};
in
  shared-packages
  ++ [
    fswatch
    dockutil
    pinentry_mac
    yabai
    mas
    iina
  ]
