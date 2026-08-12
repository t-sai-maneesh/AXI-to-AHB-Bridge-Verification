class ahb_monitor extends uvm_monitor;
	`uvm_component_utils(ahb_monitor)

	//Handles 
	ahb_agt_config m_cfg;	
	virtual ahb_if.AHB_MON_MP vif;
	ahb_xtn xtn;

	uvm_analysis_port #(ahb_xtn) mon_port;

	//Methods
	extern function new(string name = "ahb_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
endclass

//Constructor New
function ahb_monitor::new(string name = "ahb_monitor", uvm_component parent);
	super.new(name,parent);
	mon_port = new("mon_port",this);
endfunction

//Build Phase
function void ahb_monitor::build_phase(uvm_phase phase);
	if(!uvm_config_db #(ahb_agt_config)::get(this,"","ahb_agt_config",m_cfg))
		`uvm_fatal("AHB_MONITOR","m_cfg didn't get, Have you set")
endfunction

//Connect phase
function void ahb_monitor::connect_phase(uvm_phase phase);
	vif = m_cfg.vif;
endfunction

//Run phase
task ahb_monitor::run_phase(uvm_phase phase);
	forever
		collect_data();	
endtask

//Collect Data
task ahb_monitor::collect_data();
	xtn = ahb_xtn::type_id::create("xtn");
	
	wait(vif.ahb_mon_cb.hready === 1 && vif.ahb_mon_cb.htrans === 2'b10);
	xtn.haddr = vif.ahb_mon_cb.haddr;
	xtn.htrans = vif.ahb_mon_cb.htrans;
	xtn.hburst = vif.ahb_mon_cb.hburst;
	xtn.hsize = vif.ahb_mon_cb.hsize;
	xtn.hwrite = vif.ahb_mon_cb.hwrite;
	xtn.hready = vif.ahb_mon_cb.hready;
	xtn.hresp = vif.ahb_mon_cb.hresp;
	if(vif.ahb_mon_cb.hwrite == 1)
	begin
		@(vif.ahb_mon_cb);
		wait(vif.ahb_mon_cb.hready == 1);
		xtn.hwdata = vif.ahb_mon_cb.hwdata;
		mon_port.write(xtn);
	end
	else
	begin
	$display("aaaaaaaaaaaaaaaaaaaaaaaaaaaaa %b",vif.ahb_mon_cb.hwrite);


		@(vif.ahb_mon_cb);
                wait(vif.ahb_mon_cb.hready === 1);
                xtn.hrdata = vif.ahb_mon_cb.hrdata;
                mon_port.write(xtn);
	end

	`uvm_info("AHB_MONITOR","Printing from AHB Monitor",UVM_LOW)
	xtn.print();
endtask


