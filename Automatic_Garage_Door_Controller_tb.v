module tb_Automatic_Garage_Door_Controller

// Testbench signals
reg UP_Max;
reg DN_Max;
reg Activate;
reg CLK;
reg RST;
wire UP_M;
wire DN_M;

// Instantiate the Device Under Test (DUT)
Automatic_Garage_Door_Controller dut (
    .UP_Max(UP_Max),
    .DN_Max(DN_Max),
    .Activate(Activate),
    .CLK(CLK),
    .RST(RST),
    .UP_M(UP_M),
    .DN_M(DN_M)
);

// Clock period and initialization
parameter CLOCK_PERIOD = 20; // Clock period = 1 / 50 MHz = 20 ns

// Clock generator
always #(CLOCK_PERIOD / 2) CLK = ~CLK;

// Test stimulus (behavior)
initial begin
  // Initial values
  UP_Max = 0;
  DN_Max = 0;
  Activate = 0;
  CLK = 0;
  RST = 0;

  // Reset Test
  #5 RST = 1;  // Reset Done
  #5 RST = 0;  // Reset Not Done
  #5 RST = 1;  // Reset Done
  
  // Move Up Motor Test
  #10 Activate = 1;
  #10 DN_Max = 1;   // Door is closed
  #10 UP_Max = 0;   // Door is not open
  #10 UP_Max = 1;   // Door is open
  #10 Activate = 0; // Deactivate

  // Move Down Motor Test
  #10 Activate = 1;
  UP_Max = 1; // Door is open
  #10 DN_Max = 0; // Door is not closed
  #10 DN_Max = 1; // Door is closed
  #10 Activate = 0; // Deactivate

  // Test Case 3: No activation, no movement (IDLE State)
  #20;
  Activate = 0;
  UP_Max = 0;
  DN_Max = 0;
   
  // Finish simulation
  #20;
  $finish;
end

// Monitor signals
initial begin
  $monitor("Time: %0t | RST: %b | Activate: %b | UP_Max: %b | DN_Max: %b | UP_M: %b | DN_M: %b", 
           $time, RST, Activate, UP_Max, DN_Max, UP_M, DN_M);
end

endmodule
