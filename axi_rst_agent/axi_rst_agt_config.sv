class axi_rst_agt_config extends uvm_object;
	`uvm_object_utils(axi_rst_agt_config)

	virtual axi_rst_if vif; 
	uvm_active_passive_enum is_active;

	//Methods
	extern function new(string name = "axi_rst_agt_config");
endclass

//Constructor New
function axi_rst_agt_config::new(string name = "axi_rst_agt_config");
	super.new(name);
endfunction	

