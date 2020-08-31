{ pkgs, fetchpatch, callPackage, wxGTK30, openssl_1_0_2, lib, util }:

let
  buildOptsR22_23 = {
    wxGTK = wxGTK30;
    # Can be enabled since the bug has been fixed in https://github.com/erlang/otp/pull/2508
    parallelBuild = true;
  };
  buildOptsR20_21 = { wxGTK = wxGTK30; };
  buildOptsR18_19 = {
    wxGTK = wxGTK30;
    openssl = openssl_1_0_2;
  };
  buildOptsR16 = { };

  featureOptsR18_23 = {
    odbc = { odbcSupport = true; };
    javac = { javacSupport = true; };
    nox = { wxSupport = false; };
  };
  featureOptsR16 = { odbc = { odbcSupport = true; }; };

  versions = [
    {
      buildOpts = buildOptsR22_23;
      featureOpts = featureOptsR18_23;
      release = {
        version = "23.0.3";
        sha256 = "133aw1ffkxdf38na3smmvn5qwwlalh4r4a51793h1wkhdzkyl6mv";

        prePatch = ''
          substituteInPlace make/configure.in --replace '`sw_vers -productVersion`' "''${MACOSX_DEPLOYMENT_TARGET:-10.12}"
          substituteInPlace erts/configure.in --replace '-Wl,-no_weak_imports' ""
        '';
      };
    }
    {
      buildOpts = buildOptsR22_23;
      featureOpts = featureOptsR18_23;
      release = {
        version = "22.3";
        sha256 = "0srbyncgnr1kp0rrviq14ia3h795b3gk0iws5ishv6rphcq1rs27";
        prePatch = ''
          substituteInPlace make/configure.in --replace '`sw_vers -productVersion`' "''${MACOSX_DEPLOYMENT_TARGET:-10.12}"
          substituteInPlace erts/configure.in --replace '-Wl,-no_weak_imports' ""
        '';
      };
    }
    {
      buildOpts = buildOptsR20_21;
      featureOpts = featureOptsR18_23;
      release = {
        version = "21.3.8.3";
        sha256 = "1szybirrcpqsl2nmlmpbkxjqnm6i7l7bma87m5cpwi0kpvlxwmcw";

        prePatch = ''
          substituteInPlace configure.in --replace '`sw_vers -productVersion`' "''${MACOSX_DEPLOYMENT_TARGET:-10.12}"
        '';
      };
    }
    {
      buildOpts = buildOptsR20_21;
      featureOpts = featureOptsR18_23;
      release = {
        version = "20.3.8.9";
        sha256 = "0v2iiyzss8hiih98wvj0gi2qzdmmhh7bvc9p025wlfm4k7r1109a";

        prePatch = ''
          substituteInPlace configure.in --replace '`sw_vers -productVersion`' "''${MACOSX_DEPLOYMENT_TARGET:-10.12}"
        '';
      };
    }
    {
      buildOpts = buildOptsR18_19;
      featureOpts = featureOptsR18_23;
      release = {
        version = "19.3.6.11";
        sha256 = "0b02iv8dly1vkc2xnqqi030sdj34h4gji2h4qgilllajr1f868vm";

        patches = [
          # macOS 10.13 crypto fix from OTP-20.1.2
          (fetchpatch {
            name = "darwin-crypto.patch";
            url =
              "https://github.com/erlang/otp/commit/882c90f72ba4e298aa5a7796661c28053c540a96.patch";
            sha256 = "1gggzpm8ssamz6975z7px0g8qq5i4jqw81j846ikg49c5cxvi0hi";
          })
        ];

        prePatch = ''
          substituteInPlace configure.in --replace '`sw_vers -productVersion`' "''${MACOSX_DEPLOYMENT_TARGET:-10.12}"
        '';
      };
    }
    {
      buildOpts = buildOptsR18_19;
      featureOpts = featureOptsR18_23;
      release = {
        version = "18.3.4.8";
        sha256 = "16c0h25hh5yvkv436ks5jbd7qmxzb6ndvk64mr404347a20iib0g";

        patches = [
          (fetchpatch {
            url =
              "https://github.com/erlang/otp/commit/98b8650d22e94a5ff839170833f691294f6276d0.patch";
            sha256 = "0zjs7as83prgq4d5gaw2cmnajnsprdk8cjl5kklknx0pc2b3hfg5";
          })
          (fetchpatch {
            url =
              "https://github.com/erlang/otp/commit/9f9841eb7327c9fe73e84e197fd2965a97b639cf.patch";
            sha256 = "00fx5wc88ki3z71z5q4xzi9h3whhjw1zblpn09w995ygn07m9qhm";
          })
          (fetchpatch {
            url =
              "https://github.com/erlang/otp/commit/2f1a37f1011ff9d129bc35a6efa0ab937a2aa0e9.patch";
            sha256 = "0xfa6hzxh9d7qllkyidcgh57xrrx11w65y7s1hyg52alm06l6b9n";
          })
          (fetchpatch {
            url =
              "https://github.com/erlang/otp/commit/de8fe86f67591dd992bae33f7451523dab36e5bd.patch";
            sha256 = "1cj9fjhdng6yllajjm3gkk04ag9bwyb3n70hrb5nk6c292v8a45c";
          })
        ];
      };
    }
    {
      buildOpts = buildOptsR16;
      featureOpts = featureOptsR16;
      release = {
        baseName = "erlang";
        version = "16B02.basho10";

        src = pkgs.fetchFromGitHub {
          owner = "basho";
          repo = "otp";
          rev = "OTP_R16B02_basho10";
          sha256 = "1s2c3ag9dnp6xmcr27kh95n1w50xly97n1mp8ivc2a3gpv4blqmj";
        };

        preConfigure = ''
          export HOME=$PWD/../
          export LANG=C
          export ERL_TOP=$(pwd)
          sed -e s@/bin/pwd@pwd@g -i otp_build
          sed -e s@"/usr/bin/env escript"@$(pwd)/bootstrap/bin/escript@g -i lib/diameter/bin/diameterc

          ./otp_build autoconf
        '';

        enableHipe = false;

        # Do not install docs, instead use prebuilt versions.
        installTargets = "install";
        postInstall = let
          manpages = pkgs.fetchurl {
            url = "https://www.erlang.org/download/otp_doc_man_R16B02.tar.gz";
            sha256 = "12apxjmmd591y9g9bhr97z5jbd1jarqg7wj0y2sqhl21hc1yp75p";
          };
        in ''
          sed -e s@$(pwd)/bootstrap/bin/escript@$out/bin/escript@g -i $out/lib/erlang/lib/diameter-1.4.3/bin/diameterc

          tar xf "${manpages}" -C "$out/lib/erlang"
          for i in "$out"/lib/erlang/man/man[0-9]/*.[0-9]; do
            prefix="''${i%/*}"
            mkdir -p "$out/share/man/''${prefix##*/}"
            ln -s "$i" "$out/share/man/''${prefix##*/}/''${i##*/}erl"
          done
        '';

        meta = {
          homepage = "https://github.com/basho/otp/";
          description =
            "Programming language used for massively scalable soft real-time systems, Basho fork";

          longDescription = ''
            Erlang is a programming language used to build massively scalable
            soft real-time systems with requirements on high availability.
            Some of its uses are in telecoms, banking, e-commerce, computer
            telephony and instant messaging. Erlang's runtime system has
            built-in support for concurrency, distribution and fault
            tolerance.
            This version of Erlang is Basho's version, forked from Ericsson's
            repository.
          '';

          knownVulnerabilities = [ "CVE-2017-1000385" ];

          platforms = [ "x86_64-linux" "x86_64-darwin" ];
          license = pkgs.stdenv.lib.licenses.asl20;
          maintainers = with pkgs.stdenv.lib.maintainers; [ mdaiter ];
        };
      };
    }
  ];

  makeVariantsForVersion = { release, buildOpts, featureOpts }:
    let
      featureVariants = util.featureCombination featureOpts "_";
      featureList = util.attrsToList featureVariants;
      variants = map ({ name, value }:
        let
          features = name;
          featureFlags = value;
          builder = callPackage ./generic-builder.nix buildOpts;
          mkDerivation = pkgs.makeOverridable builder;
          pkgPath = util.makePkgPath "erlang" release.version features;
          pkgName = util.makePkgName "erlang" release.version features;

          pkg = ((mkDerivation release).override featureFlags).overrideAttrs
            (o: { name = pkgName; });
        in {
          name = pkgPath;
          value = pkg;
        }) featureList;
    in variants;

  variants = builtins.concatLists (map makeVariantsForVersion versions);

in (builtins.listToAttrs variants)
