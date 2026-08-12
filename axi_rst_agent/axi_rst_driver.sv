class axi_rst_driver extends uvm_driver #(axi_rst_xtn);
	`uvm_component_utils(axi_rst_driver)

	virtual axi_rst_if.AXI_RST_DRV_MP vif;
	axi_rst_agt_config m_cfg;	

	//Methods
	extern function new(string name = "axi_rst_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(axi_rst_xtn xtn);
endclass

//Constructor New
function axi_rst_driver::new(string name = "axi_rst_driver", uvm_component parent);
	super.new(name,parent);
endfunction

//Build Phase
function void axi_rst_driver::build_phase(uvm_phase phase);
	if(!uvm_config_db #(axi_rst_agt_config)::get(this,"","axi_rst_agt_config",m_cfg))
		`uvm_fatal("AXI_RST_DRIVER","m_cfg didn't get, Have you set")
endfunction

//Connect phase
function void axi_rst_driver::connect_phase(uvm_phase phase);
	vif = m_cfg.vif;
endfunction

//Run phase
task axi_rst_driver::run_phase(uvm_phase phase);
	forever
	begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);	
		seq_item_port.item_done();
	end
endtask

//Send to DUT
task axi_rst_driver::send_to_dut(axi_rst_xtn xtn);
	@(vif.axi_rst_drv_cb);
	vif.axi_rst_drv_cb.aresetn <= xtn.aresetn;
	@(vif.axi_rst_drv_cb);
	@(vif.axi_rst_drv_cb);
	vif.axi_rst_drv_cb.aresetn <= 1'b1;

	`uvm_info("AXI_RST_DRIVER","Printing from AXI_RST Driver",UVM_LOW)
	xtn.print();
endtask

