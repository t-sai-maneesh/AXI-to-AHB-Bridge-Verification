class axi_rst_agent extends uvm_agent;
	`uvm_component_utils(axi_rst_agent)

	//Handles
	axi_rst_agt_config m_cfg;
	axi_rst_seqsr seqsr;
	axi_rst_driver drv;
	axi_rst_monitor mon;

	//Methods
	extern function new(string name = "axi_rst_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);	
endclass

//Constructor New
function axi_rst_agent::new(string name = "axi_rst_agent", uvm_component parent);
	super.new(name,parent);
endfunction

//Build phase
function void axi_rst_agent::build_phase(uvm_phase phase);
	if(!uvm_config_db #(axi_rst_agt_config)::get(this,"","axi_rst_agt_config",m_cfg))
		`uvm_fatal("AXI_RST_AGENT","m_cfg didn't get, Have you set")

	mon = axi_rst_monitor::type_id::create("mon",this);

	if(m_cfg.is_active)
	begin	
		seqsr = axi_rst_seqsr::type_id::create("seqsr",this);
		drv = axi_rst_driver::type_id::create("drv",this);
	end
endfunction

//Connect phase
function void axi_rst_agent::connect_phase(uvm_phase phase);
	if(m_cfg.is_active)
		drv.seq_item_port.connect(seqsr.seq_item_export);
endfunction		

