{
  stdenv,
  lib,
  fetchsvn,
  linux,
  scripts ? fetchsvn {
    url = "https://www.fsfla.org/svn/fsfla/software/linux-libre/releases/branches/";
    rev = "19795";
    sha256 = "1gcg9n5b2yyd3nhzf4v8xiy7xxnizmk33bwnp6c768vckxbzmhdh";
  },
  ...
}@args:

let
  majorMinor = lib.versions.majorMinor linux.modDirVersion;

  major = lib.versions.major linux.modDirVersion;
  minor = lib.versions.minor linux.modDirVersion;
  patch = lib.versions.patch linux.modDirVersion;

  # See http://linux-libre.fsfla.org/pub/linux-libre/releases
  versionPrefix = if linux.kernelOlder "5.14" then "gnu1" else "gnu";
in
linux.override {
  argsOverride = {
    modDirVersion = "${linux.modDirVersion}-${versionPrefix}";
    isLibre = true;
    pname = "linux-libre";

    src = stdenv.mkDerivation {
      name = "${linux.name}-libre-src";
      src = linux.src;
      buildPhase = ''
        # --force flag to skip empty files after deblobbing
        ${scripts}/${majorMinor}/deblob-${majorMinor} --force \
            ${major} ${minor} ${patch}
      '';
      checkPhase = ''
        ${scripts}/deblob-check
      '';
      installPhase = ''
        cp -r . "$out"
      '';
    };

    passthru.updateScript = ./update-libre.sh;

    maintainers = with lib.maintainers; [ qyliss ];
  };
}
// (args.argsOverride or { })
