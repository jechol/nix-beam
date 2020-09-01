{ stdenv, pkgs, rebar, erlang, beamLib, debugInfo, annotateErlangInVersion, util
, mainOnly ? false }:

let
  releases =
    if mainOnly then [ ./1.10.0.nix ] else [ ./1.10.0.nix ./1.10.4.nix ];

  pkgs =
    map (r: beamLib.callElixir r { inherit rebar erlang debugInfo; }) releases;

  pairs = map (pkg: {
    name = util.snakeVersion pkg.name;
    value = annotateErlangInVersion pkg;
  }) pkgs;

in (builtins.listToAttrs pairs)
