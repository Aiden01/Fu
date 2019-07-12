{ mkDerivation, aeson, ansi-terminal, base, bytestring, directory
, hpack, lens, mtl, optparse-applicative, stdenv
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
}
