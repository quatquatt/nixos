{ lib, myLib, inputs, ... }:

let
  internals = # Helper functions we don't plan on exporting past this file
  {
    myPkgs = system: import inputs.nixpkgs { inherit system; config.allowUnfree = true; };
    myUnstablePkgs = system: import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true; };
  };


  mkNixos = hostname: { system }: # Function to be exported
  lib.nixosSystem
    {
      inherit system;

    specialArgs =
    {
      inherit inputs myLib;

      pkgs-unstable = internals.myUnstablePkgs system;
    };

    modules = myLib.resolveAndFilter # Use custom function that grabs all files within a folder and filters out non-nix files
    [
      ../base/core
      ../base/features
      ../base/gnome
      ../base/modules
      ../base/terminal
      ../base/baseVars.nix

      ../apps/cli
      ../apps/gui

      ../hosts/${hostname}/modules
      ../hosts/${hostname}/hardware-configuration.nix
      ../hosts/${hostname}/${hostname}Vars.nix
      {
        nixpkgs.pkgs = internals.myPkgs system;
      }
    ];
  };
in
  mkNixos