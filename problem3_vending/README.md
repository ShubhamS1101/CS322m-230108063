# Vending Machine FSM (Mealy)

## 📌 Problem Description
We design a *Mealy FSM vending machine* with the following behavior:

- **Item price = 15 units**  
- **Accepted coins:**
  - 01 → 5 units  
  - 10 → 10 units  
  - 00 → idle (no coin)  
  - 11 → invalid (ignored)  
- When the total ≥ 15:
  - `dispense = 1` for **1 clock cycle**  
  - After dispensing, the total resets to 0  
- **Reset:** synchronous, active-high  

This design uses a **Mealy FSM** because the outputs depend on both the current state and the present input.

---

## ⚙ Files in this Project
- `vending_mealy.v` → FSM implementation of the vending machine  
- `tb_vending_mealy.v` → Testbench that drives coin sequences and validates output  
- `README.md` → Documentation file (this file)  
- `waves/vending.vcd` → VCD file for GTKWave visualization  
- `waves/wave_image.png.png` → Example waveform screenshot  

---

## 🛠 Compilation & Simulation Steps
1. Compile with Icarus Verilog  
```bash
iverilog -o vending_tb vending_mealy.v tb_vending_mealy.v
```

2. Run the Simulation  
```bash
vvp vending_tb
```

This generates `vending.vcd`.

3. Visualize with GTKWave  
```bash
gtkwave waves/vending.vcd
```

In GTKWave, add signals: `clk, rst, coin, dispense, state_present`.

---

## 📊 FSM Design

### States (encoded in `state_present`)
- **s0** → total = 0  
- **s5** → total = 5  
- **s10** → total = 10  

### Transitions
- From **s0**:
  - coin=01 → s5  
  - coin=10 → s10  
- From **s5**:
  - coin=01 → s10  
  - coin=10 → Vend (15) → s0, dispense=1  
- From **s10**:
  - coin=01 → Vend (15) → s0, dispense=1  
  - coin=10 → Vend (≥15, treat as 20) → s0, dispense=1  

---

## ⏱ Expected Waveform Behavior
- After reset, FSM starts in **s0**.  
- Example sequence:  

| Time  | Coin Input | State Transition | Outputs                  |
|-------|------------|------------------|--------------------------|
| 10ns  | 01 (5)     | s0 → s5          | dispense=0               |
| 20ns  | 10 (10)    | s5 → s0 (vend)   | dispense=1 (1 cycle)     |
| 30ns  | 10 (10)    | s0 → s10         | dispense=0               |
| 40ns  | 01 (5)     | s10 → s0 (vend)  | dispense=1 (1 cycle)     |

- `dispense` pulses high for one cycle at vending events.

---

## 🧪 Testbench Features
The testbench applies:
- Reset at the beginning.  
- Multiple coin input streams to test:  
  - **5 + 10 = 15** → dispense once.  
  - **10 + 5 = 15** → dispense once.  
  - **10 + 10 = 20** → still dispense once (no change).  
  - Idle cycles and invalid inputs → no false triggers.  
- Generates `vending.vcd` for waveform analysis.  

---

✅ With this README, anyone can compile, run, and visualize the vending machine FSM design, while understanding the states, transitions, and testbench validation.
