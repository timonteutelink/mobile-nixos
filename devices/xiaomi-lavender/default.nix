{ config, lib, pkgs, ... }:

let
  deviceCfg = config.mobile.device;
in
{
  imports = [
    ../families/sdm660-mainline
  ];

  mobile.device.name = "xiaomi-lavender";
  mobile.device.identity = {
    name = "Xiaomi Redmi Note 7";
    manufacturer = "Xiaomi";
  };
  mobile.device.supportLevel = "best-effort";

  mobile.hardware = {
    ram = 1024 * 4;
    screen = {
      width = 1080;
      height = 2340;
    };
  };

  mobile.system.android.device_name = "lavender";
  mobile.system.android.appendDTB = lib.mkAfter [
    "dtbs/qcom/sdm660-xiaomi-lavender-boe.dtb"
    "dtbs/qcom/sdm660-xiaomi-lavender-shenchao.dtb"
    "dtbs/qcom/sdm660-xiaomi-lavender-tianma.dtb"
  ];
  mobile.system.android.flashingMethod = lib.mkDefault "fastboot";

  mobile.boot.stage-1.kernel.modules = lib.mkAfter [
    "msm"
    "panel-boe-td4320"
    "panel-novatek-nt36672a"
    "novatek_nvt_ts"
    "qcom_q6v5_mss"
    "qcom_q6v5_wcss"
    "qrtr"
    "qrtr_smd"
    "ipa"
    "rmnet"
    "ath10k_snoc"
    "qcom_geni_serial"
    "i2c_qcom_geni"
    "spi_qcom_geni"
    "phy_qcom_qmp"
    "phy_qcom_qusb2"
  ];

  mobile.device.firmware = pkgs.callPackage ./firmware (
    lib.optionalAttrs (deviceCfg.firmwareRoot != null) {
      firmwareRoot = deviceCfg.firmwareRoot;
    }
  );
  mobile.device.enableFirmware = lib.mkDefault false;

  services.udev.extraRules = lib.mkAfter "\n${lib.readFile ./udev.rules}";
  services.iio-sensor-proxy.enable = lib.mkDefault true;
}
