{ pkgs }:

with pkgs; [
 # ========================
# System & Terminal Utilities
# ========================
# alacritty          # GPU-accelerated terminal emulator
# bash-completion    # Bash completion scripts
# bat                # Cat clone with syntax highlighting
# btop               # System monitor and process viewer
# coreutils          # Basic file/text/shell utilities
# direnv             # Environment variable management per directory
# duf                # Disk usage/free utility
# du-dust            # Disk usage analyzer
# dust               # Disk usage analyzer
# eza                # Modern replacement for 'ls'
# fd                 # Fast find alternative
# fzf                # Fuzzy finder
# htop               # Interactive process viewer
# iftop              # Network bandwidth monitor
# jq                 # JSON processor
# killall            # Kill processes by name
# neofetch           # System information tool
# ripgrep            # Fast text search tool
# sd                 # Modern sed replacement
# sqlite             # SQL database engine
# tealdeer           # tldr client
# tree               # Directory tree viewer
# tmux               # Terminal multiplexer
# unzip              # ZIP archive extractor
# unrar              # RAR archive extractor
# wget               # File downloader
# zip                # ZIP archive creator
# zoxide             # Smarter cd command
# zsh-autosuggestions
# zsh-powerlevel10k
# zsh-syntax-highlighting
# zsh-fzf-tab
# wrangler           # Cloudflare Workers CLI
# warp-terminal      # Modern terminal

# ========================
# Fonts & Appearance
# ========================
# dejavu_fonts
# emacs-all-the-icons-fonts
# font-awesome
# hack-font
# jetbrains-mono
# meslo-lgs-nf
# monaspace
# noto-fonts
# noto-fonts-emoji

# ========================
# Programming Languages & Toolchains
# ========================
# bun                # JavaScript runtime
# cargo              # Rust package manager
# cmake              # Cross-platform build system
# deno               # JavaScript/TypeScript runtime
# nodejs
# nodejs_23
# python3
# python312.withPackages
# python313.withPackages
# rustup             # Rust toolchain installer

# ========================
# Node.js & JavaScript Utilities
# ========================
# nodePackages.live-server
# nodePackages.nodemon
# nodePackages.npm
# nodePackages.prettier

# ========================
# Python Utilities
# ========================
# pip
# pipx
# poetry
# virtualenv
# uv

# ========================
# Security, Encryption & Secrets
# ========================
# age
# age-plugin-yubikey
# age-plugin-ledger
# gnupg
# libfido2
# pass
# gopass
# gopass-hibp
# gopass-summon-provider
# git-credential-gopass
# git-credential-manager
# openssh
# tailscale
# wireshark

# ========================
# DevOps, Cloud & Containers
# ========================
# act                # Run Github actions locally
# cachix             # Nix binary cache management
# devenv             # Development environments manager
# docker
# docker-compose
# nix-direnv
# podman
# podman-compose
# terraform
# terraform-ls
# tflint

# ========================
# Git & Version Control
# ========================
# delta              # Modern git diff
# gh                 # GitHub CLI
# git-branchless
# lazygit
# procs

# ========================
# Editors & IDEs
# ========================
# code-cursor
# vscode
# zed-editor
# windsurf
# jetbrains.phpstorm

# ========================
# Communication & Social
# ========================
# discord
# slack
# telegram-desktop

# ========================
# Media & Graphics
# ========================
# ffmpeg
# imagemagick
# jpegoptim
# pngquant

# ========================
# Productivity & Miscellaneous
# ========================
# aider-chat
# alejandra
# atuin
# bazecor
# boringtun
# clipboard-jh
# difftastic
# fabric-ai
# fh
# gopls
# gping
# glow
# hyperfine
# lazydocker
# marimo
# mcfly
# micromamba
# mods
# myFonts
# myPHP
# myPython
# nil
# nurl
# pandoc
# python3.withPackages
# ripgrep
# slack
# talon
# typst
# xh

# ========================
# Other/Uncategorized
# ========================
# pass
# slpp
# sqlite
# virtualenv
# zip 
]
