{ stdenv, fetchurl, coq, ocaml, ocamlPackages }:

stdenv.mkDerivation rec {
  name    = "compcert-${version}";
  version = "2.4";

  src = fetchurl {
    url    = "http://compcert.inria.fr/release/${name}.tgz";
    sha256 = "1qrb1cplx3v5wxn1c46kx67v1j52yznvjm2hkrsdybphhki2pyia";
  };

  buildInputs = [ coq ocaml ocamlPackages.menhir ];

  enableParallelBuilding = true;

  configurePhase = ''
    substituteInPlace ./configure --replace '{toolprefix}gcc' '{toolprefix}cc'
    ./configure -prefix $out -toolprefix ${stdenv.cc}/bin/ '' +
    (if stdenv.isDarwin then "ia32-macosx" else "ia32-linux");

  buildPhase = '' [ -n $out ] &&\
                  make -j 4 &&\
                  make -j 4 clightgen
               '';
  installPhase = ''
                   [ -n $out ] &&\
                   make install &&\
                   cp `readlink ./clightgen` $out/bin/clightgen &&\
                   mkdir -p $out/lib/coq/${coq.coq-version}/user-contrib/compcert &&\
                   cp -a . $out/lib/coq/${coq.coq-version}/user-contrib/compcert
                 '';

  meta = with stdenv.lib; {
    description = "Formally verified C compiler";
    homepage    = "http://compcert.inria.fr";
    license     = licenses.inria;
    platforms   = platforms.linux ++
                  platforms.darwin;
    maintainers = with maintainers; [ thoughtpolice jwiegley vbgl ];
  };
}

