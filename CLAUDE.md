# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Academic RISC-V assembly project (CEP platform) pairing C implementations with hand-written RISC-V assembly (RV32I/M). Labs progress from basic arithmetic (tp1) through recursion (tp2), data structures (tp3), optimization (tp4), and hardware interrupts (tp5).

## Build & Run

**Prerequisites**: `riscv32-unknown-elf-gcc`, `qemu-system-riscv32`, `make`

```bash
# Set toolchain path if not at default /matieres/3MMCEP/riscv
export RVDIR=/path/to/riscv
```

```bash
cd tp1           # navigate to a lab directory
make             # build all exercises
make pgcd        # build a single exercise
make clean       # remove build artifacts
```

**Run in QEMU:**
```bash
qemu-system-riscv32 -machine cep -nographic -bios none -kernel pgcd
# Exit with Ctrl+A then X
```

**Run all tests for a lab:**
```bash
cd tp1
../common/verif_etud.sh
```

**Debug with GDB:**
```bash
# Terminal 1
qemu-system-riscv32 -machine cep -nographic -bios none -s -S -kernel pgcd
# Terminal 2
riscv32-unknown-elf-gdb -ex "target remote :1234" pgcd
```

## Architecture

Each exercise follows: `<name>.c` (C driver + test harness) + `fct_<name>.s` (assembly implementation) → `<name>` binary. Expected test output lives in `test/<name>.sortie`.

Shared build infrastructure is in `common/`:
- `rules.mk` — included by each lab's `Makefile`; defines compilation, assembly, linking, and validation targets
- `cep.ld` — linker script for CEP platform
- `cep_platform.h` — memory-mapped peripheral addresses (LEDs, push buttons, PLIC, CLINT, frame buffer)
- `verif_etud.sh` — automated test runner (builds → runs in QEMU → diffs output)
- `ordre_etiquettes.awk` — validates mandatory label ordering in `.s` files

## Assembly Function Requirements

Every `fct_*.s` file must follow this exact structure — label ordering is validated at build time:

```asm
/* DEBUT DU CONTEXTE
Fonction :
    function_name : feuille        # or non-feuille
Contexte :
    param1 : registre a0
    temp1  : registre t0
    local1 : pile *(sp+0)
FIN DU CONTEXTE */

function_name:
function_name_fin_prologue:
    # body
function_name_debut_epilogue:
    ret
```

Missing or misordered labels (`function:` → `_fin_prologue:` → `_debut_epilogue:` → `ret`) cause build errors.

## RISC-V Calling Convention

| Registers | Role | Callee-saved? |
|-----------|------|---------------|
| `a0–a7` | Arguments & return values | No |
| `t0–t6` | Temporaries | No |
| `s0–s11` | Saved registers | Yes |
| `sp` | Stack pointer | Yes |
| `ra` | Return address | Yes (save before `call`) |

## Compilation Flags

- ISA: `-march=rv32im` (M extension for multiply/divide)
- ABI: `-mabi=ilp32`
- Linking: `-nostartfiles -nostdlib -static -T cep.ld`

## CEP Platform Peripheral Addresses

| Device | Address |
|--------|---------|
| LEDs | `0x30000000` |
| Push Buttons | `0x30000008` |
| PLIC | `0x0c000000` |
| CLINT timer compare | `0x02004000` |
| Frame Buffer | `0x70000000` |

Full definitions in `common/cep_platform.h`.
