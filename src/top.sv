`include "defines.svh"
`include "FIFO.v"
//`include "uvm_macros.svh"
`include "fifo_package.sv"
`include "fifo_interface.sv"
//`include "FIFO.v"

import fifo_pkg::*;

module top;
        `include "uvm_macros.svh"
        import uvm_pkg::*;

        bit wclk, rclk;
        bit rrst_n, wrst_n;

        always #20 rclk = ~rclk;
        always #10 wclk = ~wclk;

        inf vif(rclk, rrst_n, wclk, wrst_n);

        event we, re;

        FIFO #(DSIZE, ASIZE) dut(.rdata(vif.rdata), .wfull(vif.wfull), .rempty(vif.rempty), .wdata(vif.wdata), .winc(vif.winc), .wclk(wclk), .wrst_n(wrst_n), .rinc(vif.rinc), .rclk(rclk), .rrst_n(rrst_n));

  initial begin
    rrst_n = 1'b1;
    #10 rrst_n = 1'b0;
    #20 rrst_n = 1'b1;
  end
  initial begin
    wrst_n = 1'b1;
    #5 wrst_n = 1'b0;
    #10 wrst_n = 1'b1;
  end
        initial begin
                uvm_config_db#(virtual inf)::set(null, "*", "vif", vif);
                uvm_config_db#(event)::set(null, "*", "we", we);
                uvm_config_db#(event)::set(null, "*", "re", re);
                run_test("reg_test");
        end
endmodule
