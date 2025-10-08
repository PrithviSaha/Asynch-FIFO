`include "defines.svh"

class fifo_write_monitor extends uvm_monitor;

  `uvm_component_utils(fifo_write_monitor)
  int count;
  virtual fifo_intf vif;
  uvm_analysis_port#(fifo_write_seq_item)analysis_write_port;
  uvm_analysis_port#(fifo_write_seq_item)analysis_write_cg_port;
  fifo_write_seq_item wr_mon_seq;

  function new(string name = "fifo_write_monitor", uvm_component parent);
    super.new(name,parent);
    analysis_write_port = new("analysis_write_port",this);
    analysis_write_cg_port = new("analysis_write_cg_port",this);
    wr_mon_seq = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_intf)::get(this,"","fifo_intf",vif))
      `uvm_error(get_type_name(), "Failed to get virtual interface")
  endfunction

  function void wr_monitor();
    wr_mon_seq.winc = vif.winc;
    //wr_mon_seq.wrst_n = vif.wrst_n;
    wr_mon_seq.wdata = vif.wdata;
    wr_mon_seq.wfull = vif.wfull;
    analysis_write_port.write(wr_mon_seq);
    analysis_write_cg_port.write(wr_mon_seq);
  endfunction

  task run_phase(uvm_phase phase);
    repeat(4)@(vif.mon_w_cb);
    forever begin
      repeat(1)@(vif.mon_w_cb);
      wr_monitor();
      `uvm_info(get_type_name(), $sformatf("| WRITE-MONITOR-INPUTS | WINC = %0d | WDATA = %0d | ",  wr_mon_seq.winc, wr_mon_seq.wdata ), UVM_MEDIUM)
      `uvm_info(get_type_name(), $sformatf("| WRITE_MONITOR-OUTPUT | WFULL = %0d |",wr_mon_seq.wfull), UVM_MEDIUM)
      $display("");
      repeat(1)@(vif.mon_w_cb);
    end
  endtask

endclass

class fifo_read_monitor extends uvm_monitor;

  `uvm_component_utils(fifo_read_monitor)
  fifo_read_seq_item rd_mon_seq;
  virtual fifo_intf vif;
  uvm_analysis_port#(fifo_read_seq_item)analysis_read_port;
  uvm_analysis_port#(fifo_read_seq_item)analysis_read_cg_port;

  function new(string name = "fifo_read_monitor",uvm_component parent);
    super.new(name,parent);
    analysis_read_port = new("analysis_read_port",this);
    analysis_read_cg_port = new("analysis_read_cg_port",this);
    rd_mon_seq = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_intf)::get(this,"","fifo_intf",vif))
      `uvm_error(get_type_name(), "Failed to get virtual interface")
  endfunction

  function void rd_monitor();
    rd_mon_seq.rinc = vif.rinc;
    //rd_mon_seq.rrst_n = vif.rrst_n;
    rd_mon_seq.rdata = vif.rdata;
    rd_mon_seq.rempty = vif.rempty;
    analysis_read_port.write(rd_mon_seq);
    analysis_read_cg_port.write(rd_mon_seq);
  endfunction

  task run_phase(uvm_phase phase);
    repeat(4)@(vif.mon_r_cb);
    forever begin
      repeat(1)@(vif.mon_r_cb);
      rd_monitor();
      `uvm_info(get_type_name(), $sformatf("| READ-MONITOR-INPUTS |  RINC = %0d |", rd_mon_seq.rinc), UVM_MEDIUM)
      `uvm_info(get_type_name(), $sformatf("| READ_MONITOR-OUTPUT | RDATA = %0d | REMPTY = %0d | ",rd_mon_seq.rdata,rd_mon_seq.rempty), UVM_MEDIUM)
      $display("");
      repeat(1)@(vif.mon_r_cb);
    end
  endtask

endclass
