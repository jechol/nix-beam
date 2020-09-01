{ beamLib, erlang, buildRebar3, buildHex, annotateErlangInVersion, util
, mainOnly ? false }:

let
  releases = if mainOnly then [ ./1.3.nix ] else [ ./1.2.nix ./1.3.nix ];
  pkgs = map (r: beamLib.callLFE r { inherit erlang buildRebar3 buildHex; })
    releases;

  pairs = map (pkg: {
    name = util.snakeVersion pkg.name;
    value = annotateErlangInVersion pkg;
  }) pkgs;

in (builtins.listToAttrs pairs)
