{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, requests
, websocket-client
, websockets
}:

buildPythonPackage rec {
  pname = "sense-energy";
  version = "0.9.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "scottbonline";
    repo = "sense";
    rev = version;
    sha256 = "0wzb1glc0i8jwhckparfm7426nv55fcrink00sj1axr8q5yhdssz";
  };

  propagatedBuildInputs = [
    aiohttp
    requests
    websocket-client
    websockets
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "sense_energy"
  ];

  meta = with lib; {
    description = "API for the Sense Energy Monitor";
    homepage = "https://github.com/scottbonline/sense";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
