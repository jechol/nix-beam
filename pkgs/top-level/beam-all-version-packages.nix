{ pkgs, callPackage, wxGTK30, openssl_1_0_2, lib, util }:

with lib;
with attrsets;
let
  erlangs = recurseIntoAttrs
    (callPackage ../development/interpreters/erlang/all-versions.nix {
      inherit util;
    });

  main_erlangs = recurseIntoAttrs (erlangs.override { mainOnly = true; });

in recurseIntoAttrs {
  all = recurseIntoAttrs { inherit erlangs; };
  main = recurseIntoAttrs { erlangs = main_erlangs; };
  # packages = attrsets.recurseIntoAttrs (attrsets.mapAttrs (_: erlang:
  #   attrsets.recurseIntoAttrs
  #   (callPackage ../development/beam-modules/all-versions.nix {
  #     inherit erlang util;
  #   })) erlangs);
}
