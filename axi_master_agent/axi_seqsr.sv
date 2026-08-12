class axi_seqsr extends uvm_sequencer #(axi_xtn);
	`uvm_component_utils(axi_seqsr)

	//Methods
	extern function new(string name = "axi_seqsr", uvm_component parent);
endclass

//Constructor New
function axi_seqsr::new(string name = "axi_seqsr", uvm_component parent);
	super.new(name,parent);
endfunction
