{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  intel-gmmlib,
  intel-graphics-compiler,
  level-zero,
  libva,
}:

stdenv.mkDerivation rec {
  pname = "intel-compute-runtime";
  version = "24.52.32224.5";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "compute-runtime";
    rev = version;
    hash = "sha256-Unoh33bZFsMCqJ2hWEYVEdMF2V/aSIDynThz1pUyM7Q=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    intel-gmmlib
    intel-graphics-compiler
    libva
    level-zero
  ];

  cmakeFlags = [
    "-DSKIP_UNIT_TESTS=1"
    "-DIGC_DIR=${intel-graphics-compiler}"
    "-DOCL_ICD_VENDORDIR=${placeholder "out"}/etc/OpenCL/vendors"
    # The install script assumes this path is relative to CMAKE_INSTALL_PREFIX
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  outputs = [
    "out"
    "drivers"
  ];

  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  postInstall = ''
    # Avoid clash with intel-ocl
    mv $out/etc/OpenCL/vendors/intel.icd $out/etc/OpenCL/vendors/intel-neo.icd

    mkdir -p $drivers/lib
    mv -t $drivers/lib $out/lib/libze_intel*
  '';

  postFixup = ''
    patchelf --set-rpath ${
      lib.makeLibraryPath [
        intel-gmmlib
        intel-graphics-compiler
        libva
        stdenv.cc.cc
      ]
    } \
      $out/lib/intel-opencl/libigdrcl.so
  '';

  meta = with lib; {
    description = "Intel Graphics Compute Runtime oneAPI Level Zero and  OpenCL, supporting 12th Gen and newer";
    mainProgram = "ocloc";
    homepage = "https://github.com/intel/compute-runtime";
    changelog = "https://github.com/intel/compute-runtime/releases/tag/${version}";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
