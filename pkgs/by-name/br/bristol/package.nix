{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  libjack2,
  pkg-config,
  libX11,
  libXext,
  xorgproto,
  libpulseaudio,
  copyDesktopItems,
  makeDesktopItem,
}:

stdenv.mkDerivation rec {
  pname = "bristol";
  version = "0.60.11";

  src = fetchurl {
    url = "mirror://sourceforge/bristol/${pname}-${version}.tar.gz";
    hash = "sha256-fR8LvQ19MD/HfGuVSbYXCNeoO03AB4GAEbH1XR+pIro=";
  };

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    libjack2
    libpulseaudio
    libX11
    libXext
    xorgproto
  ];

  postPatch = ''
    sed -i '41,43d' libbristolaudio/audioEngineJack.c  # disable alsa/iatomic
    sed -i '35i void doPitchWheel(Baudio *baudio);' bristol/bristolmemorymoog.c
  '';

  configureFlags = [
    "--enable-jack-default-audio"
    "--enable-jack-default-midi"
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #  ld: brightonCLI.o:/build/bristol-0.60.11/brighton/brightonCLI.c:139: multiple definition of
  #    `event'; brightonMixerMenu.o:/build/bristol-0.60.11/brighton/brightonMixerMenu.c:1182: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon -Wno-implicit-int";

  preInstall = ''
    sed -e "s@\`which bristol\`@$out/bin/bristol@g" -i bin/startBristol
    sed -e "s@\`which brighton\`@$out/bin/brighton@g" -i bin/startBristol
  '';

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/scalable/apps/
    ln -s $out/share/bristol/bitmaps/bicon.svg $out/share/icons/hicolor/scalable/apps/
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Bristol";
      exec = "bristol";
      icon = "bicon";
      desktopName = "Bristol";
      comment = "Graphical user interface for the Bristol synthesizer emulator";
      categories = [ "AudioVideo" ];
    })
  ];

  meta = {
    description = "Range of synthesiser, electric piano and organ emulations";
    homepage = "https://bristol.sourceforge.net";
    license = lib.licenses.gpl3;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = [ ];
  };
}
