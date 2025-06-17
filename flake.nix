{
  description = "Starter Configuration for MacOS and NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixjail = {
      url = "github:lessuselesss/nixjail-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager.url = "github:nix-community/home-manager";

    # determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    # nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    flake-utils.url = "github:numtide/flake-utils";

    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
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

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Assuming 'claude-task-master' package and module are defined within this 'mcp-servers-nix' flake
    # on the 'taskmaster' branch, as per our previous discussion.
    mcp-servers-nix.lib = {
      url = "github:lessuselesss/mcp-servers-nix?ref=taskmaster";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { agenix, self, claude-desktop, darwin, disko, flake-utils, home-manager, homebrew-bundle, homebrew-cask, homebrew-core, mcp-servers-nix, nix-homebrew, nixjail, nixpkgs, ... }@inputs:
    let
      user = "lessuseless";
      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;

      devShell = system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = with pkgs;
            mkShell {
              nativeBuildInputs = [ bashInteractive git ];
              shellHook = ''
                export EDITOR=vim
              '';
            };
        };

      mkApp = scriptName: system: {
        type = "app";
        program = "${(nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
          #!/usr/bin/env bash
          PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
          echo "Running ${scriptName} for ${system}"
          exec ${self}/apps/${system}/${scriptName}
        '')}/bin/${scriptName}";
      };

      mkLinuxApps = system: {
        "apply" = mkApp "apply" system;
        "build-switch" = mkApp "build-switch" system;
        "copy-keys" = mkApp "copy-keys" system;
        "create-keys" = mkApp "create-keys" system;
        "check-keys" = mkApp "check-keys" system;
        "install" = mkApp "install" system;
      };

      mkDarwinApps = system: {
        "apply" = mkApp "apply" system;
        "build" = mkApp "build" system;
        "build-switch" = mkApp "build-switch" system;
        "copy-keys" = mkApp "copy-keys" system;
        "create-keys" = mkApp "create-keys" system;
        "check-keys" = mkApp "check-keys" system;
        "rollback" = mkApp "rollback" system;
      };

    in {
      devShells = forAllSystems devShell;

      apps = nixpkgs.lib.genAttrs linuxSystems mkLinuxApps // nixpkgs.lib.genAttrs darwinSystems mkDarwinApps;

      darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (system:
          darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit inputs system; };
          modules = [
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                inherit user;
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
        });

         nixosConfigurations = nixpkgs.lib.genAttrs linuxSystems (system: # Opening parenthesis for the function starts here
          let
            pkgs = import nixpkgs {
              inherit system;
              config = {
                allowUnfree = true;
              };
              overlays = [ mcp-servers-nix.overlays.default ];
            };
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = inputs;
            modules = [
              agenix.nixosModules.default
              nixjail.nixosModules.nixjail
              disko.nixosModules.disko

              # THIS IS WHERE THAT ANONYMOUS MODULE GOES:
              ({ config, ... }: {
                imports = [
                  mcp-servers-nix.lib.filesystem
                  mcp-servers-nix.lib.fetch
                  mcp-servers-nix.lib.claude-task-master
                ];

                programs.filesystem = {
                  enable = true;
                  args = [ "/path/to/allowed/directory" ];
                };
                programs.fetch.enable = true;
                programs.claude-task-master = {
                  enable = true;
                  anthropicApiKey = "YOUR_ANTHROPIC_API_KEY_HERE";
                  perplexityApiKey = "YOUR_PERPLEXITY_API_KEY_HERE";
                  openaiApiKey = "YOUR_OPENAI_KEY_HERE";
                  googleApiKey = "YOUR_GOOGLE_KEY_HERE";
                };
              }) # Closing brace for the anonymous module. This is an item in the 'modules' list.
              # ENSURE there is no accidental extra 'imports = [...]' here.

              home-manager.nixosModules.home-manager {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${user} = import ./modules/nixos/home-manager.nix;
                };
              }
              ./hosts/nixos
              {
                environment.systemPackages = with pkgs; [
                  claude-desktop.packages.${system}.claude-desktop
                  mcp-server-fetch
                  mcp-server-filesystem
                  claude-task-master
                ];
              }
            ];
          }
        ); # This closing parenthesis was missing or misplaced, it closes the function passed to genAttrs.
