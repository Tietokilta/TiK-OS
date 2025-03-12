# TiK-OS

A NixOS based operating system that displays the [TiK infoscreen](https://tietokilta.fi/fi/infoscreen)

## Supported devices

- raspberry pi 3
- generic pc (same as builder host architecture)

## Building

### Pi

1. Run
```sh
nix build .#pi3
```
2. `.img` file is found under `result/sd-image`

### PC

1. Run
```sh
nix build .#pc
```
2. Bootable `.iso` file is found under `result/iso`

### Testing in a VM

You can test the (pc) OS in qemu by running the following command:
```sh
nix run .#vm
```

## Known issues

- Red and Blue colors seem to be inverted on rpi 3
