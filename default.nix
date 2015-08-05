with import <nixpkgs> {};
let
  mycoq = pkgs.stdenv.lib.overrideDerivation coq (oldAttrs: {
                                name = "coq-8.4";
                                version = "8.4";
                                src = fetchurl {
                                        url="https://coq.inria.fr/distrib/V8.4pl4/files/coq-8.4pl4.tar.gz";
                                        sha256="06c3aeab7819eed8f35ce794c887a70cf3b4f6b71ee52cd3110fb4e526717f01";};});
  mycompcert = callPackage ./compcert.nix {coq = mycoq;};
  vst = callPackage ./vst.nix {coq = mycoq; compcert = mycompcert;};
in
runCommand "bash"
{
   buildInputs = [stdenv bash mycoq mycompcert vst emacs emacs24Packages.proofgeneral];
} ""

