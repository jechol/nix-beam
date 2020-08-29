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
}
