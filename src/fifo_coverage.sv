`uvm_analysis_imp_decl(_read)
`uvm_analysis_imp_decl(_write)
class coverage extends uvm_component;
        `uvm_component_utils(coverage);

        uvm_analysis_imp_read #(rd_seq_item, coverage) rd_item_collect_cov;
        uvm_analysis_imp_write #(wr_seq_item, coverage) wr_item_collect_cov;

        wr_seq_item wr_pkt;
				rd_seq_item rd_pkt;

covergroup wr_cg;
                //wrst_n_cp : coverpoint wr_pkt.wrst_n;
                wdata_cp : coverpoint wr_pkt.wdata{
                                bins low = {[0 : (2**DSIZE) / 2]};
                                bins high = {[(2**DSIZE / 2) + 1 : 2 ** DSIZE - 1]};
                }
                winc_cp : coverpoint wr_pkt.winc;
                wfull_cp : coverpoint wr_pkt.wfull;
        endgroup

        covergroup rd_cg;
                //rrst_n_cp : coverpoint rd_pkt.rrst_n;
                rinc_cp : coverpoint rd_pkt.rinc;
                rempty_cp : coverpoint rd_pkt.rempty;
                rdata_cp : coverpoint rd_pkt.rdata{
                                bins low = {[0 : (2**DSIZE) / 2]};
                                bins high = {[(2**DSIZE / 2) + 1 : 2 ** DSIZE - 1]};
                }
        endgroup

        function new(string name = "cov", uvm_component parent = null);
                super.new(name, parent);
                wr_cg = new();
                rd_cg = new();
                rd_item_collect_cov = new("ricc", this);
                wr_item_collect_cov = new("wicc", this);
        endfunction

        function void write_write(wr_seq_item pkt);
                wr_pkt = pkt;
                wr_cg.sample();
        endfunction

        function void write_read(rd_seq_item pkt);
                rd_pkt = pkt;
                rd_cg.sample();
        endfunction
/*
        function void extract_phase(uvm_phase phase);
                super.extract_phase(phase);
                `uvm_info("COV", $sformatf("read coverage = %0f, write coverage = %0f", rd_cg.get_inst_coverage(), wr_cg.get_inst_coverage()), UVM_LOW);
        endfunction
*/
  function void report_phase(uvm_phase phase);
   super.report_phase(phase);
    $display("------------------------- WRITE - COVERAGE ------------------------------");
    $display("");
    $display(" !!!! WRITE MONITOR COVERAGE = %0.2f %% !!!!",wr_cg.get_coverage());
    $display("");
    $display("------------------------- WRITE -COVERAGE ------------------------------");
    $display("");
    $display("------------------------- READ - COVERAGE ------------------------------");
    $display("");
    $display(" !!!! READ MONITOR COVERAGE = %0.2f %% !!!!",rd_cg.get_coverage());
    $display("");
    $display("------------------------- READ - COVERAGE ------------------------------"); 
  endfunction

endclass
