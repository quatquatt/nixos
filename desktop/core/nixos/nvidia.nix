{
  config,
  ...
}:

{


  hardware.opengl =
  {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia =
  {
    modesetting.enable = true;

    powerManagement.enable = false;

    powerManagement.finegrained = false;

    open = false;
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  services.xserver.videoDrivers = ["nvidia"];
}
