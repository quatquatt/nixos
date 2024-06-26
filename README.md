# WHAT IS THIS?
This is my own nixos configuration for both my desktop and laptop. Currently it provides a base configuration, as well as per-host modules on top of the base.

# HOW IS IT ORGANIZED?
The current structure is organized like this:

```
project
│   base.nix
│   flake.nix
|   vars.nix
└───baseNix
│   └───core
│   └───features
│   └───os
│   └───software
└───baseHome
│   └───core
│   └───features
│   └───os
│   └───software
└───desktop
│   └───home
│   └───home-software
│   └───nixos
│   └───nixos-software
|   └───desktopVars.nix
└───framework
│   └───home-modules
│   └───home-software
│   └───nixos-modules
│   └───nixos-software
|   └───frameworkVars.nix
└───overlays
└───packages
```

# DIVING DEEPER

## Facilitation
The flake.nix acts as our entrypoint, which declares our inputs and hosts. Our hosts inherit the base configuration declared in base.nix, along with their own modules and software.

## Base configuration
The base configuration is split between nixos and home-manager. These each have their own subfolders, which each manage different parts of the configuration.

- Core manages basic functions you'd always want on a computer, like networking, the bootloader, etc.

- Features manages extra features on top of core that every host would want, like virtualization.

- OS manages operating-system specific features. Currently the configuration uses GNOME, so these manage dconf settings and gnome-extensions. However, moving to KDE Plasma is on the [roadmap](roadmap.md).

- Software manages configurations for specific apps, like VSCode, Firefox, etc.

## Variables
There are two types of variables: general variables, and host-specific variables. General variables are host-independent, such as the directory of the nixos configuration. Host-specific variables are set based on the host, like the hostname and email.

Files can request a value from hostVars without knowing which host is being used. For example, files in the base configuration can use values set in hostVars.

# HOW DO I USE THIS?

Well, you could install NixOS and clone the repo into your /etc/nixos directory. But I wouldn't recommend it, since most of the configuration is specific to my taste, which probably won't match yours. HOWEVER, I do think my configuration is pretty well organized, and a lot more readable than a lot of Nix code out there, which makes it appropriate for beginners. Because of this, I'd recommend fiddling around with it in a VM and seeing what parts of it you might want to adapt to your own tastes. 