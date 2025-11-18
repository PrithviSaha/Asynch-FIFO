class wr_seq_item extends uvm_sequence_item;

  rand logic 		   winc;
  rand logic [DSIZE-1 : 0] wdata;

  logic wfull;

  `uvm_object_utils_begin(wr_seq_item)
    `uvm_field_int(wdata, UVM_ALL_ON)
    `uvm_field_int(winc, UVM_ALL_ON)
    `uvm_field_int(wfull, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name="wr_sequence_item");
    super.new(name);
  endfunction
endclass

/////////////////////////////////////////////////

class rd_seq_item extends uvm_sequence_item;

  rand logic rinc;

  logic [DSIZE-1 : 0] rdata;
  logic 	      rempty;

  `uvm_object_utils_begin(rd_seq_item)
    `uvm_field_int(rdata, UVM_ALL_ON)
    `uvm_field_int(rinc, UVM_ALL_ON)
    `uvm_field_int(rempty, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name="rd_sequence_item");
    super.new(name);
  endfunction
endclass
