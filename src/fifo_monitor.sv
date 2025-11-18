//`include "defines.svh"

class wr_monitor extends uvm_monitor;
        `uvm_component_utils(wr_monitor);
        virtual inf vif;
        //event we;
        wr_seq_item pkt;
        uvm_analysis_port#(wr_seq_item) item_collect_wr_mon;
        function new(string name = "wr_monitor", uvm_component parent = null);
                super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db#(virtual inf)::get(this, "", "vif", vif))
                        `uvm_warning("ERR", "Cannot access write interface");
                /*if(!uvm_config_db#(event)::get(this, "", "we", we))
                        `uvm_warning("ERR", "Cannot access write event");*/
                pkt = wr_seq_item::type_id::create("pkt");
                item_collect_wr_mon = new("icwm", this);
        endfunction

        task monitor();
                //wait(we);
                `uvm_info("WR_MON", $sformatf("winc = %0b | wfull = %0d", vif.winc, vif.wfull), UVM_MEDIUM);
                pkt.winc = vif.write_mon_cb.winc;
                pkt.wdata = vif.write_mon_cb.wdata;
                pkt.wfull = vif.write_mon_cb.wfull;
                item_collect_wr_mon.write(pkt);
        endtask

        task run_phase(uvm_phase phase);
                repeat(2)@(vif.write_mon_cb);
                forever begin
                        monitor();
                        repeat(1)@(vif.write_mon_cb);
                end
        endtask
endclass

////////////////////////////////////////////////////////////////////////////////////////////

class rd_monitor extends uvm_monitor;
  `uvm_component_utils(rd_monitor);
  virtual inf vif;
  //event re;
  rd_seq_item pkt;
  uvm_analysis_port#(rd_seq_item) item_collect_rd_mon;

  function new(string name = "rd_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual inf)::get(this, "", "vif", vif))
      `uvm_warning("ERR", "Cannot access read interface");
  /*  if(!uvm_config_db#(event)::get(this, "", "re", re))
      `uvm_warning("ERR", "Cannot access read event");*/
    pkt = rd_seq_item::type_id::create("pkt");
    item_collect_rd_mon = new("icrm", this);
  endfunction

  task monitor();
    //wait(re);
    `uvm_info(get_type_name(), $sformatf("rempty = %0b | rdata = %0d", vif.rempty, vif.rdata), UVM_MEDIUM);
    pkt.rinc = vif.read_mon_cb.rinc;
    pkt.rempty = vif.read_mon_cb.rempty;
    pkt.rdata = vif.read_mon_cb.rdata;
  endtask

  task run_phase(uvm_phase phase);
    repeat(2)@(vif.read_mon_cb);
    forever begin
      monitor();
      item_collect_rd_mon.write(pkt);
      @(vif.read_mon_cb);
    end
  endtask
endclass
