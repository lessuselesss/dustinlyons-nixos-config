{
  config,
  pkgs,
  lib,
  ...
}: {
  # Base configuration for all home-manager users
  programs = {
    # Essential zsh configuration that should be available to all users
    zsh = {
      enable = true;
      enableCompletion = true;
      initExtra = ''
        # Cross-platform clipboard support
        if [[ "$(uname)" == "Linux" ]]; then
          alias pbcopy='xclip -selection clipboard'
        fi

        # Basic system aliases that should be available to all users
        alias ls='ls --color=auto'
        alias ll='ls -la'
        alias df='df -h'
      '';
    };

    # Base git configuration
    git = {
      enable = true;
      ignores = ["*.swp" ".DS_Store"];
      extraConfig = {
        init.defaultBranch = "main";
        core = {
          autocrlf = "input";
          safecrlf = true;
        };
        pull.rebase = true;
        push.autoSetupRemote = true;
        rebase.autoStash = true;
      };
    };

    # Base vim configuration
    vim = {
      enable = true;
      settings = {
        ignorecase = true;
        smartcase = true;
      };
      extraConfig = ''
        " General
        set number
        set history=1000
        set nocompatible
        set modelines=0
        set encoding=utf-8
        set scrolloff=3
        set showmode
        set showcmd
        set hidden
        set wildmenu
        set wildmode=list:longest
        set cursorline
        set ttyfast
        set nowrap
        set ruler
        set backspace=indent,eol,start
        set laststatus=2

        " Whitespace rules
        set tabstop=8
        set shiftwidth=2
        set softtabstop=2
        set expandtab

        " Searching
        set incsearch
        set gdefault

        " File-type highlighting and configuration
        syntax on
        filetype on
        filetype plugin on
        filetype indent on
      '';
    };

    # Base alacritty configuration
    alacritty = {
      enable = true;
      settings = {
        cursor.style = "Block";
        window = {
          opacity = 1.0;
          padding = {
            x = 24;
            y = 24;
          };
        };
        font = {
          size = 14.0;
          normal = {
            family = "JetBrains Mono";
            style = "Regular";
          };
          bold = {
            family = "JetBrains Mono";
            style = "Bold";
          };
          italic = {
            family = "JetBrains Mono";
            style = "Italic";
          };
        };
      };
    };
  };
};
