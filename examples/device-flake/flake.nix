{
  description = "Mobile NixOS personal flake example";

  inputs = {
    mobile-nixos = {
      url = "github:mobile-nixos/mobile-nixos";
      flake = false;
    };
  };

  outputs = { self, mobile-nixos, ... }:
    let
      evalWithConfiguration = import (mobile-nixos + "/lib/eval-with-configuration.nix");
      target = {
        system = "aarch64-linux";
        device = mobile-nixos + "/devices/xiaomi-lavender";
        configuration = [
          { _module.args.mobile-nixos = mobile-nixos; }
          ./configuration.nix
        ];
      };
      eval = evalWithConfiguration target;
    in {
      packages.${target.system} = {
        default = eval.outputs.default;
        fastboot-images = eval.outputs.android.android-fastboot-images;
        bootimg = eval.outputs.android.bootimg;
      };

      templates.default = {
        path = ./.;
        description = self.description;
      };
    };
}
