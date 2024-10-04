  { lib, myLib, inputs, ... }:

  let internals = # Helper functions we don't plan on exporting past this file
  {
    mkPkgs = version: system: import version { inherit system; config.allowUnfree = true; };

    mkHost = baseConfig: hostname: { system }:
      lib.nixosSystem
      {
        inherit system;

      specialArgs =
      {
        inherit inputs myLib;

        pkgs-unstable = internals.mkPkgs inputs.nixpkgs-unstable system;
      };

      modules = baseConfig ++
      myLib.importUtils.importAll # Use custom function to allow importing all nix files within a folder
      [
        ../hosts/${hostname}/modules
        ../hosts/${hostname}/hardware-configuration.nix
        ../hosts/${hostname}/${hostname}Vars.nix
        {
          nixpkgs.pkgs = internals.mkPkgs inputs.nixpkgs system;
        }
      ];
    };

  };
  in
    baseConfig: hosts:
    lib.mapAttrs
    (
      hostname: { system }:
        internals.mkHost baseConfig hostname { inherit system; }
    )
    hosts