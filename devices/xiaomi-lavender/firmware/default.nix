{ lib
, stdenvNoCC
, pkgs
, firmwareRoot ? ""
}:

stdenvNoCC.mkDerivation {
  pname = "firmware-xiaomi-lavender";
  version = "1";

  dontUnpack = true;
  installPhase = ''
    if [ -z "${firmwareRoot}" ]; then
      cat >&2 <<'MSG'
Provide the proprietary lavender firmware by setting
  mobile.device.firmwareRoot = /absolute/path;
or overriding
  config.mobile.device.firmware.override { firmwareRoot = /absolute/path; }
MSG
      exit 1
    fi

    mkdir -p $out/lib/firmware

    # 1) Copy only your proprietary blobs from firmwareRoot
    if [ -d "${firmwareRoot}/lib/firmware" ]; then
      cp -a "${firmwareRoot}/lib/firmware/." $out/lib/firmware/
    else
      cp -a "${firmwareRoot}/." $out/lib/firmware/
    fi

    chmod -R u+w $out/lib/firmware

    # 2) Provide ath10k WCN3990 from linux-firmware (redistributable)
    mkdir -p $out/lib/firmware/ath10k
    cp -a ${pkgs.linux-firmware}/lib/firmware/ath10k/WCN3990 $out/lib/firmware/ath10k/
  '';

  postInstall = ''
    fwroot="$out/lib/firmware"
    need() {
      if [ ! -f "$fwroot/$1" ]; then
        echo "Missing firmware: $1" >&2
        exit 1
      fi
    }
    need "ath10k/WCN3990/hw1.0/firmware-5.bin"
    need "ath10k/WCN3990/hw1.0/board-2.bin"
    need "qcom/wlanmdsp.mbn"
    need "qcom/ipa_fws.mbn"

    if ! ls "$fwroot"/qca/*.tlv "$fwroot"/qca/*.bin "$fwroot"/qcom/bt/* >/dev/null 2>&1; then
      echo "Warning: Bluetooth rampatch/NVM files not found under qca/ or qcom/bt/." >&2
    fi

    if ! ls "$fwroot"/qcom/*adsp* "$fwroot"/qcom/*mba*.mbn "$fwroot"/qcom/*modem*.mbn >/dev/null 2>&1; then
      echo "Warning: ADSP/modem firmware not detected under qcom/." >&2
    fi
  '';

  meta = {
    description = "Proprietary firmware bundle for Xiaomi Redmi Note 7 (lavender)";
    # license = with lib.licenses; [ unfree ];
  };
}


#nix build --impure --expr '
#  let pkgs = import <nixpkgs> {};
#  in pkgs.callPackage ./devices/xiaomi-lavender/firmware {
#    firmwareRoot = /home/tteutelink/projects/timon/nixos-phone/data/xiaomi-redmi-note-7;
#  }
#'
