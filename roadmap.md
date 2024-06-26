# FEATURES:

- [ ] Create new aliases for rebuilding
 with option for fast install

- [ ] Set up SSH
- [ ] Try out KDE

- [ ] Add secrets management (either with sops or agenix)
- [ ] Add disko configuration and reinstall everyone with it applied
- [ ] Try out impermanence


# SOFTWARE:
- [ ] Set up firefox dark mode
- [ ] Kit out vscode with all options
    - [ ] Get vscode-server fully working

- [ ] Work on vscode theme again (whether it's personal or lesbian theme)
    - [ ] Get npm packages like watch working correctly


- [ ] Kit out bash / try other terminals
- [x] Kit out firefox with all options


# IMPROVEMENTS:
- [ ] Update readme to reflect not using base anymore
- [ ] Ask discord if there's a way to pass the set from flake.nix to mkHosts.nix so that the functions are more lightweight

- [ ] Reinstall desktop name with name and host as "emanresu@desktop"

- [ ] Create new, working iso with disko
- [ ] Add swap partition to disko

- [ ] See if hostVars can be enforced to have all the same variables
    - This could be done with mkIf and passing hostname from the flake.nix

- [x] Improve the way inputs are passed from flake to be more clear and less hacky (ASAP)
- [x] Learn how to custom-build firefox extensions to add movie-web remastered
    - OR: Make issue with rycee to add the extension

- [x] Move all non-base software to an area independent of host for modularity
    - [x] If this is implemented, make sure not to crowd flake.nix with imports
