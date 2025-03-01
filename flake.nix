{
  description = "lessuseless Nix Systems Configurations";
  inputs = {
    # Home manager will use the rolling version of nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # Latest packages for our builds

    # Nix Systems will use flakehub versions of nixpkgs via determinate
    nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/*"; # For production stability
    nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1"; # Bleeding edge features
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";
      inputs.nixpkgs.follows = "nixpkgs-stable"; # Uses our main package source
    };
    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*"; # FlakeHub integration
    agenix.url = "github:ryantm/agenix";
    home-manager.url = "github:nix-community/home-manager";
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-services = {
      url = "github:homebrew/homebrew-services";
      flake = false;
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # Commenting out secrets temporarily
    secrets = {
      url = "git+ssh://git@github.com/lessuseless/nix-secrets.git";
      flake = false;
    };

    # apple-silicon-support = {
    #   url = "github:tpwrules/nixos-apple-silicon";
    #   inputs.nixpkgs.follows = "nixpkgs"; # Maintains package consistency
    # };

    # nix-on-droid = {
    #   url = "github:nix-community/nix-on-droid/release-24.05"; # Android support
    #   inputs.nixpkgs.follows = "nixpkgs"; # Maintains package consistency
    # };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix"; # Pre-commit hook framework
      inputs.nixpkgs.follows = "nixpkgs-stable"; # Uses main packages
    };
  };
  outputs = {
    fh,
    self,
    disko,
    darwin,
    determinate,
    nix-homebrew,
    homebrew-bundle,
    homebrew-core,
    homebrew-cask,
    home-manager,
    homebrew-services,
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-unstable,
    pre-commit-hooks,
    secrets, # Comment out from outputs
    agenix,
  } @ inputs: let
    adminUser = "admin";
    regularUser = "lessuseless";
    linuxSystems = ["x86_64-linux" "aarch64-linux"];
    darwinSystems = ["aarch64-darwin" "x86_64-darwin"];
    mobileSystems = ["aarch64-linux"]; # Mobile platform architectures
    forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems ++ mobileSystems) f; # Helper for multi-platform configs

    devShell = system: let
      pkgs = nixpkgs.legacyPackages.${system}; # System-specific packages
      mkPreCommitHook = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.; # Current directory
          hooks = {
            # Temporarily disabled: Was used to generate codebase overview when IDE couldn't show all files.
            # Consider removing once IDE tooling improves or if a non-nodejs alternative is found.
            # repomix-generator = {
            #   enable = true;
            #   name = "repomix-generator";
            #   entry = "${pkgs.writeShellScript "generate-repomix" ''
            #     ${pkgs.nodejs}/bin/node ${pkgs.nodePackages.npm}/bin/npx repomix .
            #     git add repomix-output.txt
            #   ''}";
            #   files = ".*"; # Runs on all files
            #   pass_filenames = false;
            # };

            alejandra-lint = {
              enable = true;
              name = "alejandra-lint";
              entry = "${pkgs.alejandra}/bin/alejandra .";
              files = ".*"; # Formats all files
              pass_filenames = false;
            };

            deadnix-lint = {
              enable = true;
              name = "deadnix-lint";
              entry = "${pkgs.deadnix}/bin/deadnix .";
              files = ".*"; # Checks for dead code
              pass_filenames = false;
            };

            build-check = {
              enable = true;
              name = "build-check";
              entry = "${pkgs.writeShellScript "verify-build" ''
                echo "Verifying build..."
                nix run .#build-switch
              ''}";
              files = ".*"; # Checks all files
              pass_filenames = false;
            };
          };
        };
      };
    in {
      default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          bashInteractive # Enhanced shell
          git # Version control
          age # Encryption tool
          age-plugin-yubikey # YubiKey support
          age-plugin-ledger # Ledger support
          deadnix # Dead code elimination for Nix
        ];
        shellHook = ''
          ${mkPreCommitHook.pre-commit-check.shellHook}  # Setup pre-commit hooks
          export EDITOR=vim  # Set default editor
          git config --unset-all core.hooksPath || true  # Reset Git hooks path
        '';
      };
    };

    mkApp = scriptName: system: {
      type = "app";
      program = "${(nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
        #!/usr/bin/env bash
        PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
        echo "Running ${scriptName} for ${system}"
        # Detect Android environment
        if [[ -n "$TERMUX_VERSION" ]]; then
          exec ${self}/apps/aarch64-android/${scriptName}  # Use Android-specific path
        else
          exec ${self}/apps/${system}/${scriptName}  # Use system-specific path
        fi
      '')}/bin/${scriptName}";
    };

    mkLinuxApps = system:
      {
        apply = mkApp "apply" system; # System changes application
        "build-switch" = mkApp "build-switch" system; # Build and switch configuration
      }
      // (
        if system != "aarch64-android"
        then {
          "copy-keys" = mkApp "copy-keys" system; # Key management
          "create-keys" = mkApp "create-keys" system; # Key generation
          "check-keys" = mkApp "check-keys" system; # Key verification
          install = mkApp "install" system; # System installation
          "install-with-secrets" = mkApp "install-with-secrets" system; # Installation with secrets
        }
        else {}
      );

    mkDarwinApps = system: {
      apply = mkApp "apply" system; # Apply system changes
      build = mkApp "build" system; # Build configuration
      "build-switch" = mkApp "build-switch" system; # Build and switch configuration
      "copy-keys" = mkApp "copy-keys" system; # Copy encryption keys
      "create-keys" = mkApp "create-keys" system; # Generate new keys
      "check-keys" = mkApp "check-keys" system; # Verify key status
      rollback = mkApp "rollback" system; # Revert system changes
    };
  in {
    # What: Development environment definitions
    # Does: Creates development shells for all platforms
    # Why: Ensures consistent development across systems
    devShells = forAllSystems devShell; # Generate shells for each platform

    # What: System-specific applications
    # Does: Creates platform-specific command wrappers
    # Why: Provides consistent interface across systems
    apps = (nixpkgs.lib.genAttrs linuxSystems mkLinuxApps) // (nixpkgs.lib.genAttrs darwinSystems mkDarwinApps);

    # What: Code quality checks
    # Does: Configures pre-commit hooks for all systems
    # Why: Maintains code quality standards
    checks = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system}; # System-specific packages
    in {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.; # Current directory
        hooks = {
          # What: Documentation generator
          # Does: Updates repository documentation
          # Why: Maintains current documentation
          repomix-generator = {
            enable = true;
            name = "repomix-generator";
            entry = "${pkgs.writeShellScript "generate-repomix" ''
              ${pkgs.nodejs}/bin/node ${pkgs.nodePackages.npm}/bin/npx repomix .
              git add repomix-output.txt
            ''}";
            files = ".*"; # All files
            pass_filenames = false;
          };

          # What: Code formatter
          # Does: Ensures consistent code style
          # Why: Maintains code quality
          alejandra-lint = {
            enable = true;
            name = "alejandra-lint";
            entry = "${pkgs.alejandra}/bin/alejandra .";
            files = ".*"; # All files
            pass_filenames = false;
          };

          # What: Build verification
          # Does: Tests system configuration
          # Why: Catches build issues early
          build-check = {
            enable = true;
            name = "build-check";
            entry = "${pkgs.writeShellScript "verify-build" ''
              echo "Verifying build..."
              nix run .#build-switch
            ''}";
            files = ".*"; # All files
            pass_filenames = false;
          };
        };
      };
    });

    darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (
      system:
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = inputs;
          modules = [
            ./modules/shared/users/admin.nix
            ./modules/shared/users/lessuseless.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = false; # Separation of concerns for admin and regular users
                useUserPackages = true; # Isolate user-specific packages
              };
            }
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                user = regularUser;
                enable = true;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                };
                mutableTaps = false;
                autoMigrate = true;
              };
            }
            ./hosts/darwin
          ];
        }
    );
    nixosConfigurations = nixpkgs.lib.genAttrs linuxSystems (
      system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs;
          modules = [
            ./modules/shared/users/admin.nix
            ./modules/shared/users/lessuseless.nix
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = false;
                useUserPackages = true;
              };
            }
            ./hosts/nixos
          ];
        }
    );
  };
}
