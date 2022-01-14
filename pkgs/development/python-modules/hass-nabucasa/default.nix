{ lib
, acme
, aiohttp
, asynctest
, atomicwrites
, attrs
, buildPythonPackage
, fetchFromGitHub
, pycognito
, pytest-aiohttp
, pytestCheckHook
, snitun
, warrant
}:

buildPythonPackage rec {
  pname = "hass-nabucasa";
  version = "0.51.0";

  src = fetchFromGitHub {
    owner = "nabucasa";
    repo = pname;
    rev = version;
    sha256 = "05cyk6viwfg11bmi89w3ihqqlanqs7iqrcb6z27rn9i1rrgc1pm8";
  };

  postPatch = ''
    sed -i 's/"acme.*"/"acme"/' setup.py
    substituteInPlace setup.py \
      --replace "cryptography>=2.8,<4.0" "cryptography" \
      --replace "snitun==" "snitun>="
  '';

  propagatedBuildInputs = [
    acme
    aiohttp
    atomicwrites
    attrs
    pycognito
    snitun
    warrant
  ];

  checkInputs = [
    asynctest
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hass_nabucasa" ];

  meta = with lib; {
    homepage = "https://github.com/NabuCasa/hass-nabucasa";
    description = "Python module for the Home Assistant cloud integration";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
