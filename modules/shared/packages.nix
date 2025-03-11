{ pkgs }:

with pkgs; [
  # General packages for development and system management
  alacritty
  aspell
  aspellDicts.en
  bash-completion
  bat
  btop
  cachix
  coreutils
  duf
  dust
  eza
  cargo
  fd
  fh
  fzf
  gping
  hyperfine
  killall
  mcfly
  neofetch
  openssh
  procs
  sd
  sqlite
  tealdeer
  wget
  xh
  zoxide
  zip

  # Git and version control
  delta  # modern git diff
  lazygit

  # Encryption and security tools
  age
  age-plugin-yubikey
  gnupg
  libfido2

  # Cloud-related tools and SDKs
  docker
  docker-compose

  # Media and fonts
  emacs-all-the-icons-fonts
  dejavu_fonts
  ffmpeg
  rustup
  font-awesome
  hack-font
  jetbrains-mono
  meslo-lgs-nf
  noto-fonts
  noto-fonts-emoji

  # Node.js development tools
  nodePackages.npm # globally install npm
  nodePackages.prettier
  nodejs

  # Text and terminal utilities
  htop
  hunspell
  iftop
  jq
  ripgrep
  tree
  tmux
  unrar
  unzip
  zsh-powerlevel10k

  # Python packages
  python3
  virtualenv
]
