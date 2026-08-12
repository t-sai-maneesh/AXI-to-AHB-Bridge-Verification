class axi_seqs extends uvm_sequence #(axi_xtn);
	`uvm_object_utils(axi_seqs)

	env_config m_cfg;	

	//Methods
	extern function new(string name = "axi_seqs");	
endclass

//Constructor New
function axi_seqs::new(string name = "axi_seqs");	
	super.new(name);	
endfunction

/*-------------------------------------------------------
		Test class for fixed - Write
-------------------------------------------------------*/
class axi_fixed_seqs1 extends axi_seqs;
	`uvm_object_utils(axi_fixed_seqs1)

	//Methods
	extern function new(string name = "axi_fixed_seqs1");	
	extern task body();
endclass	

function axi_fixed_seqs1::new(string name = "axi_fixed_seqs1");	
	super.new(name);	
endfunction

task axi_fixed_seqs1::body();
	req = axi_xtn::type_id::create("req");

	if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",m_cfg))
		`uvm_fatal("AHB_SEQS1","m_cfg didn't get, Have you set")

	start_item(req);
	assert(req.randomize() with {awvalid == 1; wvalid ==1; arvalid == 0; awburst == 2'b00; awlen == m_cfg.ahb_length;});
	finish_item(req);
endtask

/*-------------------------------------------------------
		Test class for fixed - Read
-------------------------------------------------------*/
class axi_fixed_seqs2 extends axi_seqs;

	`uvm_object_utils(axi_fixed_seqs2)

	//Methods
	extern function new(string name = "axi_fixed_seqs2");	
	extern task body();
endclass	

function axi_fixed_seqs2::new(string name = "axi_fixed_seqs2");	
	super.new(name);	
endfunction

task axi_fixed_seqs2::body();
	req = axi_xtn::type_id::create("req");

	if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",m_cfg))
		`uvm_fatal("AHB_SEQS1","m_cfg didn't get, Have you set")

	start_item(req);
	assert(req.randomize() with {awvalid == 1; wvalid ==1; arvalid == 1; arburst == 2'b01; awlen == m_cfg.ahb_length; arlen == m_cfg.ahb_length;});
	finish_item(req);
endtask

/*-------------------------------------------------------
		Test class for Incr - Write
-------------------------------------------------------*/
class axi_incr_seqs1 extends axi_seqs;
	`uvm_object_utils(axi_incr_seqs1)

	//Methods
	extern function new(string name = "axi_incr_seqs1");	
	extern task body();
endclass	

function axi_incr_seqs1::new(string name = "axi_incr_seqs1");	
	super.new(name);	
endfunction

task axi_incr_seqs1::body();
	req = axi_xtn::type_id::create("req");

	if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",m_cfg))
		`uvm_fatal("AHB_SEQS1","m_cfg didn't get, Have you set")

	start_item(req);
	assert(req.randomize() with {awvalid == 1; wvalid ==1; arvalid == 0; awburst == 2'b01; awlen == m_cfg.ahb_length;});
	finish_item(req);
endtask

/*-------------------------------------------------------
		Test class for incr - Read
-------------------------------------------------------*/
class axi_incr_seqs2 extends axi_seqs;
	`uvm_object_utils(axi_incr_seqs2)

	//Methods
	extern function new(string name = "axi_incr_seqs2");	
	extern task body();
endclass	

function axi_incr_seqs2::new(string name = "axi_incr_seqs2");	
	super.new(name);	
endfunction

task axi_incr_seqs2::body();
	req = axi_xtn::type_id::create("req");

	if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",m_cfg))
		`uvm_fatal("AHB_SEQS1","m_cfg didn't get, Have you set")

	start_item(req);
	assert(req.randomize() with {awvalid == 0; wvalid ==0; arvalid == 1; arburst == 2'b01; awlen == 8'd0; arlen == m_cfg.ahb_length;});
	finish_item(req);
endtask

/*-------------------------------------------------------
		Test class for wrap - Write
-------------------------------------------------------*/
class axi_wrap_seqs1 extends axi_seqs;
	`uvm_object_utils(axi_wrap_seqs1)

	//Methods
	extern function new(string name = "axi_wrap_seqs1");	
	extern task body();
endclass	

function axi_wrap_seqs1::new(string name = "axi_wrap_seqs1");	
	super.new(name);	
endfunction

task axi_wrap_seqs1::body();
	req = axi_xtn::type_id::create("req");

	if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",m_cfg))
		`uvm_fatal("AHB_SEQS1","m_cfg didn't get, Have you set")

	start_item(req);
	assert(req.randomize() with {awvalid == 1; wvalid ==1; arvalid == 0; awburst == 2'b10; awlen == m_cfg.ahb_length;});
	finish_item(req);
endtask

/*-------------------------------------------------------
		Test class for wrap - Read
-------------------------------------------------------*/
class axi_wrap_seqs2 extends axi_seqs;
	`uvm_object_utils(axi_wrap_seqs2)

	//Methods
	extern function new(string name = "axi_wrap_seqs2");	
	extern task body();
endclass	

function axi_wrap_seqs2::new(string name = "axi_wrap_seqs2");	
	super.new(name);	
endfunction

task axi_wrap_seqs2::body();
	req = axi_xtn::type_id::create("req");

	if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",m_cfg))
		`uvm_fatal("AHB_SEQS1","m_cfg didn't get, Have you set")

	start_item(req);
	assert(req.randomize() with {awvalid == 0; wvalid ==0; arvalid == 1; arburst == 2'b10; awlen == 8'd0; arlen == m_cfg.ahb_length;});
	finish_item(req);
endtask


