#!/bin/bash

COMPOSE="docker compose"
COMPOSE_FILE="compose.yml"
if [ -f $COMPOSE_FILE ]; then
  IS_COMPOSE=1
fi

ARGS="run --rm -it"
VOLUME="-v ./:/usr/src"

# ATTENTION TO CHANGE CONTAINER NAME IF COMPOSE IS USED
CONTAINER_NAME="strzelca/arm-linux-gnueabihf"

QEMU="qemu-arm"

CC="arm-linux-gnueabihf-gcc"
GDB="gdb-multiarch"
FLAGS="-z noexecstack -static -fno-pie -no-pie -ggdb3 -mcpu=cortex-a53 -march=armv7-a"

if [[ $IS_COMPOSE -eq 1 ]]; then
  case $1 in 
    init)
      $COMPOSE build
      ;;
    compile)
      $COMPOSE $ARGS $CONTAINER_NAME $CC $FLAGS $2 -o $3 
      ;; 
    run)
      $COMPOSE $ARGS $CONTAINER_NAME $QEMU $2
      ;;
    debug)
      $COMPOSE $ARGS -d --name="debugger" $CONTAINER_NAME $QEMU -g 9999 $2
      docker exec -it debugger $GDB -q --nh -ex "set architecture arm" -ex "set sysroot /lib/arm-linux-gnueabihf" -ex "file ${2}" -ex "target extended-remote :9999" -ex "layout split" -ex "break main" -ex "continue"
      sleep 1
      $COMPOSE down --remove-orphans
      ;;
  esac
else
  case $1 in
    init)
      docker build . -t $CONTAINER_NAME
      ;;
    compile)
      docker $ARGS $VOLUME $CONTAINER_NAME $CC $FLAGS $2 -o $3
      ;;
    run)
      docker $ARGS $VOLUME $CONTAINER_NAME $QEMU $2
      ;;
    debug)
      docker $ARGS $VOLUME -d --name="debugger" $CONTAINER_NAME $QEMU -g 9999 $2
      docker exec -it debugger $GDB -q --nh -ex "set architecture arm" -ex "set sysroot /lib/arm-linux-gnueabihf" -ex "file ${2}" -ex "target extended-remote :9999" -ex "layout split" -ex "break main" -ex "continue"
      ;;
  esac
fi
