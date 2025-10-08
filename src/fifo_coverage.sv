`uvm_analysis_imp_decl(_wr_mon_cg)
`uvm_analysis_imp_decl(_rd_mon_cg)

class fifo_coverage extends uvm_component;

  `uvm_component_utils(fifo_coverage)
  uvm_analysis_imp_wr_mon_cg#(fifo_write_seq_item, fifo_coverage)analysis_write_cg_imp;
  uvm_analysis_imp_rd_mon_cg#(fifo_read_seq_item, fifo_coverage)analysis_read_cg_imp;
    
  fifo_write_seq_item wr_seq;
  fifo_read_seq_item rd_seq;

  covergroup wr_mon_cgrp;
    WINC_CP : coverpoint wr_seq.winc;
    WDATA_CP : coverpoint wr_seq.wdata {
      bins write_data_low = {[0:127]};
      bins write_data_high = {[128:255]};
    }
    WFULL_CP : coverpoint wr_seq.wfull;

    WFULL_CP_x_WDATA_CP :  cross WFULL_CP,WDATA_CP;   

  endgroup

  covergroup rd_mon_cgrp;
    RINC_CP : coverpoint rd_seq.rinc;
    RDATA_CP : coverpoint rd_seq.rdata {
      bins read_data = {[0:255]};
    }
    REMPTY_CP : coverpoint rd_seq.rempty;

    REMPTY_CP_x_RINC_CP : cross REMPTY_CP, RINC_CP;
  endgroup  
  
  function new(string name = "fifo_coverage", uvm_component parent);
    super.new(name,parent);
    wr_mon_cgrp = new();
    rd_mon_cgrp = new();
    analysis_write_cg_imp = new("analysis_write_cg_imp",this);
    analysis_read_cg_imp = new("analysis_read_cg_imp",this);
  endfunction

  function void write_wr_mon_cg(fifo_write_seq_item req);
    wr_seq = req;
    wr_mon_cgrp.sample();
  endfunction

  function void write_rd_mon_cg(fifo_read_seq_item req);
    rd_seq = req;
    rd_mon_cgrp.sample();
  endfunction

  function void report_phase(uvm_phase phase);
   super.report_phase(phase);
    $display("------------------------- WRITE - COVERAGE ------------------------------");
    $display("");
    $display(" !!!! WRITE MONITOR COVERAGE = %0.2f %% !!!!",wr_mon_cgrp.get_coverage());
    $display("");
    $display("------------------------- WRITE -COVERAGE ------------------------------");
    $display("");
    $display("------------------------- READ - COVERAGE ------------------------------");
    $display("");
    $display(" !!!! READ MONITOR COVERAGE = %0.2f %% !!!!",rd_mon_cgrp.get_coverage());
    $display("");
    $display("------------------------- READ - COVERAGE ------------------------------"); 
  endfunction

  

endclass
