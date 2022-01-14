{ lib, buildPythonPackage, fetchPypi, idna, pytestCheckHook }:

buildPythonPackage rec {
  pname = "rfc3986";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c";
  };

  propagatedBuildInputs = [ idna ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Validating URI References per RFC 3986";
    homepage = "https://rfc3986.readthedocs.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
