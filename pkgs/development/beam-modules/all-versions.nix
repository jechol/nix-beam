{ callPackage, stdenv, pkgs, erlang, util }:

let
  lib = pkgs.callPackage ./lib.nix { };

  packages = self:
    let
      callPackageWithBeam = stdenv.lib.callPackageWith (pkgs // self);
      # callPackageWithBeam = drv: args:
      #   (callPackageWithBeam drv args).overrideAttrs
      #   (o: { name = "${o.pname}-${o.version}-${erlang.name}"; });
      # callPackage = drv: args: (specifyErlang (callPackage drv args));
      # # callPackage = callPackage;
      specifyErlang = drv:
        drv.overrideDerivation (o: { name = "${o.name}-${erlang.name}"; });
      # (old: if old ? name then 
      # else { name = "${old.pname}-${old.version}-${erlang.name}"; });

      callAndSpecifyErlang = drv: args:
        specifyErlang (callPackageWithBeam drv args);
    in rec {
      # inherit callPackage erlang;

      # beamPackages = self;

      # Functions
      fetchHex = callPackageWithBeam ./fetch-hex.nix { };
      fetchRebar3Deps = callPackageWithBeam ./fetch-rebar-deps.nix { };
      rebar3Relx = callPackageWithBeam ./rebar3-release.nix { };

      buildRebar3 = callPackageWithBeam ./build-rebar3.nix { };
      buildHex = callPackageWithBeam ./build-hex.nix { };
      buildErlangMk = callPackageWithBeam ./build-erlang-mk.nix { };
      buildMix = callPackageWithBeam ./build-mix.nix { };

      # Derivations
      rebar = callAndSpecifyErlang ../tools/build-managers/rebar { };
      rebar3 = callAndSpecifyErlang ../tools/build-managers/rebar3 { };
      # rebar3 port compiler plugin is required by buildRebar3
      pc = callAndSpecifyErlang ./pc { };

      elixirs = callAndSpecifyErlang ../interpreters/elixir/all-versions.nix {
        inherit rebar erlang util;
        debugInfo = true;
      };

      # Remove old versions of elixir, when the supports fades out:
      # https://hexdocs.pm/elixir/compatibility-and-deprecations.html

      # lfe = lfe_1_3;
      # lfe_1_2 = lib.callLFE ../interpreters/lfe/1.2.nix {
      #   inherit erlang buildRebar3 buildHex;
      # };
      # lfe_1_3 = lib.callLFE ../interpreters/lfe/1.3.nix {
      #   inherit erlang buildRebar3 buildHex;
      # };

      # Non hex packages. Examples how to build Rebar/Mix packages with and
      # without helper functions buildRebar3 and buildMix.
      hex = callPackageWithBeam ./hex { };
      webdriver = callPackageWithBeam ./webdriver { };
      relxExe = callPackageWithBeam ../tools/erlang/relx-exe { };

      # An example of Erlang/C++ package.
      cuter = callPackageWithBeam ../tools/erlang/cuter { };
    };
in stdenv.lib.makeExtensible packages
