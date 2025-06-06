{ pkgs, config, lib, ... }:

let
  githubPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOk8iAnIaa1deoc7jw8YACPNVka1ZFJxhnU4G74TmS+p dustin@Dustins-MBP.localdomain";
  githubPublicSigningKey = '''
    -----BEGIN PGP PUBLIC KEY BLOCK-----

    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
    1USIqi8ymF08Ak+cIhyO
    =WFfO
    -----END PGP PUBLIC KEY BLOCK-----
  ''';
  user = "lessuseless"; # Corrected to your specified username
in

# This module returns an attribute set of files that will be placed in the user's home directory.
# We are extending this attribute set to include the johnny-mnemonix configuration.
{
  # Initializes Emacs with org-mode so we can tangle the main config
  #
  # @todo: Get rid of this after we've upgraded to Emacs 29 on the Macbook
  # Emacs 29 includes org-mode now
  ".emacs.d/init.el" = {
    text = builtins.readFile ./config/emacs/init.el;
  };

  ".ssh/id_github.pub" = {
    text = githubPublicKey;
  };

  ".ssh/pgp_github.pub" = {
    text = githubPublicSigningKey;
  };

  # Johnny Mnemonix configuration
  # We define options and config within this module
  # which will be picked up by Home Manager when this module is imported.
  options.johnny-mnemonix = {
    enable = lib.mkEnableOption "Johnny Mnemonix configuration";
    baseDir = lib.mkOption {
      type = lib.types.str;
      default = "/Users/${user}/Documents"; # Corrected path for macOS
      description = "Base directory for Johnny Mnemonix";
    };
    spacer = lib.mkOption {
      type = lib.types.str;
      default = "_";
      description = "Spacer character for directory names";
    };
    areas = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Areas configuration for Johnny Mnemonix";
    };
  };

  config = lib.mkIf config.johnny-mnemonix.enable {
    johnny-mnemonix = {
      baseDir = "/Users/${user}/Documents"; # Ensure baseDir uses /Users
      spacer = "_"; # Keep the specified spacer
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
                  target = "/Users/${user}/.dotfiles";
                };
                "01.01" = {
                  name = "applications";
                  target = "/Users/${user}/Applications";
                };
                "01.02" = {
                  name = "desktop";
                  target = "/Users/${user}/Desktop";
                };
                "01.03" = {
                  name = "documents";
                  target = "/Users/${user}/Documents";
                };
                "01.04" = {
                  name = "downloads";
                  target = "/Users/${user}/.local/share/downloads";
                };
                "01.05" = {
                  name = "movies";
                  target = "/Users/${user}/Movies";
                };
                "01.06" = {
                  name = "music";
                  target = "/Users/${user}/Music";
                };
                "01.07" = {
                  name = "pictures";
                  target = "/Users/${user}/Pictures";
                };
                "01.08" = {
                  name = "public";
                  target = "/Users/${user}/Public";
                };
                "01.09" = {
                  name = "templates";
                  target = "/Users/${user}/Templates";
                };
                "01.10" = {
                  name = "dotlocal_share";
                  target = "/Users/${user}/.local/share";
                };
                "01.11" = {
                  name = "dotlocal_bin";
                  target = "/Users/${user}/.local/bin";
                };
                "01.12" = {
                  name = "dotlocal_lib";
                  target = "/Users/${user}/.local/lib";
                };
                "01.13" = {
                  name = "dotlocal_include";
                  target = "/Users/${user}/.local/include";
                };
                "01.14" = {
                  name = "dotlocal_state";
                  target = "/Users/${user}/.local/state";
                };
                "01.15" = {
                  name = "dotlocal_cache";
                  target = "/Users/${user}/.cache";
                };
              };
            };
            "02" = {
              name = "Cloud";
              items = {
                "02.00" = {
                  name = "configs";
                  target = "/Users/${user}/.config/rclone";
                };
                "02.01" = {name = "dropbox";};
                "02.02" = {name = "google drive";};
                "02.03" = {
                  name = "icloud";
                  target = "/Users/${user}/Library/Mobile Documents/com~apple~CloudDocs";
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
