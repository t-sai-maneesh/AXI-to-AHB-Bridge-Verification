class ahb_seqsr extends uvm_sequencer #(ahb_xtn);
	`uvm_component_utils(ahb_seqsr)

	//Methods
	extern function new(string name = "ahb_seqsr", uvm_component parent);
endclass

//Constructor New
function ahb_seqsr::new(string name = "ahb_seqsr", uvm_component parent);
	super.new(name,parent);
endfunction

