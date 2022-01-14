{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "jsmin";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "88fc1bd6033a47c5911dbcada7d279c7a8b7ad0841909590f6a742c20c4d2e08";
  };

  meta = with lib; {
    description = "JavaScript minifier";
    homepage = "https://github.com/tikitu/jsmin/";
    license = licenses.mit;
  };
}
