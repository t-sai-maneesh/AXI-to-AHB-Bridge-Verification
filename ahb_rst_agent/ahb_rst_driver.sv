class ahb_rst_driver extends uvm_driver #(ahb_rst_xtn);
	`uvm_component_utils(ahb_rst_driver)

	virtual ahb_rst_if.AHB_RST_DRV_MP r_vif;
	virtual ahb_if.AHB_DRV_MP a_vif;
	
	ahb_rst_agt_config m_rst_cfg;
	ahb_agt_config m_ahb_cfg;

	//Methods
	extern function new(string name = "ahb_rst_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(ahb_rst_xtn xtn);
endclass

//Constructor New
function ahb_rst_driver::new(string name = "ahb_rst_driver", uvm_component parent);
	super.new(name,parent);
endfunction

//Build phase
function void ahb_rst_driver::build_phase(uvm_phase phase);
	if(!uvm_config_db #(ahb_rst_agt_config)::get(this,"","ahb_rst_agt_config",m_rst_cfg))
		`uvm_fatal("AHB_RST_DRIVER","m_rst_cfg didn't get, Have you set")
	if(!uvm_config_db #(ahb_agt_config)::get(this,"","ahb_agt_config",m_ahb_cfg))
                `uvm_fatal("AHB_RST_DRIVER","m_ahb_cfg didn't get, Have you set")
endfunction

//Connect Phase
function void ahb_rst_driver::connect_phase(uvm_phase phase);
	r_vif = m_rst_cfg.vif;
	a_vif = m_ahb_cfg.vif;
endfunction

//Run phase
task ahb_rst_driver::run_phase(uvm_phase phase);
	forever
	begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	end
endtask

//Send to DUT
task ahb_rst_driver::send_to_dut(ahb_rst_xtn xtn);
	@(r_vif.ahb_rst_drv_cb);
	r_vif.ahb_rst_drv_cb.hresetn <= xtn.hresetn;
	a_vif.ahb_drv_cb.hready <= 1'b1;
	@(r_vif.ahb_rst_drv_cb);
	@(r_vif.ahb_rst_drv_cb);
	r_vif.ahb_rst_drv_cb.hresetn <= 1'b1;
        a_vif.ahb_drv_cb.hready <= 1'b0;

	`uvm_info("AHB_RST_DRIVER","Printing from AHB_RST Driver",UVM_LOW)
	xtn.print();
endtask



