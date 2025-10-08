class fifo_env extends uvm_env;
  
  `uvm_component_utils(fifo_env)
  fifo_write_agent wr_agt;
  fifo_read_agent rd_agt;
  virtual_seqr vseqr;
  fifo_scoreboard scb;
  fifo_coverage cov;
  
  function new(string name = "fifo_env", uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rd_agt = fifo_read_agent::type_id::create("rd_agt",this);
    wr_agt = fifo_write_agent::type_id::create("wr_agt",this);
    vseqr = virtual_seqr::type_id::create("vseqr",this);
    scb = fifo_scoreboard::type_id::create("scb",this);
    cov = fifo_coverage::type_id::create("cov",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vseqr.rd_seqr = rd_agt.rd_seqr;
    vseqr.wr_seqr = wr_agt.wr_seqr;
    wr_agt.wr_mon.analysis_write_port.connect(scb.analysis_write_imp);
    rd_agt.rd_mon.analysis_read_port.connect(scb.analysis_read_imp);
    wr_agt.wr_mon.analysis_write_cg_port.connect(cov.analysis_write_cg_imp);
    rd_agt.rd_mon.analysis_read_cg_port.connect(cov.analysis_read_cg_imp);
  endfunction
endclass
