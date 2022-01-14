{ buildPythonPackage, lib, fetchFromGitHub, isPy3k
, cython, setuptools
, numpy, affine, attrs, cligj, click-plugins, snuggs, gdal
, pytest, pytest-cov, packaging, hypothesis, boto3, mock
, certifi, shapely
}:

buildPythonPackage rec {
  pname = "rasterio";
  version = "4";

  # Pypi doesn't ship the tests, so we fetch directly from GitHub
  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "rasterio";
    rev = version;
    sha256 = "07j1fba1jm55qby0ljxmm983n229qgarjdm9gwyfzdq4cag0bvb0";
  };

  checkInputs = [ boto3 pytest pytest-cov packaging hypothesis shapely ] ++ lib.optional (!isPy3k) mock;
  nativeBuildInputs = [ cython gdal ];
  propagatedBuildInputs = [ certifi gdal numpy attrs affine cligj click-plugins snuggs setuptools ];

  meta = with lib; {
    description = "Python package to read and write geospatial raster data";
    license = licenses.bsd3;
    homepage = "https://rasterio.readthedocs.io/en/latest/";
    maintainers = with maintainers; [ mredaelli ];
  };
}
