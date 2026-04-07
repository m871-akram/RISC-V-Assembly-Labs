# CEP RISC-V development environment
# Requires the CEP toolchain mounted at /matieres/3MMCEP/riscv32
# See cep.sh for usage

FROM --platform=linux/amd64 ubuntu:22.04

RUN apt-get update -qq && apt-get install -y \
    make bison flex gawk libmpc3 \
    libglib2.0-0 libpixman-1-0 libslirp0 libfdt1 libepoxy0 \
    libpng16-16 libjpeg8 libsdl2-2.0-0 libnuma1 libgbm1 \
    libgtk-3-0 libcairo2 libgdk-pixbuf-2.0-0 libx11-6 \
    libasound2 libpulse0 libaio1 libcurl4 \
    && rm -rf /var/lib/apt/lists/*

ENV RVDIR=/matieres/3MMCEP/riscv32
ENV PATH="/matieres/3MMCEP/riscv32/bin:$PATH"

WORKDIR /work
