{ pkgs, fetchpatch, callPackage, wxGTK30, openssl_1_0_2, lib, util
, mainOnly ? false }:

let
  beamLib = callPackage ../../beam-modules/lib.nix { };

  overrideFeature = basePkg: featureString: featureFlag:
    let
      pkgPath = util.makePkgPath "erlang" basePkg.version featureString;
      pkgName = util.makePkgName "erlang" basePkg.version featureString;

      featurePkg = basePkg.override featureFlag;
      namedPkg = featurePkg.overrideAttrs (o: { name = pkgName; });
    in {
      name = pkgPath;
      value = namedPkg;
    };

  deriveErlangFeatureVariants = release: buildOpts: featureOpts:
    let
      basePkg = beamLib.callErlang release buildOpts;
      featureStringToFlags = util.featureCombination featureOpts "_";
    in lib.attrsets.mapAttrs' (overrideFeature basePkg) featureStringToFlags;
in rec {
  # let
  # releases = [ (callPackage ./R23/default.nix { inherit beamLib util; }) ];

  # releaseAttrs = builtins.foldl' (acc: release: acc // release) { } releases;

  r23 = callPackage ./R23 {
    inherit beamLib util mainOnly deriveErlangFeatureVariants;
  };

  # in releaseAttrs

}
