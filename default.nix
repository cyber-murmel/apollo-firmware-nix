let
  nixpkgs_hash = "79baff8812a0d68e24a836df0a364c678089e2c7"; # nixos-23.11 on 2024-03-02
  nixpkgs_url = "https://github.com/NixOS/nixpkgs/archive/${nixpkgs_hash}.tar.gz";
  nixpkgs_src = builtins.fetchTarball {
    url = nixpkgs_url;
  };

  microchip_driver_hash = "9e8b37e307d8404033bb881623a113931e1edf27";
  microchip_driver_url = "https://github.com/hathach/microchip_driver/archive/${microchip_driver_hash}.tar.gz";
  microchip_driver_src = builtins.fetchTarball {
    url = microchip_driver_url;
  };

  uf2_hash = "19615407727073e36d81bf239c52108ba92e7660";
  uf2_url = "https://github.com/microsoft/uf2/archive/${uf2_hash}.tar.gz";
  uf2_src = builtins.fetchTarball {
    url = uf2_url;
  };

in
{ pkgs ? import nixpkgs_src{ } }:

with pkgs;

# pkgsCross.arm-embedded.stdenvNoLibs.mkDerivation rec{
stdenv.mkDerivation rec {
  pname = "apollo";
  version = "more-rp2040-boards";

  src = fetchFromGitHub {
    owner = "cyber-murmel";
    repo = "apollo";
    rev = "8881979";
    hash = "sha256-hVKZfO2XfMBKTDbJVH7Y5kspQiupkdOFF0ZUpbn+1Ac=";
    
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gcc-arm-embedded
    cmake
    python3
  ];

  phases = [ "unpackPhase" "buildPhase" ];

  buildPhase = ''
    runHook preBuild

    ln -s ${microchip_driver_src} lib/tinyusb/hw/mcu/microchip
    ln -s ${uf2_src} lib/tinyusb/tools/uf2

    ${stdenv.shell} ${./helper.sh}

    runHook postBuild
  '';

  enableParallelBuilding = true;
}
