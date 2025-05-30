{
  lib,
  stdenv,
  autoPatchelfHook,
  fetchurl,
  nixosTests,
  metaCommon,
}:

let
  serverSource.url = "https://github.com/zadam/trilium/releases/download/v${version}/trilium-linux-x64-server-${version}.tar.xz";
  serverSource.sha256 = "0gwp6h6nvfzq7k1g3233h838nans45jkd5c3pzl6qdhhm19vcs27";
  version = "0.63.6";
in
stdenv.mkDerivation {
  pname = "trilium-server";
  inherit version;
  meta = metaCommon // {
    platforms = [ "x86_64-linux" ];
    mainProgram = "trilium-server";
  };

  src = fetchurl serverSource;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
  ];

  patches = [
    # patch logger to use console instead of rolling files
    ./0001-Use-console-logger-instead-of-rolling-files.patch
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/share/trilium-server

    cp -r ./* $out/share/trilium-server
    runHook postInstall
  '';

  postFixup = ''
    cat > $out/bin/trilium-server <<EOF
    #!${stdenv.cc.shell}
    cd $out/share/trilium-server
    exec ./node/bin/node src/www
    EOF
    chmod a+x $out/bin/trilium-server

    # ERROR: noBrokenSymlinks: found 4 dangling symlinks, 0 reflexive symlinks and 0 unreadable symlinks
    unlink $out/share/trilium-server/node/bin/npx
    unlink $out/share/trilium-server/node/bin/npm
    unlink $out/share/trilium-server/node_modules/.bin/electron
    unlink $out/share/trilium-server/node_modules/.bin/electron-installer-debian
  '';

  passthru.tests = {
    trilium-server = nixosTests.trilium-server;
  };
}
