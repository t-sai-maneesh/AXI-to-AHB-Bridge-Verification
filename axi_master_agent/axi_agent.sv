class axi_agent extends uvm_agent;
	`uvm_component_utils(axi_agent)

	//Handles
	axi_agt_config m_cfg;
	axi_seqsr seqsr;
	axi_driver drv;
	axi_monitor mon;

	//Methods
	extern function new(string name = "axi_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);	
endclass

//Constructor New
function axi_agent::new(string name = "axi_agent", uvm_component parent);
	super.new(name,parent);
endfunction

//Build phase
function void axi_agent::build_phase(uvm_phase phase);
	if(!uvm_config_db #(axi_agt_config)::get(this,"","axi_agt_config",m_cfg))
		`uvm_fatal("AXI_AGENT","m_cfg didn't get, Have you set")

	mon = axi_monitor::type_id::create("mon",this);

	if(m_cfg.is_active)
	begin	
		seqsr = axi_seqsr::type_id::create("seqsr",this);
		drv = axi_driver::type_id::create("drv",this);
	end
endfunction

//Connect phase
function void axi_agent::connect_phase(uvm_phase phase);
	if(m_cfg.is_active)
		drv.seq_item_port.connect(seqsr.seq_item_export);
endfunction		
