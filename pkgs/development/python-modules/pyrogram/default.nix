{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pyaes
, pysocks
, async-lru
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "pyrogram";
  version = "1.3.5";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "Pyrogram";
    inherit version;
    sha256 = "e75feda3c642c8ae9c616402196710d3bac60d1dbd6b07f1714367485e6f20a1";
  };

  propagatedBuildInputs = [
    pyaes
    pysocks
    async-lru
  ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "pyrogram"
    "pyrogram.errors"
    "pyrogram.types"
  ];

  meta = with lib; {
    description = "Telegram MTProto API Client Library and Framework for Python";
    homepage = "https://github.com/pyrogram/pyrogram";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
