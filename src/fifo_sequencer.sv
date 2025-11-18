
class wr_sequencer extends uvm_sequencer#(wr_seq_item);
        `uvm_component_utils(wr_sequencer)
        function new(string name = "wr_sequencer", uvm_component parent = null);
                super.new(name, parent);
        endfunction
endclass

////////////////////////////////////////////////////////////////////////

class rd_sequencer extends uvm_sequencer#(rd_seq_item);
        `uvm_component_utils(rd_sequencer)
        function new(string name = "rd_sequencer", uvm_component parent = null);
                super.new(name, parent);
        endfunction
endclass

