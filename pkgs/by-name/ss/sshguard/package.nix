{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  bison,
  flex,
}:

stdenv.mkDerivation rec {
  version = "2.4.3";
  pname = "sshguard";

  src = fetchurl {
    url = "mirror://sourceforge/sshguard/${pname}-${version}.tar.gz";
    sha256 = "sha256-ZAKd7/bekP3u+x9JfUFPDkBFB2aTqR2hpw63WV6X7+s=";
  };

  doCheck = true;

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
  ];

  configureFlags = [ "--sysconfdir=/etc" ];

  meta = with lib; {
    description = "Protects hosts from brute-force attacks";
    mainProgram = "sshguard";
    longDescription = ''
      SSHGuard can read log messages from various input sources. Log messages are parsed, line-by-line, for recognized patterns.
      If an attack, such as several login failures within a few seconds, is detected, the offending IP is blocked.
    '';
    homepage = "https://sshguard.net";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sargon ];
    platforms = with platforms; linux ++ darwin ++ freebsd ++ netbsd ++ openbsd;
  };
}
