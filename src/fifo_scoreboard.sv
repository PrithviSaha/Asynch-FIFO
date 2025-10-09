`uvm_analysis_imp_decl(_wr_mon)
`uvm_analysis_imp_decl(_rd_mon)
`include "defines.svh"
class fifo_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(fifo_scoreboard)
  uvm_analysis_imp_wr_mon#(fifo_write_seq_item, fifo_scoreboard)analysis_write_imp;
  uvm_analysis_imp_rd_mon#(fifo_read_seq_item, fifo_scoreboard)analysis_read_imp;

  fifo_write_seq_item wr_seq_item;
  fifo_read_seq_item rd_seq_item;
  fifo_write_seq_item wr_queue[$];
  fifo_read_seq_item rd_queue[$];

  int match,mismatch;
  int full_match, full_mismatch;
  int empty_match, empty_mismatch;
  int count;
  bit [`DSIZE - 1 : 0] fifo_mem[$:15];
  bit [`DSIZE - 1 : 0] ref_data;

  bit hold;
  int full;
  function new(string name = "fifo_scoreboard", uvm_component parent);
    super.new(name,parent);
    analysis_write_imp = new("analysis_write_imp", this);
    analysis_read_imp = new("analysis_read_imp",this);
    wr_seq_item = new();
    rd_seq_item = new();
  endfunction

  function void write_wr_mon(fifo_write_seq_item req);
    wr_queue.push_back(req);
    $display("write data received here @ %0t", $time);
  endfunction

  function void write_rd_mon(fifo_read_seq_item req);
    rd_queue.push_back(req);
    $display("read data received here @ %0t", $time);
  endfunction

  task wr_scb;
    wait(wr_queue.size() > 0);
    wr_seq_item = wr_queue.pop_front();
    if(wr_seq_item.winc == 1) begin : i_main
      fifo_mem.push_back(wr_seq_item.wdata);
      if(wr_seq_item.wfull == 1 && fifo_mem.size == (`DEPTH))  begin
        $display("-------------------------------------------");
        `uvm_info(get_type_name(),$sformatf("| FIFO FULL PASSED | wdata = %0d | wfull = %0d |",wr_seq_item.wdata,wr_seq_item.wfull),UVM_MEDIUM)
          $display("-------------------------------------------");
          full_match++;
      end
      else if(wr_seq_item.wfull == 1 && fifo_mem.size != (`DEPTH))begin
          $display("-------------------------------------------");
          `uvm_info(get_type_name(),$sformatf("FIFO FULL FAILED | wfull = %0d |", wr_seq_item.wfull),UVM_MEDIUM)
          $display("-------------------------------------------");
          full_mismatch++;
      end
    end : i_main
    /*else if(wr_seq_item.wfull == 1 && rd_seq_item.rinc == 1) begin
      fifo_mem.push_back(wr_seq_item.wdata);
    end*/

  endtask

  task rd_scb;
    wait(rd_queue.size() > 0);
    rd_seq_item  = rd_queue.pop_front();
    if(rd_seq_item.rinc == 1) begin
      if(rd_seq_item.rempty == 0) begin
        ref_data = fifo_mem.pop_front();
        if(ref_data == rd_seq_item.rdata) begin
	  `uvm_info(get_type_name(),$sformatf(" ======================================================== "),UVM_MEDIUM)
          `uvm_info(get_type_name(),$sformatf(" || SCOREBOARD | PASSED | rdata = %0d | ref_data = %0d || ", rd_seq_item.rdata, ref_data),UVM_MEDIUM)
	  `uvm_info(get_type_name(),$sformatf(" ======================================================== "),UVM_MEDIUM)
          match ++;
          count ++;
        end

        else begin
	  `uvm_info(get_type_name(),$sformatf(" ======================================================== "),UVM_MEDIUM)
          `uvm_info(get_type_name(),$sformatf(" || SCOREBOARD | FAILED | rdata = %0d | ref_data = %0d || ", rd_seq_item.rdata, ref_data), UVM_MEDIUM)
	  `uvm_info(get_type_name(),$sformatf(" ======================================================== "),UVM_MEDIUM)
          mismatch ++;
          count ++;
        end
      end
    //  $display("---------------------------------------------------------------- TESTBENCH ----------------------------------------------------------------------------");
    end
    if(fifo_mem.size == 0 && rd_seq_item.rempty == 1) begin
        `uvm_info(get_type_name(), $sformatf("REMPTY PASSED "),UVM_MEDIUM)
        empty_match++;
    end
    else if(fifo_mem.size == 0 && rd_seq_item.rempty == 0)begin
    `uvm_info(get_type_name(), $sformatf("REMPTY FAILED"),UVM_MEDIUM)
    empty_mismatch++;
    end

    $display("---------------------------------------------------------------- TESTBENCH ----------------------------------------------------------------------------");
    $display("");
    $display("TOTAL TXNS : %0d | READ MATCH = %0d | READ MISMATCH = %0d |", count , match, mismatch);
    $display("FIFO_FULL_MATCH = %0d | FIFO_FULL_MISMATCH = %0d |", full_match,full_mismatch);
    $display("FIFO_EMPTY_MATCH = %0d | FIFO_EMPTY_MISMATCH = %0d |", empty_match, empty_mismatch);
    $display("");
    $display("---------------------------------------------------------------- TESTBENCH ----------------------------------------------------------------------------");
    $display("");
  endtask
  task run_phase(uvm_phase phase);
    fork
    forever begin
      wr_scb();
    end
    forever begin
      rd_scb();
    end
    join
  endtask


endclass
