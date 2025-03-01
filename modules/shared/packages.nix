{pkgs}:
with pkgs; [
  # Due to how this flake defines an admin at the system level
  # and standard users via home-manager, packages defined here
  # SHOULD
  # 1. NOT be system services
  # 2. NOT require sudo or an admin password
  # 3. BE available in nixpkgs and have builds
  #    hosts supported in this flake.
  #
  # [srv] = system service/daemon
  # [adm] = admin application
  # [usr] = user package
  act
  age
  age-plugin-ledger
  age-plugin-yubikey
  alacritty
  alejandra
  aspell
  aspellDicts.en
  bash-completion
  bat
  bazecor
  beeper
  black
  btop
  bun
  cargo
  claude-code
  cmake
  code-cursor
  coreutils
  curl
  dejavu_fonts
  deno
  devenv
  difftastic
  discord
  du-dust
  dunst
  emacs-all-the-icons-fonts
  fabric-ai
  fd
  ffmpeg
  flyctl
  font-awesome
  fzf
  gcc
  gh
  git
  git-filter-repo
  glow
  gnupg
  go
  google-cloud-sdk
  gopls
  hack-font
  htop
  hunspell
  iftop
  imagemagick
  jetbrains-mono
  jetbrains.phpstorm
  jpegoptim
  jq
  killall
  lazydocker
  libfido2
  meslo-lgs-nf
  mods
  neofetch
  ngrok
  nil
  nix-direnv
  nodePackages.live-server
  nodePackages.nodemon
  nodePackages.npm
  nodePackages.prettier
  nodejs_23
  noto-fonts
  noto-fonts-emoji
  nurl
  ollama
  openssh
  pandoc
  pass
  php82
  php82Extensions.xdebug
  php82Packages.composer
  php82Packages.deployer
  php82Packages.php-cs-fixer
  phpunit
  pkg-config
  pngquant
  polybar
  (python312.withPackages (ps:
    with ps; [
      black
      virtualenv
      pip
      time-machine
    ]))
  qflipper
  ripgrep
  slack
  spacedrive
  sqlite
  ssm-session-manager-plugin
  tailscale
  terraform
  terraform-ls
  tflint
  tmux
  tree
  udiskie
  unrar
  unzip
  uv
  vim
  vscode
  warp
  wget
  wireshark
  zip
  zsh
  zsh-autosuggestions
  zsh-powerlevel10k
  zsh-syntax-highlighting
]
