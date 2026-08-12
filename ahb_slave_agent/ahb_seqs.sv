class ahb_seqs extends uvm_sequence #(ahb_xtn);
	`uvm_object_utils(ahb_seqs)

	env_config m_cfg;

	//Methods
	extern function new(string name = "ahb_seqs");	
endclass

//Constructor New
function ahb_seqs::new(string name = "ahb_seqs");	
	super.new(name);	
endfunction

/*------------------------------------------------------------------
			AHB SEQ1
------------------------------------------------------------------*/
class ahb_seqs1 extends ahb_seqs;	
	`uvm_object_utils(ahb_seqs1)
	
	//Methods
	extern function new(string name = "ahb_seqs1");
	extern task body();
endclass

//Constructor New
function ahb_seqs1::new(string name = "ahb_seqs1");	
	super.new(name);	
endfunction

//Body
task ahb_seqs1::body();
	req = ahb_xtn::type_id::create("req");

	if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",m_cfg))
		`uvm_fatal("AHB_SEQS1","m_cfg didn't get, Have you set")

	repeat((2*(m_cfg.ahb_length + 1)))
	begin	
		start_item(req);
		assert(req.randomize() with {delay_cycles == 2;});
		finish_item(req);
	end
endtask

/*------------------------------------------------------------------
			AHB Read SEQ
------------------------------------------------------------------*/
class ahb_rd_seqs extends ahb_seqs;	
	`uvm_object_utils(ahb_rd_seqs)
	
	//Methods
	extern function new(string name = "ahb_rd_seqs");
	extern task body();
endclass

//Constructor New
function ahb_rd_seqs::new(string name = "ahb_rd_seqs");	
	super.new(name);	
endfunction

//Body
task ahb_rd_seqs::body();
	req = ahb_xtn::type_id::create("req");

	if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",m_cfg))
		`uvm_fatal("AHB_rd_SEQS","m_cfg didn't get, Have you set")

	repeat((2*(m_cfg.ahb_length + 1)))
	begin	
		start_item(req);
		assert(req.randomize() with {delay_cycles == 2; resp == 0;});
		finish_item(req);
	end
endtask

/*------------------------------------------------------------------
			AHB SEQ2
------------------------------------------------------------------*/
class ahb_seqs2 extends ahb_seqs;	
	`uvm_object_utils(ahb_seqs2)
	
	//Methods
	extern function new(string name = "ahb_seqs2");
	extern task body();
endclass

//Constructor New
function ahb_seqs2::new(string name = "ahb_seqs2");	
	super.new(name);	
endfunction

//Body
task ahb_seqs2::body();
	req = ahb_xtn::type_id::create("req");

	if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",m_cfg))
		`uvm_fatal("AHB_SEQS2","m_cfg didn't get, Have you set")

	repeat((2*(m_cfg.ahb_length + 1)))
	begin	
		start_item(req);
		assert(req.randomize() with {delay_cycles == 2; resp == 1;});
		finish_item(req);
	end
endtask

