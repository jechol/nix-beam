{ pkgs, callPackage, wxGTK30, openssl_1_0_2, lib }:

with lib;
attrsets.recurseIntoAttrs rec {
  util = callPackage ../util.nix { };
  erlangs = util.filterDerivations
    (callPackage ../development/interpreters/erlang/all-versions.nix { });
  packages = attrsets.recurseIntoAttrs (attrsets.mapAttrs (_: erlang:
    attrsets.recurseIntoAttrs
    (callPackage ../development/beam-modules/all-versions.nix {
      inherit erlang util;
    })) erlangs);
}
