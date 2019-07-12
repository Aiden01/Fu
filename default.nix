{ mkDerivation, stdenv, hpack }:
let
  packages = import ./nix/packages.nix {};
  in mkDerivation {
    pname = "fu";
    version = "0.1.0.0";
    src = ./.;
    isLibrary = true;
    isExecutable = true;
    libraryHaskellDepends = [ packages.lib ];
     libraryToolDepends = [ hpack ];
    executableHaskellDepends = [ packages.exe ];
    testHaskellDepends = [ packages.test ];
    preConfigure = "hpack";
    homepage = "https://github.com/githubuser/fu#readme";
    license = stdenv.lib.licenses.bsd3;
  }
