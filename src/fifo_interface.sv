interface inf(input bit rclk, input bit rrst_n, input bit wclk, input bit wrst_n);
        //inputs
        logic rinc, winc;
        logic [DSIZE - 1 : 0] wdata;
        //outputs
        logic wfull, rempty;
        logic [DSIZE - 1 : 0] rdata;

        clocking write_drv_cb @(posedge wclk);
                output winc, wdata;
        endclocking

        clocking write_mon_cb @(posedge wclk);
                input winc, wdata, wfull;
        endclocking

        clocking read_drv_cb @(posedge rclk);
                output rinc;
        endclocking

        clocking read_mon_cb @(posedge rclk);
                        input rinc, rempty, rdata;
        endclocking

        clocking wrst_n_cb @(posedge wclk);
    input wrst_n;
  endclocking

  clocking rrst_n_cb @(posedge rclk);
    input rrst_n;
  endclocking
/****Assertions****/
//Write clock toggling

  property p1;
    @(posedge wclk, negedge wclk) ##1 wclk == $past(~wclk);
  endproperty
  assert property(p1)begin
    $info("Write Clock Toggling Pass");
  end
        else begin
    $info("Write Clock Toggling Fail");
  end

//Read clock toggling
  property p2;
    @(posedge rclk, negedge rclk) ##1 rclk == $past(~rclk);
  endproperty
  assert property(p2)begin
    $info("Read Clock Toggling Pass");
  end
  else begin
    $info("Read Clock Toggling Fail");
  end

//read_reset_n
  property p3;
    @(posedge rclk) !rrst_n |-> rempty;
  endproperty
  assert property(p3)begin
    $info("Read Reset Pass");
  end
  else begin
    $info("Read Reset Fail");
  end

//write_reset_n
  property p4;
    @(posedge wclk) !wrst_n |-> !wfull;
  endproperty
  assert property(p4)begin
    $info("Write Reset Pass");
  end
  else begin
    $info("Write Reset Fail");
  end

//valid write inputs
  property p5;
    @(posedge wclk) wrst_n |-> not($isunknown({winc, wdata}));
  endproperty
  assert property(p5)begin
    $info("Valid Write Inputs Pass");
  end
  else begin
    $info("Valid Write Inputs Fail");
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
