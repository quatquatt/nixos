{
  description = "A no-longer simple NixOS flake";

  inputs =
  {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05"; # Use nixos branches instead of nixpkgs, it runs more tests
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager =
    {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko =
    {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons =
    {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-gnome-theme =
    {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  };


  outputs = inputs @ { ... }: # Everything is passed via "inputs.NAME" to avoid clutter

  let
    myLib = import ./myLib { inherit inputs; };

    baseConfig = myLib.importUtils.importAll # The configuration to be applied to every host
    [
      ./base/core
      ./base/features
      ./base/gnome
      ./base/modules
      ./base/terminal
      ./base/baseVars.nix

      ./apps/cli
      ./apps/gui
    ];


    # Declare nixosConfigurations within the let expression so we can reuse it for homeConfigurations
    nixosConfigurations = myLib.mkHosts # Create each host with the given base config, plus their custom files in ./hosts
    baseConfig
    {
      framework.system = "x86_64-linux";

      desktop.system = "x86_64-linux";
    };

  in
  {
    inherit nixosConfigurations;

    # homeConfigurations = builtins.mapAttrs myLib.mkHome # Run mkHome for each homeConfiguration, with key passed as userhost
    # {
    #   "emanresu@framework" = { inherit nixosConfigurations; };
    # };
  };
}
