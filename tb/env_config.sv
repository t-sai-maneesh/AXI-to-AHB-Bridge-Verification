class env_config extends uvm_object;
	`uvm_object_utils(env_config)

	uvm_active_passive_enum is_active;

	bit has_scoreboard;

	bit has_axi_agent;
	bit has_axi_rst_agent;
	bit has_ahb_agent;
	bit has_ahb_rst_agent;

	int no_of_axi_agents;
	int no_of_axi_rst_agents;
	int no_of_ahb_agents;
	int no_of_ahb_rst_agents;

	int ahb_length;

	axi_agt_config m_axi_cfg[];
	axi_rst_agt_config m_axi_rst_cfg[];
	ahb_agt_config m_ahb_cfg[];
	ahb_rst_agt_config m_ahb_rst_cfg[];

	//Methods
	extern function new(string name = "env_config");
endclass

//Constructor New
function env_config::new(string name = "env_config");
	super.new(name);
endfunction	
