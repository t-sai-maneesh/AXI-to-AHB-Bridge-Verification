class axi_rst_monitor extends uvm_monitor;
	`uvm_component_utils(axi_rst_monitor)

	uvm_analysis_port #(axi_rst_xtn) rst_mon_port;

	virtual axi_rst_if.AXI_RST_MON_MP r_vif;
	virtual axi_if.AXI_MON_MP a_vif;
	axi_rst_agt_config m_rst_cfg;
	axi_agt_config m_axi_cfg;

	axi_rst_xtn xtn;

	//Methods
	extern function new(string name = "axi_rst_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
endclass

//Constructor New
function axi_rst_monitor::new(string name = "axi_rst_monitor", uvm_component parent);
	super.new(name,parent);
	rst_mon_port = new("rst_mon_port",this);
endfunction

//Build phase
function void axi_rst_monitor::build_phase(uvm_phase phase);
	if(!uvm_config_db #(axi_rst_agt_config)::get(this,"","axi_rst_agt_config",m_rst_cfg))
		`uvm_fatal("AXI_RST_MONITOR","m_rst_cfg didn't get, Have you set")
	if(!uvm_config_db #(axi_agt_config)::get(this,"","axi_agt_config",m_axi_cfg))
                `uvm_fatal("AXI_RST_MONITOR","m_axi_cfg didn't get, Have you set")

	xtn = axi_rst_xtn::type_id::create("xtn");
endfunction

//Connect phase
function void axi_rst_monitor::connect_phase(uvm_phase phase);
	r_vif = m_rst_cfg.vif;
	a_vif = m_axi_cfg.vif;
endfunction
	
//Run phase
task axi_rst_monitor::run_phase(uvm_phase phase);
	forever
		collect_data();
endtask

//Collect data
task axi_rst_monitor::collect_data();
	wait(!r_vif.axi_rst_mon_cb.aresetn);
	@(r_vif.axi_rst_mon_cb);
	xtn.aresetn = r_vif.axi_rst_mon_cb.aresetn;
	xtn.bvalid = a_vif.axi_mon_cb.bvalid;
	xtn.rvalid = a_vif.axi_mon_cb.rvalid;

	`uvm_info("AXI_RST_MONITOR","Printing from AXI_RST Monitor",UVM_LOW)
	xtn.print();

	rst_mon_port.write(xtn);
endtask
