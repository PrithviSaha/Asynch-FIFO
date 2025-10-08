`include "defines.svh"

class fifo_test extends uvm_test;

  `uvm_component_utils(fifo_test)

  fifo_env env;
  fifo_vsequence vseq;

  function new(string name = "fifo_test", uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fifo_env::type_id::create("env",this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    vseq = fifo_vsequence::type_id::create("vseq");
    vseq.start(env.vseqr);
    phase.drop_objection(this);
  endtask
endclass

