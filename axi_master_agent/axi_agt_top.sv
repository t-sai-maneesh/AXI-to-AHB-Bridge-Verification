class axi_agt_top extends uvm_env;
	`uvm_component_utils(axi_agt_top)

	//Handles
	env_config m_cfg;
	axi_agent agnth[];

	//Methods
	extern function new(string name = "axi_agt_top", uvm_component parent);
	extern function void build_phase(uvm_phase phase);	
endclass

//Constructor New
function axi_agt_top::new(string name = "axi_agt_top", uvm_component parent);
	super.new(name,parent);
endfunction

//Build phase
function void axi_agt_top::build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
		`uvm_fatal("AXI_AGT_TOP","m_cfg_didn't get, Have you set")

	agnth = new[m_cfg.no_of_axi_agents];
	
	foreach(agnth[i])
		agnth[i] = axi_agent::type_id::create($sformatf("agnth[%0d]",i),this);
endfunction
