`include "defines.svh"
`include "uvm_macros.svh"
`include "fifo_interface.sv"
`include "FIFO.v"

module top;
  import uvm_pkg::*;
  import fifo_pkg::*;
  
  bit wclk;
  bit rclk;
  bit rrst_n;
  bit wrst_n;

  fifo_intf intf(wclk,wrst_n,rrst_n,rclk);

  FIFO dut(.rdata(intf.rdata), .wfull(intf.wfull), .rempty(intf.rempty), .wdata(intf.wdata), .winc(intf.winc), .wclk(wclk), .wrst_n(wrst_n), .rinc(intf.rinc), .rclk(rclk), .rrst_n(rrst_n));
 


  always #5 wclk = ~wclk;
  always #10 rclk = ~rclk;

  initial begin
    //#10;
    rrst_n = 0;
    #20;
    rrst_n = 1;
  end

  initial begin

    //#5;
    wrst_n = 0;
    #40;
    wrst_n = 1;

  end

  initial begin
//    #20;
//    wrst_n = 0;
//    #20;
//    wrst_n = 1;
    uvm_config_db#(virtual fifo_intf)::set(null, "*", "fifo_intf",intf);
    run_test("fifo_test");
  end

endmodule
