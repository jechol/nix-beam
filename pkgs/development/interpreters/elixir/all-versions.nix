{ stdenv, pkgs, rebar, erlang, callElixir, debugInfo }:

callElixir ./1.10.nix { inherit rebar erlang debugInfo; }
