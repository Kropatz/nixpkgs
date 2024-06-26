{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "deezer-py";
  version = "1.3.7";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-saMy+IeAy6H9SgS8XHnZ9klFerGyr+vQqhuCtimgbEo=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "requests" ];

  meta = with lib; {
    homepage = "https://gitlab.com/RemixDev/deezer-py";
    description = "Wrapper for all Deezer's APIs";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ natto1784 ];
  };
}
