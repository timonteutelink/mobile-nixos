{ config, lib, pkgs, ... }:

{
  imports = [
    ./sound.nix
  ];

  mobile.hardware = {
    soc = "qualcomm-sdm660";
  };

  mobile.boot.stage-1 = {
    compression = lib.mkDefault "xz";
    kernel.package = pkgs.callPackage ./kernel { };
  };

  hardware.enableRedistributableFirmware = true;

  mobile.boot.stage-1.firmware =
    lib.optional config.mobile.device.enableFirmware
      (pkgs.runCommand "initrd-firmware" {} ''
        cp -vrf ${config.mobile.device.firmware} $out
        chmod -R +w $out
        rm -vf $out/lib/firmware/qcom/sdm660/*/modem*.mbn || true
      '');

  mobile.system.type = "android";
  mobile.system.android = {
    ab_partitions = lib.mkDefault true;
    bootimg.flash = {
      # Matches the offsets used by postmarketOS for lavender and other SDM660 handsets.
      offset_base = "0x00000000";
      offset_kernel = "0x00008000";
      offset_ramdisk = "0x01000000";
      offset_second = "0x00f00000";
      offset_tags = "0x00000100";
      pagesize = "4096";
    };
    appendDTB = lib.mkDefault [];
  };

  mobile.usb.mode = "gadgetfs";
  mobile.usb.idVendor = lib.mkDefault "18D1";
  mobile.usb.idProduct = lib.mkDefault "D001";
  mobile.usb.gadgetfs.functions = {
    adb = "ffs.adb";
    rndis = "rndis.usb0";
  };
}
