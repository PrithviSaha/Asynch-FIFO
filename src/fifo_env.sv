class env extends uvm_env;
        `uvm_component_utils(env);
        write_agent w_agnt;
        read_agent r_agnt;
        scoreboard scb;
        coverage cov;

        function new(string name = "env", uvm_component parent = null);
                super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                w_agnt = write_agent::type_id::create("w_agnt", this);
                r_agnt = read_agent::type_id::create("r_agnt", this);
                scb = scoreboard::type_id::create("scb", this);
                cov = coverage::type_id::create("cov", this);
        endfunction

        function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                
                w_agnt.w_mon.item_collect_wr_mon.connect(scb.wr_item_collect_scb);
                r_agnt.r_mon.item_collect_rd_mon.connect(scb.rd_item_collect_scb);

                w_agnt.w_mon.item_collect_wr_mon.connect(cov.wr_item_collect_cov);
                r_agnt.r_mon.item_collect_rd_mon.connect(cov.rd_item_collect_cov);
        endfunction
endclass
