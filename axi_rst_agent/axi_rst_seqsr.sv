class axi_rst_seqsr extends uvm_sequencer #(axi_rst_xtn);
	`uvm_component_utils(axi_rst_seqsr)

	//Methods
	extern function new(string name = "axi_rst_seqsr", uvm_component parent);
endclass

//Constructor New
function axi_rst_seqsr::new(string name = "axi_rst_seqsr", uvm_component parent);
	super.new(name,parent);
endfunction
