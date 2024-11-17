# Docker setup to Compile, Run and Debug ARMv7 

This setup is supported on every platform supported by the `arm-linux-gnueabihf` toolchain

- **Dockerfile** is based on `ubuntu:latest`
- **arm.sh** is a shortand for Docker's command and automatize debugging using `quemu-arm` and `gdb-multiarch`

- **compose.yml** in Compose V2 format is optional for custom port mapping or volumes, **arm.sh** is enable to recognise *compose.yml* file and adapt. **ATTENTION**: you must change container name in **arm.sh** according to compose settings.

## Prerequisites
- Latest Docker CE release for you system (Windows/MacOS/Linux)
- Bash *(Use WSL on Windows)*

## Usage
To build Docker Image run `./arm.sh init`

Command available:
- `./arm.sh compile <infile> <outfile>` to compile your source
- `./arm.sh run <executable>` run your executable using *qemu-arm* emulation
- `./arm.sh debug <executable>` run your executable in *qemu-arm* and attach *gdb-multiarch* to its execution (killing execution on gdb kills it on qemu too, shutting down the current container)

## Contributors
Thanks to Prof. Marco Danelutto for Dockerfile base 

GPLv3 Public License 

