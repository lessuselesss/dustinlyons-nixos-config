{ pkgs }:

with pkgs; [
  # General packages for development and system management
  alejandra
  alacritty
  aspell
  aspellDicts.en
  bash-completion
  bat
  bun
  btop
  cachix
  coreutils
  wrangler
  clipboard-jh
  duf
  dust
  eza
  rustup
  fd
  fh
  gh   
  git-branchless
  fzf
  gping
  hyperfine
  killall
  mcfly
  mods
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
  # defined in /modules/shared/home-manager.nix and /modules/nixos/
  # not sure why direnv is not included in /modules/shared/ or /modules/darwin/
  #nix-direnv 
  devenv
  uv
  pipx
  pass
  talon  # Now available through the overlay
  nodePackages.npm # globally install npm
  nodePackages.prettier
  nodejs

  # Git and version control
  delta  # modern git diff
  lazygit

  # Encryption and security tools
  age
  age-plugin-yubikey
  age-plugin-ledger
  gnupg
  libfido2
  

  # Cloud-related tools and SDKs
  #docker
  #docker-compose
  podman
  podman-compose
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
  monaspace

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
  zsh-fzf-tab
  warp-terminal
  wireshark
  tailscale

  # Python packages
  python3
  virtualenv
]
