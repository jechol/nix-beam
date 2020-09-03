{ stdenv, fetchFromGitHub, fetchHex, erlang, tree }:

let
  version = "3.14.0";

  erlware_commons = fetchHex {
    pkg = "erlware_commons";
    version = "1.3.1";
    sha256 = "7aada93f368d0a0430122e39931b7fb4ac9e94dbf043cdc980ad4330fd9cd166";
  };
  ssl_verify_fun = fetchHex {
    pkg = "ssl_verify_fun";
    version = "1.1.6";
    sha256 = "bdb0d2471f453c88ff3908e7686f86f9be327d065cc1ec16fa4540197ea04680";
  };
  certifi = fetchHex {
    pkg = "certifi";
    version = "2.5.2";
    sha256 = "3b3b5f36493004ac3455966991eaf6e768ce9884693d9968055aeeeb1e575040";
  };
  providers = fetchHex {
    pkg = "providers";
    version = "1.8.1";
    sha256 = "e45745ade9c476a9a469ea0840e418ab19360dc44f01a233304e118a44486ba0";
  };
  getopt = fetchHex {
    pkg = "getopt";
    version = "1.0.1";
    sha256 = "53e1ab83b9ceb65c9672d3e7a35b8092e9bdc9b3ee80721471a161c10c59959c";
  };
  bbmustache = fetchHex {
    pkg = "bbmustache";
    version = "1.10.0";
    sha256 = "43effa3fd4bb9523157af5a9e2276c493495b8459fc8737144aa186cb13ce2ee";
  };
  relx = fetchHex {
    pkg = "relx";
    version = "4.0.0";
    sha256 = "6c398119b8912ed5a579fdbf11426b8ee06e95adb8830cbc9672de816880f579";
  };
  cf = fetchHex {
    pkg = "cf";
    version = "0.3.1";
    sha256 = "315e8d447d3a4b02bcdbfa397ad03bbb988a6e0aa6f44d3add0f4e3c3bf97672";
  };
  cth_readable = fetchHex {
    pkg = "cth_readable";
    version = "1.4.8";
    sha256 = "46c3bb14df581dc7a9dc0cb9e8c755bff596665fb9a23148dd76e3a200804e90";
  };
  eunit_formatters = fetchHex {
    pkg = "eunit_formatters";
    version = "0.5.0";
    sha256 = "d6c8ba213424944e6e05bbc097c32001cdd0abe3925d02454f229b20d68763c9";
  };
  parse_trans = fetchHex {
    pkg = "parse_trans";
    version = "3.3.0";
    sha256 = "17ef63abde837ad30680ea7f857dd9e7ced9476cdd7b0394432af4bfc241b960";
  };

in stdenv.mkDerivation rec {
  pname = "rebar3";
  inherit version erlang;

  src = fetchFromGitHub {
    owner = "erlang";
    repo = pname;
    rev = version;
    sha256 = "11bh4vs70lbl2m3iz9g631h4qywb9q0wg938bv9gl4c7l8ldf840";
  };

  bootstrapper = ./rebar3-nix-bootstrap;

  buildInputs = [ erlang tree ];

  postPatch = ''
    mkdir -p _checkouts
    mkdir -p _build/default/lib/

    cp --no-preserve=mode -R ${erlware_commons} _build/default/lib/erlware_commons
    cp --no-preserve=mode -R ${providers} _build/default/lib/providers
    cp --no-preserve=mode -R ${getopt} _build/default/lib/getopt
    cp --no-preserve=mode -R ${bbmustache} _build/default/lib/bbmustache
    cp --no-preserve=mode -R ${certifi} _build/default/lib/certifi
    cp --no-preserve=mode -R ${cf} _build/default/lib/cf
    cp --no-preserve=mode -R ${cth_readable} _build/default/lib/cth_readable
    cp --no-preserve=mode -R ${eunit_formatters} _build/default/lib/eunit_formatters
    cp --no-preserve=mode -R ${relx} _build/default/lib/relx
    cp --no-preserve=mode -R ${ssl_verify_fun} _build/default/lib/ssl_verify_fun
    cp --no-preserve=mode -R ${parse_trans} _build/default/lib/parse_trans
  '';

  buildPhase = ''
    HOME=. escript bootstrap
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp rebar3 $out/bin/rebar3
  '';

  meta = {
    homepage = "https://github.com/rebar/rebar3";
    description =
      "Erlang build tool that makes it easy to compile and test Erlang applications, port drivers and releases";

    longDescription = ''
      rebar is a self-contained Erlang script, so it's easy to distribute or
      even embed directly in a project. Where possible, rebar uses standard
      Erlang/OTP conventions for project structures, thus minimizing the amount
      of build configuration work. rebar also provides dependency management,
      enabling application writers to easily re-use common libraries from a
      variety of locations (hex.pm, git, hg, and so on).
    '';

    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ gleber tazjin ];
    license = stdenv.lib.licenses.asl20;
  };
}
