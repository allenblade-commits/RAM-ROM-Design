/*
----------------------------------------------------------------------------------
Name    : Allen Stanley
Title   : Read-Only Memory (ROM) Testbench
Date    : 04-10-2025
----------------------------------------------------------------------------------
Description:
This is the **testbench** for verifying the functionality of the *Read-Only Memory (ROM)* module.

The testbench performs a series of read operations from various memory addresses 
to validate the ROM’s behavior when the enable signal is active and inactive.

Simulation Steps:
1. Initializes the clock and waveform dumping for visualization.
2. Disables the ROM initially to verify the undefined output behavior (`xxxx`).
3. Sequentially enables the ROM and reads data from different addresses.
4. Disables and re-enables the ROM to confirm proper control of the `en` signal.
5. Tests undefined address input behavior at the end of simulation.

Simulation Details:
- Clock period: 10 ns (T = 10 ns → 100 MHz)
- Output waveform file: `dump.vcd` (for viewing in GTKWave or similar tools)

Signals:
  - clk        : Clock signal for synchronous operation.
  - en         : Enable signal (active high).
  - addr [3:0] : 4-bit address to select memory location (0–15).
  - data [3:0] : 4-bit data output from the ROM.
----------------------------------------------------------------------------------
*/

module rom_tb;

  reg clk;         // Clock signal
  reg en;          // Enable signal
  reg [3:0] addr;  // 4-bit address input
  wire [3:0] data; // 4-bit output data
  
  // Instantiate the ROM module
  rom r1(
    .clk(clk),
    .en(en),
    .addr(addr),
    .data(data)
  );
  
  // Clock generation: toggles every 5 ns → 10 ns period
  initial begin
      $dumpfile("dump.vcd");          // Create waveform dump file
      $dumpvars(1, rom_tb);           // Dump all testbench signals
      clk = 1'b1;                     // Initialize clock to high
      forever #5 clk = ~clk;          // Generate a 10 ns clock period
  end
  
  // Test sequence to verify ROM functionality
  initial begin
      // Step 1: ROM disabled — output should be undefined (xxxx)
      en = 1'b0;
      #10;
      
      // Step 2: Enable ROM and read data from address 10 (0xA)
      en = 1'b1;
      addr = 4'b1010;
      #10;
      
      // Step 3: Read from address 6
      addr = 4'b0110;
      #10;
      
      // Step 4: Read from address 3
      addr = 4'b0011;
      #10;
      
      // Step 5: Disable ROM and access address 15 (output should be xxxx)
      en = 1'b0;
      addr = 4'b1111;
      #10;
      
      // Step 6: Re-enable ROM and read from address 8
      en = 1'b1;
      addr = 4'b1000;
      #10;
      
      // Step 7: Read from address 0
      addr = 4'b0000;
      #10;
      
      // Step 8: Undefined address (testing don’t-care condition)
      addr = 4'bxxxx;
      #10;
  end
  
  // Stop simulation after 80 ns
  initial begin
      #80 $stop;
  end
  
endmodule  
