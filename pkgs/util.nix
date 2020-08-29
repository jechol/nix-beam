rec {
  comb = x:
    if x == [ ] then
      [ [ ] ]
    else
      let
        h = builtins.head x;
        t = builtins.tail x;
        off_comb = comb t;
        on_comb = builtins.map (c: [ h ] ++ c) off_comb;
      in off_comb ++ on_comb;

  optionComb = attrs:
    let
      names = builtins.attrNames attrs;
      nameCombs = comb names;
      mergeValues =
        (names: builtins.foldl' (s: name: s // attrs.${name}) { } names);
      combs_attrs = let
        nameToList = builtins.map (names: {
          name = (builtins.concatStringsSep "" names);
          value = mergeValues names;
        }) nameCombs;
      in builtins.listToAttrs (builtins.trace nameToList nameToList);
    in combs_attrs;

  attrsToList = attrs:
    let names = builtins.attrNames attrs;
    in builtins.map (name: {
      name = name;
      value = builtins.getAttr name attrs;
    }) names;
}
