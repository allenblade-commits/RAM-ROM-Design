/*
----------------------------------------------------------------------------------
Name    : Allen Stanley
Title   : Read-Only Memory (ROM)
Date    : 04-10-2025
----------------------------------------------------------------------------------
Description:
This module implements a **Read-Only Memory (ROM)** with 16 memory locations, 
each storing 4-bit data. The ROM contents are pre-initialized using an `initial` block.

Features:
- 4-bit data width per memory location.
- 16 addressable memory locations (address range: 0–15).
- Synchronous read operation on the rising edge of the clock.
- Data output is valid only when the `en` (enable) signal is high.

Ports:
  - clk         : Clock input. Data is read on the rising edge.
  - en          : Enable signal. When low, output is undefined (`xxxx`).
  - addr [3:0]  : 4-bit address input to select one of 16 memory locations.
  - data [3:0]  : 4-bit output data corresponding to the selected address.

Behavior:
- On each rising edge of the clock:
    - If `en` is high, the ROM outputs the stored value at address `addr`.
    - If `en` is low, the output `data` is set to `4'bxxxx` (undefined).
- The ROM contents are defined at initialization and cannot be modified during runtime.
----------------------------------------------------------------------------------
*/

module rom (
  input clk,              // Clock input (rising edge-triggered)
  input en,               // Enable signal (active high)
  input [3:0] addr,       // 4-bit address input (0–15)
  output reg [3:0] data   // 4-bit output data
);
  
  // Declare ROM with 16 memory locations, each 4 bits wide
  reg [3:0] mem [15:0];
  
  // Synchronous read operation
  always @ (posedge clk) 
    begin
      if (en)
        // Read data from the ROM at the specified address
        data <= mem[addr];
      else 
        // Output undefined when ROM is disabled
        data <= 4'bxxxx;
    end
  
  // Initialize ROM contents
  initial 
    begin    
      mem[0]  = 4'b0010;
      mem[1]  = 4'b0010;
      mem[2]  = 4'b1110;
      mem[3]  = 4'b0010;
      mem[4]  = 4'b0100;
      mem[5]  = 4'b1010;
      mem[6]  = 4'b1100;
      mem[7]  = 4'b0000;
      mem[8]  = 4'b1010;
      mem[9]  = 4'b0010;
      mem[10] = 4'b1110;
      mem[11] = 4'b0010;
      mem[12] = 4'b0100;
      mem[13] = 4'b1010;
      mem[14] = 4'b1100;
      mem[15] = 4'b0000;
    end    

endmodule
