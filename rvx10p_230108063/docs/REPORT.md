# RVX10-P: Five-Stage Pipelined RISC-V Core

**Course:** CS322M — Digital Logic and Computer Architecture  
**Instructor:** Dr. Satyajit Das, IIT Guwahati  
 

---

## 🔍 Project Overview

RVX10-P is a five-stage pipelined implementation of the RISC-V RV32I instruction set extended with ten custom ALU operations (RVX10 extension).  
It transforms the previously built single-cycle RVX10 processor into a higher-throughput design with instruction-level parallelism.

### Supported Instruction Sets
- **Base:** RV32I (arithmetic, logical, load/store, branch, and jump)
- **Extension:** 10 ALU operations under **RVX10** (ANDN, ORN, XNOR, MIN, MAX, MINU, MAXU, ROL, ROR, ABS)

---

## ⚙️ Pipeline Architecture

RVX10-P follows the classic **five-stage RISC pipeline**:

| Stage | Name | Description |
|-------|------|--------------|
| IF | Instruction Fetch | Fetch instruction and compute PC + 4 |
| ID | Instruction Decode | Decode, register read, and immediate generation |
| EX | Execute | ALU operation, branch evaluation |
| MEM | Memory | Data memory read/write |
| WB | Write Back | Write ALU/memory result to register file |

Each stage is separated by **pipeline registers**: IF/ID, ID/EX, EX/MEM, MEM/WB.

---

## 🧩 Major Modules and Responsibilities

| File | Module | Function |
|------|---------|-----------|
| `riscvpipeline.sv` | Top-Level | Connects datapath, controller, and memories |
| `datapath.sv` | Datapath | Implements all pipeline stages and register updates |
| `controller.sv` | Controller | Generates control signals based on opcode/funct fields |
| `maindec.sv` | Main Decoder | Decodes instruction type and produces control lines |
| `aludec.sv` | ALU Decoder | Decodes funct3/funct7 → ALU control codes |
| `alu.sv` | ALU | Executes arithmetic, logical, and RVX10 custom ops |
| `regfile.sv` | Register File | 32 × 32-bit register bank (x0 fixed to 0) |
| `imem.sv` | Instruction Memory | Loads program from `tests/rvx10_pipeline.hex` |
| `dmem.sv` | Data Memory | Supports word-level reads/writes |
| `hazard_unit.sv` | Hazard Detection | Detects load-use hazards and stalls pipeline |
| `forwarding_unit.sv` | Forwarding Unit | Resolves data hazards via bypass paths |
| `tb/tb_pipeline.sv` | Testbench | Runs simulation, dumps waveform, self-checks |
| `tests/rvx10_pipeline.hex` | Program | Test program loaded into instruction memory |

---

## 🧠 Control Path Details

The controller generates the following control signals:

| Signal | Function |
|---------|-----------|
| `RegWrite` | Enables register file write |
| `MemWrite` | Enables data memory write |
| `MemToReg` | Selects between ALU and memory data for write-back |
| `ALUSrc` | Selects between register operand or immediate |
| `Branch` | Activates branch logic |
| `Jump` | Enables PC update via jump target |

**Forwarding** and **hazard detection** logic ensure correct data flow:
- Forwarding paths from EX/MEM and MEM/WB to ALU inputs.
- One-cycle stall for load-use dependencies.
- Flush of IF/ID on taken branches.

---

## 🧮 ALU and RVX10 Extensions

The ALU supports both standard RV32I and RVX10 operations:

| ALU Control | Operation | Description |
|--------------|------------|-------------|
| 0000 | ADD | Arithmetic addition |
| 0001 | SUB | Arithmetic subtraction |
| 0010 | AND | Bitwise AND |
| 0011 | OR | Bitwise OR |
| 0100 | XOR | Bitwise XOR |
| 0101 | SLL | Logical shift left |
| 0110 | SRL | Logical shift right |
| 0111 | MIN | Minimum (signed) |
| 1000 | MAX | Maximum (signed) |

(Additional RVX10 ops such as ANDN, ORN, XNOR, ROL, ROR, ABS can be easily added to this decoder pattern.)

---

## 🧰 Verification and Testing

### Testbench:
- Loads `tests/rvx10_pipeline.hex` using `$readmemh`.
- Runs for 2000 ns and generates `dump.vcd`.
- Observes memory writes (`MEM[...] <= ...`) for correctness.
- Ends simulation using `$finish`.

### Test Program Summary:
```asm
addi x1, x0, 0
addi x2, x0, 1
add  x3, x1, x2
add  x4, x2, x3
sw   x4, 100(x0)
jal  x0, 0       # loop forever
