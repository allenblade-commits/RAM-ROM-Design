/*
----------------------------------------------------------------------------------
Name    : Allen Stanley
Title   : Single Port RAM
Date    : 04-10-2025
----------------------------------------------------------------------------------
Description:
This module implements a simple **Single Port RAM** (Random Access Memory) 
with synchronous write and asynchronous read behavior.

Features:
- 8-bit data width
- 64 memory locations (address range: 0–63)
- Data is written to memory on the rising edge of the clock when `we` (write enable) is high.
- When `we` is low, the address is latched, and the corresponding data is made available on output `q`.

Ports:
  - data [7:0] : 8-bit input data to be written into memory.
  - addr [5:0] : 6-bit address input (selects one of 64 memory locations).
  - we         : Write enable signal; when high, performs write operation.
  - clk        : Clock input; memory operations occur on the rising edge.
  - q [7:0]    : 8-bit output data from the addressed memory location.
----------------------------------------------------------------------------------
*/

module single_port_ram(
  input [7:0] data,   // Input data to be written into memory
  input [5:0] addr,   // 6-bit memory address input
  input we,           // Write enable signal (active high)
  input clk,          // Clock signal for synchronous operation
  output [7:0] q      // 8-bit output data from memory
);
  
  // Declare 64 memory locations, each 8 bits wide
  reg [7:0] ram [63:0]; 
  
  // Register to store the current address for read operation
  reg [5:0] addr_reg; 
 
  // Always block triggered on rising edge of clock
  always @ (posedge clk)
    begin
      if (we)
        // Write operation: store input data into memory at given address
        ram[addr] <= data;
      else
        // Read operation: latch the current address for data retrieval
        addr_reg <= addr; 
    end
 
  // Continuous assignment: output data corresponding to latched address
  assign q = ram[addr_reg];
  
endmodule
