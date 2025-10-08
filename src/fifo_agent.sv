`include "defines.svh"

class fifo_write_agent extends uvm_agent;

  `uvm_component_utils(fifo_write_agent)

  fifo_write_driver wr_drv;
  fifo_write_monitor wr_mon;
  fifo_write_sequencer wr_seqr;

  function new(string name = "%0d", uvm_component parent);
    super.new(name,parent);
  endfunction 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_ACTIVE) begin 
      wr_drv = fifo_write_driver::type_id::create("wr_drv",this);
      wr_seqr = fifo_write_sequencer::type_id::create("wr_seqr",this);
    end
    wr_mon = fifo_write_monitor::type_id::create("wr_mon",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    wr_drv.seq_item_port.connect(wr_seqr.seq_item_export);
  endfunction
endclass

class fifo_read_agent extends uvm_agent;
  
  `uvm_component_utils(fifo_read_agent)
  
  fifo_read_driver rd_drv;
  fifo_read_monitor rd_mon;
  fifo_read_sequencer rd_seqr;

  function new(string name = "fifo_read_agent", uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_ACTIVE) begin
      rd_drv = fifo_read_driver::type_id::create("rd_drv",this);
      rd_seqr = fifo_read_sequencer::type_id::create("rd_seqr",this);
    end
    rd_mon = fifo_read_monitor::type_id::create("rd_mon",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    rd_drv.seq_item_port.connect(rd_seqr.seq_item_export);
  endfunction
endclass
