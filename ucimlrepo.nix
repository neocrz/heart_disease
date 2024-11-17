# toolz.nix
{
  lib,
  pkgs,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "ucimlrepo";
  version = "0.0.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TP8/noFDZ91glW2pmazkcxlyN7n85MB+mmied7T/tZo=";
  };

  # do not run tests
  doCheck = false;

  # specific to buildPythonPackage, see its reference
  pyproject = true;
  build-system = [
    setuptools
    wheel
  ];
  nativeBuildInputs = [ pkgs.python311Packages.pip pkgs.git ];
  propagatedBuildInputs = with pkgs.python311Packages; [
    setuptools
    packaging
    cython
    numpy
    pandas
    certifi
  ];
}

