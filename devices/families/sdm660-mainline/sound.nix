{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      sdm660-alsa-ucm = self.callPackage (
        { runCommand, fetchFromGitHub }:
        runCommand "sdm660-alsa-ucm" {
          src = fetchFromGitHub {
            name = "sdm660-alsa-ucm";
            owner = "sdm660-mainline";
            repo = "alsa-ucm-conf";
            rev = "75c52fd064005c8bae3bec4fed22fa3638e7f63a";
            sha256 = "sha256-zPihFcwcatsjGsFZS5b4bzqvsQPq4ilwgRuVHvzZpQw=";
          };
        } ''
          mkdir -p $out/share/
          ln -s $src $out/share/alsa
        ''
      ) {};
    })
  ];

  mobile.quirks.audio.alsa-ucm-meld = true;
  environment.systemPackages = [
    pkgs.sdm660-alsa-ucm
  ];
}
