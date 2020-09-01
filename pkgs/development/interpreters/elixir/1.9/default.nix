{ deriveElixirs, mainOnly ? false }:

let
  releases = if mainOnly then [ ./1.9.0.nix ] else [ ./1.9.0.nix ./1.9.4.nix ];

in deriveElixirs releases
