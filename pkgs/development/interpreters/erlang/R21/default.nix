{ lib, openssl_1_0_2, wxGTK30, beamLib, util, deriveErlangFeatureVariants
, mainOnly ? false }:

let
  releases =
    if mainOnly then [ ./R21.0.nix ] else [ ./R21.0.nix ./R21.3.8.3.nix ];

  buildOpts = { wxGTK = wxGTK30; };

  featureOpts = if mainOnly then
    { }
  else {
    odbc = { odbcSupport = true; };
    javac = { javacSupport = true; };
    nox = { wxSupport = false; };
  };

  variantsPerReleases =
    map (r: deriveErlangFeatureVariants r buildOpts featureOpts) releases;

in util.mergeListOfAttrs variantsPerReleases
