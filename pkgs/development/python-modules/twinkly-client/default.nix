{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "twinkly-client";
  version = "0.0.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17f37ac8c3af2c721f5ef3f247bcf73ff46587bf4ebc26ef1223700a52d22e5f";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "twinkly_client" ];

  meta = with lib; {
    description = "Python module to communicate with Twinkly LED strings";
    homepage = "https://github.com/dr1rrb/py-twinkly-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
