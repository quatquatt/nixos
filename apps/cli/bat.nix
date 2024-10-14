{ lib, pkgs, ... }:
let
  robin = pkgs.writeShellApplication
  {
    name = "robin";
    runtimeInputs = with pkgs;
    [
      man
      bat-extras.batman
    ];
    text = 
    ''
      command_name=$(basename "$0")
      if man -w "$command_name" > /dev/null 2>&1; then
        exec batman "$command_name"
      else
        exec "$0" "$@"
      fi
    '';
  };
in
{
  environment.shellAliases.cat = "bat";
  environment.shellAliases.man = "batman";

  hm.programs.bat =
  {
    enable = true;

    extraPackages = with pkgs.bat-extras;
    [
      batman # Prettier version of man
    ];
  };

  environment.variables = # Make --help look pretty like batman
  {
    MANPAGER = "sh -c 'col -bx | bat --language man --plain' ";
    MANROFFOPT = "-c";
  };

  hm.home.activation.batCache = lib.mkForce "";# Waiting for https://github.com/nix-community/home-manager/issues/5481 is fixed
}
