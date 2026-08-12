class ahb_rst_seqsr extends uvm_sequencer #(ahb_rst_xtn);
	`uvm_component_utils(ahb_rst_seqsr)

	//Methods
	extern function new(string name = "ahb_rst_seqsr", uvm_component parent);
endclass

//Constructor New
function ahb_rst_seqsr::new(string name = "ahb_rst_seqsr", uvm_component parent);
	super.new(name,parent);
endfunction

