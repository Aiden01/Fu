{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, aeson, ansi-terminal, base, bytestring
      , directory, hpack, lens, mtl, optparse-applicative, stdenv
      }:
      mkDerivation {
        pname = "fu";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = true;
        isExecutable = true;
        libraryHaskellDepends = [
          aeson ansi-terminal base bytestring directory lens mtl
          optparse-applicative
        ];
        libraryToolDepends = [ hpack ];
        executableHaskellDepends = [
          aeson ansi-terminal base bytestring directory lens mtl
          optparse-applicative
        ];
        testHaskellDepends = [
          aeson ansi-terminal base bytestring directory lens mtl
          optparse-applicative
        ];
        preConfigure = "hpack";
        homepage = "https://github.com/githubuser/fu#readme";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
