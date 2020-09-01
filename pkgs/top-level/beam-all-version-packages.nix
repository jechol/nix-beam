{ pkgs, callPackage, wxGTK30, openssl_1_0_2, lib, util }:

with lib;
let
  erlangs = (callPackage ../development/interpreters/erlang/all-versions.nix {
    inherit util;
  });
in attrsets.recurseIntoAttrs rec {
  all = { } // erlangs;

  main = { } // erlangs.override { mainOnly = true; };
  # packages = attrsets.recurseIntoAttrs (attrsets.mapAttrs (_: erlang:
  #   attrsets.recurseIntoAttrs
  #   (callPackage ../development/beam-modules/all-versions.nix {
  #     inherit erlang util;
  #   })) erlangs);
}
