interface fifo_intf(input bit wclk,wrst_n,rrst_n,rclk);

  logic [`DSIZE-1 : 0] wdata;
  logic winc;
  logic wfull;

  clocking drv_w_cb@(posedge wclk);
    default input #0 output #0;
    output winc, wdata;
  endclocking

  clocking mon_w_cb@(posedge wclk);
    default input #0 output #0;
    input wfull,winc,wdata;
  endclocking

  logic [`DSIZE - 1 : 0] rdata;
  logic rinc;
  //logic rrst_n;
  logic rempty;

  clocking drv_r_cb@(posedge rclk);
    default input #0 output #0;
    output rinc;
  endclocking

  clocking mon_r_cb@(posedge rclk);
    default input #0 output #0;
     input rdata, rempty, rinc;
  endclocking

  modport DRV_R(clocking drv_r_cb, input rclk,rrst_n);
  modport MON_R(clocking drv_r_cb, input rclk,rrst_n);
  modport DRV_W(clocking drv_w_cb, input wclk,wrst_n);
  modport MON_W(clocking mon_w_cb, input wclk,wrst_n);

  property VALID_CHECK_WRITE;
    @(posedge wclk) wrst_n |-> not($isunknown({winc,wdata}));
  endproperty
  assert property(VALID_CHECK_WRITE)begin
    $info("VALID INPUTS");
  end
  else begin
    $error("INVALID INPUTS");
  end

  property VALID_CHECK_READ;
    @(posedge rclk) rrst_n |-> not($isunknown({rinc}));
  endproperty
  assert property(VALID_CHECK_READ)begin
    $info("VALID INPUTS");
  end
  else begin
    $error("INVALID INPUTS");
  end

  property RESET_READ_CHECK;
    @(posedge rclk) !rrst_n |-> (rempty == 1);
  endproperty

  assert property(RESET_READ_CHECK)
    $info("RESET PASSED");
  else begin
    $error("RESET FAILED");
  end

  property RESET_WRITE_CHECK;
    @(posedge wclk) !wrst_n |-> (wfull == 0);
  endproperty

  assert property(RESET_WRITE_CHECK)
    $info("RESET PASSED");
  else begin
    $error("RESET FAILED");
  end


endinterface


/*
interface fifo_read_intf(input bit rclk,rrst_n);

  logic [`DSIZE - 1 : 0] rdata;
  logic rinc;
  //logic rrst_n;
  logic rempty;

  clocking drv_r_cb@(posedge rclk);
    default input #0 output #0; 
    output rinc;
  endclocking 

  clocking mon_r_cb@(posedge rclk);
    default input #0 output #0;
     input rdata, rempty, rinc;
  endclocking

  modport DRV_R(clocking drv_r_cb, input rclk,rrst_n);

  modport MON_R(clocking drv_r_cb, input rclk,rrst_n);

endinterface*/ 
