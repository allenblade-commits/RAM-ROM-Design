# Memory Module Designs in Verilog

## 🧠 Overview
This repository contains Verilog implementations and testbenches for various memory architectures:
- **Single Port RAM**
- **Dual Port RAM**
- **Read-Only Memory (ROM)**

Each design includes:
- Well-documented Verilog module code.
- Corresponding testbench to verify functionality.
- Waveform dump (`.vcd`) for simulation visualization.


---

## 🧩 1. Single Port RAM

### 📄 Description
A synchronous **Single Port RAM** that supports one read or write operation per clock cycle through a single address port.

### 🧱 Specifications
| Parameter | Description |
|------------|--------------|
| Data Width | 8 bits |
| Memory Depth | 64 locations |
| Address Width | 6 bits |
| Operation | Synchronous read/write |

### 🔍 Functionality
- On the rising edge of the clock:
  - If `we = 1`, data is written to the specified address.
  - If `we = 0`, data from the selected address is read to the output.

### 🧪 Testbench
The testbench performs:
- Sequential write operations.
- Multiple read operations.
- Overwrite and readback verification.


---
# ⚙️ 2. Dual Port RAM Design in Verilog

## 📘 Overview
This project implements and verifies a **Dual Port RAM** module using **Verilog HDL**.  
Dual Port RAM allows **simultaneous read and write operations** on two independent ports — enabling parallel data access for high-performance systems such as FIFOs, image buffers, and pipelined architectures.

The design includes:
- RTL design (`dual_port_ram.v`)
- Comprehensive testbench (`dual_port_ram_tb.v`)
- Simulation setup with waveform generation (`dump.vcd`)



## 🧩 Module Description

### 🔹 Dual Port RAM
Dual Port RAM provides **two separate access ports (A and B)**, each with:
- Independent **address**, **data**, and **write enable** signals
- A **shared clock** for synchronous operation

Both ports can operate concurrently, allowing parallel data transfers or simultaneous reads and writes.

### ⚙️ Specifications

| Parameter | Description |
|------------|--------------|
| Data Width | 8 bits |
| Memory Depth | 64 locations |
| Address Width | 6 bits |
| Operation | Synchronous Read/Write |
| Ports | Port A, Port B |
| Write Enable | Active High |
| Clock | Positive Edge Triggered |



## 🔍 Functional Description

### Port A Signals
| Signal | Direction | Description |
|---------|------------|-------------|
| `data_a` | Input | Data to write at address A |
| `addr_a` | Input | Address location for Port A |
| `we_a` | Input | Write enable for Port A |
| `q_a` | Output | Data read from Port A |

### Port B Signals
| Signal | Direction | Description |
|---------|------------|-------------|
| `data_b` | Input | Data to write at address B |
| `addr_b` | Input | Address location for Port B |
| `we_b` | Input | Write enable for Port B |
| `q_b` | Output | Data read from Port B |

### Common Signal
| Signal | Direction | Description |
|---------|------------|-------------|
| `clk` | Input | Common clock for both ports |



## 🧠 Working Principle

- Both **Port A** and **Port B** can **read or write** in the same clock cycle.
- The module supports **independent access**:
  - Port A can write while Port B reads (and vice versa).
- If both ports attempt to write to the **same address** simultaneously, the behavior is **undefined** (implementation-dependent).

## 🧪 Testbench Description

### Testbench File: `dual_port_ram_tb.v`

The testbench performs the following:
1. Initializes the clock and stimulus signals.
2. Performs write operations on both ports.
3. Reads back data from previously written locations.
4. Tests simultaneous read and write operations on different ports.
5. Verifies concurrent port activity.

### Test Sequence Summary
| Time (ns) | Operation |
|------------|------------|
| 0–10 | Write `0x33` to address `1` (Port A), `0x44` to address `2` (Port B) |
| 10–20 | Write `0x55` to address `3` (Port A), Read address `1` (Port B) |
| 20–30 | Read address `2` (Port A), Read address `3` (Port B) |
| 30–40 | Write `0x77` to address `2` (Port B), Read address `1` (Port A) |

---


# 🧠 3. Read-Only Memory (ROM) Design in Verilog

## 📘 Overview
This project implements and verifies a **Read-Only Memory (ROM)** module using **Verilog HDL**.  
The ROM is a **non-volatile memory** structure used to store predefined data that can only be read during operation — not written or modified dynamically.

This design includes:
- **RTL Design**: `rom.v`
- **Testbench**: `rom_tb.v`
- **Simulation Waveform Generation**: `dump.vcd`



## 🧩 Module Description

### 🔹 ROM (Read-Only Memory)

The **ROM module** reads fixed data values stored in memory.  
The memory is initialized at design time using the `initial` block, and data is retrieved based on the **address input** when the **enable signal** (`en`) is active.

### ⚙️ Specifications

| Parameter | Description |
|------------|--------------|
| Data Width | 4 bits |
| Memory Depth | 16 locations |
| Address Width | 4 bits |
| Operation | Synchronous Read |
| Enable Signal | Active High |
| Clock | Positive Edge Triggered |



## 🔍 Functional Description

| Signal | Direction | Width | Description |
|---------|------------|--------|-------------|
| `clk` | Input | 1 | Clock signal controlling read operation |
| `en` | Input | 1 | Enable signal — must be HIGH to read data |
| `addr` | Input | 4 | Address input to select a memory location |
| `data` | Output | 4 | Output data from the selected address |



## 🧠 Working Principle

- On every **positive edge of the clock**, if `en = 1`, the ROM outputs the data corresponding to the address provided.
- If `en = 0`, the output becomes undefined (`xxxx`), representing an inactive or tri-stated condition.
- The contents of the ROM are **preloaded** during synthesis using the `initial` block.

### Memory Contents Example

| Address | Data |
|----------|------|
| 0 | `0010` |
| 1 | `0010` |
| 2 | `1110` |
| 3 | `0010` |
| 4 | `0100` |
| 5 | `1010` |
| 6 | `1100` |
| 7 | `0000` |
| 8 | `1010` |
| 9 | `0010` |
| 10 | `1110` |
| 11 | `0010` |
| 12 | `0100` |
| 13 | `1010` |
| 14 | `1100` |
| 15 | `0000` |



## 🧪 Testbench Description

### Testbench File: `rom_tb.v`

The testbench verifies the functionality of the ROM by performing read operations under various enable conditions.

### 🧠 Test Scenarios
| Step | Enable (`en`) | Address (`addr`) | Expected Output (`data`) | Description |
|------|----------------|------------------|----------------------------|--------------|
| 1 | 0 | `0000` | `xxxx` | ROM disabled |
| 2 | 1 | `1010` | `1110` | Read address 10 |
| 3 | 1 | `0110` | `1100` | Read address 6 |
| 4 | 1 | `0011` | `0010` | Read address 3 |
| 5 | 0 | `1111` | `xxxx` | Disabled read |
| 6 | 1 | `1000` | `1010` | Read address 8 |
| 7 | 1 | `0000` | `0010` | Read address 0 |
| 8 | 1 | `xxxx` | `xxxx` | Undefined address input |

---


