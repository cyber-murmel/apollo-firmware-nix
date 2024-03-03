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
      tar czf "_build/$1.tar.gz" "_build/$1/$f"
      install -m 0444 "_build/$1/$f" "$out/firmware/$1"
    fi
    if [ -r "_build/$f" ]; then
      mkdir -p "$out/firmware/$1"
      install -m 0444 "_build/$f" "$out/firmware/$1"
    fi
    # ls "$out/firmware/"
    # tar czf "$out/firmware/$1.tar.gz" "$out/firmware/$1"
  done
  if [ -r "_build/$1/$f" ]; then
    tar czf "_build/$1.tar.gz" "_build/$1/$f"
  fi
  if [ -r "_build/$f" ]; then
    tar czf  "_build/$1.tar.gz" "_build/$f"
  fi
  install -m 0444 "_build/$1.tar.gz" "$out/firmware/"
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

for item in "samd11_xplained" "cynthion_d11"
do
    if [ "$1" == "$item" ]; then
        echo $1
        make_platform $1
        exit
    fi
done

for item in "qtpy" "cynthion_d21"
do
    if [ "$1" == "$item" ]; then
        make_platform $1 "uf2"
        exit
    fi
done

for item in "raspberry_pi_pico" "waveshare_rp2040_zero" "adafruit_qtpy_rp2040"
do
    if [ "$1" == "$item" ]; then
        cmake_platform $1
        exit
    fi
done
