{}:
let
  pkgs = import <nixpkgs> {};
  libPkgs = with pkgs.haskellPackages; [
    aeson
    ansi-terminal
    base
    bytestring
    directory
    lens
    mtl
    optparse-applicative
  ];
  exePkgs = with pkgs; [ haskellPackages.base ];
  testPkgs = with pkgs; [ haskellPackages.base ];
in
 {
   lib = libPkgs;
   exe = exePkgs;
   test = testPkgs;
 }
