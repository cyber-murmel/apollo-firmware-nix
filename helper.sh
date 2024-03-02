################################################################################
# Build all of the platforms manually since the `all_platforms' target
# doesn't preserve all of the build outputs and overrides CFLAGS.
set -e
set -u

################################################################################
# Prevent a warning from shellcheck:
out=${out:-/tmp}

################################################################################
# export CFLAGS=$NIX_CFLAGS_COMPILE
export MAKEFLAGS="\
  ${enableParallelBuilding:+-j${NIX_BUILD_CORES}}"

################################################################################
PRODUCTS="firmware.bin firmware.hex firmware.uf2 firmware.elf"

################################################################################
install_platform() {
  for f in $PRODUCTS; do
    if [ -r "_build/$1/$f" ]; then
      mkdir -p "$out/firmware/$1"
      install -m 0444 "_build/$1/$f" "$out/firmware/$1"
    fi
    if [ -r "_build/$f" ]; then
      mkdir -p "$out/firmware/$1"
      install -m 0444 "_build/$f" "$out/firmware/$1"
    fi
  done
}

make_platform() {
  echo "Building for hardware platform $1"

  rm -rf _build
  make APOLLO_BOARD="$1" ${2:-}

  install_platform "$1"
}

cmake_platform() {
  echo "Building for hardware platform $1"

  rm -rf _build
  make APOLLO_BOARD="$1" "_build/$1"
  make APOLLO_BOARD="$1" -C "_build" ${2:-}

  install_platform "$1"
}

################################################################################
# And now all of the platforms:

cd firmware

make_platform "samd11_xplained"
make_platform "qtpy" "uf2"
make_platform "cynthion_d11"
make_platform "cynthion_d21" "uf2"
cmake_platform "raspberry_pi_pico"
cmake_platform "waveshare_rp2040_zero"
cmake_platform "adafruit_qtpy_rp2040"
