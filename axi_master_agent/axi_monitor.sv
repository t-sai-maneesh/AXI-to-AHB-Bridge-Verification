class axi_monitor extends uvm_monitor;
	`uvm_component_utils(axi_monitor)

	virtual axi_if.AXI_MON_MP vif;
	axi_agt_config m_cfg;

	//Analysis Ports
	uvm_analysis_port #(axi_xtn) axi_monitor_port;
	uvm_analysis_port #(axi_xtn) axi_wr_data_monitor_port;
	uvm_analysis_port #(axi_xtn) axi_rd_data_monitor_port;	

	axi_xtn xtn,xtn1,xtn2,xtn3,xtn4,axi_wr_data,axi_rd_data;
	axi_xtn q1[$], q2[$];

	semaphore aw_w = new(); //wr_addr data dependent channel
	semaphore w_b = new(); //wr_data resp dependent channel
	semaphore aw = new(1); //wr_addr channel
	semaphore w = new(1); //wr_data channel
	semaphore b = new(1); //wr_resp channel

	semaphore ar_r = new(); //rd_addr data dependent channel
	semaphore ar = new(1); //rd_addr channel
	semaphore r = new(1); //rd_data channel

	//Methods
	extern function new(string name = "axi_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);	
	extern function void connect_phase(uvm_phase phase);	
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern task write_addr_channel();
	extern task write_data_channel(axi_xtn xtn);
	extern task write_resp_channel(axi_xtn xtn1);
	extern task read_addr_channel();
	extern task read_data_channel(axi_xtn xtn3);	
endclass

//Constructor New
function axi_monitor::new(string name = "axi_monitor", uvm_component parent);
	super.new(name,parent);
	axi_monitor_port = new("axi_monitor_port",this);
	axi_wr_data_monitor_port = new("axi_wr_data_monitor_port",this);
	axi_rd_data_monitor_port = new("axi_rd_data_monitor_port",this);
endfunction

//Build Phase
function void axi_monitor::build_phase(uvm_phase phase);
	if(!uvm_config_db #(axi_agt_config)::get(this,"","axi_agt_config",m_cfg))
		`uvm_fatal("AXI_MONITOR","m_cfg didn't get, Have you Set")
endfunction

//Connect phase
function void axi_monitor::connect_phase(uvm_phase phase);
	vif = m_cfg.vif;
endfunction

//Run phase
task axi_monitor::run_phase(uvm_phase phase);
	forever
	begin
		collect_data();
	end
endtask

//Collect data
task axi_monitor::collect_data();
	xtn = axi_xtn::type_id::create("xtn");
	
	fork
	begin
		aw.get(1);
		write_addr_channel();
		aw.put(1);
		aw_w.put(1);	
	end

	begin
		aw_w.get(1);
		w.get(1);
		write_data_channel(q1.pop_front());
		w.put(1);			
		w_b.put(1);
	end

	begin	
		w_b.get(1);
		b.get(1);
		write_resp_channel(q1.pop_front());	
		b.put(1);		
	end

	begin	
		ar.get(1);
		read_addr_channel();
		ar.put(1);			
		ar_r.put(1);
	end
	
	begin	
		ar_r.get(1);
		r.get(1);
		read_data_channel(q2.pop_front());	
		r.put(1);		
	end
	join_any
	//`uvm_info("AXI_MONITOR","Printing from AXI Monitor",UVM_LOW)
	//	xtn.print();
endtask

//Write addr channel
task axi_monitor::write_addr_channel();
	
	wait((vif.axi_mon_cb.awvalid===1) && (vif.axi_mon_cb.awready===1))

	xtn.awid = vif.axi_mon_cb.awid;
	xtn.awvalid = vif.axi_mon_cb.awvalid;
	xtn.awready = vif.axi_mon_cb.awready;
	xtn.awaddr = vif.axi_mon_cb.awaddr;
	xtn.awlen = vif.axi_mon_cb.awlen;
	xtn.awsize = vif.axi_mon_cb.awsize;
	xtn.awburst = vif.axi_mon_cb.awburst;
	q1.push_back(xtn);
	@(vif.axi_mon_cb);
	`uvm_info("AXI_MONITOR","Printing from AXI Monitor - wr_addr",UVM_LOW)
		xtn.print();
endtask

//write data channel
task axi_monitor::write_data_channel(axi_xtn xtn);
	xtn1 = axi_xtn::type_id::create("xtn1");
	xtn1 = xtn;
	xtn1.wdata = new[xtn1.awlen+1];
	xtn1.wstrb = new[xtn1.awlen+1];

	foreach(xtn1.wdata[i])
	begin
		wait((vif.axi_mon_cb.wvalid===1) && (vif.axi_mon_cb.wready===1))

		axi_wr_data = axi_xtn::type_id::create("axi_wr_data");
		
		xtn.wready = vif.axi_mon_cb.wready;
		xtn.wvalid = vif.axi_mon_cb.wvalid;
		xtn1.wid = vif.axi_mon_cb.wid;
		xtn1.wdata[i] = vif.axi_mon_cb.wdata;
/*	xtn1.wdata[i] = vif.axi_mon_cb.wstrb[0]?vif.axi_mon_cb.wdata[7:0]:8'b00000000;
	xtn1.wdata[i]= vif.axi_mon_cb.wstrb[1]?vif.axi_mon_cb.wdata[15:8]:8'b00000000;
	xtn1.wdata[i] = vif.axi_mon_cb.wstrb[2]?vif.axi_mon_cb.wdata[23:16]:8'b00000000;
	xtn1.wdata[i] = vif.axi_mon_cb.wstrb[3]?vif.axi_mon_cb.wdata[31:24]:8'b00000000;
	xtn1.wdata[i]= vif.axi_mon_cb.wstrb[4]?vif.axi_mon_cb.wdata[39:32]:8'b00000000;
	xtn1.wdata[i] = vif.axi_mon_cb.wstrb[5]?vif.axi_mon_cb.wdata[47:40]:8'b00000000;
	xtn1.wdata[i]= vif.axi_mon_cb.wstrb[6]?vif.axi_mon_cb.wdata[55:48]:8'b00000000;
	xtn1.wdata[i]= vif.axi_mon_cb.wstrb[7]?vif.axi_mon_cb.wdata[63:56]:8'b00000000;*/

		axi_wr_data.temp_wdata[7:0] = vif.axi_mon_cb.wstrb[0]?vif.axi_mon_cb.wdata[7:0]:8'b00000000;
		axi_wr_data.temp_wdata[15:8] = vif.axi_mon_cb.wstrb[1]?vif.axi_mon_cb.wdata[15:8]:8'b00000000;
		axi_wr_data.temp_wdata[23:16] = vif.axi_mon_cb.wstrb[2]?vif.axi_mon_cb.wdata[23:16]:8'b00000000;
		axi_wr_data.temp_wdata[31:24] = vif.axi_mon_cb.wstrb[3]?vif.axi_mon_cb.wdata[31:24]:8'b00000000;
		axi_wr_data.temp_wdata[39:32] = vif.axi_mon_cb.wstrb[4]?vif.axi_mon_cb.wdata[39:32]:8'b00000000;
		axi_wr_data.temp_wdata[47:40] = vif.axi_mon_cb.wstrb[5]?vif.axi_mon_cb.wdata[47:40]:8'b00000000;
		axi_wr_data.temp_wdata[55:48] = vif.axi_mon_cb.wstrb[6]?vif.axi_mon_cb.wdata[55:48]:8'b00000000;
		axi_wr_data.temp_wdata[63:56] = vif.axi_mon_cb.wstrb[7]?vif.axi_mon_cb.wdata[63:56]:8'b00000000;
		$display("Temp_wdata : %d",axi_wr_data.temp_wdata);

		xtn1.wstrb[i] = vif.axi_mon_cb.wstrb;
		if(i == (xtn1.wdata.size-1))
			xtn1.wlast = vif.axi_mon_cb.wlast;
		@(vif.axi_mon_cb);
		axi_wr_data_monitor_port.write(axi_wr_data);
	end
	`uvm_info("AXI_MONITOR","Printing from AXI Monitor - wr_data",UVM_LOW)
		xtn.print();

	q1.push_back(xtn1);
	
endtask

//Write resp channel
task axi_monitor::write_resp_channel(axi_xtn xtn1);
	xtn2 = axi_xtn::type_id::create("xtn2");
	xtn2 = xtn1;
	@(vif.axi_mon_cb);
	wait((vif.axi_mon_cb.bvalid===1) && (vif.axi_mon_cb.bready===1))

	xtn.bvalid = vif.axi_mon_cb.bvalid;
	xtn.bready = vif.axi_mon_cb.bready;
	xtn2.bid = vif.axi_mon_cb.bid;
	xtn2.bresp = vif.axi_mon_cb.bresp;
	//xtn2.bvalid = vif.axi_mon_cb.bvalid;
	`uvm_info("AXI_MONITOR","Printing from AXI Monitor - wr_resp",UVM_LOW)
	xtn.print();
	axi_monitor_port.write(xtn2);

	q1.push_back(xtn2);
	
endtask

//Read Addr channel
task axi_monitor::read_addr_channel();
	xtn3 = axi_xtn::type_id::create("xtn3");
	@(vif.axi_mon_cb);
	wait((vif.axi_mon_cb.arvalid ===1) && (vif.axi_mon_cb.arready===1))

	xtn3.arid = vif.axi_mon_cb.arid;
	xtn3.arvalid = vif.axi_mon_cb.arvalid;
	xtn3.arready = vif.axi_mon_cb.arready;
	xtn3.araddr = vif.axi_mon_cb.araddr;
	xtn3.arlen = vif.axi_mon_cb.arlen;
	xtn3.arsize = vif.axi_mon_cb.arsize;
	xtn3.arburst = vif.axi_mon_cb.arburst;
	`uvm_info("AXI_MONITOR","Printing from AXI Monitor - rd_addr",UVM_LOW)
		xtn3.print();

	q2.push_back(xtn3);
	@(vif.axi_mon_cb);
endtask

//Read Data Channel
task axi_monitor::read_data_channel(axi_xtn xtn3);
	bit a;
	xtn4 = axi_xtn::type_id::create("xtn4");
	xtn4 = xtn3;
	xtn4.rdata = new[xtn4.arlen+1];
	foreach(xtn4.rdata[i])
	begin	
		wait((vif.axi_mon_cb.rvalid) && (vif.axi_mon_cb.rready))
		axi_rd_data = axi_xtn::type_id::create("axi_rd_data");
		xtn4.rid = vif.axi_mon_cb.rid;
		xtn4.rvalid = vif.axi_mon_cb.rvalid;
		xtn4.rready = vif.axi_mon_cb.rready;
		xtn4.rdata[i] = vif.axi_mon_cb.rdata;
		xtn4.rresp[i] = vif.axi_mon_cb.rresp;
		axi_rd_data.temp_rdata = vif.axi_mon_cb.rdata;
		
		if(i == (xtn4.rdata.size-1))
		begin
			xtn4.rlast = vif.axi_mon_cb.rlast;
			a = vif.axi_mon_cb.rlast;
		end
		`uvm_info("AXI_MONITOR","Printing from AXI Monitor - rd_data",UVM_LOW)
		xtn4.print();
		@(vif.axi_mon_cb);	
		axi_rd_data_monitor_port.write(axi_rd_data);
	end
	
	axi_monitor_port.write(xtn4);
endtask

