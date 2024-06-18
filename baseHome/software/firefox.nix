{ pkgs, ...}:

{

  programs.firefox =
  {
    enable = true;

    package = pkgs.firefox.overrideAttrs
    (oldAttrs:
    {
      buildCommand = oldAttrs.buildCommand + ''
        wrapProgram $out/bin/firefox \
          --set MOZ_ENABLE_WAYLAND 0
      '';
    });
  };
}