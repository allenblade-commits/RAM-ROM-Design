/*
----------------------------------------------------------------------------------
Name    : Allen Stanley
Title   : Dual Port RAM Testbench
Date    : 04-10-2025
----------------------------------------------------------------------------------
Description:
This is the **testbench** for verifying the functionality of the *Dual Port RAM* module.

The testbench simulates independent read and write operations through two ports 
(Port A and Port B) to validate correct parallel access and data consistency.

Simulation Steps:
1. Initializes the clock signal and waveform dumping for visualization.
2. Performs simultaneous write operations from both ports.
3. Performs a combination of read and write operations to test independent control.
4. Verifies that both ports can access different addresses concurrently.
5. Confirms that data written through one port can be read from the other port.

Simulation Details:
- Clock period: 10 ns (T = 10 ns → 100 MHz)
- Waveform output: `dump.vcd` for GTKWave or equivalent viewer.

Signals:
  - data_a [7:0] : Data input for Port A.
  - data_b [7:0] : Data input for Port B.
  - addr_a [5:0] : Address input for Port A.
  - addr_b [5:0] : Address input for Port B.
  - we_a         : Write enable for Port A (active high).
  - we_b         : Write enable for Port B (active high).
  - clk          : Clock input for synchronous operations.
  - q_a [7:0]    : Data output from Port A.
  - q_b [7:0]    : Data output from Port B.
----------------------------------------------------------------------------------
*/

module dual_port_ram_tb;

  reg [7:0] data_a, data_b; // Input data for Port A and Port B
  reg [5:0] addr_a, addr_b; // Address for Port A and Port B
  reg we_a, we_b;           // Write enable for Port A and Port B
  reg clk;                  // Clock signal
  wire [7:0] q_a, q_b;      // Output data from Port A and Port B
  
  // Instantiate the Dual Port RAM module
  dual_port_ram dpr1(
    .data_a(data_a),
    .data_b(data_b),
    .addr_a(addr_a),
    .addr_b(addr_b),
    .we_a(we_a),
    .we_b(we_b),
    .clk(clk),
    .q_a(q_a),
    .q_b(q_b)
  );
  
  // Clock generation: toggles every 5 ns → 10 ns period
  initial begin
      $dumpfile("dump.vcd");             // Create VCD file for waveform viewing
      $dumpvars(1, dual_port_ram_tb);    // Dump testbench signals
      clk = 1'b1;                        // Initialize clock
      forever #5 clk = ~clk;             // Generate periodic clock
  end
  
  // Test sequence to verify dual-port behavior
  initial begin
      // Step 1: Write different data to two different addresses
      data_a = 8'h33;  // Data for Port A
      addr_a = 6'h01;  // Address 1 for Port A
      data_b = 8'h44;  // Data for Port B
      addr_b = 6'h02;  // Address 2 for Port B
      we_a = 1'b1;     // Enable write on Port A
      we_b = 1'b1;     // Enable write on Port B
      #10;              // Wait one clock cycle
      
      // Step 2: Port A writes new data, Port B reads from address 1
      data_a = 8'h55;  
      addr_a = 6'h03;  // Port A writes at address 3
      addr_b = 6'h01;  // Port B reads from address 1
      we_b = 1'b0;     // Disable write on Port B
      #10;
      
      // Step 3: Both ports perform read operations
      addr_a = 6'h02;  // Read from address 2
      addr_b = 6'h03;  // Read from address 3
      we_a = 1'b0;     // Disable write on Port A
      #10;
      
      // Step 4: Port B overwrites address 2, Port A reads from address 1
      addr_a = 6'h01;  // Read from address 1
      data_b = 8'h77;  // New data to write on Port B
      addr_b = 6'h02;  // Address 2 for Port B
      we_b = 1'b1;     // Enable write on Port B
      #10;
  end
  
  // Stop simulation after 40 ns
  initial
    #40 $stop;
  
endmodule
