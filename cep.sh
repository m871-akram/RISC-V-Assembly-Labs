#!/bin/bash
# CEP local development helper
# Usage:
#   ./cep.sh build              — build the Docker image (once)
#   ./cep.sh shell [tp1]        — open a shell in a lab directory
#   ./cep.sh make tp1 pgcd      — build a specific target
#   ./cep.sh run  tp1 pgcd      — build and run in QEMU
#   ./cep.sh test tp1           — run verif_etud.sh for a lab

PROJECT="$(cd "$(dirname "$0")" && pwd)"
TOOLCHAIN="${CEP_TOOLCHAIN:-$PROJECT/riscv32-cep}"
IMAGE="cep-env"
QEMU="/matieres/3MMCEP/riscv32/bin/qemu-system-riscv32"

if [ ! -d "$TOOLCHAIN" ]; then
    echo "Toolchain not found at $TOOLCHAIN"
    echo "Set CEP_TOOLCHAIN or copy it there:"
    echo "  scp -r <login>@ensipcetu.ensimag.fr:/matieres/3MMCEP/riscv32/ ~/riscv32-cep/"
    exit 1
fi

docker_run() {
    TTY_FLAG=$([ -t 0 ] && echo "-it" || echo "-i")
    docker run --platform linux/amd64 --rm $TTY_FLAG \
        -v "$TOOLCHAIN":/matieres/3MMCEP/riscv32 \
        -v "$PROJECT":/work \
        -w "/work/${1:-}" \
        "$IMAGE" "${@:2}"
}

case "$1" in
    build)
        docker build --platform linux/amd64 -t "$IMAGE" "$PROJECT"
        ;;
    shell)
        docker_run "${2:-}" bash
        ;;
    make)
        # ./cep.sh make tp1 pgcd
        docker_run "$2" bash -c "make ${3:-}"
        ;;
    run)
        # ./cep.sh run tp1 pgcd
        docker_run "$2" bash -c "make $3 && $QEMU -machine cep -nographic -bios none -kernel $3"
        ;;
    test)
        # ./cep.sh test tp1
        docker_run "$2" bash -c "../common/verif_etud.sh"
        ;;
    *)
        echo "Usage: $0 {build|shell|make|run|test} [args]"
        echo "  build              build the Docker image"
        echo "  shell [tp1]        open a shell (optionally in a lab dir)"
        echo "  make  <tp> <target> build a target (e.g. make tp1 pgcd)"
        echo "  run   <tp> <target> build and run in QEMU"
        echo "  test  <tp>         run all tests for a lab"
        ;;
esac
