{ lib, pkgs, mobile-nixos, ... }:
{
  imports = [
    # Provides strict kernel config assertions and other shared defaults.  Remove
    # or replace this entry if you maintain your own common modules.
    (mobile-nixos + "/examples/common-configuration.nix")
  ];

  mobile.system.stateVersion = "24.05";

  mobile.users.defaultUser = "nixos";
  users.users.nixos = {
    isNormalUser = true;
    initialPassword = "nixos";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAA...replace-with-your-key"
    ];
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  services.phosh.enable = true;
  services.squeekboard.enable = true;
  services.geoclue2.enable = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  mobile.boot.stage-1.splash.enable = lib.mkDefault false;
}
