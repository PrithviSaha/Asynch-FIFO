`include "defines.svh"

class fifo_write_sequencer extends uvm_sequencer#(fifo_write_seq_item);

  `uvm_component_utils(fifo_write_sequencer)
  
  function new(string name = "write_sequencer", uvm_component parent);
    super.new(name,parent);
  endfunction

endclass

class fifo_read_sequencer extends uvm_sequencer#(fifo_read_seq_item);

  `uvm_component_utils(fifo_read_sequencer)

  function new(string name = "read_sequencer",uvm_component parent);
    super.new(name,parent);
  endfunction

endclass

class virtual_seqr extends uvm_sequencer;
  
  `uvm_component_utils(virtual_seqr)

  fifo_read_sequencer rd_seqr;
  fifo_write_sequencer wr_seqr;

  function new(string name = "virtual_seqr",uvm_component parent);
    super.new(name,parent);
  endfunction

endclass
