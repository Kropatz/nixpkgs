{
  stdenv,
  lib,
  fetchFromGitHub,
  glib,
  gobject-introspection,
  intltool,
  shared-mime-info,
  gtk3,
  wrapGAppsHook3,
  libarchive,
  libxml2,
  xapp,
  meson,
  pkg-config,
  cairo,
  libsecret,
  poppler,
  libspectre,
  libgxps,
  webkitgtk_4_1,
  nodePackages,
  ninja,
  djvulibre,
  backends ? [
    "pdf"
    "ps" # "dvi" "t1lib"
    "djvu"
    "tiff"
    "pixbuf"
    "comics"
    "xps"
    "epub"
  ],
}:

stdenv.mkDerivation rec {
  pname = "xreader";
  version = "4.2.6";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-ELqO8pYMWgU6DUS5vg+F+xFp3w3H6u0Jzms3xaNlTqE=";
  };

  nativeBuildInputs = [
    shared-mime-info
    wrapGAppsHook3
    meson
    ninja
    pkg-config
    gobject-introspection
    intltool
  ];

  mesonFlags = [
    "-Dmathjax-directory=${nodePackages.mathjax}"
    "-Dintrospection=true"
  ] ++ (map (x: "-D${x}=true") backends);

  buildInputs = [
    glib
    gtk3
    xapp
    cairo
    libarchive
    libxml2
    libsecret
    poppler
    libspectre
    libgxps
    webkitgtk_4_1
    nodePackages.mathjax
    djvulibre
  ];

  meta = with lib; {
    description = "Document viewer capable of displaying multiple and single page
document formats like PDF and Postscript";
    homepage = "https://github.com/linuxmint/xreader";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
  };
}
