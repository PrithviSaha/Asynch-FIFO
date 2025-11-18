class wr_driver extends uvm_driver #(wr_seq_item);
  `uvm_component_utils(wr_driver);
  virtual inf vif;
  wr_seq_item req;
  //event we;
  function new(string name = "wr_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual inf)::get(this, "", "vif", vif))
      `uvm_warning("ERR", "Cannot access write driver interface");
    /*if(!uvm_config_db#(event)::get(this, "", "we", we))
      `uvm_warning("ERR", "Cannot access write event");*/
  endfunction

  task drive();
    `uvm_info(get_type_name(), $sformatf("winc = %0b | wdata = %0d", req.winc, req.wdata), UVM_MEDIUM);
    vif.write_drv_cb.winc <= req.winc;
    vif.write_drv_cb.wdata <= req.wdata;
    repeat(1)@(vif.write_drv_cb);
//  ->we;
  endtask

  task run_phase(uvm_phase phase);
    repeat(1)@(vif.write_drv_cb);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask

endclass

////////////////////////////////////////////////////////////////////////////

class rd_driver extends uvm_driver #(rd_seq_item);
  `uvm_component_utils(rd_driver);
  virtual inf vif;
//  event e;
  function new(string name = "rd_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual inf)::get(this, "", "vif", vif))
      `uvm_warning("ERR", "Cannot access read driver interface");
  /*  if(!uvm_config_db#(
      `uvm_warning("ERR", "Cannot access read event");*/
  endfunction

  task drive();
    `uvm_info("RD_DRV", $sformatf("rinc = %0b", req.rinc), UVM_MEDIUM);
    vif.read_drv_cb.rinc <= req.rinc;
    repeat(1)@(vif.read_drv_cb);
  //  ->e;
  endtask

  task run_phase(uvm_phase phase);
    repeat(1)@(vif.read_drv_cb);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask
endclass
