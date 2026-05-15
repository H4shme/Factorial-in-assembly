# factorial — x86-64 NASM · macOS

Computes `10!` in pure x86-64 NASM assembly, prints result to stdout via macOS syscalls.

## Requirements

- macOS 10.13+
- NASM (`brew install nasm`)
- Xcode CLT (`xcode-select --install`)

## Build & Run

```sh
nasm -f macho64 factorial.asm -o factorial.o && \
ld -o factorial factorial.o \

   -macos_version_min 10.13 \
   -lSystem \
   -L$(xcrun --show-sdk-path)/usr/lib && \
./factorial
```

**Terminal**
<img width="1458" height="232" alt="2026_05_15_0g6_Kleki" src="https://github.com/user-attachments/assets/85585f51-49ad-441e-bb34-9bea550fd73b" />

**Output:** `3628800`

## How It Works

### 1. Factorial loop (`.loop`)

| reg | role |
|-----|------|
| `rax` | accumulator (result), init `1` |
| `rcx` | counter, init `10` |

`imul rax, rcx` → `rax *= rcx`, then `rcx--` until `rcx == 1`.  
Result: `rax = 10! = 3628800`.

### 2. Digit extraction (`.extract`)

Repeatedly `div 10`:
- `rdx` = digit (remainder)
- `rdx + 48` → ASCII char
- `push rdx` onto stack (digits extracted LSD-first)
- `rcx` counts digits

### 3. Print (`.print`)

`pop rdx` → LIFO reversal → MSD-first order.  
Each digit written to `buf` (1-byte `.data` buffer), syscall `0x2000004` (write, fd=1).  
`loop .print` decrements `rcx` until zero.

### 4. Newline + exit

Writes `0x0A` to stdout, then `syscall 0x2000001` (exit 0).

## Syscalls Used

| id | name | args |
|----|------|------|
| `0x2000004` | `write` | `rdi=fd`, `rsi=buf`, `rdx=len` |
| `0x2000001` | `exit` | `rdi=code` |

## Change n

Edit line:
```asm
mov rcx, 10   ; <- change to desired n
```

> No overflow guard. `rax` is 64-bit → max safe n is `20` (`20! = 2432902008176640000 < 2^63`).  
> `n=21` overflows.

## Files

```
factorial.asm   source
factorial.o     object (generated)
factorial       binary (generated)
```
