class fifo_write_driver extends uvm_driver#(fifo_write_seq_item);

  `uvm_component_utils(fifo_write_driver)

  virtual fifo_intf vif;
  bit drv;
  function new(string name = "fifo_write_driver", uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_intf)::get(this,"","fifo_intf",vif))
      `uvm_error(get_type_name(), "Failed to get Virtual Interface")
  endfunction

  task run_phase(uvm_phase phase);
    repeat(3)@(vif.drv_w_cb);
    forever begin
      seq_item_port.get_next_item(req);
      drive_wr_inputs();
//      if(drv == 0) begin
//        repeat(4)@(vif.drv_w_cb);
//        drv = 1;
//      end
//      else begin
      `uvm_info(get_type_name(), $sformatf("| -> WRITE - DRIVER <- | WINC = %0d |  WDATA = %0d |",req.winc,req.wdata), UVM_MEDIUM)
        repeat(1)@(vif.drv_w_cb);
//      end
//      `uvm_info(get_type_name(), $sformatf("| -> WRITE - DRIVER <- | WINC = %0d |  WDATA = %0d |",req.winc,req.wdata), UVM_MEDIUM)
      seq_item_port.item_done();
    end
  endtask
  task drive_wr_inputs();
    vif.winc <= req.winc;
    //vif.wrst_n <= req.wrst_n;
    vif.wdata <= req.wdata;
  endtask
endclass

class fifo_read_driver extends uvm_driver#(fifo_read_seq_item);

  `uvm_component_utils(fifo_read_driver)

  virtual fifo_intf vif;
  function new(string name = "fifo_read_driver", uvm_component parent);
    super.new(name,parent);
  endfunction
  bit drv;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_intf)::get(this,"","fifo_intf",vif))
      `uvm_error(get_type_name(), "Failed to get Virtual Interface")
  endfunction

  task run_phase(uvm_phase phase);
    repeat(3)@(vif.drv_r_cb);
    forever begin
      seq_item_port.get_next_item(req);
      drive_rd_inputs();
//     if(drv == 0) begin
//        repeat(4)@(vif.drv_r_cb);
//        drv = 1;
//      end
//      else begin

        `uvm_info(get_type_name(), $sformatf("| -> READ - DRIVER <- | RINC = %0d |",req.rinc), UVM_MEDIUM)
        repeat(1)@(vif.drv_r_cb);
//      end
      //`uvm_info(get_type_name(), $sformatf("| -> READ - DRIVER <- | RINC = %0d |",req.rinc), UVM_MEDIUM)
      seq_item_port.item_done();
    end
  endtask
  task drive_rd_inputs();
    vif.rinc <= req.rinc;
  endtask
endclass
