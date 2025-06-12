{ pkgs }:

with pkgs; [
  # General packages for development and system management
  atuin
  alacritty
  aspell
  aspellDicts.en
  appimage-run
  bash-completion
  bat
  btop
  cachix
  coreutils
  distrobox
  git-credential-manager
  gh
  killall
  neofetch
  openssh
  sqlite
  wget
  zip
  
  # Communication/im
  telegram-desktop
 
  # Encryption and security tools
  age
  age-plugin-yubikey
  gnupg
  libfido2
  gopass 
  git-credential-gopass
  gopass-summon-provider
  gopass-hibp

  # Cloud-related tools and SDKs
  docker
  docker-compose

  # Media-related packages
  emacs-all-the-icons-fonts
  dejavu_fonts
  ffmpeg
  fd
  font-awesome
  hack-font
  noto-fonts
  noto-fonts-emoji
  meslo-lgs-nf

  # Node.js development tools
  nodePackages.npm # globally install npm
  nodePackages.prettier
  nodejs

  # Text and terminal utilities
  htop
  hunspell
  iftop
  jetbrains-mono
  jq
  ripgrep
  tree
  tmux
  typst
  unrar
  unzip
  zip
  zsh-powerlevel10k
  code-cursor
  vscode
  warp-terminal

  # Python packages
  python3
  virtualenv
  uv
  marimo

 # Peripherals
 bazecor
 
]
