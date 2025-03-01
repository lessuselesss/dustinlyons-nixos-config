# User-scoped configuration that integrates with home-manager and johnny-mnemonix
# to maintain proper permissions and create a declarative johnny-decimal style
# system under ~/Documents. This ensures both reproducibility and organized
# file management.
{pkgs, ...}: {
  # Core packages needed for development, security, and daily workflow

  home.packages = with pkgs; [
    # These belong in lessuseless's home-manager config
    emacs # Your primary editor
    vscode # Modern IDE
    cmake # Build system
    pkg-config # Build tool
    python312 # Python runtime
    nodejs_23 # Node.js runtime
    cargo # Rust package manager
    nix-direnv # Directory environments
    devenv # Development environments
    jetbrains-mono # Code font
    hack-font # Code font

    # Development tools and fonts - everything needed for coding and UI work
    bun # JavaScript/TypeScript runtime and toolkit
    cargo # Rust package manager and build tool
    cmake # Cross-platform build system generator
    deno # Modern JavaScript/TypeScript runtime
    devenv # Per-praoject development environments
    emacs-all-the-icons-fonts # Icons for Emacs UI
    fabric-ai # AI development toolkit

    micromamba # Lightweight conda-compatible package manager
    nix-direnv # Nix integration for per-directory environments
    nodejs_23 # Latest Node.js runtime
    nurl # Nix URL fetcher conversion tool
    pkg-config # Helper tool for compiling applications
    python312 # Latest Python interpreter
    ripgrep # Fast code-aware search tool
    sqlite # Embedded SQL database engine
    tmux # Terminal session manager and multiplexer
    tree # Directory structure visualizer
    uv # Fast Python package installer and resolver
    wget # Network file retriever
    zip # File compression utility

    # Security and encryption tools for safe data handling
    age # Modern file encryption tool
    age-plugin-yubikey # YubiKey support for age
    gnupg # Complete OpenPGP implementation
    libfido2 # Library for FIDO 2.0 protocol
    pass # Unix password manager

    # Shell utilities that improve terminal workflow
    bat # Better cat with syntax highlighting
    btop # Resource monitor and process viewer
    fzf # Fuzzy finder for everythinga
    zsh-autosuggestions # Fish-like history suggestions
    zsh-syntax-highlighting # Shell syntax highlighting
  ];

  # Pin home-manager version to maintain stability
  home.stateVersion = "24.11";

  # Program configurations - customizing each tool for optimal workflow
  programs = {
    # Basic terminal emulator setup
    alacritty.enable = true;

    # Directory-specific environment manager
    direnv = {
      enable = true;
      nix-direnv.enable = true; # Efficient caching for nix shells
    };

    # Fuzzy finder configuration with shell integration
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # Git version control configuration
    git = {
      enable = true;
      userName = "Ashley Barr";
      userEmail = "lessuseless@duck.com";
      lfs.enable = true; # Support for large file storage

      # Additional git behavior customization
      extraConfig = {
        init.defaultBranch = "main";
        core = {
          editor = "vim";
          autocrlf = "input"; # Normalize line endings on commit
        };
        commit.gpgsign = true; # Sign all commits with GPG
        pull.rebase = true; # Rebase instead of merge on pull
        rebase.autoStash = true; # Auto stash/unstash during rebase
      };
    };

    # Shell configuration with plugins and customizations
    zsh = {
      enable = true;
      autocd = false; # Disable automatic directory changing
      enableCompletion = true;
      cdpath = ["~/.local/share/src"]; # Quick access to source code

      # Shell enhancement plugins
      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.zsh-autosuggestions;
          file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.zsh-syntax-highlighting;
          file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
        }
      ];

      # Shell initialization script - environment setup and aliases
      initExtraFirst = ''
        # Load nix environment if available
        if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
          . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fi

        # Set up SSH authentication via Secretive
        export SSH_AUTH_SOCK=/Users/lessuseless/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

        # Configure autosuggestions for better performance
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
        ZSH_AUTOSUGGEST_USE_ASYNC=1
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#808080"

        # Set up fuzzy finder if available
        if [ -n "''${commands[fzf-share]}" ]; then
          source "$(fzf-share)/key-bindings.zsh"
          source "$(fzf-share)/completion.zsh"
        fi

        # Add local binaries and package managers to PATH
        export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
        export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
        export PATH=$HOME/.local/share/bin:$PATH

        # Configure command history
        export HISTIGNORE="pwd:ls:cd"

        # Set up Emacs as the default editor
        export ALTERNATE_EDITOR=""
        export EDITOR="emacsclient -t"
        export VISUAL="emacsclient -c -a emacs"

        # Convenient command aliases
        alias e='emacsclient -t'
        alias pn=pnpm
        alias px=pnpx
        alias diff=difft
        alias ls='ls --color=auto'
        alias search='rg -p --glob "!node_modules/*"'
      '';
    };

    # Terminal multiplexer configuration
    tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator # Seamless navigation between tmux and vim
        sensible # Sensible default settings
        yank # Better copy/paste support
        prefix-highlight # Visual indicator for prefix key
        {
          plugin = power-theme;
          extraConfig = ''
            set -g @tmux_power_theme 'gold'
          '';
        }
        {
          plugin = resurrect; # Session persistence across restarts
          extraConfig = ''
            set -g @resurrect-dir '$HOME/.cache/tmux/resurrect'
            set -g @resurrect-capture-pane-contents 'on'
            set -g @resurrect-pane-contents-area 'visible'
          '';
        }
        {
          plugin = continuum; # Continuous session saving
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '5'
          '';
        }
      ];
      terminal = "screen-256color"; # Full color support
      prefix = "C-x"; # Emacs-style prefix key
      escapeTime = 10; # Reduce key input delay
      historyLimit = 50000; # Increase scrollback buffer

      # Additional tmux settings and key bindings
      extraConfig = ''
        # Enable terminal features
        set -g focus-events on
        set -g mouse on

        # Clear default key bindings
        unbind C-b
        unbind '"'
        unbind %

        # Set up intuitive split commands
        bind-key x split-window -v
        bind-key v split-window -h

        # Vim-style pane navigation
        bind-key -n M-k select-pane -U
        bind-key -n M-h select-pane -L
        bind-key -n M-j select-pane -D
        bind-key -n M-l select-pane -R
      '';
    };

    # Johnny Mnemonix configuration for file organization
    johnny-mnemonix = {
      enable = true;

      areas = {
        "00-09" = {
          name = "System";
          categories = {
            "00" = {
              name = "Meta";
              items = {
                "00.00" = {
                  name = "nixos-config";
                  url = "https://github.com/lessuselesss/nixos-config";
                  ref = "main";
                };
                "00.01" = {
                  name = "logs";
                  target = "/var/log";
                };
                "00.02" = {
                  name = "qubesOS-config";
                  url = "https://github.com/lessuselesss/qubesos-config";
                  ref = "main";
                };
                "00.03" = {
                  name = "workflows";
                };
                "00.04" = {
                  name = "VMs";
                };
              };
            };
            "01" = {
              name = "home";
              items = {
                "01.00" = {
                  name = "dotfiles";
                  target = "/Users/lessuseless/.dotfiles";
                };
                "01.01" = {
                  name = "applications";
                  target = "/Users/lessuseless/Applications";
                };
                "01.02" = {
                  name = "desktop";
                  target = "/Users/lessuseless/Desktop";
                };
                "01.03" = {
                  name = "documents";
                  target = "/Users/lessuseless/Documents";
                };
                "01.04" = {
                  name = "downloads";
                  target = "/Users/lessuseless/.local/share/downloads";
                };
                "01.05" = {
                  name = "movies";
                  target = "/Users/lessuseless/Movies";
                };
                "01.06" = {
                  name = "music";
                  target = "/Users/lessuseless/Music";
                };
                "01.07" = {
                  name = "pictures";
                  target = "/Users/lessuseless/Pictures";
                };
                "01.08" = {
                  name = "public";
                  target = "/Users/lessuseless/Public";
                };
                "01.09" = {
                  name = "templates";
                  target = "/Users/lessuseless/Templates";
                };
                "01.10" = {
                  name = "dotlocal_share";
                  target = "/Users/lessuseless/.local/share";
                };
                "01.11" = {
                  name = "dotlocal_bin";
                  target = "/Users/lessuseless/.local/bin";
                };
                "01.12" = {
                  name = "dotlocal_lib";
                  target = "/Users/lessuseless/.local/lib";
                };
                "01.13" = {
                  name = "dotlocal_include";
                  target = "/Users/lessuseless/.local/include";
                };
                "01.14" = {
                  name = "dotlocal_state";
                  target = "/Users/lessuseless/.local/state";
                };
                "01.15" = {
                  name = "dotlocal_cache";
                  target = "/Users/lessuseless/.cache";
                };
              };
            };
            "02" = {
              name = "Cloud";
              items = {
                "02.00" = {
                  name = "configs";
                  target = "/Users/lessuseless/.config/rclone";
                };
                "02.01" = {name = "dropbox";};
                "02.02" = {name = "google drive";};
                "02.03" = {
                  name = "icloud";
                  target = "/Users/lessuseless/Library/Mobile Documents/com~apple~CloudDocs";
                };
              };
            };
          };
        };
        "10-19" = {
          name = "Projects";
          categories = {
            "11" = {
              name = "maintaining";
              items = {
                "11.01" = {
                  name = "johnny-Mnemonix";
                  url = "https://github.com/lessuselesss/johnny-mnemonix";
                  ref = "main";
                };
                "11.02" = {name = "forks";};
                "11.03" = {
                  name = "anki Sociology";
                  url = "https://github.com/lessuselesss/anki_sociology100";
                  ref = "main";
                };
                "11.04" = {
                  name = "anki Ori's Decks";
                  url = "https://github.com/lessuselesss/anki-ori_decks";
                  ref = "main";
                };
                "11.05" = {
                  name = "claude desktop";
                  url = "https://github.com/lessuselesss/claude_desktop";
                  ref = "main";
                };
                "11.06" = {
                  name = "dygma raise - Miryoku";
                  url = "https://github.com/lessuselesss/dygma-raise-miryoku";
                  ref = "main";
                };
                "11.07" = {
                  name = "uber-FZ_SD-files";
                  url = "https://github.com/lessuselesss/Uber-FZ_SD-Files";
                  ref = "main";
                };
                "11.08" = {
                  name = "prosocial_ide";
                  url = "https://github.com/lessuselesss/Prosocial_IDE";
                  ref = "main";
                };
              };
            };
            "12" = {
              name = "Contributing";
              items = {
                "12.01" = {
                  name = "screenpipe";
                  url = "https://github.com/lessuselesss/screenpipe";
                  ref = "main";
                };
                "12.02" = {
                  name = "ai16z-main";
                  url = "https://github.com/ai16z/eliza.git";
                  ref = "main";
                };
                "12.03" = {
                  name = "ai16z-develop";
                  url = "https://github.com/ai16z/eliza.git";
                  ref = "develop";
                };
                "12.04" = {
                  name = "ai16z-fork";
                  url = "https://github.com/lessuselesss/eliza.git";
                  ref = "main";
                };
                "12.05" = {
                  name = "ai16z-characterfile";
                  url = "https://github.com/lessuselesss/characterfile.git";
                  ref = "main";
                };
                "12.06" = {
                  name = "fabric";
                  url = "https://github.com/lessuselesss/fabric";
                  ref = "main";
                };
                "12.07" = {
                  name = "whisper diarization";
                  url = "https://github.com/lessuselesss/whisper-diarization";
                  ref = "main";
                };
              };
            };
            "13" = {
              name = "Testing_ai";
              items = {
                "13.01" = {
                  name = "curxy";
                  url = "https://github.com/ryoppippi/curxy";
                  ref = "main";
                };
                "13.02" = {
                  name = "dify";
                  url = "https://github.com/langgenius/dify";
                  ref = "main";
                };
                "13.03" = {
                  name = "browser-use";
                  url = "https://github.com/browser-use/browser-use";
                  ref = "main";
                };
                "13.04" = {
                  name = "omniParser";
                  url = "https://github.com/microsoft/OmniParser";
                  ref = "main";
                };
              };
            };

            "14" = {
              name = "Pending";
              items = {
                "14.01" = {name = "waiting";};
              };
            };
          };
        };

        "20-29" = {
          name = "Areas";

          categories = {
            "21" = {
              name = "Personal";
              items = {
                "21.01" = {name = "health";};
                "21.02" = {name = "finance";};
                "21.03" = {name = "family";};
              };
            };
            "22" = {
              name = "Professional";
              items = {
                "22.01" = {
                  name = "career";
                  url = "https://github.com/lessuselesss/careerz";
                };
                "22.02" = {name = "skills";};
              };
            };
          };
        };
        "30-39" = {
          name = "Resources";

          categories = {
            "30" = {
              name = "devenv_repos";
              items = {
                "30.01" = {
                  name = "rwkv-Runner";
                  url = "https://github.com/lessuselesss/RWKV-Runner";
                  ref = "master";
                };
                "30.02" = {
                  name = "exo";
                  url = "https://github.com/lessuselesss/exo";
                  ref = "main";
                };
              };
            };
            "31" = {
              name = "References";
              items = {
                "31.01" = {name = "technical";};
                "31.02" = {name = "academic";};
              };
            };
            "32" = {
              name = "Collections";
              items = {
                "32.01" = {name = "templates";};
                "32.02" = {name = "checklists";};
              };
            };
          };
        };

        "90-99" = {
          name = "Archive";

          categories = {
            "90" = {
              name = "Completed";
              items = {
                "90.01" = {name = "projects";};
                "90.02" = {name = "references";};
              };
            };
            "91" = {
              name = "deprecated";
              items = {
                "91.01" = {name = "old Documents";};
                "91.02" = {name = "legacy Files";};
              };
            };
            "92" = {
              name = "Models";
              items = {
                "92.01" = {name = "huggingface";};
                "92.02" = {name = "ollama";};
              };
            };
            "93" = {
              name = "Datasets";
              items = {
                "93.01" = {name = "kaggle";};
                "93.02" = {name = "x";};
              };
            };
          };
        };
      };
    };
  };
}
