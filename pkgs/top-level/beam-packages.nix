{ pkgs, callPackage, wxGTK30, openssl_1_0_2, lib, util }:

with lib;
with attrsets;
let
  erlangs = (callPackage ../development/interpreters/erlang/all-versions.nix {
    inherit util;
    mainOnly = false;
  });

  main_erlangs =
    lib.attrsets.recurseIntoAttrs (erlangs.override { mainOnly = true; });

  packages = (mapAttrs (_: erlang:
    lib.attrsets.recurseIntoAttrs
    (callPackage ../development/beam-modules/all-versions.nix {
      inherit erlang util;
      mainOnly = false;
    })) (util.filterDerivations erlangs));

  main_packages = lib.attrsets.recurseIntoAttrs (mapAttrs (_: erlang:
    lib.attrsets.recurseIntoAttrs
    (callPackage ../development/beam-modules/all-versions.nix {
      inherit erlang util;
      mainOnly = true;
    })) (util.filterDerivations main_erlangs));

in lib.attrsets.recurseIntoAttrs {
  all = lib.attrsets.recurseIntoAttrs { inherit erlangs packages; };
  main = lib.attrsets.recurseIntoAttrs {
    erlangs = main_erlangs;
    packages = main_packages;
  };
}
