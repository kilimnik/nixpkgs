{ lib
, buildPythonPackage
, fetchPypi
, ruamel-base
, ruamel-yaml-clib
, isPyPy
}:

buildPythonPackage rec {
  pname = "ruamel-yaml";
  version = "0.17.20";

  src = fetchPypi {
    pname = "ruamel.yaml";
    inherit version;
    sha256 = "4b8a33c1efb2b443a93fcaafcfa4d2e445f8e8c29c528d9f5cdafb7cc9e4004c";
  };

  # Tests use relative paths
  doCheck = false;

  propagatedBuildInputs = [ ruamel-base ]
    ++ lib.optional (!isPyPy) ruamel-yaml-clib;

  pythonImportsCheck = [ "ruamel.yaml" ];

  meta = with lib; {
    description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = "https://sourceforge.net/projects/ruamel-yaml/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
