class ahb_rst_agent extends uvm_agent;
	`uvm_component_utils(ahb_rst_agent)

	//Handles
	ahb_rst_agt_config m_cfg;
	ahb_rst_seqsr seqsr;
	ahb_rst_driver drv;
	ahb_rst_monitor mon;

	//Methods
	extern function new(string name = "ahb_rst_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);	
endclass

//Constructor New
function ahb_rst_agent::new(string name = "ahb_rst_agent", uvm_component parent);
	super.new(name,parent);
endfunction

//Build phase
function void ahb_rst_agent::build_phase(uvm_phase phase);
	if(!uvm_config_db #(ahb_rst_agt_config)::get(this,"","ahb_rst_agt_config",m_cfg))
		`uvm_fatal("AHB_RST_AGENT","m_cfg didn't get, Have you set")

	mon = ahb_rst_monitor::type_id::create("mon",this);

	if(m_cfg.is_active)
	begin	
		seqsr = ahb_rst_seqsr::type_id::create("seqsr",this);
		drv = ahb_rst_driver::type_id::create("drv",this);
	end
endfunction

//Connect phase
function void ahb_rst_agent::connect_phase(uvm_phase phase);
	if(m_cfg.is_active)
		drv.seq_item_port.connect(seqsr.seq_item_export);
endfunction		


