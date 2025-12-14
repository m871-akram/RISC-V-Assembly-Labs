# RISC-V Assembly Learning Project (CEP Platform)

An **academic project** for mastering **RISC-V assembly language** (RV32I/M instruction set) through progressive exercises. This project pairs C implementations with hand-written RISC-V assembly, targeting a custom embedded platform (CEP - Custom Embedded Platform).



##  Project Structure

The project is organized into 5 progressive lab assignments (tp1-tp5), each building on fundamental assembly concepts:

### tp1: Basic Arithmetic & Algorithms
- GCD (PGCD) using Euclid's algorithm
- Array summation with different strategies
- Multiplication algorithms (simple, Egyptian, native)

### tp2: Control Flow & Recursion
- Conditional statements and branching
- Recursive functions (factorial, Fibonacci)
- String manipulation basics

### tp3: Data Structures
- String operations (length, reversal)
- Linked list manipulation
- Array sorting algorithms
- Structure handling in assembly

### tp4: Optimization Techniques
- Binary search trees (BST)
- Tail-call optimization
- Performance comparison: naive → optimized → super-optimized
- Loop unrolling and register optimization

### tp5: Interrupts & Hardware
- Timer-based interrupts (CLINT)
- External interrupts (PLIC)
- LED and push-button I/O
- HDMI frame buffer manipulation

##  Quick Start

### Prerequisites

- **RISC-V Toolchain**: `riscv32-unknown-elf-gcc` (GCC cross-compiler)
- **QEMU**: `qemu-system-riscv32` (for emulation)
- **Build Tools**: `make`, `flex`, `bison`
- **Debugger**: `riscv32-unknown-elf-gdb`

Set the toolchain path (if not in default location):
```bash
export RVDIR=/path/to/riscv
```

### Step-by-Step: Build and Run

#### 1. **Navigate to a Lab Directory**

```bash
cd tp1  # Start with tp1, or choose tp2-tp5
```

#### 2. **Build All Exercises in the Lab**

```bash
make
```

This will:
- Compile all `.c` files to `.o` object files
- Assemble all `fct_*.s` files to `.o` object files
- Validate assembly structure (label ordering, context blocks)
- Link C and assembly objects into executable binaries
- Generate `.ctxt`, `.fun`, and `.stxetd` validation files

**Expected output**: Binary files (`pgcd`, `somme`, `mult_egypt`, etc.) appear in the directory.

#### 3. **Build a Specific Exercise**

```bash
make pgcd
```

This builds only the `pgcd` binary from `pgcd.c` + `fct_pgcd.s`.

#### 4. **Run the Binary in QEMU**

```bash
qemu-system-riscv32 -machine cep -nographic -bios none -kernel pgcd
```

**Expected output**:
```
PGCD calculé
	en C : 5
	en assembleur: 5
```

Press `Ctrl+A` then `X` to exit QEMU.

#### 5. **Run All Automated Tests**

```bash
../common/verif_etud.sh
```

This script:
- Builds all exercises in the current lab
- Runs each binary in QEMU
- Compares output with expected results in `test/<name>.sortie`
- Reports pass/fail status with colored output

**Expected output**:
```
pgcd................OK
somme...............OK
mult_egypt..........OK
```

#### 6. **Debug with GDB**

**Terminal 1** - Start QEMU in debug mode:
```bash
qemu-system-riscv32 -machine cep -nographic -bios none -s -S -kernel pgcd
```
(waits for debugger connection on port 1234)

**Terminal 2** - Connect GDB:
```bash
riscv32-unknown-elf-gdb -ex "target remote :1234" pgcd

# Inside GDB:
(gdb) break pgcd          # Set breakpoint at function
(gdb) continue            # Start execution
(gdb) info registers      # View register contents
(gdb) stepi               # Step one assembly instruction
(gdb) x/10i $pc           # Examine next 10 instructions
```

Or use the provided script:
```bash
cd ../exam
./gdb-script.sh ../tp1/pgcd
```

#### 7. **Clean Build Artifacts**

```bash
make clean
```

Removes: `.o` files, binaries, `.ctxt`, `.fun`, `.stxetd`, and `.sortie` files.

### Common Build Errors & Solutions

| Error | Cause | Solution |
|-------|-------|----------|
| `Étiquette de la fonction X manquante` | Missing function label | Add `function_name:` label |
| `Attention à l'étiquette X_fin_prologue` | Missing prologue label | Add `function_name_fin_prologue:` label |
| `Les étiquettes dans votre fonction doivent être, dans l'ordre` | Wrong label order | Order: `function:` → `_fin_prologue:` → `_debut_epilogue:` → `ret` |
| `access fault` (runtime) | Invalid memory access | Check memory alignment, verify addresses |
| `Illegal instruction` (runtime) | Invalid opcode or unimplemented instruction | Verify RISC-V syntax, check ISA extension requirements |



### File Organization Pattern

Each exercise follows this structure:

```
<name>.c           # C driver with main() and test harness
fct_<name>.s       # RISC-V assembly implementation
<name>             # Compiled binary (created by make)
test/<name>.sortie # Expected output for validation
```

**Example**: `pgcd.c` + `fct_pgcd.s` → `pgcd` binary

### Assembly Function Template

Every assembly function must follow this structure:

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
    # Function body here
function_name_debut_epilogue:
    ret
```

**Important**: The label order is strictly enforced by build scripts.

##  Technical Details

### RISC-V Calling Convention

| Register | Usage | Preserved? |
|----------|-------|-----------|
| `a0-a7`  | Arguments & return values | No |
| `t0-t6`  | Temporary registers | No |
| `s0-s11` | Saved registers | Yes (by callee) |
| `sp`     | Stack pointer | Yes |
| `ra`     | Return address | Yes (save before `call`) |

### Compilation Flags

- **ABI**: `-mabi=ilp32` (32-bit integers, longs, pointers)
- **ISA**: `-march=rv32im` (M extension for multiply/divide)
- **Standard**: `-std=c99` with `-Wall -Wextra`
- **Linking**: `-nostartfiles -nostdlib -static -T cep.ld`

### CEP Platform Peripherals

Memory-mapped I/O devices:

| Device | Base Address | Description |
|--------|--------------|-------------|
| LEDs | `0x30000000` | Output display |
| Push Buttons | `0x30000008` | Input polling/interrupts |
| PLIC | `0x0c000000` | External interrupt controller |
| CLINT | `0x02000000` | Timer and software interrupts |
| Frame Buffer | `0x70000000` | HDMI video output (720p/1080p) |



##  Validation & Testing

The `verif_etud.sh` script automates testing:

1. Compiles each exercise
2. Runs binary in QEMU emulator
3. Compares output with `test/<name>.sortie`
4. Reports errors: "access fault", "Illegal instruction"

### Test Status Badges


[![ lastUPDATE](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/lastupdate.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/0_lastupdate.log)

## tp1

Niveau 1 : 
[![pgcd status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/pgcd.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/pgcd.log)
[![somme status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/somme.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/somme.log)
[![sommeMem status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/sommeMem.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/sommeMem.log)
[![mult_simple status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/mult_simple.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/mult_simple.log)

Niveau 2 : 
[![mult_egypt status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/mult_egypt.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/mult_egypt.log)
[![somme8 status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/somme8.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/somme8.log)

Niveau 3 : 
[![mult_native status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/mult_native.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/mult_native.log)


## tp2

Niveau 1 : 
[![age status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/age.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/age.log)
[![hello status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/hello.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/hello.log)
[![affine status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/affine.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/affine.log)
[![fact status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/fact.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/fact.log)

Niveau 2 : 
[![val_binaire status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/val_binaire.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/val_binaire.log)

Niveau 3 : 
[![fact_papl status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/fact_papl.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/fact_papl.log)


## tp3

Niveau 1 : 
[![taille_chaine status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/taille_chaine.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/taille_chaine.log)
[![inverse_chaine status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/inverse_chaine.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/inverse_chaine.log)
[![tri_min status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/tri_min.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/tri_min.log)

Niveau 2 : 
[![inverse_liste status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/inverse_liste.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/inverse_liste.log)
[![decoupe_liste status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/decoupe_liste.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/decoupe_liste.log)

Niveau 3 : 
[![palin status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/palin.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/palin.log)


## tp4

Niveau 1 : 
[![abr_est_present status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/abr_est_present.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/abr_est_present.log)

Niveau 2 : 
[![abr_vers_tab status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/abr_vers_tab.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/abr_vers_tab.log)

Niveau 3 : 
[![abr_est_present_tail_call status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/abr_est_present_tail_call.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/abr_est_present_tail_call.log)
[![tri_nain status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/tri_nain.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/tri_nain.log)
[![tri_nain_opt status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/tri_nain_opt.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/tri_nain_opt.log)
[![tri_nain_superopt status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/tri_nain_superopt.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/tri_nain_superopt.log)


[![Performance du tri_nain_superopt](https://CEP_Deploy.pages.ensimag.fr/competition/lrhorfim.svg)](https://CEP_Deploy.pages.ensimag.fr/competition/lrhorfim.time)
[Classement pour tri_nain_superopt](https://CEP_Deploy.pages.ensimag.fr/competition/resultats.txt)
## tp5

Niveau 1 : 
[![it status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/it.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/it.log)

Niveau 2 : 
[![timer status](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/timer.svg)](https://CEP_Deploy.pages.ensimag.fr/CEP_TP_G4_2024_2025/EvalEP/lrhorfim_eval/timer.log)

