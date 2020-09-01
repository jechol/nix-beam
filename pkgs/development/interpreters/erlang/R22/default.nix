{ lib, wxGTK30, beamLib, util, deriveErlangFeatureVariants, mainOnly ? false }:

let
  buildOpts = {
    wxGTK = wxGTK30;
    # Can be enabled since the bug has been fixed in https://github.com/erlang/otp/pull/2508
    parallelBuild = true;
  };

  featureOpts = if mainOnly then
    { }
  else {
    odbc = { odbcSupport = true; };
    javac = { javacSupport = true; };
    nox = { wxSupport = false; };
  };

  releases = if mainOnly then [ ./R22.0.nix ] else [ ./R22.0.nix ./R22.3.nix ];

  variantsPerReleases =
    map (r: deriveErlangFeatureVariants r buildOpts featureOpts) releases;

in builtins.foldl' (acc: attrs: acc // attrs) { } variantsPerReleases
