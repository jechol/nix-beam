[![Linux](https://github.com/jechol/nur-packages/workflows/Linux/badge.svg)](https://github.com/jechol/nur-packages/actions?query=workflow%3A%22Linux%22)
[![macOS](https://github.com/jechol/nur-packages/workflows/macOS/badge.svg)](https://github.com/jechol/nur-packages/actions?query=workflow%3A%22macOS%22)
[![Cachix Cache](https://img.shields.io/badge/cachix-jechol-blue.svg)](https://jechol.cachix.org)

# Nix Packages for Erlang, Elixir, LFE

## Installation

### Nix

You must have installed `nix`. See [NixOS install](https://nixos.org/manual/nix/stable/#chap-installation) for more information.

### Cachix (optional)

Save compile time with binary caches:

```console
$ nix-env -iA cachix -f https://cachix.org/api/v1/install
$ cachix use jechol
```

### Configuration

Include NUR(Nix User Repository) to `~/.config/nixpkgs/config.nix`:

```nix
{
  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };
}
```

## How to use

Then packages can be used or installed from the NUR namespace.

```console
$ nix-env -f '<nixpkgs>' -iA nur.repos.jechol.beam.main.erlangs.erlang_23_0
$ erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().'  -noshell
"23"

$ nix-env -f '<nixpkgs>' -iA nur.repos.jechol.beam.main.packages.erlang_22_0.elixirs.elixir_1_10_0
$ elixir --version
Erlang/OTP 22 [erts-10.4] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe]

Elixir 1.10.0 (compiled with Erlang/OTP 22)
```

`beam.main` includes only combinations of major versions of Erlang/Elixir.

On the other hands, `beam.all` includes every combinations and other tools. For example,

- `beam.all.erlangs.erlang_22_3_javac_odbc` : Erlang 22.3 with support for Java and ODBC
- `beam.all.packages.erlang_22_3.elixirs.elixir_1_10_4` : Elixir 1.10.4 running on Erlang 22.3
