{ pkgs, fetchpatch, callPackage, wxGTK30, openssl_1_0_2, lib, util, mainOnly }:

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

  majorVersions = [ ./R23 ./R22 ./R21 ./R20 ./R19 ./R18 ./R16 ];

  releasesPerMajorVersion = map (r:
    callPackage r {
      inherit beamLib util mainOnly deriveErlangFeatureVariants;
    }) majorVersions;

in util.mergeListOfAttrs releasesPerMajorVersion
