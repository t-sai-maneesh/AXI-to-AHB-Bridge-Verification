class ahb_rst_seqs_base extends uvm_sequence #(ahb_rst_xtn);
	`uvm_object_utils(ahb_rst_seqs_base)

	//Methods
	extern function new(string name = "ahb_rst_seqs_base");
endclass

//Constructor New
function ahb_rst_seqs_base::new(string name = "ahb_rst_seqs_base");
	super.new(name);
endfunction

/*-----------------------------------------------------------------------
			AHB rst class
-----------------------------------------------------------------------*/
class ahb_rst_seqs extends ahb_rst_seqs_base;
	`uvm_object_utils(ahb_rst_seqs)

	//Methods
	extern function new(string name = "ahb_rst_seqs");
	extern task body();
endclass

//Constructor New
function ahb_rst_seqs::new(string name = "ahb_rst_seqs");
	super.new(name);
endfunction

//Body
task ahb_rst_seqs::body();
	req = ahb_rst_xtn::type_id::create("req");
	
	start_item(req);
	assert(req.randomize() with {hresetn == 1'b0;});
	finish_item(req);
endtask
