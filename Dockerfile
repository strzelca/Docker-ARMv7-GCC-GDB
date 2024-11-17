FROM ubuntu:latest
LABEL authors="Marco Danelutto, Apollinaria Martiri"
RUN apt update
RUN apt install -y gcc-arm-linux-gnueabihf qemu-user gdb-multiarch
COPY . /usr/src 
WORKDIR /usr/src 
RUN mkdir -p /usr/src/target
