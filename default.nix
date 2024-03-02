let
  sources = import ./sources.nix;
in
{ pkgs ? import sources.nixpkgs { } }:

pkgs.stdenv.mkDerivation rec {
  pname = "apollo";
  version = "more-rp2040-boards";

  src = sources.apollo;

  nativeBuildInputs = with pkgs;[
    gcc-arm-embedded
    cmake
    python3
  ];

  phases = [ "unpackPhase" "buildPhase" ];

  buildPhase = ''
    runHook preBuild

    cp -r --no-preserve=mode,ownership ${sources.tinyusb}/* lib/tinyusb
    ln -s ${sources.microchip_driver} lib/tinyusb/hw/mcu/microchip
    ln -s ${sources.uf2} lib/tinyusb/tools/uf2

    ${pkgs.stdenv.shell} ${./helper.sh}

    runHook postBuild
  '';

  enableParallelBuilding = true;

  PICO_SDK_PATH = "${pkgs.pico-sdk}/lib/pico-sdk";
}
