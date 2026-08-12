class axi_xtn extends uvm_sequence_item;
	`uvm_object_utils(axi_xtn)

	//aw channel
	rand bit aresetn;
	rand bit [7:0] awid;
	rand bit [31:0] awaddr;
	rand bit [7:0] awlen;
	rand bit [2:0] awsize;
	rand bit [1:0] awburst;
	rand bit awvalid;
	     bit awready;

	//w channel
	rand bit [7:0] wid;
	rand bit [63:0] wdata[];
	     bit [7:0] wstrb[];
	     bit wlast;
	rand bit wvalid;
	     bit wready;
	
	//ar channel
	rand bit [7:0] arid;
        rand bit [31:0] araddr;
        rand bit [7:0] arlen;
        rand bit [2:0] arsize;
        rand bit [1:0] arburst;
        rand bit arvalid;
             bit arready;

	//b channel
	bit [7:0] bid;
	bit [1:0] bresp;	
	bit bvalid;
	bit bready;

	//r channel
	bit [7:0] rid;
	bit [63:0] rdata[];
	bit [1:0] rresp[];
	bit rlast;
	bit rvalid;
	bit rready;

	bit [63:0] temp_wdata;
	bit [63:0] temp_rdata;	
	int delay_cycles;
	
	//Constraints
	//id const
	constraint wr_id{awid == wid; bid == wid;}
	constraint rd_id{arid == rid;}
		
	//burst type const
	constraint wr_brst{awburst inside {[0:2]};}
	constraint rd_brst{arburst inside {[0:2]};}

	//size of the byte
	constraint wr_awsize{awsize inside {[0:3]};}
	constraint rd_arsize{arsize inside {[0:3]};}	

	//wrap const
	constraint wr_align1 {((awburst == 2'b10) && (awsize == 1)) -> awaddr%2 ==0;}
	constraint wr_align2 {((awburst == 2'b10) && (awsize == 2)) -> awaddr%4 ==0;}
	constraint wr_align3 {((awburst == 2'b10) && (awsize == 3)) -> awaddr%8 ==0;}

	constraint rd_align1 {((arburst == 2'b10) && (arsize == 1)) -> araddr%2 ==0;}
	constraint rd_align2 {((arburst == 2'b10) && (arsize == 2)) -> araddr%4 ==0;}
	constraint rd_align3 {((arburst == 2'b10) && (arsize == 3)) -> araddr%8 ==0;}

	constraint wdat{wdata.size == awlen + 1;}

	//methods
	extern function new(string name = "axi_xtn");
	extern function void post_randomize();
	extern function void do_print(uvm_printer printer);	
endclass

//Constructor New
function axi_xtn::new(string name = "axi_xtn");
	super.new(name);
endfunction

//Post randomization
function void axi_xtn::post_randomize();
	
	int j = 0;	
	bit [31:0] start_address = awaddr;
	int number_of_bytes = 2**awsize;
	int burst_length = awlen + 1;
	bit [31:0] aligned_address = (start_address/number_of_bytes)*number_of_bytes;
	wstrb = new[awlen+1];

	for(int i = (start_address%8); i < ((aligned_address%8) + number_of_bytes); i++)
	begin
		wstrb[j][i] = 1'b1;
	end
	
	for(int l = 1; l < burst_length; l++)
	begin
		aligned_address = aligned_address + number_of_bytes;
		j++;
		for(int k = (aligned_address%8); k < ((aligned_address%8) + number_of_bytes); k++)
			wstrb[j][k] = 1'b1;
	end
endfunction

//do print
function void axi_xtn::do_print(uvm_printer printer);
	//super.print(printer);
	printer.print_field("awid", this.awid, $bits(this.awid), UVM_DEC);
	printer.print_field("awaddr", this.awaddr, $bits(this.awaddr), UVM_DEC);
	printer.print_field("awlen", this.awlen, $bits(this.awlen), UVM_DEC);
	printer.print_field("awsize", this.awsize, $bits(this.awsize), UVM_DEC);
	printer.print_field("awburst", this.awburst, $bits(this.awburst), UVM_DEC);
	printer.print_field("awvalid", this.awvalid, $bits(this.awvalid), UVM_DEC);
	printer.print_field("awready", this.awready, $bits(this.awready), UVM_DEC);

	printer.print_field("wid", this.wid, $bits(this.wid), UVM_DEC);
	foreach(wdata[i])
		printer.print_field($sformatf("wdata[%0d]",i), this.wdata[i], $bits(this.wdata[i]), UVM_DEC);
	foreach(wstrb[i])
        	printer.print_field($sformatf("wstrb[%0d]",i), this.wstrb[i], $bits(this.wstrb[i]), UVM_BIN);
	printer.print_field("wlast", this.wlast, $bits(this.wlast), UVM_DEC);
	printer.print_field("wvalid", this.wvalid, $bits(this.wvalid), UVM_DEC);
	printer.print_field("wready", this.wready, $bits(this.wready), UVM_DEC);

	printer.print_field("bid", this.bid, $bits(this.bid), UVM_DEC);
	printer.print_field("bresp", this.bresp, $bits(this.bresp), UVM_DEC);	
	printer.print_field("bvalid", this.bvalid, $bits(this.bvalid), UVM_DEC);
	printer.print_field("bready", this.bready, $bits(this.bready), UVM_DEC);

	printer.print_field("arid", this.arid, $bits(this.arid), UVM_DEC);
        printer.print_field("araddr", this.araddr, $bits(this.araddr), UVM_DEC);
        printer.print_field("arlen", this.arlen, $bits(this.arlen), UVM_DEC);
        printer.print_field("arsize", this.arsize, $bits(this.arsize), UVM_DEC);
        printer.print_field("arburst", this.arburst, $bits(this.arburst), UVM_DEC);
        printer.print_field("arvalid", this.arvalid, $bits(this.arvalid), UVM_DEC);
        printer.print_field("arready", this.arready, $bits(this.arready), UVM_DEC);

	printer.print_field("rid", this.rid, $bits(this.rid), UVM_DEC);
	foreach(rdata[i])
        	printer.print_field($sformatf("rdata[%0d]",i), this.rdata[i], $bits(this.rdata[i]), UVM_DEC);
        foreach(rresp[i])
        	printer.print_field($sformatf("rresp[%0d]",i), this.rresp[i], $bits(this.rresp[i]), UVM_DEC);
	printer.print_field("rlast", this.rlast, $bits(this.rlast), UVM_DEC);
	printer.print_field("rvalid", this.rvalid, $bits(this.rvalid), UVM_DEC);
	printer.print_field("rready", this.rready, $bits(this.rready), UVM_DEC);
endfunction

