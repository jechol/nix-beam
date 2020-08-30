{ pkgs, callPackage, wxGTK30, openssl_1_0_2, lib }:

with lib; rec {
  # lib = callPackage ../development/beam-modules/lib.nix { };
  util = callPackage ../util.nix { };

  lib = callPackage ../development/beam-modules/lib.nix { };

  erlangs = util.filterDerivations
    (callPackage ../development/interpreters/erlang/all-versions.nix { });

  elixirs = { };
  lfes = { };

  interpreters2 = erlangs // elixirs // lfes;

  # Each
  interpreters = rec {

    # Other Beam languages. These are built with `beam.interpreters.erlang`. To
    # access for example elixir built with different version of Erlang, use
    # `beam.packages.erlangR22.elixir`.
    inherit (packages.erlang)
      elixir elixir_1_10 elixir_1_9 elixir_1_8 elixir_1_7 elixir_1_6;

    inherit (packages.erlang) lfe lfe_1_2 lfe_1_3;
  };

  packagesWith = erlang:
    callPackage ../development/beam-modules/all-versions.nix {
      inherit erlang util;
    };

  packages = attrsets.mapAttrs (k: v: packagesWith v) interpreters2;
}
