class axi_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(axi_scoreboard)

	uvm_tlm_analysis_fifo #(axi_rst_xtn) fifo_axi_rst_h[];
	uvm_tlm_analysis_fifo #(ahb_rst_xtn) fifo_ahb_rst_h[];
	uvm_tlm_analysis_fifo #(axi_xtn) fifo_axi_h[];
	uvm_tlm_analysis_fifo #(ahb_xtn) fifo_ahb_h[];
	uvm_tlm_analysis_fifo #(axi_xtn) fifo_axi_wdata_h[];
	uvm_tlm_analysis_fifo #(axi_xtn) fifo_axi_rdata_h[];

	axi_xtn wdata[$],rdata[$];

	axi_rst_xtn axi_rst;
	axi_rst_xtn axi_rst_cov_data;
	ahb_rst_xtn ahb_rst;
	ahb_rst_xtn ahb_rst_cov_data;

	axi_xtn axi_xtnh,axi_wdata,axi_rdata;
	axi_xtn axi_cov_data;

	ahb_xtn ahb_xtnh;	
	ahb_xtn ahb_cov_data;

	env_config m_cfg;

	covergroup axi_rst_cg;
		option.per_instance = 1;
		CP_A_ARESETN: coverpoint axi_rst_cov_data.aresetn {bins RST[] = {0,1};}
	endgroup
	
	covergroup ahb_rst_cg;
		option.per_instance = 1;
		CP_H_ARESETN: coverpoint ahb_rst_cov_data.hresetn {bins RST[] = {0,1};}
	endgroup

	covergroup axi_cg;
		option.per_instance = 1;
		CP_AW_ID: coverpoint axi_cov_data.awid {bins low = {[0:$]};}

		CP_AW_ADDR:  coverpoint axi_cov_data.awaddr { bins awaddr = {[32'h0000_0000:32'hffff_ffff]};}
	
		CP_AWLEN: coverpoint axi_cov_data.awlen { bins AWLEN = {[1:15]};}

		CP_AWSIZE: coverpoint axi_cov_data.awsize { bins AW_SIZE[] = {0,1,2,3};}
	
		CP_AWBURST: coverpoint axi_cov_data.awburst { bins AW_BURST[] = {[0:2]};}

		CP_WID: coverpoint axi_cov_data.wid { bins low = {[0:$]};}

		CP_WLAST: coverpoint axi_cov_data.wlast { bins W_LAST[] = {[0:1]};}

		CP_BID: coverpoint axi_cov_data.bid { bins low = {[0:$]};}

		CP_BRESP: coverpoint axi_cov_data.bresp { bins B_RESP[] = {[0:1]};}

		CPARID: coverpoint axi_cov_data.arid { bins low = {[0:$]};}

		CP_AR_ADDR:  coverpoint axi_cov_data.araddr { bins araddr = {[32'h0000_0000:32'hffff_ffff]};}

		CP_ARLEN: coverpoint axi_cov_data.arlen { bins ARLEN = {[1:15]};}

		CP_ARSIZE: coverpoint axi_cov_data.arsize { bins AR_SIZE[] = {0,1,2,3};}
	
		CP_ARBURST: coverpoint axi_cov_data.arburst { bins AR_BURST[] = {[0:2]};}

		CP_RID: coverpoint axi_cov_data.rid { bins low = {[0:$]};}

		CP_RLAST: coverpoint axi_cov_data.rlast { bins W_LAST[] = {[0:1]};}
	endgroup

	covergroup axi_wdata_dyn with function sample(int i);
		CP_W_DATA: coverpoint axi_cov_data.wdata[i] { bins wdata = {[64'h0000_0000_0000_0000:64'hffff_ffff_ffff_ffff]};}

		CP_W_STRB: coverpoint axi_cov_data.wstrb[i] { bins w_strb = {1,2,4,8,16,32,64,128};}
	endgroup

	covergroup axi_rdata_dyn with function sample(int i);
		CP_R_DATA: coverpoint axi_cov_data.rdata[i] { bins wdata = {[64'h0000_0000_0000_0000:64'hffff_ffff_ffff_ffff]};}

		CP_RRESP: coverpoint axi_cov_data.rresp[i] { bins RRESP = {0};}
	endgroup

	covergroup ahb_cg;	
		option.per_instance = 1;
		CP_HADDR: coverpoint ahb_cov_data.haddr { bins awaddr = {[32'h0000_0000:32'hffff_ffff]};}

		CP_HWRITE: coverpoint ahb_cov_data.hwrite { bins HWRITE[] = {0,1};}

		CP_HSIZE: coverpoint ahb_cov_data.hsize { bins H_SIZE[] = {0,1,2,3};}

		CP_HREADY: coverpoint ahb_cov_data.hready { bins H_READY = {1};}

		CP_HRESP: coverpoint ahb_cov_data.hresp { bins H_RESP = {0,1};}

		CP_HWDATA: coverpoint ahb_cov_data.hwdata { bins ahb_wdata = {[64'h0000_0000_0000_0000:64'hffff_ffff_ffff_ffff]};}
	
		CP_HRDATA: coverpoint ahb_cov_data.hrdata { bins ahb_rdata = {[64'h0000_0000_0000_0000:64'hffff_ffff_ffff_ffff]};}
	endgroup							 

	//Methods
	extern function new(string name = "axi_scoreboard", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task axi_rst_check(axi_rst_xtn axi_rst);
	extern task ahb_rst_check(ahb_rst_xtn ahb_rst);
	extern task data_compare(ahb_xtn ahb_xtnh);
endclass

//Constructor New
function axi_scoreboard::new(string name = "axi_scoreboard", uvm_component parent);
	super.new(name,parent);
	axi_cg = new();	
	axi_rst_cg = new();
	ahb_cg = new();
	ahb_rst_cg = new();
	axi_wdata_dyn = new();
	axi_rdata_dyn = new();
endfunction

//BUild Phase
function void axi_scoreboard::build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
		`uvm_fatal("AXI_SCOREBOARD","m_cfg didn't get, Have you set")

	fifo_axi_rst_h = new[m_cfg.no_of_axi_rst_agents];	
	fifo_ahb_rst_h = new[m_cfg.no_of_ahb_rst_agents];	
	fifo_axi_h = new[m_cfg.no_of_axi_agents];	
	fifo_axi_wdata_h = new[m_cfg.no_of_axi_agents];
	fifo_axi_rdata_h = new[m_cfg.no_of_axi_agents];	
	fifo_ahb_h = new[m_cfg.no_of_ahb_agents];	
	
	foreach(fifo_axi_rst_h[i])
		fifo_axi_rst_h[i] = new($sformatf("fifo_axi_rst_h[%0d]",i),this);
	
	foreach(fifo_ahb_rst_h[i])
		fifo_ahb_rst_h[i] = new($sformatf("fifo_ahb_rst_h[%0d]",i),this);

	foreach(fifo_axi_h[i])
		fifo_axi_h[i] = new($sformatf("fifo_axi_h[%0d]",i),this);

	foreach(fifo_axi_wdata_h[i])
		fifo_axi_wdata_h[i] = new($sformatf("fifo_axi_wdata_h[%0d]",i),this);

	foreach(fifo_axi_rdata_h[i])
		fifo_axi_rdata_h[i] = new($sformatf("fifo_axi_rdata_h[%0d]",i),this);

	foreach(fifo_ahb_h[i])
		fifo_ahb_h[i] = new($sformatf("fifo_ahb_h[%0d]",i),this);
endfunction

//Run Phase
task axi_scoreboard::run_phase(uvm_phase phase);	
	fork
	begin
		forever
		begin
			fifo_axi_rst_h[0].get(axi_rst);
			axi_rst_check(axi_rst);
			axi_rst_cov_data = new axi_rst;
			axi_rst_cg.sample();
		end
	end
	
	begin
		forever
		begin
			fifo_ahb_rst_h[0].get(ahb_rst);
			ahb_rst_check(ahb_rst);
			ahb_rst_cov_data = new ahb_rst;
			ahb_rst_cg.sample();
		end
	end

	begin
		forever
		begin
			fifo_axi_h[0].get(axi_xtnh);
			axi_cov_data = new axi_xtnh;
			axi_cg.sample();
			axi_cov_data = new axi_xtnh;				
			foreach(axi_cov_data.wdata[i])
				axi_wdata_dyn.sample(i);

			axi_cov_data = new axi_xtnh;							
			foreach(axi_cov_data.rdata[i])
				axi_rdata_dyn.sample(i);
		end
	end

	begin	
		forever
		begin
			fifo_ahb_h[0].get(ahb_xtnh);
			ahb_cov_data = new ahb_xtnh;
			data_compare(ahb_xtnh);
			ahb_cg.sample();
		end
	end
	
	begin
		forever
		begin	
			fifo_axi_wdata_h[0].get(axi_wdata);
			wdata.push_back(axi_wdata);
		end
	end

	begin	
		forever
		begin	
			fifo_axi_rdata_h[0].get(axi_rdata);
			rdata.push_back(axi_rdata);
		end
	end
	join
endtask

//Axi Rst check
task axi_scoreboard::axi_rst_check(axi_rst_xtn axi_rst);
	if(axi_rst.aresetn == 1'b0)
	begin
		if(axi_rst.bvalid == 1'b0 && axi_rst.rvalid == 1'b0)
			`uvm_info("AXI_SCOREBOARD","AXI Reset Operation Success",UVM_LOW)
		else
			`uvm_info("AXI_SCOREBOARD","AXI Reset Operation Success",UVM_LOW)
	end
endtask

//Ahb rst check
task axi_scoreboard::ahb_rst_check(ahb_rst_xtn ahb_rst);
	if(ahb_rst.hresetn == 1'b0)
	begin
		if(ahb_rst.htrans == 2'b0)
			`uvm_info("AXI_SCOREBOARD","AHB Reset Operation Success",UVM_LOW)
		else
			`uvm_info("AXI_SCOREBOARD","AHB Reset Operation Success",UVM_LOW)
	end
endtask

//Data Compare
task axi_scoreboard::data_compare(ahb_xtn ahb_xtnh);
	axi_xtn axi_xtnh;
	if(ahb_xtnh.hwrite == 1)
	begin
		wait(wdata.size() != 0);
		axi_xtnh = wdata.pop_front();
		if(axi_xtnh.temp_wdata == ahb_xtnh.hwdata)
		begin
			`uvm_info("AXI_SCOREBOARD","Data is Matched",UVM_LOW)
			`uvm_info("AXI_SCOREBOARD",$sformatf("axi_temp_wdata: %0d, ahb_hwdata: %0d",axi_xtnh.temp_wdata,ahb_xtnh.hwdata),UVM_LOW)
		end
		else
			`uvm_error("AXI_SCOREBOARD","Data is Mismatched")
	end
	else
	begin
		wait(rdata.size() != 0);
		axi_xtnh = rdata.pop_front();
		if(axi_xtnh.temp_rdata == ahb_xtnh.hrdata)
		begin
			`uvm_info("AXI_SCOREBOARD","Data is Matched",UVM_LOW)
			`uvm_info("AXI_SCOREBOARD",$sformatf("axi_temp_rdata: %0d, ahb_hrdata: %0d",axi_xtnh.temp_rdata,ahb_xtnh.hrdata),UVM_LOW)
		end
		else
			`uvm_error("AXI_SCOREBOARD","Data is Mismatched")
	end
endtask
	

	



