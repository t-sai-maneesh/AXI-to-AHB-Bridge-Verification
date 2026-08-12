class ahb_agt_config extends uvm_object;
	`uvm_object_utils(ahb_agt_config)

	virtual ahb_if vif;

	uvm_active_passive_enum is_active;

	//Methods
	extern function new(string name = "ahb_agt_config");
endclass

//Constructor New
function ahb_agt_config::new(string name = "ahb_agt_config");
	super.new(name);
endfunction	

