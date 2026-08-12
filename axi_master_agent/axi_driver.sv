class axi_driver extends uvm_driver #(axi_xtn);
	`uvm_component_utils(axi_driver)

	axi_xtn q1[$], q2[$], q3[$], q4[$], q5[$];

	semaphore aw_w = new(); //wr_addr data dependent channel
	semaphore w_b = new(); //wr_data resp dependent channel
	semaphore aw = new(1); //wr_addr channel
	semaphore w = new(1); //wr_data channel
	semaphore b = new(1); //wr_resp channel

	semaphore ar_r = new(); //rd_addr data dependent channel
	semaphore ar = new(1); //rd_addr channel
	semaphore r = new(1); //rd_data channel

	//Handles 
	axi_agt_config m_cfg;
	axi_rst_agt_config m_rst_cfg;

	virtual axi_if.AXI_DRV_MP a_vif;
	virtual axi_rst_if.AXI_RST_DRV_MP r_vif;

	//Methods
	extern function new(string name = "axi_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(axi_xtn xtn);
	extern task write_addr_channel(axi_xtn xtn);
	extern task write_data_channel(axi_xtn xtn);
	extern task write_resp_channel(axi_xtn xtn);
	extern task read_addr_channel(axi_xtn xtn);
	extern task read_data_channel(axi_xtn xtn);	
endclass

//Constructor New
function axi_driver::new(string name = "axi_driver", uvm_component parent);
	super.new(name,parent);
endfunction

//Build phase
function void axi_driver::build_phase(uvm_phase phase);
	if(!uvm_config_db #(axi_agt_config)::get(this,"","axi_agt_config",m_cfg))
		`uvm_fatal("AXI_DRIVER","m_cfg didn't get, Have you set")
	if(!uvm_config_db #(axi_rst_agt_config)::get(this,"","axi_rst_agt_config",m_rst_cfg))
		`uvm_fatal("AXI_DRIVER","m_rst_cfg didn't get, Have you set")
endfunction

//connect phase
function void axi_driver::connect_phase(uvm_phase phase);
	a_vif = m_cfg.vif;
	r_vif = m_rst_cfg.vif;
endfunction

//Run phase
task axi_driver::run_phase(uvm_phase phase);
	forever 
	begin
		seq_item_port.get_next_item(req);	
		send_to_dut(req);
		seq_item_port.item_done();
	end
endtask

//Send to DUT
task axi_driver::send_to_dut(axi_xtn xtn);
	q1.push_back(xtn);
	q2.push_back(xtn);
	q3.push_back(xtn);
	q4.push_back(xtn);
	q5.push_back(xtn);
	
	fork
	begin
		aw.get(1);
		write_addr_channel(q1.pop_front());
		aw.put(1);
		aw_w.put(1);	
	end

	begin
		aw_w.get(1);
		w.get(1);
		write_data_channel(q2.pop_front());
		w.put(1);			
		w_b.put(1);
	end

	begin	
		w_b.get(1);
		b.get(1);
		write_resp_channel(q3.pop_front());	
		b.put(1);		
	end

	begin	
		ar.get(1);
		read_addr_channel(q4.pop_front());
		ar.put(1);			
		ar_r.put(1);
	end
	
	begin	
		ar_r.get(1);
		r.get(1);
		read_data_channel(q5.pop_front());	
		r.put(1);		
	end
	//`uvm_info("AXI_DRIVER","Printing from AXI Driver",UVM_LOW)
	//	xtn.print();

	join_any
endtask

//write_addr channel
task axi_driver::write_addr_channel(axi_xtn xtn);
	@(a_vif.axi_drv_cb);
	begin
		a_vif.axi_drv_cb.awvalid <= xtn.awvalid;
		a_vif.axi_drv_cb.awid <= xtn.awid;
		a_vif.axi_drv_cb.awaddr <= xtn.awaddr;
		a_vif.axi_drv_cb.awlen <= xtn.awlen;
		a_vif.axi_drv_cb.awsize <= xtn.awsize;
		a_vif.axi_drv_cb.awburst <= xtn.awburst;
		wait(a_vif.axi_drv_cb.awready)
		@(a_vif.axi_drv_cb);
		a_vif.axi_drv_cb.awvalid <= 1'b0;
		
		repeat(xtn.delay_cycles)
		@(a_vif.axi_drv_cb);

		`uvm_info("AXI_DRIVER","Printing from AXI Driver - Wr_addr_ch",UVM_LOW)
		xtn.print();
	end
endtask

//write data channel
task axi_driver::write_data_channel(axi_xtn xtn);
	begin
		foreach(xtn.wdata[i])
		begin
			a_vif.axi_drv_cb.wvalid <= xtn.wvalid;
			a_vif.axi_drv_cb.wid <= xtn.wid;
			a_vif.axi_drv_cb.wdata <= xtn.wdata[i];
			a_vif.axi_drv_cb.wstrb <= xtn.wstrb[i];

			if(i == (xtn.awlen))
				a_vif.axi_drv_cb.wlast <= 1'b1;
			else
				a_vif.axi_drv_cb.wlast <= 1'b0;
			wait(a_vif.axi_drv_cb.wready)
			@(a_vif.axi_drv_cb);
			a_vif.axi_drv_cb.wvalid <= 1'b0;
			a_vif.axi_drv_cb.wlast <= 1'b0;
			@(a_vif.axi_drv_cb);
						
			repeat(xtn.delay_cycles)
			@(a_vif.axi_drv_cb);
		
			`uvm_info("AXI_DRIVER","Printing from AXI Driver - Wr_data_ch",UVM_LOW)
			xtn.print();
		end
	end
endtask

//write resp channel
task axi_driver::write_resp_channel(axi_xtn xtn);
	a_vif.axi_drv_cb.bready <= 1'b1;
	wait(a_vif.axi_drv_cb.bvalid);	
	@(a_vif.axi_drv_cb);
	a_vif.axi_drv_cb.bready <= 1'b0;
	
	repeat(xtn.delay_cycles)
	@(a_vif.axi_drv_cb);

	`uvm_info("AXI_DRIVER","Printing from AXI Driver - Wr_resp_ch",UVM_LOW)
	xtn.print();

endtask

//read addr channel
task axi_driver::read_addr_channel(axi_xtn xtn);
	@(a_vif.axi_drv_cb);
	begin
		a_vif.axi_drv_cb.arvalid <= xtn.arvalid;
		a_vif.axi_drv_cb.arid <= xtn.arid;
		a_vif.axi_drv_cb.araddr <= xtn.araddr;
		a_vif.axi_drv_cb.arlen <= xtn.arlen;
		a_vif.axi_drv_cb.arsize <= xtn.arsize;
		a_vif.axi_drv_cb.arburst <= xtn.arburst;
		wait(a_vif.axi_drv_cb.arready)
		@(a_vif.axi_drv_cb);
		a_vif.axi_drv_cb.arvalid <= 1'b0;
		
		repeat(xtn.delay_cycles)
		@(a_vif.axi_drv_cb);

		`uvm_info("AXI_DRIVER","Printing from AXI Driver - rd_addr_ch",UVM_LOW)
		xtn.print();
	end
endtask

//read data channel
task axi_driver::read_data_channel(axi_xtn xtn);
	repeat(xtn.arlen + 1)
	begin
		@(a_vif.axi_drv_cb);
		a_vif.axi_drv_cb.rready <= 1'b1;
		wait(a_vif.axi_drv_cb.rvalid)
		@(a_vif.axi_drv_cb);
		a_vif.axi_drv_cb.rready <= 1'b0;
		
		repeat(xtn.delay_cycles)
		@(a_vif.axi_drv_cb);

		`uvm_info("AXI_DRIVER","Printing from AXI Driver - rd_data_ch",UVM_LOW)
		xtn.print();
	end
endtask
			
	

