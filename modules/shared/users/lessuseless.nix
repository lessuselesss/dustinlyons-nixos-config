# User-scoped configuration that integrates with home-manager and johnny-mnemonix
# to maintain proper permissions and create a declarative johnny-decimal style
# system under ~/Documents. This ensures both reproducibility and organized
# file management.
{
  pkgs,
  config,
  lib,
  ...
}: {
  users.users.lessuseless = {
    name = "lessuseless";
    home = "/Users/lessuseless";
    shell = pkgs.zsh;

    packages = with pkgs; [
      # Development tools
      git
      gh
      gnupg
      pinentry_mac
      direnv
      nix-direnv
      fzf
      ripgrep
      fd
      jq
      yq
      tree
      wget
      curl
      htop
      btop
      neofetch
      tmux
      vim
      neovim

      # Security tools
      age
      sops
      ssh-copy-id
      yubikey-manager

      # Shell utilities
      bat
      eza
      zoxide
      starship

      # Program configurations
      alejandra
      deadnix
      statix

      # Development tools and fonts - everything needed for coding and UI work
      bun # JavaScript/TypeScript runtime and toolkit
      cargo # Rust package manager and build tool
      cmake # Cross-platform build system generator
      deno # Modern JavaScript/TypeScript runtime
      devenv # Per-project development environments
      emacs # Your primary editor
      emacs-all-the-icons-fonts # Icons for Emacs UI
      fabric-ai # AI development toolkit
      hack-font # Code font
      jetbrains-mono # Code font
      micromamba # Lightweight conda-compatible package manager
      nurl # Nix URL fetcher conversion tool
      pkg-config # Helper tool for compiling applications
      python312 # Latest Python interpreter
      zip # File compression utility

      # Security and encryption tools for safe data handling
      age-plugin-yubikey # YubiKey support for age
      pass # Unix password manager

      # Shell utilities that improve terminal workflow
      bat # Better cat with syntax highlighting
      btop # Resource monitor and process viewer
      fzf # Fuzzy finder for everythinga
      zsh-autosuggestions # Fish-like history suggestions
      zsh-syntax-highlighting # Shell syntax highlighting
    ];
  };

  home-manager.users.lessuseless = {
    home.stateVersion = "24.11";

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;

      completionInit = ''
        # Initialize completion system
        autoload -U compinit
        compinit -d "$HOME/.cache/zsh/zcompdump-$ZSH_VERSION"

        # Completion settings
        zstyle ':completion:*' completer _complete _match _approximate
        zstyle ':completion:*' use-cache on
        zstyle ':completion:*' cache-path "$HOME/.cache/zsh/zcompcache"
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive completion
        zstyle ':completion:*:*:*:*:*' menu select # Interactive completion menu
        zstyle ':completion:*:matches' group 'yes' # Group matches
        zstyle ':completion:*:options' description 'yes' # Show descriptions in options
        zstyle ':completion:*:options' auto-description '%d' # Auto describe options
        zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f' # Format corrections
        zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f' # Format descriptions
        zstyle ':completion:*:messages' format ' %F{purple}-- %d --%f' # Format messages
        zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f' # Format warnings
        zstyle ':completion:*' group-name "" # Group by type
      '';

      history = {
        size = 10000;
        path = "$HOME/.local/share/zsh/history";
        ignoreDups = true;
        ignoreSpace = true;
        expireDupsFirst = true;
        share = false; # Don't share history between sessions for security
      };

      initExtra = ''
        # Security settings for history and autosuggestions
        # Ensure history directory exists with proper permissions
        mkdir -p "$(dirname $HISTFILE)" && chmod 700 "$(dirname $HISTFILE)"
        [[ -e "$HISTFILE" ]] && chmod 600 "$HISTFILE"

        # Ensure completion cache directory exists with proper permissions
        mkdir -p "$HOME/.cache/zsh" && chmod 700 "$HOME/.cache/zsh"

        # Don't store sensitive patterns in history
        export HISTORY_IGNORE="(*password|*secret|*key|*token|*credential*|*PRIVATE*)"

        # Shell options focused on security and usability
        # History security
        setopt HIST_FCNTL_LOCK # Use system locks for history
        setopt HIST_IGNORE_DUPS # Don't store duplicate commands
        setopt HIST_IGNORE_SPACE # Don't store commands starting with space
        setopt HIST_EXPIRE_DUPS_FIRST # Remove duplicates first when trimming history
        setopt HIST_FIND_NO_DUPS # Don't display duplicates when searching
        setopt HIST_VERIFY # Show command from history before executing
        setopt EXTENDED_HISTORY # Store timestamp in history

        # General security
        setopt NO_CLOBBER # Don't overwrite files with >
        setopt RM_STAR_WAIT # Wait before executing rm with *
        setopt PATH_DIRS # Search path for commands
        setopt PRINT_EXIT_VALUE # Show non-zero exit values

        # Shell behavior
        setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell
        setopt HASH_CMDS # Hash command paths for faster lookup
        setopt NO_FLOW_CONTROL # Disable flow control (^S/^Q)

        # Load starship prompt
        if command -v starship >/dev/null 2>&1; then
          eval "$(starship init zsh)"
        fi

        # Load zoxide
        if command -v zoxide >/dev/null 2>&1; then
          eval "$(zoxide init zsh)"
        fi

        # Load fzf
        if [[ -f ${pkgs.fzf}/share/fzf/completion.zsh ]]; then
          source ${pkgs.fzf}/share/fzf/completion.zsh
        fi
        if [[ -f ${pkgs.fzf}/share/fzf/key-bindings.zsh ]]; then
          source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        fi

        # GPG settings
        export GPG_TTY=$(tty)
        if [[ -n "''${commands[pinentry-mac]}" ]]; then
          export PINENTRY_USER_DATA="USE_CURSES=1"
        fi
      '';

      shellAliases = {
        # Modern alternatives
        cat = "bat";
        ls = "eza";
        ll = "eza -l";
        la = "eza -la";
        tree = "eza --tree";

        # Git extras
        glog = "git log --oneline --decorate --graph";
        gwip = "git add -A && git commit -m 'wip'";

        # Nix extras
        nrs = "darwin-rebuild switch --flake .";
        nrb = "darwin-rebuild build --flake .";

        # Directory navigation
        dev = "cd ~/Development";
        dots = "cd ~/nix-systems-config";
      };
    };

    programs.git = {
      enable = true;
      userName = "lessuseless";
      userEmail = "lessuseless@users.noreply.github.com";
      signing = {
        key = "0x1234567890ABCDEF";
        signByDefault = true;
      };
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        rebase.autoStash = true;
      };
    };

    programs.starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✗](bold red)";
        };
        git_branch.style = "bold purple";
        nix_shell = {
          symbol = " ";
          style = "bold blue";
        };
      };
    };

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
    };
  };
}
