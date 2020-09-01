{ pkgs, fetchpatch, callPackage, wxGTK30, openssl_1_0_2, lib, util
, mainOnly ? false }:

rec {
  # let
  beamLib = callPackage ../../beam-modules/lib.nix { };
  # releases = [ (callPackage ./R23/default.nix { inherit beamLib util; }) ];

  # releaseAttrs = builtins.foldl' (acc: release: acc // release) { } releases;

  r23 = callPackage ./R23 { inherit beamLib util mainOnly; };

  # in releaseAttrs

}
