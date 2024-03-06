let
  sources = import ./sources.nix;
in
{ pkgs ? import sources.nixpkgs { } }:
{
  apollo-firmware-cynthion = import ./apollo-firmware.nix { target-board = "cynthion_d11"; };
  apollo-firmware-cynthion_d11 = import ./apollo-firmware.nix { target-board = "cynthion_d11"; };
  apollo-firmware-cynthion_d21 = import ./apollo-firmware.nix { target-board = "cynthion_d21"; };
  apollo-firmware-samd11_xplained = import ./apollo-firmware.nix { target-board = "samd11_xplained"; };
  apollo-firmware-qtpy = import ./apollo-firmware.nix { target-board = "qtpy"; };
  apollo-firmware-raspberry_pi_pico = import ./apollo-firmware.nix { target-board = "raspberry_pi_pico"; };
  apollo-firmware-waveshare_rp2040_zero = import ./apollo-firmware.nix { target-board = "waveshare_rp2040_zero"; };
  apollo-firmware-adafruit_qtpy_rp2040 = import ./apollo-firmware.nix { target-board = "adafruit_qtpy_rp2040"; };
}
