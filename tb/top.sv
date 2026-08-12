module top;
	import uvm_pkg::*;
	import axi_test_pkg::*;
	`include "uvm_macros.svh"

	//clocks
	bit clk1;
	bit clk2;
	
	always #5 clk1 = ~clk1;
	always #5 clk2 = ~clk2;

	//interfaces
	axi_rst_if in0(clk1);
	axi_if in1(clk1);
	ahb_rst_if in2(clk2);
	ahb_if in3(clk2);

	//DUT Instantiation
	axi2ahb_bridge_top DUT(.aclk(clk1),.aresetn(in0.aresetn),.awid(in1.awid),.awaddr(in1.awaddr),.awlen(in1.awlen),.awsize(in1.awsize),.awburst(in1.awburst),.awvalid(in1.awvalid),.awready(in1.awready),.wid(in1.wid),.wdata(in1.wdata),.wstrb(in1.wstrb),.wlast(in1.wlast),.wvalid(in1.wvalid),.wready(in1.wready),.arid(in1.arid),.araddr(in1.araddr),.arlen(in1.arlen),.arsize(in1.arsize),.arburst(in1.arburst),.arvalid(in1.arvalid),.arready(in1.arready),.bid(in1.bid),.bresp(in1.bresp),.bvalid(in1.bvalid),.bready(in1.bready),.rid(in1.rid),.rdata(in1.rdata),.rresp(in1.rresp),.rlast(in1.rlast),.rvalid(in1.rvalid),.rready(in1.rready),.hclk(clk2),.hresetn(in2.hresetn),.haddr(in3.haddr),.htrans(in3.htrans),.hwrite(in3.hwrite),.hsize(in3.hsize),.hburst(in3.hburst),.hwdata(in3.hwdata),.hbusreq(in3.hbusreq),.hlock(in3.hlock),.hrdata(in3.hrdata),.hready(in3.hready),.hresp(in3.hresp),.hgrant(in3.hgrant),.hmaster(in3.hmaster));

	initial
	begin
			`ifdef VCS
         		$fsdbDumpvars(0, top);
        		`endif

		uvm_config_db #(virtual axi_rst_if)::set(null,"*","axi_rst_if",in0);
		uvm_config_db #(virtual axi_if)::set(null,"*","axi_if",in1);
		uvm_config_db #(virtual ahb_rst_if)::set(null,"*","ahb_rst_if",in2);
		uvm_config_db #(virtual ahb_if)::set(null,"*","ahb_if",in3);

		run_test();	
	end
endmodule
