{ inputs, ... }:

let
  lib = inputs.nixpkgs.lib;

  myLib = (import ./default.nix) {inherit inputs;}; # Pass around so functions in different files can call each other

in
{
  importUtils = import ./importUtils.nix { inherit lib myLib; };

  mkHosts = import ./mkHosts.nix { inherit lib myLib inputs; };
  mkHome = import ./mkHome.nix { inherit lib myLib; };

  mkList = attrset: [ attrset ];

  mkUnfreeNixpkgs = import ./mkUnfreeNixpkgs.nix;
}
