{ stdenv, pass, fetchFromGitHub, python3Packages, makeWrapper }:

let
  pythonEnv = python3Packages.python.withPackages (p: [ p.requests p.zxcvbn ]);

in stdenv.mkDerivation rec {
  name = "pass-audit-${version}";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "roddhjav";
    repo = "pass-audit";
    rev = "4d285fada719b84e2ffeb03797c1f67c6f29633e";
    sha256 = "1b1nh45ayyl3pymz75naim0wwzb5nf8x6b9c5w71j2c771zgxc05";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ pythonEnv ];

  patchPhase = ''
    substituteInPlace Makefile --replace '@python3' '@${pythonEnv}/bin/python'
  '';

  installFlags = [
    "PREFIX=$(out)"
    "BASHCOMPDIR=$(out)/share/bash-completion/completions"
  ];

  postInstall = ''
    wrapProgram $out/lib/password-store/extensions/audit.bash \
      --prefix PATH : "${pythonEnv}/bin" \
      --prefix PYTHONPATH : $out/lib/${pythonEnv.libPrefix}/site-packages \
      --run "export PREFIX"
  '';

  meta = with stdenv.lib; {
    description = "Pass extension for auditing your password repository.";
    homepage = https://github.com/roddhjav/pass-audit;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
