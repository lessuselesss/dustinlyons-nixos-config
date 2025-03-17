{
  description = "Starter Configuration with secrets for MacOS and NixOS";
  inputs = {
    # Example of how to reference a FlakeHub package
    # Replace "owner/repo/version" with the actual FlakeHub package you want to use
    # example-flakehub-package = {
    #   url = "https://flakehub.com/f/owner/repo/0.1.0.tar.gz";
    # };
    
    determinate.url = "https://flakehub.com/f/DeterminateSystems/nix/2.0";
    
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*";
    nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/*";
    nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

    agenix.url = "https://flakehub.com/f/ryantm/agenix/0.14.0";

    home-manager.url = "https://flakehub.com/f/nix-community/home-manager/0.2411.3881";
    #flake-parts.url = "github:hercules-ci/flake-parts";
    #process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    #services-flake.url = "github:juspay/services-flake";

    disko = {
      url = "https://flakehub.com/f/nix-community/disko/1.11.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
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
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets = {
      url = "git+ssh://git@github.com/lessuselesss/nix-secrets.git?ref=main";
      flake = false;
    };
    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";
    #microvm.inputs.flake-utils.follows = "flake-utils";

    # Declarative Directories 
    sane-defaults = {
      url = "github:lessuselesss/sane-defaults";
      flake = false;
    };

    home-office = {
      url = "git+ssh://git@github.com/lessuselesss/home-office.git";
      flake = false;
    };

  };
  outputs = inputs @ { self, determinate, darwin, nix-homebrew, homebrew-bundle, homebrew-core, homebrew-cask, home-manager, nixpkgs, nixpkgs-stable, nixpkgs-unstable, nix-index-database, microvm, disko, agenix, secrets, home-office, sane-defaults}:
    let
      # Move these variable definitions to the top level
      user = "lessuseless";
      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;
      devShell = system: let pkgs = nixpkgs.legacyPackages.${system}; in {
        default = with pkgs; mkShell {
          nativeBuildInputs = with pkgs; [ bashInteractive git age age-plugin-yubikey ];
          shellHook = with pkgs; ''
            export EDITOR=vim
          '';
        };
      };
      
      # Define the mkApp function at the top level
      mkApp = scriptName: system: {
        type = "app";
        program = "${(inputs.nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
          #!/usr/bin/env bash
          PATH=${inputs.nixpkgs.legacyPackages.${system}.git}/bin:$PATH
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
        "install-with-secrets" = mkApp "install-with-secrets" system;
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
      
      # TODO: Re-implement forAllSytems instead
      # Define supported systems
      # systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      
      # reference the TODO regarding overlays at the bottom of this flake
      # Define overlays
      # overlays = [
      #   (import ./overlays/talon.nix)
      # ];
      
      # Create pkgs with overlays
      # pkgsFor = system: import nixpkgs {
      #   inherit system overlays;
      #   config.allowUnfree = true;
      # };
    in 
    {
      # TODO: simplify the devshell defnition below
      # It looks like cursor broke this down so instead of using a 
      # simple "devShells = forAllSystems devShell;" we have the following
      # Your devShell definition
      # devShells = nixpkgs.lib.genAttrs systems (system: 
      #   let pkgs = pkgsFor system; in
      #   {
      #     pkgs.mkShell {
      #       nativeBuildInputs = with pkgs; [ bashInteractive git age age-plugin-yubikey ];
      #       shellHook = with pkgs; ''
      #         export EDITOR=vim
      #       '';
      #     };
      #   }
      # );
      devShells = forAllSystems devShell;
      # Your existing flake outputs
      apps = 
        inputs.nixpkgs.lib.genAttrs linuxSystems mkLinuxApps // 
        inputs.nixpkgs.lib.genAttrs darwinSystems mkDarwinApps;
      
      # Your Darwin configurations
      darwinConfigurations = inputs.nixpkgs.lib.genAttrs darwinSystems (system:
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = inputs;
          modules = [
            # determinate.nixosModules.default  # this might not supposed to be here.
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            nix-index-database.darwinModules.nix-index
            # TODO: migrate nix-index to shared home-manager config
            { 
              # reference the TODO regarding overlays at the bottom of this flake
              # nixpkgs.overlays = overlays; 
              nixpkgs.config.allowUnfree = true;
              programs.nix-index-database.comma.enable = true;
              
              home-manager.extraSpecialArgs = inputs;
            }
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
      
      # Your NixOS configurations
      nixosConfigurations = inputs.nixpkgs.lib.genAttrs linuxSystems (system: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = inputs;
        modules = [
          determinate.nixosModules.default
          disko.nixosModules.disko
          microvm.nixosModules.microvm
          {
            # nixpkgs.overlays = overlays;
            nixpkgs.config.allowUnfree = true;
          }
          home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${user} = import ./modules/nixos/home-manager.nix;
            };
          }
          ./hosts/nixos
        ];
      });
      # TODO: Overlays are not defined at the flake level in the 
      # upstream flake. Investigate how to get this working with 
      # the /overlays directory at the root of this repo.
      # Export the overlay
      # overlays.default = import ./overlays/talon.nix;
    };
}
