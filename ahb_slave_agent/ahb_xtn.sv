class ahb_xtn extends uvm_sequence_item;
	`uvm_object_utils(ahb_xtn)

	bit [31:0] haddr;
	bit [1:0]  htrans;
	bit 	   hwrite;
	bit [2:0]  hsize;
	bit [2:0]  hburst;
	bit [63:0] hwdata;
	bit 	   hbusreq;
	bit 	   hlock;

	rand bit [63:0] hrdata;
	     bit hready;
	     bit [1:0] hresp;
	     bit hgrant;
	     bit [3:0] hmaster;
	rand bit [1:0] delay_cycles;
	rand enum {okay, okay_with_wait_states, error} resp;

	//Constraints 
	constraint delay_c{delay_cycles inside {[2:5]};}
	constraint h_resp{hresp inside {[0:1]};} 

	//methods
	extern function new(string name = "ahb_xtn");
	extern function void do_print(uvm_printer printer);
endclass

//Constructor New
function ahb_xtn::new(string name = "ahb_xtn");
	super.new(name);
endfunction

//Do print
function void ahb_xtn::do_print(uvm_printer printer);
	printer.print_field("haddr", this.haddr, $bits(this.haddr), UVM_DEC);
	printer.print_field("htrans", this.htrans, $bits(this.htrans), UVM_DEC);
	printer.print_field("hwrite", this.hwrite, $bits(this.hwrite), UVM_DEC);
	printer.print_field("hsize", this.hsize, $bits(this.hsize), UVM_DEC);
	printer.print_field("hburst", this.hburst, $bits(this.hburst), UVM_DEC);
	printer.print_field("hwdata", this.hwdata, $bits(this.hwdata), UVM_DEC);
	printer.print_field("hbusreq", this.hbusreq, $bits(this.hbusreq), UVM_DEC);
	printer.print_field("hlock", this.hlock, $bits(this.hlock), UVM_DEC);

	printer.print_field("hrdata", this.hrdata, $bits(this.hrdata), UVM_DEC);
	printer.print_field("hready", this.hready, $bits(this.hready), UVM_DEC);
	printer.print_field("hresp", this.hresp, $bits(this.hresp), UVM_DEC);
	printer.print_field("hgrant", this.hgrant, $bits(this.hgrant), UVM_DEC);
	printer.print_field("hmaster", this.hmaster, $bits(this.hmaster), UVM_DEC);
endfunction
