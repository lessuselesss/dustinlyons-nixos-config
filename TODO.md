convert https://github.com/keganedwards/nix-scripts/tree/main to nix apps 
# Enable AppImage support
  programs.appimage = {
    enable = true;                 # Enable AppImage integration
    binfmt = true;                 # Enable AppImage binary format support
  };
