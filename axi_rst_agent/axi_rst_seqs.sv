class axi_rst_base_seqs extends uvm_sequence #(axi_rst_xtn);
	`uvm_object_utils(axi_rst_base_seqs)

	//Methods
	extern function new(string name = "axi_rst_base_seqs");
endclass

//Constructor new
function axi_rst_base_seqs::new(string name = "axi_rst_base_seqs");
	super.new(name);
endfunction

/*---------------------------------------------------------------------
			RST Seqs
---------------------------------------------------------------------*/
class axi_rst_seqs extends axi_rst_base_seqs;
	`uvm_object_utils(axi_rst_seqs)

        //Methods
        extern function new(string name = "axi_rst_seqs");
	extern task body();
endclass

//Constructor new
function axi_rst_seqs::new(string name = "axi_rst_seqs");
        super.new(name);
endfunction

//Body
task axi_rst_seqs::body();	
	req = axi_rst_xtn::type_id::create("req");	

	start_item(req);	
	assert(req.randomize() with {aresetn == 1'b0;});
	finish_item(req);
endtask







