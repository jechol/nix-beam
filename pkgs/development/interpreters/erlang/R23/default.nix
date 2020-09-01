{ lib, wxGTK30, beamLib, util, mainOnly ? false }:

let

  buildOpts = {
    wxGTK = wxGTK30;
    # Can be enabled since the bug has been fixed in https://github.com/erlang/otp/pull/2508
    parallelBuild = true;
  };

  featureOpts = {
    odbc = { odbcSupport = true; };
    javac = { javacSupport = true; };
    nox = { wxSupport = false; };
  };

  makeVariants = release:
    let
      basePkg = beamLib.callErlang release buildOpts;
      featureStringToFlags = util.featureCombination featureOpts "_";
      makePkg = featureString: featureFlag:
        let
          # pkgPath = util.makePkgPath "erlang" release.version featureString;
          # pkgName = util.makePkgName "erlang" release.version featureString;
          pkgPath = util.makePkgPath "erlang" basePkg.version featureString;
          pkgName = util.makePkgName "erlang" basePkg.version featureString;

          featurePkg = basePkg.override featureFlag;
          namedPkg = featurePkg.overrideAttrs (o: { name = pkgName; });
        in {
          name = pkgPath;
          value = namedPkg;
        };

    in lib.attrsets.mapAttrs' makePkg featureStringToFlags;

  releases = [ ./R23.nix ];
  nestedVariants = map makeVariants releases;
  flatVariants = builtins.foldl' (acc: attrs: acc // attrs) { } nestedVariants;

in flatVariants
