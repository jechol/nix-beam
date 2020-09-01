{ callPackage, rebar, erlang, debugInfo, annotateErlangInVersion, util
, mainOnly ? false }:

let
  beamLib = callPackage ../../beam-modules/lib.nix { };

  # majorVersions = [ ./1.10 ./1.9 ./1.8 ./1.7 ./1.6 ];
  majorVersions = [ ./1.10 ];

  releasesPerMajorVersion = map (r:
    callPackage r {
      inherit erlang debugInfo beamLib util annotateErlangInVersion mainOnly;
    }) majorVersions;

in util.mergeListOfAttrs releasesPerMajorVersion
