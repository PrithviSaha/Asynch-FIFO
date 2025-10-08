`include "defines.svh"

class fifo_wsequence extends uvm_sequence#(fifo_write_seq_item);

  `uvm_object_utils(fifo_wsequence)
  fifo_write_seq_item req;

  function new(string name = "fifo_write_sequence");
    super.new(name);
  endfunction

  task body();
    repeat(`num_of_txns) begin
    req = fifo_write_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {req.winc == 1;});
      finish_item(req);
    end
  endtask
endclass
class fifo_wsequence2 extends uvm_sequence#( fifo_write_seq_item);
  `uvm_object_utils(fifo_wsequence2)

   fifo_write_seq_item req;

  function new( string name = "fifo_wsequence2");
    super.new(name);
  endfunction: new

  task body();
    repeat(`num_of_txns) begin
      req =  fifo_write_seq_item::type_id::create("req");
      `uvm_rand_send_with(req, {req.winc == 1;})
    end
  endtask: body

endclass

class fifo_wsequence3 extends uvm_sequence#( fifo_write_seq_item);
  `uvm_object_utils(fifo_wsequence3)

   fifo_write_seq_item req;

  function new( string name = "fifo_wsequence3");
      super.new(name);
  endfunction: new

  task body();
    repeat(`num_of_txns) begin
      req =  fifo_write_seq_item::type_id::create("req");
      `uvm_rand_send_with(req, {req.winc == 1;})
    end
    repeat(`num_of_txns) begin
      req =  fifo_write_seq_item::type_id::create("req");
      `uvm_rand_send_with(req, {req.winc == 0;})
    end

  endtask: body
endclass : fifo_wsequence3


class fifo_rsequence extends uvm_sequence#(fifo_read_seq_item);

  `uvm_object_utils(fifo_rsequence)

  fifo_read_seq_item req;

  function new(string name = "fifo_read_sequence");
    super.new(name);
  endfunction

  task body();
    repeat(`num_of_txns) begin
    req = fifo_read_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {req.rinc == 1;});
      finish_item(req);
    end
  endtask
endclass

class fifo_rsequence2 extends uvm_sequence#( fifo_read_seq_item);
  `uvm_object_utils(fifo_rsequence2)

   fifo_read_seq_item req;

  function new( string name = "fifo_rsequence2");
      super.new(name);
  endfunction: new

  task body();
    repeat(`num_of_txns) begin
      req =  fifo_read_seq_item::type_id::create("req");
      `uvm_rand_send_with(req,{req.rinc == 0;})
    end
 endtask: body

endclass : fifo_rsequence2


class fifo_rsequence3 extends uvm_sequence#( fifo_read_seq_item);
  `uvm_object_utils(fifo_rsequence3)

   fifo_read_seq_item req;

  function new( string name = "fifo_rsequence3");
      super.new(name);
  endfunction: new

  task body();
    repeat(`num_of_txns) begin
      req =  fifo_read_seq_item::type_id::create("req");
      `uvm_rand_send_with(req,{req.rinc == 0;})
    end
   repeat(`num_of_txns) begin
      req =  fifo_read_seq_item::type_id::create("req");
      `uvm_rand_send_with(req,{req.rinc == 1;})
    end

 endtask: body

endclass : fifo_rsequence3


/*class fifo_virtual_sequence extends uvm_sequence;

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
endclass*/

class fifo_vsequence extends uvm_sequence;

  fifo_wsequence wseq;
  fifo_rsequence rseq;

  fifo_wsequence2 wseq2;
  fifo_rsequence2 rseq2;

  fifo_wsequence3 wseq3;
  fifo_rsequence3 rseq3;

  fifo_write_sequencer wr_seqr;
  fifo_read_sequencer rd_seqr;

  `uvm_object_utils(fifo_vsequence)
  `uvm_declare_p_sequencer(virtual_seqr)

  function new(string name = "fifo_vsequence");
    super.new(name);
  endfunction: new

  task body();
    wseq = fifo_wsequence::type_id::create("wseq");
    rseq = fifo_rsequence::type_id::create("rseq");
    wseq2 = fifo_wsequence2::type_id::create("wseq2");
    rseq2 = fifo_rsequence2::type_id::create("rseq2");
    wseq3 = fifo_wsequence3::type_id::create("wseq3");
    rseq3 = fifo_rsequence3::type_id::create("rseq3");

    fork
      wseq.start(p_sequencer.wr_seqr);
      rseq.start(p_sequencer.rd_seqr);
    join
    fork
      //wseq.start(p_sequencer.wr_seqr);
      //rseq3.start(p_sequencer.rd_seqr);
    join


    fork
      begin
        wseq2.start(p_sequencer.wr_seqr);
        rseq2.start(p_sequencer.rd_seqr);
      end
    join

    fork
      begin
        wseq3.start(p_sequencer.wr_seqr);
        rseq3.start(p_sequencer.rd_seqr);
      end
    join
    fork
      begin
        wseq3.start(p_sequencer.wr_seqr);
        rseq3.start(p_sequencer.rd_seqr);
        wseq2.start(p_sequencer.wr_seqr);
        rseq2.start(p_sequencer.rd_seqr);
      end
    join
  endtask: body

endclass: fifo_vsequence

