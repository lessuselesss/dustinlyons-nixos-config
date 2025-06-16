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
      flake = false;
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

    mcp-servers-nix = {
      url = "github:natsukium/mcp-servers-nix";
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
        let user = "lessuseless";
        in darwin.lib.darwinSystem {
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

        nixosConfigurations = nixpkgs.lib.genAttrs linuxSystems (system:
          let
            pkgs = import nixpkgs {
              inherit system;
              config = {
                allowUnfree = true;
              };
              # Correctly add the mcp-servers-nix overlay here
              overlays = [ mcp-servers-nix.overlays.default ];
            };
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = inputs;
            modules = [

              agenix.nixosModules.default
              nixjail.nixosModules.nixjail
              #determinate.nixosModules.default
              disko.nixosModules.disko
              # Remove these lines if they are still present from previous attempts:
              # claude-desktop.nixosModules.default
              # mcp-servers-nix.nixosModules.default
              # mcp-servers-nix.lib.mkConfig pkgs { ... }
              # mcp-servers-nix.modules.filesystem
              # mcp-servers-nix.modules.fetch

              home-manager.nixosModules.home-manager {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${user} = import ./modules/nixos/home-manager.nix;
                };
              }
              ./hosts/nixos
              { # This anonymous module correctly adds system packages
                environment.systemPackages = with pkgs; [
                  claude-desktop.packages.${system}.claude-desktop
                  # Add the specific mcp-server packages you want here:
                  mcp-server-fetch # Example: installs the mcp-server-fetch package
                  mcp-server-filesystem # Example: installs the mcp-server-filesystem package
                ];
              }
            ]; # Closing bracket for modules list
          } # Closing brace for nixpkgs.lib.nixosSystem attribute set
        ); # Closing parenthesis for nixpkgs.lib.genAttrs function call
    }; # Closing brace for outputs attribute set
} # Closing brace for the flake itself