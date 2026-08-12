class ahb_rst_monitor extends uvm_monitor;
	`uvm_component_utils(ahb_rst_monitor)

	ahb_rst_xtn xtn;
	
	virtual ahb_rst_if.AHB_RST_MON_MP r_vif;
        virtual ahb_if.AHB_MON_MP a_vif;

        ahb_rst_agt_config m_rst_cfg;
        ahb_agt_config m_ahb_cfg;	

	uvm_analysis_port #(ahb_rst_xtn) rst_mon_port;

	//Methods
	extern function new(string name = "ahb_rst_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task collect_data();
endclass

//Constructor New
function ahb_rst_monitor::new(string name = "ahb_rst_monitor", uvm_component parent);
	super.new(name,parent);
	rst_mon_port = new("rst_mon_port",this);
endfunction

//Build phase
function void ahb_rst_monitor::build_phase(uvm_phase phase);
        if(!uvm_config_db #(ahb_rst_agt_config)::get(this,"","ahb_rst_agt_config",m_rst_cfg))
                `uvm_fatal("AHB_RST_DRIVER","m_rst_cfg didn't get, Have you set")
        if(!uvm_config_db #(ahb_agt_config)::get(this,"","ahb_agt_config",m_ahb_cfg))
                `uvm_fatal("AHB_RST_DRIVER","m_ahb_cfg didn't get, Have you set")

	xtn = ahb_rst_xtn::type_id::create("xtn");
endfunction

//Connect Phase
function void ahb_rst_monitor::connect_phase(uvm_phase phase);
        r_vif = m_rst_cfg.vif;
        a_vif = m_ahb_cfg.vif;
endfunction

//Run phase
task ahb_rst_monitor::run_phase(uvm_phase phase);
	forever
		collect_data();
endtask

//Collect data from DUT
task ahb_rst_monitor::collect_data();	
	wait(!r_vif.ahb_rst_mon_cb.hresetn);
	@(r_vif.ahb_rst_mon_cb);
	xtn.hresetn = r_vif.ahb_rst_mon_cb.hresetn;
	xtn.htrans = a_vif.ahb_mon_cb.htrans;

	`uvm_info("AHB_RST_MONITOR","Printing from AHB_RST Monitor",UVM_LOW)
	xtn.print();


	rst_mon_port.write(xtn);
endtask


