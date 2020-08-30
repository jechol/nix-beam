rec {
  combination = x:
    if x == [ ] then
      [ [ ] ]
    else
      let
        h = builtins.head x;
        t = builtins.tail x;
        offComb = combination t;
        onComb = builtins.map (c: [ h ] ++ c) offComb;
      in offComb ++ onComb;

  featureCombination = attrs: sep:
    let
      names = builtins.attrNames attrs;
      namesComb = combination names;
      mergeValueAttrs =
        (names: builtins.foldl' (s: name: s // attrs.${name}) { } names);
      combs_attrs = let
        nameToList = builtins.map (names: {
          name = (builtins.concatStringsSep sep names);
          value = mergeValueAttrs names;
        }) namesComb;
      in builtins.listToAttrs nameToList;
    in combs_attrs;

  attrsToList = attrs:
    let names = builtins.attrNames attrs;
    in builtins.map (name: {
      name = name;
      value = builtins.getAttr name attrs;
    }) names;

  snakeVersion = version:
    builtins.replaceStrings [ "." "-" ] [ "_" "_" ] version;

  makeFeatureString = features: sep:
    if features == "" then "" else "${sep}${builtins.replaceStrings ["_"] [sep] features}";

  makePkgPath = name: version: features:
    "${name}_${snakeVersion version}${makeFeatureString features "_"}";

  makePkgName = name: version: features:
    "${name}-${version}${makeFeatureString features "-"}";
}
