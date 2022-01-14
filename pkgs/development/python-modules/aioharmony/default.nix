{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchPypi
, pythonOlder
, slixmpp
}:

buildPythonPackage rec {
  pname = "aioharmony";
  version = "0.2.9";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4f7d292f33d60fee696f44a192935d88114ee3945d88c62008e4a0f2bc7eb7e6";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    slixmpp
  ];

  # aioharmony does not seem to include tests
  doCheck = false;

  pythonImportsCheck = [
    "aioharmony.harmonyapi"
    "aioharmony.harmonyclient"
  ];

  meta = with lib; {
    homepage = "https://github.com/ehendrix23/aioharmony";
    description = "Python library for interacting the Logitech Harmony devices";
    license = licenses.asl20;
    maintainers = with maintainers; [ oro ];
  };
}
