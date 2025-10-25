{ mobile-nixos
, fetchFromGitHub
, ...
}:

let
  rev = "v6.17.4-sdm660";
  sha256 = "sha256-yRoAMA17fLNU5sQQg2tOhdjj+nu8FmmsoyaGZJq4yjY=";
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
