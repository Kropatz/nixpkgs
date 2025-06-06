{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "anyascii";
  version = "0.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nV0y74RP4iW4vHy6f5UFNPrk2iepvzpr6iyw6kbORzA=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/anyascii/anyascii/blob/${version}/CHANGELOG.md";
    description = "Unicode to ASCII transliteration";
    homepage = "https://github.com/anyascii/anyascii";
    license = licenses.isc;
    teams = [ teams.tts ];
  };
}
