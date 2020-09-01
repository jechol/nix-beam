{ pkgs, callPackage, wxGTK30, openssl_1_0_2, lib, util }:

with lib;
attrsets.recurseIntoAttrs rec {
  erlangs = (callPackage ../development/interpreters/erlang/all-versions.nix {
    inherit util;
  });
  # erlangs = util.filterDerivations
  #   (callPackage ../development/interpreters/erlang/all-versions.nix {
  #     inherit util;
  #   });
  # packages = attrsets.recurseIntoAttrs (attrsets.mapAttrs (_: erlang:
  #   attrsets.recurseIntoAttrs
  #   (callPackage ../development/beam-modules/all-versions.nix {
  #     inherit erlang util;
  #   })) erlangs);
}
