{ lib
, buildPythonPackage
, fetchPypi
, markupsafe
}:

buildPythonPackage rec {
  version = "3.0.1";
  pname = "WTForms";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6b351bbb12dd58af57ffef05bc78425d08d1914e0fd68ee14143b7ade023c5bc";
  };

  propagatedBuildInputs = [ markupsafe ];

  # Django tests are broken "django.core.exceptions.AppRegistryNotReady: Apps aren't loaded yet."
  doCheck = false;

  meta = with lib; {
    description = "A flexible forms validation and rendering library for Python";
    homepage = "https://github.com/wtforms/wtforms";
    changelog = "https://github.com/wtforms/wtforms/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = [ maintainers.bhipple ];
  };

}
