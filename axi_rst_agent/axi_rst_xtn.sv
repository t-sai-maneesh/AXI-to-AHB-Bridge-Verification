class axi_rst_xtn extends uvm_sequence_item;
	`uvm_object_utils(axi_rst_xtn)

	rand bit aresetn;
	     logic bvalid;
	     logic rvalid;

	//Methods
	extern function new(string name = "axi_rst_xtn");
	extern function void do_print(uvm_printer printer);
endclass

//Constructor New
function axi_rst_xtn::new(string name = "axi_rst_xtn");
	super.new(name);
endfunction

//Do printer
function void axi_rst_xtn::do_print(uvm_printer printer);
	super.do_print(printer);
	
	printer.print_field("aresetn", this.aresetn, 1, UVM_DEC);
endfunction
