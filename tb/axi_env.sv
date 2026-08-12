class axi_env extends uvm_env;
	`uvm_component_utils(axi_env)

	//Handles
	env_config m_cfg;
	axi_agt_top axi_agt_toph;
	axi_rst_agt_top axi_rst_agt_toph;
	ahb_agt_top ahb_agt_toph;
	ahb_rst_agt_top ahb_rst_agt_toph;
	axi_scoreboard sb;

	//Methods
	extern function new(string name = "axi_env", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

//Constructor New
function axi_env::new(string name = "axi_env",uvm_component parent);
	super.new(name,parent);
endfunction

//Build phase
function void axi_env::build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
		`uvm_fatal("AXI_ENV","m_cfg_didn't get, Have you set")

	if(m_cfg.has_axi_agent)
		axi_agt_toph = axi_agt_top::type_id::create("axi_agt_toph",this);

	if(m_cfg.has_axi_rst_agent)
		axi_rst_agt_toph = axi_rst_agt_top::type_id::create("axi_rst_agt_toph",this);

	if(m_cfg.has_ahb_agent)
		ahb_agt_toph = ahb_agt_top::type_id::create("ahb_agt_toph",this);

	if(m_cfg.has_ahb_rst_agent)
		ahb_rst_agt_toph = ahb_rst_agt_top::type_id::create("ahb_rst_agt_toph",this);

	if(m_cfg.has_scoreboard)
		sb = axi_scoreboard::type_id::create("sb",this);
endfunction

//Connect phase
function void axi_env::connect_phase(uvm_phase phase);
	axi_rst_agt_toph.agnth[0].mon.rst_mon_port.connect(sb.fifo_axi_rst_h[0].analysis_export);
	ahb_rst_agt_toph.agnth[0].mon.rst_mon_port.connect(sb.fifo_ahb_rst_h[0].analysis_export);	
	axi_agt_toph.agnth[0].mon.axi_monitor_port.connect(sb.fifo_axi_h[0].analysis_export);
	ahb_agt_toph.agnth[0].mon.mon_port.connect(sb.fifo_ahb_h[0].analysis_export);
	axi_agt_toph.agnth[0].mon.axi_wr_data_monitor_port.connect(sb.fifo_axi_wdata_h[0].analysis_export);
	axi_agt_toph.agnth[0].mon.axi_rd_data_monitor_port.connect(sb.fifo_axi_rdata_h[0].analysis_export);
endfunction	

