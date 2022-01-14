{ lib
, boto3
, buildPythonPackage
, envs
, fetchFromGitHub
, isPy27
, mock
, pytestCheckHook
, python-jose
, requests
}:

buildPythonPackage rec {
  pname = "pycognito";
  version = "2022.01.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "pvizeli";
    repo = pname;
    rev = version;
    sha256 = "09jda8zjx41a3frlsfwwy175zwx0y9qrs8piin2l82yc5bg70scs";
  };

  propagatedBuildInputs = [
    boto3
    envs
    python-jose
    requests
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'python-jose[cryptography]' 'python-jose'
  '';

  pytestFlagsArray = [ "tests.py" ];

  pythonImportsCheck = [ "pycognito" ];

  meta = with lib; {
    description = "Python class to integrate Boto3's Cognito client so it is easy to login users. With SRP support";
    homepage = "https://github.com/pvizeli/pycognito";
    license = licenses.asl20;
    maintainers = with maintainers; [ mic92 ];
  };
}
