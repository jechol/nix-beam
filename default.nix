# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> {} }:

rec {
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  # beam = pkgs.callPackage ./pkgs/top-level/beam-packages.nix { };

  # inherit (beam.interpreters)
  #   erlang erlangR23 erlangR22 erlangR21 erlangR20 erlangR19 erlangR18
  #   erlang_odbc erlang_javac erlang_odbc_javac erlang_nox erlang_basho_R16B02
  #   elixir elixir_1_10 elixir_1_9 elixir_1_8 elixir_1_7 elixir_1_6;

  # inherit (beam.packages.erlang)
  #   rebar rebar3
  #   fetchHex beamPackages
  #   relxExe;

  # inherit (beam.packages.erlangR19) cuter lfe_1_2;

  # inherit (beam.packages.erlangR21) lfe lfe_1_3;
} // (pkgs.callPackage pkgs/development/interpreters/erlang/all-versions.nix { })

