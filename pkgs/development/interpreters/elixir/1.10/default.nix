{ stdenv, pkgs, rebar, erlang, beamLib, debugInfo, annotateErlangInVersion, util
, mainOnly ? false }:

let
  releases = [ ./1.10.nix ];

  pkgs =
    map (r: beamLib.callElixir r { inherit rebar erlang debugInfo; }) releases;

  pairs = map (pkg: {
    name = util.snakeVersion pkg.name;
    value = annotateErlangInVersion pkg;
  }) pkgs;

in (builtins.listToAttrs pairs)
