{ lib
, buildPythonPackage
, callPackage
, fetchPypi
, pythonOlder
, pytest
, blis
, catalogue
, cymem
, jinja2
, jsonschema
, murmurhash
, numpy
, preshed
, requests
, setuptools
, srsly
, spacy-legacy
, thinc
, typer
, wasabi
, packaging
, pathy
, pydantic
, python
, tqdm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "3.2.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6ebac511627740a8ca2b117b91ef5515c8f0b2fb117a69ebe01d010dd4fc53c";
  };

  propagatedBuildInputs = [
    blis
    catalogue
    cymem
    jinja2
    jsonschema
    murmurhash
    numpy
    packaging
    pathy
    preshed
    pydantic
    requests
    setuptools
    srsly
    spacy-legacy
    thinc
    tqdm
    typer
    wasabi
  ] ++ lib.optional (pythonOlder "3.8") typing-extensions;

  checkInputs = [
    pytest
  ];

  doCheck = false;
  checkPhase = ''
    ${python.interpreter} -m pytest spacy/tests --vectors --models --slow
  '';

  pythonImportsCheck = [ "spacy" ];

  passthru.tests.annotation = callPackage ./annotation-test { };

  meta = with lib; {
    description = "Industrial-strength Natural Language Processing (NLP) with Python and Cython";
    homepage = "https://github.com/explosion/spaCy";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
