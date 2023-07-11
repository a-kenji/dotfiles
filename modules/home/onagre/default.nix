{
  cmake,
  crane,
  expat,
  fontconfig,
  freetype,
  lib,
  libGL,
  libglvnd,
  libxkbcommon,
  makeWrapper,
  onagre,
  papirus-icon-theme,
  pkgconf,
  pkgs,
  pop-launcher,
  vulkan-loader,
  xorg,
}: let
  src = onagre;
  cargoTOML = builtins.fromTOML (builtins.readFile (src + /Cargo.toml));
  inherit (cargoTOML.package) version name;
  craneLib = crane.mkLib pkgs;
  pname = name;
  stdenv =
    if pkgs.stdenv.isLinux
    then pkgs.stdenvAdapters.useMoldLinker pkgs.stdenv
    else pkgs.stdenv;
in
  craneLib.buildPackage {
    inherit version name pname stdenv src;
    nativeBuildInputs = [cmake pkgconf makeWrapper];
    buildInputs =
      [
        freetype
        expat
        libGL
        libglvnd
        fontconfig
        libxkbcommon
      ]
      ++ (with xorg; [
        libX11
        libXcursor
        libXi
        libXrandr
        libxcb
      ]);

    doCheck = false;

    postInstall = ''
      wrapProgram "$out/bin/${pname}" \
        --prefix PATH : "${lib.makeBinPath [pop-launcher]}" \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [vulkan-loader libGL]} \
        --suffix XDG_DATA_DIRS : "${papirus-icon-theme}/share"
    '';
  }
