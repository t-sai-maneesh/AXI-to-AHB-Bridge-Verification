class ahb_rst_xtn extends uvm_sequence_item;
	`uvm_object_utils(ahb_rst_xtn)

	rand bit hresetn;
	     bit hready;
	     logic [1:0] htrans;

	//Methods
	extern function new(string name = "ahb_rst_xtn");
	extern function void do_print(uvm_printer printer);
endclass

//Constructor New
function ahb_rst_xtn::new(string name = "ahb_rst_xtn");
	super.new(name);
endfunction

//Do print
function void ahb_rst_xtn::do_print(uvm_printer printer);
	super.do_print(printer);
	printer.print_field("hresetn", this.hresetn, 1, UVM_DEC);
endfunction
