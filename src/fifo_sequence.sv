`include "defines.svh"

class fifo_write_sequence extends uvm_sequence#(fifo_write_seq_item);

  `uvm_object_utils(fifo_write_sequence)
  fifo_write_seq_item req;

  function new(string name = "fifo_write_sequence");
    super.new(name);
  endfunction

  task body();
    req = fifo_write_seq_item::type_id::create("req");
    repeat(`num_of_txns) begin
      start_item(req);
      assert(req.randomize() with {req.winc == 1;});
      finish_item(req);
    end
  endtask
endclass

class fifo_read_sequence extends uvm_sequence#(fifo_read_seq_item);

  `uvm_object_utils(fifo_read_sequence)

  fifo_read_seq_item req;

  function new(string name = "fifo_read_sequence");
    super.new(name);
  endfunction

  task body();
    req = fifo_read_seq_item::type_id::create("req");
    repeat(`num_of_txns) begin
      start_item(req);
      assert(req.randomize() with {req.rinc == 1;});
      finish_item(req);
    end
  endtask
endclass

class fifo_virtual_sequence extends uvm_sequence;

  `uvm_object_utils(fifo_virtual_sequence)
  fifo_write_sequence wr_base_seq;
  fifo_read_sequence rd_base_seq;

  fifo_write_sequencer wr_seqr;
  fifo_read_sequencer rd_seqr;

  `uvm_declare_p_sequencer(virtual_seqr)

  function new(string name = "fifo_virtual_sequence");
    super.new(name);
  endfunction

  task body();
    wr_base_seq = fifo_write_sequence::type_id::create("wr_base_seq");
    rd_base_seq = fifo_read_sequence::type_id::create("rd_base_seq");
    fork 
    wr_base_seq.start(p_sequencer.wr_seqr);
    rd_base_seq.start(p_sequencer.rd_seqr);
    join
  endtask
endclass
