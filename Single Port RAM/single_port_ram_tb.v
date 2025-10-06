/*
----------------------------------------------------------------------------------
Name    : Allen Stanley
Title   : Single Port RAM Testbench
Date    : 04-10-2025
----------------------------------------------------------------------------------
Description:
This is the **testbench** for verifying the functionality of the *Single Port RAM* module.

The testbench performs the following operations:
1. Initializes the clock and generates a periodic square wave.
2. Writes a sequence of 8-bit data values into consecutive RAM addresses.
3. Reads back the stored data from memory to verify correctness.
4. Performs both write and read operations to confirm proper memory behavior.

Simulation Details:
- Clock period: 10 ns (T = 10 ns → 100 MHz)
- Memory operations are performed on the rising edge of the clock.
- Waveform is dumped into `dump.vcd` for visualization in GTKWave or similar tools.

Signals:
  - data [7:0] : Input data to be written into memory.
  - addr [5:0] : Address for read/write operations.
  - we         : Write enable control signal.
  - clk        : Clock signal.
  - q [7:0]    : Output data read from memory.
----------------------------------------------------------------------------------
*/

module single_port_ram_tb;

  reg [7:0] data;   // Input data to be written into memory
  reg [5:0] addr;   // Address input (6 bits for 64 locations)
  reg we;           // Write enable signal (active high)
  reg clk;          // Clock signal
  wire [7:0] q;     // Output data read from memory
  	
  // Instantiate the Single Port RAM module
  single_port_ram spr1(
    .data(data),
    .addr(addr),
    .we(we),
    .clk(clk),
    .q(q)
  );
  
  // Clock generation: toggles every 5 ns → 10 ns period
  initial begin
      $dumpfile("dump.vcd");             // Create dump file for waveform
      $dumpvars(1, single_port_ram_tb);  // Dump testbench signals
      clk = 1'b1;                        // Initialize clock to logic high
      forever #5 clk = ~clk;             // Generate clock with 10 ns period
  end
  
  // Test sequence: perform write and read operations
  initial begin
      // Write operation 1
      data = 8'h01;  // Data to write
      addr = 5'd0;   // Address 0
      we = 1'b1;     // Enable write
      #10;
           
      // Write operation 2
      data = 8'h02;  
      addr = 5'd1;     
      #10;
      
      // Write operation 3
      data = 8'h03;
      addr = 5'd2;     
      #10;
      
      // Read operation 1
      addr = 5'd0;
      we = 1'b0;     // Disable write, read from address 0
      #10;
      
      // Read operation 2
      addr = 5'd1;
      #10;
      
      // Read operation 3
      addr = 5'd2;
      #10;
      
      // Overwrite address 1
      data = 8'h04;
      addr = 5'd1;
      we = 1'b1;     // Write new data to address 1
      #10;
      
      // Read back overwritten data
      addr = 5'd1;
      we = 1'b0;
      #10;
      
      // Read from address 3 (uninitialized)
      addr = 5'd3;
      #10;
  end
  
  // Stop simulation after 90 ns
  initial
    #90 $stop;
  
endmodule
