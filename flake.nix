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

    task-master = { 
      url = "github:lessuselesss/task-master-flake";
    };

    # Changed input name from mcp-servers-nix.lib to mcp-servers-nix
#    mcp-servers-nix = {
#      url = "github:lessuselesss/mcp-servers-nix";
#      inputs.nixpkgs.follows = "nixpkgs";
#    };

    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };
  pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

# Updated output signature to reflect the mcp-servers-nix input chang
outputs = { self, pre-commit-hooks, task-master, agenix, claude-desktop, darwin, disko, flake-utils, home-manager, homebrew-bundle, homebrew-cask, homebrew-core, nix-homebrew, nixjail, nixpkgs, ... }@inputs:
  let
    user = "lessuseless";
    linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
    darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
    forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;
    # pre-commit.nix
  
      checks = forAllSystems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
          };
        };
      });
  
      devShell = system: let pkgs = nixpkgs.legacyPackages.${system}; in {
      default = with pkgs; mkShell {
        
        buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;   
        nativeBuildInputs = with pkgs; [ bashInteractive git age age-plugin-yubikey ];
  
        shellHook = with pkgs; ''
          ${self.checks.${system}.pre-commit-check.shellHook}
          export EDITOR=vim
        '';
      };
    };
    # mkApp function assumes scripts exist at specific paths or are packaged derivations.
    # This example assumes the scripts 'apply', 'build-switch', etc., exist as files
    # in a directory structure like `./apps/${system}/${scriptName}.sh` and are read into the derivation.
    # You might need to adjust the path based on where your actual scripts live.
    mkApp = scriptName: system: {
      type = "app";
      program = "${(nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
        #!/usr/bin/env bash
        # Ensure these scripts exist in your flake at the path referenced by self
        # For demonstration, let's assume they are simple shell scripts within the flake's `apps` directory
        # If these are actual Nix derivations/packages, you'd reference them differently.
        # This part requires you to provide the actual script content or a path to it.
        # For now, keeping the original logic, assuming you have files like apps/x86_64-linux/apply
        PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH # Ensure git is in PATH if needed by the script
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
  in
    {
      devShells = forAllSystems devShell;

      apps = nixpkgs.lib.genAttrs linuxSystems mkLinuxApps // nixpkgs.lib.genAttrs darwinSystems mkDarwinApps;
     
      darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (system:
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = inputs;
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
        }
      );
      nixosConfigurations = nixpkgs.lib.genAttrs linuxSystems (system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs;
          modules = [
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${user} = import ./modules/nixos/home-manager.nix;
              };
            }
            ./hosts/nixos
          ];
        }
      );
    };
}

