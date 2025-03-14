{ lib, fetchFromGitLab }:
# When updating this package, please verify at least these build (assuming x86_64-linux):
# nix build .#mesa .#pkgsi686Linux.mesa .#pkgsCross.aarch64-multiplatform.mesa .#pkgsMusl.mesa
# Ideally also verify:
# nix build .#legacyPackages.x86_64-darwin.mesa .#legacyPackages.aarch64-darwin.mesa
rec {
  pname = "mesa";
  version = "25.1.0-git";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mesa";
    repo = "mesa";
    rev = "b2a2d197f998f6d71c9f1b6ff5f98cab79779b5d";
    hash = "sha256-XxJ3xPtMyYpD5gsfAwaf92K9pI8EdcxZ4v4mSF++fgI=";
  };

  #src = fetchFromGitLab {
  #  domain = "gitlab.freedesktop.org";
  #  owner = "hakzsam";
  #  repo = "mesa";
  #  rev = "130f7467658a6222905d45032a7dbd37be17d2a7";
  #  hash = "sha256-9PcaBcic0bwoWZFrXZz3AA40ib64Mm6MCvvjLsdThI4=";
  #};

  meta = {
    description = "Open source 3D graphics library";
    longDescription = ''
      The Mesa project began as an open-source implementation of the OpenGL
      specification - a system for rendering interactive 3D graphics. Over the
      years the project has grown to implement more graphics APIs, including
      OpenGL ES (versions 1, 2, 3), OpenCL, OpenMAX, VDPAU, VA API, XvMC, and
      Vulkan.  A variety of device drivers allows the Mesa libraries to be used
      in many different environments ranging from software emulation to
      complete hardware acceleration for modern GPUs.
    '';
    homepage = "https://www.mesa3d.org/";
    changelog = "https://docs.mesa3d.org/relnotes/${version}.html";
    license = with lib.licenses; [ mit ]; # X11 variant, in most files
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      k900
      primeos
      vcunat
    ]; # Help is welcome :)
  };
}
