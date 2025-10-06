/*
----------------------------------------------------------------------------------
Name    : Allen Stanley
Title   : Dual Port RAM
Date    : 04-10-2025
----------------------------------------------------------------------------------
Description:
This module implements a **Dual Port RAM** (Random Access Memory) that supports 
independent read and write operations through two separate ports — Port A and Port B.

Features:
- 8-bit data width per memory location.
- 64 memory locations (address range: 0–63).
- Each port can independently perform read or write operations.
- Writes and reads are synchronous to the rising edge of the clock.
- Supports simultaneous operations on different addresses for Port A and Port B.

Ports:
  - data_a [7:0] : Input data for Port A.
  - data_b [7:0] : Input data for Port B.
  - addr_a [5:0] : 6-bit address for Port A.
  - addr_b [5:0] : 6-bit address for Port B.
  - we_a         : Write enable for Port A (active high).
  - we_b         : Write enable for Port B (active high).
  - clk          : Common clock input.
  - q_a [7:0]    : Output data from Port A.
  - q_b [7:0]    : Output data from Port B.

Behavior:
- On each rising edge of the clock:
    - If `we_a` is high, Port A writes `data_a` to `addr_a`.
    - If `we_a` is low, Port A reads data from `addr_a` into `q_a`.
    - If `we_b` is high, Port B writes `data_b` to `addr_b`.
    - If `we_b` is low, Port B reads data from `addr_b` into `q_b`.

Note:
- If both ports access the same address simultaneously (one writing and one reading),
  the behavior is undefined and depends on synthesis tool or FPGA memory implementation.
----------------------------------------------------------------------------------
*/

module dual_port_ram(
  input [7:0] data_a, data_b,    // Input data for Port A and Port B
  input [5:0] addr_a, addr_b,    // 6-bit address for each port (0–63)
  input we_a, we_b,              // Write enable signals for Port A and Port B
  input clk,                     // Common clock signal
  output reg [7:0] q_a, q_b      // Output data for Port A and Port B
);
  
  // Declare 64 memory locations, each 8 bits wide
  reg [7:0] ram [63:0]; 

  // Port A: Write/Read operations
  always @ (posedge clk)
    begin
      if (we_a)
        // Write data to memory at address specified by addr_a
        ram[addr_a] <= data_a;
      else
        // Read data from memory and assign it to q_a
        q_a <= ram[addr_a]; 
    end
  
  // Port B: Write/Read operations
  always @ (posedge clk)
    begin
      if (we_b)
        // Write data to memory at address specified by addr_b
        ram[addr_b] <= data_b;
      else
        // Read data from memory and assign it to q_b
        q_b <= ram[addr_b]; 
    end
  
endmodule
