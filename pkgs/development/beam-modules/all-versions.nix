{ callPackage, stdenv, pkgs, erlang, lib, util, mainOnly }:

with lib.attrsets;
let
  beamLib = callPackage ./lib.nix { };

  packages = self:
    let
      callPackageWithSelf = lib.callPackageWith (pkgs // self);

      annotateDep = drv: dep:
        drv.overrideAttrs (o:
          let drvName = if o ? name then o.name else "${o.pname}-${o.version}";
          in { name = "${drvName}_${dep.name}"; });
      annotateErlangInVersion = drv: annotateDep drv erlang;

      callAndAnnotate = drv: args:
        annotateErlangInVersion (callPackageWithSelf drv args);
      callAndAnnotateElixir = drv:
        { elixir }@args:
        annotateDep (callPackageWithSelf drv args) elixir;

    in rec {
      # Functions
      fetchHex = callPackageWithSelf ./fetch-hex.nix { };
      fetchRebar3Deps = callPackageWithSelf ./fetch-rebar-deps.nix { };
      rebar3Relx = callPackageWithSelf ./rebar3-release.nix { };

      buildRebar3 = callPackageWithSelf ./build-rebar3.nix { };
      buildHex = callPackageWithSelf ./build-hex.nix { };
      buildErlangMk = callPackageWithSelf ./build-erlang-mk.nix { };
      buildMix = callPackageWithSelf ./build-mix.nix { };

      # Derivations
      rebar = callAndAnnotate ../tools/build-managers/rebar { };
      rebar3 = callAndAnnotate ../tools/build-managers/rebar3 { };
      # rebar3 port compiler plugin is required by buildRebar3
      pc = callAndAnnotate ./pc { };

      elixirs = util.recurseIntoAttrs
        (callPackageWithSelf ../interpreters/elixir/all-versions.nix {
          inherit util annotateErlangInVersion mainOnly;
          inherit rebar erlang;
          debugInfo = true;
        });

      lfes = util.recurseIntoAttrs
        (callPackageWithSelf ../interpreters/lfe/all-versions.nix {
          inherit util beamLib annotateErlangInVersion mainOnly;
          inherit erlang buildRebar3 buildHex;
        });

      # Non hex packages. Examples how to build Rebar/Mix packages with and
      # without helper functions buildRebar3 and buildMix.
      # hex = callAndAnnotate ./hex { };
      hexes = util.recurseIntoAttrs (mapAttrs (_: elixir:
        (annotateDep (callPackageWithSelf ./hex { inherit elixir; }) elixir))
        (util.filterDerivations elixirs));
      webdriver = annotateDep
        ((callPackageWithSelf ./webdriver { }).overrideAttrs
          (o: { name = "${o.name}-${o.version}"; })) erlang;
      relxExe = callAndAnnotate ../tools/erlang/relx-exe { };

      # An example of Erlang/C++ package.
      cuter = callAndAnnotate ../tools/erlang/cuter { };
    };

  allPackages = lib.makeExtensible packages;
  mainPackages = (with allPackages; { inherit rebar rebar3 hexes elixirs; });

in if mainOnly then mainPackages else allPackages
