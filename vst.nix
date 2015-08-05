{ stdenv, fetchurl, ocaml, coq, compcert }:

stdenv.mkDerivation rec {
 name = "vst-${version}";
 version = "1.5";
 src = fetchurl {
        url = "http://vst.cs.princeton.edu/download/vst-1.5.tgz";
        sha256 = "b4b6dbd42d82b5427e33355a0df416a3135fc353f6662c06f70e3c7243a42718"; };

 enableParallelBuilding = true;
 buildInputs = [ coq ocaml compcert ];

 configurePhase = "echo COMPCERT=${compcert}/lib/coq/${coq.version}/user-contrib/compcert/ > CONFIGURE";

 installPhase = ''
                  [ -n $out ] &&
                  mkdir -p $out/share/doc/
                  cp -a doc $out/share/doc/vst
                  cp -a examples $out/share/doc/vst/examples
                  mkdir -p $out/lib/coq/${coq.coq-version}/user-contrib/
                  cp -a floyd msl veric sepcomp progs util $out/lib/coq/${coq.coq-version}/user-contrib/
                '';
}

