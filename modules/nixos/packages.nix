{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [

 # ---- Security and Authentication ----
# yubikey-agent        # Yubikey SSH agent
# keepassxc            # Password manager
# ledger-agent         # Ledger device agent

# ---- App and Package Management ----
# appimage-run         # AppImage support
# gnumake              # Build tool
# cmake                # Build tool
# home-manager         # Home Manager for NixOS
# go                   # Go programming language
# gopls                # Go language server

# ---- Niri/DE Dependencies ----
# gnome-keyring
# mako
# xdg-desktop-portal-gtk
# xdg-desktop-portal-gnome
# fuzzel
# kdePackages.polkit-kde-agent-1
# xwayland-satellite

# ---- Media and Design Tools ----
# vlc                  # Media player
# gimp                 # Image editor
# fontconfig           # Font configuration
# font-manager         # Font manager

# ---- Productivity Tools ----
# bc                   # Old school calculator
# galculator           # Calculator

# ---- Audio Tools ----
# cava                 # Terminal audio visualizer
# pavucontrol          # Pulse audio controls
# playerctl            # Control media players from command line

# ---- Testing and Development ----
# direnv               # Shell environment manager
# rofi                 # Window switcher/launcher
# rofi-calc            # Calculator for rofi
# postgresql           # Database
# libtool              # For Emacs vterm
# chromedriver         # Chrome webdriver for testing
# claude-code          # Coding agent
# inputs.claude-desktop.packages."${pkgs.system}".claude-desktop-with-fhs

# ---- Screenshot and Recording ----
# flameshot            # Screenshot tool
# screenkey            # Display pressed keys on screen
# simplescreenrecorder # Screen recording tool

# ---- Text and Terminal Utilities ----
# feh                  # Wallpaper manager
# xclip                # Clipboard utilities
# tree                 # Directory listing
# xorg.xwininfo        # Window info
# xorg.xrandr          # X display configuration

# ---- Network and System Tools ----
# unixtools.ifconfig   # Network interface configuration
# unixtools.netstat    # Network statistics

# ---- File and System Utilities ----
# inotify-tools        # File system events
# i3lock-fancy-rapid   # Lock screen
# libnotify            # Notifications
# pcmanfm              # File browser
# sqlite               # SQLite tools
# xdg-utils            # Desktop integration
# distrobox            # Containerized environments

# ---- Other Utilities ----
# yad                  # Calendar/dialog utility (used with polybar)
# xdotool              # X automation
# google-chrome        # Web browser
# brlaser              # Printer driver
# pinentry-qt          # GPG pinentry

# ---- PDF Viewer ----
# zathura              # PDF viewer

# ---- Music and Entertainment ----
# spotify              # Music player

# ---- NixOS/Keyboard Specific ----
# qmk                  # Keyboard firmware toolkit

# ---- Extras ----
# discord              # Voice and text chat
]
