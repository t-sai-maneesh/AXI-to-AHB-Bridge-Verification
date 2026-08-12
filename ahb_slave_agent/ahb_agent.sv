class ahb_agent extends uvm_agent;
	`uvm_component_utils(ahb_agent)

	//Handles
	ahb_agt_config m_cfg;
	ahb_seqsr seqsr;
	ahb_driver drv;
	ahb_monitor mon;

	//Methods
	extern function new(string name = "ahb_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);	
endclass

//Constructor New
function ahb_agent::new(string name = "ahb_agent", uvm_component parent);
	super.new(name,parent);
endfunction

//Build phase
function void ahb_agent::build_phase(uvm_phase phase);
	if(!uvm_config_db #(ahb_agt_config)::get(this,"","ahb_agt_config",m_cfg))
		`uvm_fatal("AHB_AGENT","m_cfg didn't get, Have you set")

	mon = ahb_monitor::type_id::create("mon",this);

	if(m_cfg.is_active)
	begin	
		seqsr = ahb_seqsr::type_id::create("seqsr",this);
		drv = ahb_driver::type_id::create("drv",this);
	end
endfunction

//Connect phase
function void ahb_agent::connect_phase(uvm_phase phase);
	if(m_cfg.is_active)
		drv.seq_item_port.connect(seqsr.seq_item_export);
endfunction		

