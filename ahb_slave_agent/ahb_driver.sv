class ahb_driver extends uvm_driver #(ahb_xtn);
	`uvm_component_utils(ahb_driver)
	
	//Handles
	ahb_agt_config m_ahb_cfg;
	env_config m_env_cfg;
	
	virtual ahb_if.AHB_DRV_MP vif;

	//Methods
	extern function new(string name = "ahb_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(ahb_xtn xtn);
endclass

//Constructor New
function ahb_driver::new(string name = "ahb_driver", uvm_component parent);
	super.new(name,parent);
endfunction

//Build phase
function void ahb_driver::build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",m_env_cfg))
		`uvm_fatal("AHB_DRIVER","m_env_cfg didn't get, Have you set")

	if(!uvm_config_db #(ahb_agt_config)::get(this,"","ahb_agt_config",m_ahb_cfg))
		`uvm_fatal("AHB_DRIVER","m_ahb_cfg didn't get, Have you set")
endfunction

//Connect phase
function void ahb_driver::connect_phase(uvm_phase phase);
	vif = m_ahb_cfg.vif;
endfunction

//Run phase
task ahb_driver::run_phase(uvm_phase phase);
			//vif.ahb_drv_cb.hready <= 1'b0;

	forever
	begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	end
endtask

//Send to DUT
task ahb_driver::send_to_dut(ahb_xtn xtn);

	vif.ahb_drv_cb.hmaster <= 4'b0;
	if(xtn.resp == 0)
	begin				
		if(vif.ahb_drv_cb.hwrite == 1'b1)
		begin							
			vif.ahb_drv_cb.hready <= 1'b1;
			vif.ahb_drv_cb.hresp <= 2'b0;	

			@(vif.ahb_drv_cb);
			vif.ahb_drv_cb.hready <= 1'b1;
			vif.ahb_drv_cb.hresp <= 2'b0;
		end
		else if(vif.ahb_drv_cb.hwrite == 1'b0)
		begin		
			vif.ahb_drv_cb.hready <= 1'b1;
			vif.ahb_drv_cb.hresp <= 2'b0;
			`uvm_info("AHB_DRIVER",$sformatf("ahb_hrdata: %0d",xtn.hrdata),UVM_LOW)
			vif.ahb_drv_cb.hrdata <= xtn.hrdata;
			@(vif.ahb_drv_cb);
		end
	end
	else if(xtn.resp == 1)
	begin
		if(vif.ahb_drv_cb.hwrite == 1'b1)
		begin
			vif.ahb_drv_cb.hready <= 1'b0;
			vif.ahb_drv_cb.hresp <= 2'b0;

			repeat(xtn.delay_cycles)
				@(vif.ahb_drv_cb);
			@(vif.ahb_drv_cb);
			vif.ahb_drv_cb.hready <= 1'b1;
			vif.ahb_drv_cb.hresp <= 2'b0;
			@(vif.ahb_drv_cb);
			vif.ahb_drv_cb.hready <= 1'b1;
			vif.ahb_drv_cb.hresp <= 2'b0;
	
			@(vif.ahb_drv_cb);
			vif.ahb_drv_cb.hready <= 1'b0;
		end
		else if(vif.ahb_drv_cb.hwrite == 1'b0)
		begin
			vif.ahb_drv_cb.hready <= 1'b0;
			
			vif.ahb_drv_cb.hready <= 1'b1;
			vif.ahb_drv_cb.hresp <= 2'b0;
			`uvm_info("AHB_DRIVER",$sformatf("ahb_hrdata: %0d",xtn.hrdata),UVM_LOW)
			vif.ahb_drv_cb.hrdata <= xtn.hrdata;
			
			vif.ahb_drv_cb.hready <= 1'b1;
			vif.ahb_drv_cb.hresp <= 2'b0;
			`uvm_info("AHB_DRIVER",$sformatf("ahb_hrdata: %0d",xtn.hrdata),UVM_LOW)
			vif.ahb_drv_cb.hrdata <= xtn.hrdata;

			@(vif.ahb_drv_cb);
			vif.ahb_drv_cb.hready <= 1'b0;
		end
	end
	else if(xtn.resp == 2)
	begin
		if(vif.ahb_drv_cb.hwrite == 1'b1)
		begin
			@(vif.ahb_drv_cb);
			if(vif.ahb_drv_cb.htrans == 2'b10)
			begin
				vif.ahb_drv_cb.hready <= 1'b0;
				vif.ahb_drv_cb.hresp <= 2'b01;	
				@(vif.ahb_drv_cb);
				vif.ahb_drv_cb.hready <= 1'b1;
				vif.ahb_drv_cb.hresp <= 2'b01;
				@(vif.ahb_drv_cb);
				vif.ahb_drv_cb.hready <= 1'b0;
			end
			else
			begin
				@(vif.ahb_drv_cb);
				@(vif.ahb_drv_cb);
				vif.ahb_drv_cb.hready <= 1'b1;
				vif.ahb_drv_cb.hresp <= 2'b0;	
				@(vif.ahb_drv_cb);
				@(vif.ahb_drv_cb);
				vif.ahb_drv_cb.hready <= 1'b0;
			end
		end
		else if(vif.ahb_drv_cb.hwrite == 1'b0)
		begin
			@(vif.ahb_drv_cb);
                        if(vif.ahb_drv_cb.htrans == 2'b10)
                        begin
                                vif.ahb_drv_cb.hready <= 1'b0;
                                vif.ahb_drv_cb.hresp <= 2'b01;
                                @(vif.ahb_drv_cb);
                                vif.ahb_drv_cb.hready <= 1'b1;
                                vif.ahb_drv_cb.hresp <= 2'b01;
                                @(vif.ahb_drv_cb);
                                vif.ahb_drv_cb.hready <= 1'b0;
                        end
                        else
                        begin
                                @(vif.ahb_drv_cb);
                                @(vif.ahb_drv_cb);
                                vif.ahb_drv_cb.hready <= 1'b1;
                                vif.ahb_drv_cb.hresp <= 2'b0;
                                @(vif.ahb_drv_cb);
                                @(vif.ahb_drv_cb);
                                vif.ahb_drv_cb.hready <= 1'b0;
                        end
		end
	end
	
	`uvm_info("AHB_DRIVER","Printing from AHB Driver",UVM_LOW)
	xtn.print();

endtask
	
				
