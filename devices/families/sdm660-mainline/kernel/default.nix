{ mobile-nixos
, fetchFromGitHub
, ...
}:

let
  rev = "v6.17.4-sdm660";
  sha256 = "sha256-UzZbsQLXASZrp/UGEyE7oQTvVldB85AoT0b+stw1A+Y=";
in
mobile-nixos.kernel-builder {
  version = "6.17.4";
  configfile = ./config.aarch64;

  src = fetchFromGitHub {
    owner = "sdm660-mainline";
    repo = "linux";
    inherit rev sha256;
  };

  isModular = true;
  isCompressed = "gz";
}
