class write_sequence extends uvm_sequence #(wr_seq_item);
        `uvm_object_utils(write_sequence);

        function new(string name="write_sequence");
    super.new(name);
  endfunction

        task body();
    int count;
    wr_seq_item item;
    repeat (N) begin
      item = wr_seq_item::type_id::create("write_item");
      wait_for_grant();
      item.randomize() with {winc == 1;};
      `uvm_info(get_type_name(), $sformatf("[%0t] Write Transaction %0d: winc=%0b, wdata=%0d", $time, count, item.winc, item.wdata), UVM_LOW);
                        send_request(item);
      wait_for_item_done();
      count++;
    end
    wait_for_grant();
    item.randomize() with {winc == 0;};
    `uvm_info(get_type_name(), $sformatf("[%0t] Write Transaction %0d: winc=%0b, wdata=%0d", $time, count, item.winc, item.wdata), UVM_LOW);
                        send_request(item);
      wait_for_item_done();
  endtask
endclass

class read_sequence extends uvm_sequence #(rd_seq_item);
  `uvm_object_utils(read_sequence)
  function new(string name="read_sequence");
    super.new(name);
  endfunction

  virtual task body();
    int count;
    rd_seq_item item;
    repeat(N) begin
      item = rd_seq_item::type_id::create("read_item");
        wait_for_grant();
      item.randomize() with {rinc == 0;};
      `uvm_info(get_type_name(), $sformatf("[%0t] Read Transaction %0d: rinc=%0b", $time, count, item.rinc), UVM_LOW);
                        send_request(item);
      wait_for_item_done();
    end
    repeat(N) begin
        wait_for_grant();
      item.randomize() with {rinc == 1;};
      `uvm_info(get_type_name(), $sformatf("[%0t] Read Transaction %0d: rinc=%0b", $time, count, item.rinc), UVM_LOW);
                        send_request(item);
      wait_for_item_done();
    end
  endtask
endclass

class p_read_sequence extends uvm_sequence;
  `uvm_object_utils(p_read_sequence)
  function new(string name="parallel_read_sequence");
    super.new(name);
  endfunction

  virtual task body();
    int count;
    rd_seq_item item;
    item = rd_seq_item::type_id::create("read_item");
    wait_for_grant();
    item.randomize() with {rinc == 0;};
                send_request(item);
    wait_for_item_done();
    
    repeat(N) begin
      item = rd_seq_item::type_id::create("read_item");
        wait_for_grant();
      item.randomize() with {rinc == 1;};
      `uvm_info(get_type_name(), $sformatf("[%0t] Read Transaction %0d: rinc=%0b", $time, count, item.rinc), UVM_LOW);
                        send_request(item);
      wait_for_item_done();
    end
    wait_for_grant();
    item.randomize() with {rinc == 0;};
                send_request(item);
    wait_for_item_done();
        endtask;
endclass


class p_write_sequence extends uvm_sequence;
  `uvm_object_utils(p_write_sequence)
  function new(string name="parallel_write_sequence");
    super.new(name);
  endfunction

  virtual task body();
    int count;
    wr_seq_item item;
      item = wr_seq_item::type_id::create("write_item");
    wait_for_grant();
    item.randomize() with {winc == 0;};
                send_request(item);
    wait_for_item_done();
    repeat(N) begin
      item = wr_seq_item::type_id::create("write_item");
        wait_for_grant();
      item.randomize() with {winc == 1;};
      `uvm_info(get_type_name(), $sformatf("[%0t] Write Transaction %0d: winc=%0b", $time, count, item.winc), UVM_LOW);
                        send_request(item);
      wait_for_item_done();
    end
    wait_for_grant();
    item.randomize() with {winc == 0;};
                send_request(item);
    wait_for_item_done();
        endtask
endclass

class rempty_write_sequence extends uvm_sequence #(wr_seq_item);
  `uvm_object_utils(rempty_write_sequence);

  function new(string name="rempty_write_sequence");
    super.new(name);
  endfunction

  task body();
    int count;
    wr_seq_item item;
    repeat(4)begin
      item = wr_seq_item::type_id::create("write_item");
      wait_for_grant();
      item.randomize() with {winc == 1;};
      `uvm_info(get_type_name(), $sformatf("[%0t] Write Transaction %0d: winc=%0b, wdata=%0d", $time, count, item.winc, item.wdata), UVM_LOW);
      send_request(item);
      wait_for_item_done();
    end
    repeat (N) begin
      item = wr_seq_item::type_id::create("write_item");
      wait_for_grant();
      item.randomize() with {winc == 0;};
      `uvm_info(get_type_name(), $sformatf("[%0t] Write Transaction %0d: winc=%0b, wdata=%0d", $time, count, item.winc, item.wdata), UVM_LOW);
      send_request(item);
      wait_for_item_done();
      count++;
    end

  endtask
endclass

class rempty_read_sequence extends uvm_sequence #(rd_seq_item);
  `uvm_object_utils(rempty_read_sequence)
  function new(string name="rempty_read_sequence");
    super.new(name);
  endfunction

  virtual task body();
    int count;
    rd_seq_item item;
    repeat(4) begin
      item = rd_seq_item::type_id::create("read_item");
      wait_for_grant();
      item.randomize() with {rinc == 0;};
      `uvm_info(get_type_name(), $sformatf("[%0t] Read Transaction %0d: rinc=%0b", $time, count, item.rinc), UVM_LOW);
      send_request(item);
      wait_for_item_done();
    end
    repeat(N) begin
      item = rd_seq_item::type_id::create("read_item");
      wait_for_grant();
      item.randomize() with {rinc == 1;};
      `uvm_info(get_type_name(), $sformatf("[%0t] Read Transaction %0d: rinc=%0b", $time, count, item.rinc), UVM_LOW);
      send_request(item);
      wait_for_item_done();
    end
  endtask
endclass

class wfull_write_sequence extends uvm_sequence #(wr_seq_item);
  `uvm_object_utils(wfull_write_sequence);

  function new(string name="wfull_write_sequence");
    super.new(name);
  endfunction

  task body();
    int count;
    wr_seq_item item;
    repeat (DEPTH + 2) begin
      item = wr_seq_item::type_id::create("write_item");
      wait_for_grant();
      item.randomize() with {winc == 1;};
      `uvm_info(get_type_name(), $sformatf("[%0t] Write Transaction %0d: winc=%0b, wdata=%0d", $time, count, item.winc, item.wdata), UVM_LOW);
      send_request(item);
      wait_for_item_done();
      count++;
    end

  endtask
endclass

class wfull_read_sequence extends uvm_sequence #(rd_seq_item);
  `uvm_object_utils(wfull_read_sequence)
  function new(string name="rempty_read_sequence");
    super.new(name);
  endfunction

  virtual task body();
    int count;
    rd_seq_item item;

    repeat(DEPTH + 2) begin
      item = rd_seq_item::type_id::create("read_item");
      wait_for_grant();
      item.randomize() with {rinc == 0;};
      `uvm_info(get_type_name(), $sformatf("[%0t] Read Transaction %0d: rinc=%0b", $time, count, item.rinc), UVM_LOW);
      send_request(item);
      wait_for_item_done();
    end
  endtask
endclass
