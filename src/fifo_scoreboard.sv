`uvm_analysis_imp_decl(_wr)
`uvm_analysis_imp_decl(_rd)

class scoreboard extends uvm_scoreboard;
        `uvm_component_utils(scoreboard)

        uvm_analysis_imp_wr #(wr_seq_item, scoreboard) wr_item_collect_scb;
        uvm_analysis_imp_rd #(rd_seq_item, scoreboard) rd_item_collect_scb;

        virtual inf vif;

        function new(string name = "scoreboard", uvm_component parent = null);
                super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                wr_item_collect_scb = new("wr_collect", this);
                rd_item_collect_scb = new("rd_collect", this);
                if(!uvm_config_db#(virtual inf)::get(this, "", "vif", vif))begin
                        `uvm_info("ERR", "Cannot access interface", UVM_LOW);
                end
        endfunction

        bit [DSIZE - 1 : 0] mem [DEPTH - 1 : 0];
        bit [ASIZE : 0] wptr, wq2_rptr_q1, wq2_rptr;
        bit [ASIZE : 0] wbin, wbin_next, wgray_next;
        bit wfull;
        bit [ASIZE - 1:0] waddr;
        int write_count;
        int wfull_pass, wfull_fail;

        bit [ASIZE : 0] rptr, rq2_wptr_q1, rq2_wptr;
        bit [ASIZE : 0] rbin, rbin_next, rgray_next;
        bit rempty, rempty_val;
        bit [ASIZE - 1 : 0] raddr;
        int read_count;
        int expected_data;
        int data_pass, data_fail, rempty_pass, rempty_fail;


        function bit[ASIZE : 0] bin2gray(bit [ASIZE : 0] bin);
                return (bin >> 1) ^ bin;
        endfunction
        function void write_wr(wr_seq_item pkt);
                if(!vif.wrst_n_cb.wrst_n)begin
                        wbin = 0;
                        wptr = 0;
                        wq2_rptr_q1 = 0;
                        wq2_rptr = 0;
                        wfull = 0;
                        `uvm_info(get_type_name(), $sformatf("Reset write domain"), UVM_MEDIUM);
                end

                waddr = wbin[ASIZE - 1:0];

                if(pkt.winc & !wfull)begin
                        mem[waddr] = pkt.wdata;
                        write_count++;
                        `uvm_info(get_type_name(), $sformatf("WRITE : addr = %0d, data = %0d, memory  = %p", waddr, pkt.wdata, mem), UVM_LOW);
                        wbin_next = wbin + (pkt.winc & !wfull);
                        wgray_next = bin2gray(wbin_next);

                        `uvm_info(get_type_name(), $sformatf("write_count = %0d, wbin_next = %0d, wgray_next = %0d", write_count, wbin_next, wgray_next), UVM_LOW);
                end

                else if(pkt.winc && wfull)begin
                        `uvm_info(get_type_name(), $sformatf("FIFO FULL, memory : %p", mem), UVM_LOW);
                end

                if(pkt.wfull != wfull)begin
                        `uvm_info(get_type_name(), $sformatf("WFULL MISMATCH : Expected  = %0b, Actual = %0b, wbin = %0d, wq2_rptr = %0d", wfull, pkt.wfull, wbin, wq2_rptr), UVM_MEDIUM);
                        wfull_fail++;
                end
                else begin
                        `uvm_info(get_type_name(), $sformatf("WFULL MATCH : Expected  = %0b, Actual = %0b, wbin = %0d, wq2_rptr = %0d", wfull, pkt.wfull, wbin, wq2_rptr), UVM_MEDIUM);
                        wfull_pass++;
                end

                wbin = wbin_next;
                wptr = wgray_next;

                wfull = (wgray_next == {~wq2_rptr[ASIZE : ASIZE -1], wq2_rptr[ASIZE - 2:0]});

                wq2_rptr = wq2_rptr_q1;
                wq2_rptr_q1 = rptr;

        endfunction

        function void write_rd(rd_seq_item pkt);
                if(!vif.rrst_n_cb.rrst_n)begin
                        rptr = 0;
                        rbin = 0;
                        rq2_wptr_q1 = 0;
                        rq2_wptr = 0;
                        rempty = 1;
                        `uvm_info(get_type_name(), $sformatf("Reset Read domain"), UVM_LOW);
                end

                if(pkt.rinc && !rempty)begin
                        read_count++;
                        `uvm_info(get_type_name(), $sformatf("READ: addr=%0d, expected=%0d, actual=%0d, Memory contents: %p", raddr, expected_data, pkt.rdata, mem), UVM_MEDIUM);

                        raddr = rbin[ASIZE - 1 : 0];
                        expected_data = mem[raddr];

                        if(pkt.rdata == expected_data)begin
                                `uvm_info(get_type_name(), $sformatf("Read Data pass"), UVM_MEDIUM);
                                data_pass++;
                        end
                        else begin
                                `uvm_info(get_type_name(), $sformatf("Read Data fail => Expected = %0d, Actual = %0d, raddr = %0d, rbin = %0d, mem = %p", expected_data, pkt.rdata, raddr, rbin, mem), UVM_MEDIUM);
                                data_fail++;
                        end

                        rbin_next = rbin + (pkt.rinc & ~rempty);
                        rgray_next = bin2gray(rbin_next);

                end
                else if(pkt.rinc && rempty)begin
                        `uvm_info(get_type_name(), $sformatf("Read Blocked: Fifo empty, Memory : %p", mem), UVM_LOW);
                end

                if(pkt.rempty != rempty)begin
                        `uvm_info(get_type_name(), $sformatf("REMPTY Mismatch, Expected = %0d, Actual = %0d, rbin = %0d, rq2_wptr = %0d", rempty, pkt.rempty, rbin, rq2_wptr), UVM_LOW);

                end
                else begin
                        `uvm_info(get_type_name(), "REMPTY Pass", UVM_LOW);
                        rempty_pass++;
                end

                rbin = rbin_next;
                rptr = rgray_next;

                rempty_val = (rgray_next == rq2_wptr);
                rempty = rempty_val;

                rq2_wptr = rq2_wptr_q1;
                rq2_wptr_q1 = wptr;
        endfunction

        virtual function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info(get_type_name(), "==============================================", UVM_NONE);
                `uvm_info(get_type_name(), $sformatf("  Total Writes Operations =>    %0d", write_count), UVM_NONE);
                `uvm_info(get_type_name(), $sformatf("  Total Read Operations =>     %0d", read_count), UVM_NONE);
            `uvm_info(get_type_name(), "----------------------------------------------", UVM_NONE);
                `uvm_info(get_type_name(), $sformatf("  RDATA   =>   Pass=%0d, Fail=%0d", data_pass, data_fail), UVM_NONE);
                `uvm_info(get_type_name(), $sformatf("  WFULL   =>   Pass=%0d, Fail=%0d", wfull_pass, wfull_fail), UVM_NONE);
                `uvm_info(get_type_name(), $sformatf("  REMPTY  =>   Pass=%0d, Fail=%0d", rempty_pass, rempty_fail), UVM_NONE);
            `uvm_info(get_type_name(), "==============================================", UVM_NONE);
        endfunction
endclass
