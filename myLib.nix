{ inputs, ... }:

let
  lib = inputs.nixpkgs.lib;

  myLib = (import ./myLib.nix) {inherit inputs;};

in rec
{
  myPkgs = system: import inputs.nixpkgs { inherit system; config.allowUnfree = true; };
  myUnstablePkgs = system: import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true; };


  isNixFile = lib.hasSuffix ".nix";

  importNixFile = filepath:
    if builtins.pathExists filepath && isNixFile filepath
      then [ filepath ]
    else [];

  importNixFolder = dir:
  if !builtins.pathExists dir || builtins.readDir dir == {}
    then [] # Exit early if directory doesn't exist, or is empty
  else lib.mapAttrsToList
  (file: _: dir + "/${file}")
  (lib.filterAttrs
    (file: _: isNixFile file)
    (builtins.readDir dir)
  );

  importNixFileOrFolder = path:
    if !builtins.pathExists path then [] # Exit early if path is invalid
    else if lib.pathIsDirectory path then importNixFolder path
    else importNixFile path;

  importAll = dirs:
  lib.concatLists
  (map importNixFileOrFolder dirs);



  mkNixos = { hostname, system ? "x86_64-linux" }:
  lib.nixosSystem
  {
    inherit system;

    specialArgs =
    {
      inherit inputs myLib;

      pkgs = myPkgs system;
      pkgs-unstable = myUnstablePkgs system;

      vars = import ./base/baseVars.nix;
      hostVars = import ./${hostname}/${hostname}Vars.nix;
    };

    modules =
    importAll
    [
      ./base/core/nixos
      ./base/gnome/nixos
      ./base/software/nixos
      ./base/terminal/nixos

      ./${hostname}/features/nixos
      ./${hostname}/hardware/nixos
      ./${hostname}/hardware-configuration.nix
    ]
    ++ lib.singleton # Wraps list around set
    {
      nixpkgs.pkgs = myPkgs system;
    };
  };


  mkHome = { hostname, username, system ? "x86_64-linux" }:
  inputs.home-manager.lib.homeManagerConfiguration
  {
    pkgs = myPkgs system;

    extraSpecialArgs =
    {
      inherit inputs myLib;

      pkgs-unstable = myUnstablePkgs system;

      vars = import ./base/baseVars.nix;
      hostVars = import ./${hostname}/${hostname}Vars.nix;
    };

    modules =
    importAll
    [
      ./base/core/home
      ./base/gnome/home
      ./base/software/home
      ./base/terminal/home

      ./${hostname}/features/home
      ./${hostname}/hardware/home
    ];
  };

}
