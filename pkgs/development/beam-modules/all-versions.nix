{ callPackage, stdenv, pkgs, erlang, util }:

let
  lib = pkgs.callPackage ./lib.nix { };

  packages = self:
    let
      callPackageWithSelf = stdenv.lib.callPackageWith (pkgs // self);
      annotateErlangInVersion = drv:
        drv.overrideAttrs (o:
          let drvName = if o ? name then o.name else "${o.pname}-${o.version}";
          in { name = "${drvName}_${erlang.name}"; });

      callAndAnnotate = drv: args:
        annotateErlangInVersion (callPackageWithSelf drv args);
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

      elixirs = callPackageWithSelf ../interpreters/elixir/all-versions.nix {
        inherit rebar erlang util annotateErlangInVersion;
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
      hex = callAndAnnotate ./hex { };
      webdriver = annotateErlangInVersion
        ((callPackageWithSelf ./webdriver { }).overrideAttrs
          (o: { name = "${o.name}-${o.version}"; }));
      relxExe = callAndAnnotate ../tools/erlang/relx-exe { };

      # An example of Erlang/C++ package.
      cuter = callAndAnnotate ../tools/erlang/cuter { };
    };
in stdenv.lib.makeExtensible packages
