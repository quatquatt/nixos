{
    description = "A simple NixOS flake";

    inputs =
    {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
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
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    };


    outputs =
    {
        self,

        nixpkgs,
        nixpkgs-unstable,

        home-manager,

        nixos-hardware,
        disko,
        firefox-addons,

        ...
    } @ inputs:

    let
        vars = import ./variables.nix;
        lib = nixpkgs.lib;
        system = "x86_64-linux";

        pkgsArgs = { inherit system; config.allowUnfree = true; };
        pkgs = import nixpkgs pkgsArgs;
        pkgs-unstable = import nixpkgs-unstable pkgsArgs;

        base = import ./base.nix { inherit disko nixpkgs pkgs pkgs-unstable vars; };
    in
    {


        nixosConfigurations.mypc = lib.nixosSystem
        {
            inherit system;

            modules = base.nix.modules ++
            [
                ./desktop/nix
                ./desktop/nixware
            ];
            specialArgs = base.specialArgs //
            {
                hostVars = import ./desktop/deskVars.nix;
            };
        };

        homeConfigurations."username@mypc" = home-manager.lib.homeManagerConfiguration
        {
            inherit pkgs;
            modules = base.home.modules ++
            [
                ./desktop/home
                ./desktop/homeware
            ];
            extraSpecialArgs = base.specialArgs //
            {
                hostVars = import ./desktop/deskVars.nix;
            };
        };

        nixosConfigurations.framework = lib.nixosSystem
        {
            inherit system;
            modules = base.nix.modules ++
            [
                ./framework/nix
                ./framework/nixware

            ];
            specialArgs = base.specialArgs //
            {
                hostVars = import ./framework/frameVars.nix;
            };
        };
        homeConfigurations."emanresu@framework" = home-manager.lib.homeManagerConfiguration
        {
            inherit pkgs;
            modules = base.home.modules ++
            [
                ./framework/home
                ./framework/homeware
            ];
            extraSpecialArgs = base.specialArgs //
            {
                hostVars = import ./framework/frameVars.nix;
            };
        };
    };
}
