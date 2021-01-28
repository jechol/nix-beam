{ util, deriveElixirs }:

let
  # releases = util.findByPrefix ./. (baseNameOf ./.);
  releases = [ ./1.11.0.nix ./1.11.1.nix ./1.11.2.nix ./1.11.3.nix ];
in deriveElixirs releases "21" "23"
