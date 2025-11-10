{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      sdm845-alsa-ucm = self.callPackage (
        { runCommand, fetchFromGitLab }: let
          src = fetchFromGitLab {
            name = "sdm845-alsa-ucm";
            owner = "sdm845-mainline";
            repo = "alsa-ucm-conf";
            rev = "de81252f28465fb76e2aa58eb9733b88de2076ea";
            sha256 = "sha256-bzkAF5qK7pE9ZMrjBYtzbWIhHgOTBic9zSDydaLFNsg=";
          };
        in runCommand "sdm845-alsa-ucm" { } ''
          mkdir -p $out/share/
          ln -s ${src} $out/share/alsa
        ''
      ) {};
    })
  ];

  # Alsa UCM profiles
  mobile.quirks.audio.alsa-ucm-meld = true;
  environment.systemPackages = [
    pkgs.sdm845-alsa-ucm
  ];
}
