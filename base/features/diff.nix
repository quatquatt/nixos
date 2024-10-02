{ pkgs-unstable, config, ... }:

{
  environment.systemPackages = with pkgs-unstable;
  [
    nvd # 0.2.4 is only on unstable right now and adds some nice feateures
  ];

  system.activationScripts.diff = # Runs on every rebuid
  ''
   ${pkgs-unstable.nvd}/bin/nvd --color=always --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig"
  '';
}