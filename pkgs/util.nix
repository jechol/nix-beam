rec {
  combination = x:
    if x == [ ] then
      [ [ ] ]
    else
      let
        h = builtins.head x;
        t = builtins.tail x;
        off_comb = combination t;
        on_comb = builtins.map (c: [ h ] ++ c) off_comb;
      in off_comb ++ on_comb;

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
      in builtins.listToAttrs (builtins.trace nameToList nameToList);
    in combs_attrs;

  attrsToList = attrs:
    let names = builtins.attrNames attrs;
    in builtins.map (name: {
      name = name;
      value = builtins.getAttr name attrs;
    }) names;

  snake_version = version:
    builtins.replaceStrings [ "." "-" ] [ "_" "_" ] version;

  make_feature_string = features: sep:
    if features == "" then "" else "${sep}${builtins.replaceStrings ["_"] [sep] features}";

  make_pkg_path = name: version: features:
    "${name}_${snake_version version}${make_feature_string features "_"}";

  make_pkg_name = name: version: features:
    "${name}-${version}${make_feature_string features "-"}";
}
