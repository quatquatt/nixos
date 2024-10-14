{ lib, ... }:
let
  defaultApps =
  {
    browser = lib.singleton "firefox.desktop";
    editor = lib.singleton "Helix.desktop";
    files = lib.singleton "org.gnome.Nautilus.desktop";
    terminal = lib.singleton "kitty.desktop";
    extractor = lib.singleton "org.gnome.Nautilus.desktop";

    pdf = lib.singleton "org.pwmt.zathura.desktop";
    images = lib.singleton "org.gnome.Loupe.desktop";
    videos = lib.singleton "org.gnome.Totem.desktop";

    discord = lib.singleton "vesktop.desktop";
  };

  associations =
  {
    "text/plain" = defaultApps.editor;
    "application/x-zerosize" = defaultApps.editor; # Empty files
    "application/x-trash" = defaultApps.editor; # Backup files

    # We don't set things like x-terminal-emulator, choosing instead to use xdg-terminal-exec since it behaves much better on gnome

    "text/html" = defaultApps.browser;
    "text/xml" = defaultApps.browser;
    "x-scheme-handler/http" = defaultApps.browser;
    "x-scheme-handler/https" = defaultApps.browser;
    "x-scheme-handler/unknown" = defaultApps.browser;

    "inode/directory" = defaultApps.files;

    "application/pdf" = defaultApps.pdf;
    "application/epub" = defaultApps.pdf;

    "application/*zip" = defaultApps.extractor;
    "application/gzip" = defaultApps.extractor;
    "application/rar" = defaultApps.extractor;
    "application/7z" = defaultApps.extractor;
    "application/*tar" = defaultApps.extractor;

    "image/*" = defaultApps.images;
    "video/*" = defaultApps.videos;

    "x-scheme-handler/discord" = defaultApps.discord;
  };


in
{
  hm.xdg =
  {
    enable = true;
    mime.enable = true;
  };

  hm.xdg.mimeApps =
  {
    enable = true;
    defaultApplications = associations;
  };

  hm.xdg.configFile."mimeapps.list".force = lib.mkForce true; # Delete backup for mimeApps since backups are done idiotically


  xdg.terminal-exec.enable = true; # From NixOS xdg module, not Home-Manager one
  hm.xdg.configFile."xdg-terminals.list" =
  {
    text =
    ''
      ${builtins.elemAt defaultApps.terminal 0}
    '';
    force = true;
  };

}
