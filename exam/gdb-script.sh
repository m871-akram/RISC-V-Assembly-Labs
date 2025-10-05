riscv32-unknown-elf-gdb -ex "set directories /matieres/3MMCEP/.kernel:$cdir:$cwd" -ex "target remote :1234" -ex "set prompt \001\033[1;36m\002(gdb-CEP) \001\033[0m\002" "$@"
