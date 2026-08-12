class axi_test extends uvm_test;
	`uvm_component_utils(axi_test)
	
	//Handles
	env_config m_env_cfg;
	axi_agt_config m_axi_cfg[];
	axi_rst_agt_config m_axi_rst_cfg[];
	ahb_agt_config m_ahb_cfg[];
	ahb_rst_agt_config m_ahb_rst_cfg[];
	axi_env env;

	//Prop
	bit has_scoreboard = 1;
	bit has_axi_agent = 1;
	bit has_axi_rst_agent = 1;
	bit has_ahb_agent = 1;
	bit has_ahb_rst_agent = 1;
	
	int no_of_axi_agents = 1;
	int no_of_axi_rst_agents = 1;
	int no_of_ahb_agents = 1;
	int no_of_ahb_rst_agents = 1;

	int ahb_length = $urandom_range(0,15);

	//Methods
	extern function new(string name = "axi_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
endclass

//Constructor new
function axi_test::new(string name = "axi_test", uvm_component parent);
	super.new(name,parent);	
endfunction

//Build phase
function void axi_test::build_phase(uvm_phase phase);
	m_env_cfg = env_config::type_id::create("m_env_cfg");

	//AXI agt
	if(has_axi_agent)
	begin
		m_axi_cfg = new[no_of_axi_agents];
		foreach(m_axi_cfg[i])
		begin	
			m_axi_cfg[i] = axi_agt_config::type_id::create("m_axi_cfg");
			m_axi_cfg[i].is_active = UVM_ACTIVE;
			if(!uvm_config_db #(virtual axi_if)::get(this,"","axi_if",m_axi_cfg[i].vif))
				`uvm_fatal("AXI_TEST","m_axi_cfg didn't get, Have you set")
			m_env_cfg.m_axi_cfg = m_axi_cfg;
			uvm_config_db #(axi_agt_config)::set(this,$sformatf("*.agnth[%0d]*",i),"axi_agt_config",m_axi_cfg[i]);
		end
	end

	//AXI rst agt
	if(has_axi_rst_agent)
	begin
		m_axi_rst_cfg = new[no_of_axi_rst_agents];
		foreach(m_axi_rst_cfg[i])
		begin	
			m_axi_rst_cfg[i] = axi_rst_agt_config::type_id::create("m_axi_rst_cfg");
			m_axi_rst_cfg[i].is_active = UVM_ACTIVE;
			if(!uvm_config_db #(virtual axi_rst_if)::get(this,"","axi_rst_if",m_axi_rst_cfg[i].vif))
				`uvm_fatal("AXI_TEST","m_axi_rst_cfg didn't get, Have you set")
			m_env_cfg.m_axi_rst_cfg = m_axi_rst_cfg;
			uvm_config_db #(axi_rst_agt_config)::set(this,$sformatf("*.agnth[%0d]*",i),"axi_rst_agt_config",m_axi_rst_cfg[i]);
		end
	end

	//AHB agt
	if(has_ahb_agent)
	begin
		m_ahb_cfg = new[no_of_ahb_agents];
		foreach(m_ahb_cfg[i])
		begin	
			m_ahb_cfg[i] = ahb_agt_config::type_id::create("m_ahb_cfg");
			m_ahb_cfg[i].is_active = UVM_ACTIVE;
			if(!uvm_config_db #(virtual ahb_if)::get(this,"","ahb_if",m_ahb_cfg[i].vif))
				`uvm_fatal("AXI_TEST","m_ahb_cfg didn't get, Have you set")
			m_env_cfg.m_ahb_cfg = m_ahb_cfg;
			uvm_config_db #(ahb_agt_config)::set(this,$sformatf("*.agnth[%0d]*",i),"ahb_agt_config",m_ahb_cfg[i]);
		end
	end

	//AHB rst agt
	if(has_ahb_rst_agent)
	begin
		m_ahb_rst_cfg = new[no_of_ahb_rst_agents];
		foreach(m_ahb_rst_cfg[i])
		begin	
			m_ahb_rst_cfg[i] = ahb_rst_agt_config::type_id::create("m_ahb_rst_cfg");
			m_ahb_rst_cfg[i].is_active = UVM_ACTIVE;
			if(!uvm_config_db #(virtual ahb_rst_if)::get(this,"","ahb_rst_if",m_ahb_rst_cfg[i].vif))
				`uvm_fatal("AXI_TEST","m_ahb_rst_cfg didn't get, Have you set")
			m_env_cfg.m_ahb_rst_cfg = m_ahb_rst_cfg;
			uvm_config_db #(ahb_rst_agt_config)::set(this,$sformatf("*.agnth[%0d]*",i),"ahb_rst_agt_config",m_ahb_rst_cfg[i]);
		end
	end

	//Assigning to env config
	m_env_cfg.has_scoreboard = has_scoreboard;
	m_env_cfg.has_axi_agent = has_axi_agent;
	m_env_cfg.has_axi_rst_agent = has_axi_rst_agent;
	m_env_cfg.has_ahb_agent = has_ahb_agent;
	m_env_cfg.has_ahb_rst_agent = has_ahb_rst_agent;

	m_env_cfg.no_of_axi_agents = no_of_axi_agents;
	m_env_cfg.no_of_axi_rst_agents = no_of_axi_rst_agents;
	m_env_cfg.no_of_ahb_agents = no_of_ahb_agents;
	m_env_cfg.no_of_ahb_rst_agents = no_of_ahb_rst_agents;

	m_env_cfg.ahb_length = ahb_length;

	//set the env config
	uvm_config_db #(env_config)::set(this,"*","env_config",m_env_cfg);

	//create instance for env
	env = axi_env::type_id::create("env",this);
endfunction
	
//End of Elaboration phase
function void axi_test::end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
endfunction

/*----------------------------------------------------------------------------
			Test Class for AXI Reset
----------------------------------------------------------------------------*/
class axi_rst_seqs_test extends axi_test;
	`uvm_component_utils(axi_rst_seqs_test)

	//Declare Handles for seqs
	axi_rst_seqs axi_rst;

	//Methods
	extern function new(string name = "axi_rst_seqs_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//Constructor New
function axi_rst_seqs_test::new(string name = "axi_rst_seqs_test", uvm_component parent);
	super.new(name,parent);
endfunction

//Build Phase
function void axi_rst_seqs_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

//Run phase
task axi_rst_seqs_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	axi_rst = axi_rst_seqs::type_id::create("axi_rst");

	axi_rst.start(env.axi_rst_agt_toph.agnth[0].seqsr);
	#100;
	phase.drop_objection(this);
endtask	

/*----------------------------------------------------------------------------
			Test Class for AHB Reset
----------------------------------------------------------------------------*/
class ahb_rst_seqs_test extends axi_test;
	`uvm_component_utils(ahb_rst_seqs_test)

	//Declare Handles for seqs
	ahb_rst_seqs ahb_rst;

	//Methods
	extern function new(string name = "ahb_rst_seqs_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//Constructor New
function ahb_rst_seqs_test::new(string name = "ahb_rst_seqs_test", uvm_component parent);
	super.new(name,parent);
endfunction

//Build Phase
function void ahb_rst_seqs_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

//Run phase
task ahb_rst_seqs_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	ahb_rst = ahb_rst_seqs::type_id::create("ahb_rst");

	ahb_rst.start(env.ahb_rst_agt_toph.agnth[0].seqsr);
	#100;
	phase.drop_objection(this);
endtask	

/*----------------------------------------------------------------------------
			Test Class for AXI Fixed - write
----------------------------------------------------------------------------*/
class axi_fixed_seqs1_test extends axi_test;
	`uvm_component_utils(axi_fixed_seqs1_test)

	//Declare Handles for seqs
	axi_rst_seqs axi_rst;
	ahb_rst_seqs ahb_rst;	
	axi_fixed_seqs1 fixed_seqs1;
	ahb_seqs1 ahb_seqs;

	//Methods
	extern function new(string name = "axi_fixed_seqs1_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//Constructor New
function axi_fixed_seqs1_test::new(string name = "axi_fixed_seqs1_test", uvm_component parent);
	super.new(name,parent);
endfunction

//Build Phase
function void axi_fixed_seqs1_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

//Run phase
task axi_fixed_seqs1_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	fixed_seqs1 = axi_fixed_seqs1::type_id::create("fixed_seqs1");
	axi_rst = axi_rst_seqs::type_id::create("axi_rst");
	ahb_rst = ahb_rst_seqs::type_id::create("ahb_rst");
	ahb_seqs = ahb_seqs1::type_id::create("ahb_seqs");

	axi_rst.start(env.axi_rst_agt_toph.agnth[0].seqsr);
	ahb_rst.start(env.ahb_rst_agt_toph.agnth[0].seqsr);
	fork	
	fixed_seqs1.start(env.axi_agt_toph.agnth[0].seqsr);
	ahb_seqs.start(env.ahb_agt_toph.agnth[0].seqsr);
	#2500000;
	join
	phase.drop_objection(this);
endtask	

/*----------------------------------------------------------------------------
			Test Class for AXI Fixed - Read
----------------------------------------------------------------------------*/
class axi_fixed_seqs2_test extends axi_test;
	`uvm_component_utils(axi_fixed_seqs2_test)

	//Declare Handles for seqs
	axi_rst_seqs axi_rst;
	ahb_rst_seqs ahb_rst;			
	axi_fixed_seqs2 fixed_seqs2;
	//ahb_rd_seqs ahb_rd_seq;
	ahb_seqs1 ahb_seqs;	

	//Methods
	extern function new(string name = "axi_fixed_seqs2_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//Constructor New
function axi_fixed_seqs2_test::new(string name = "axi_fixed_seqs2_test", uvm_component parent);
	super.new(name,parent);
endfunction

//Build Phase
function void axi_fixed_seqs2_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

//Run phase
task axi_fixed_seqs2_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	axi_rst = axi_rst_seqs::type_id::create("axi_rst");
	ahb_rst = ahb_rst_seqs::type_id::create("ahb_rst");
	fixed_seqs2 = axi_fixed_seqs2::type_id::create("fixed_seqs2");
	//ahb_rd_seq = ahb_rd_seqs::type_id::create("ahb_rd_seq");
	ahb_seqs = ahb_seqs1::type_id::create("ahb_seqs");

//fork
	axi_rst.start(env.axi_rst_agt_toph.agnth[0].seqsr);
	ahb_rst.start(env.ahb_rst_agt_toph.agnth[0].seqsr);
//join
	//fork
	fixed_seqs2.start(env.axi_agt_toph.agnth[0].seqsr);
	//ahb_rd_seq.start(env.ahb_agt_toph.agnth[0].seqsr);
	ahb_seqs.start(env.ahb_agt_toph.agnth[0].seqsr);	
	#2000000;	
	//join
	phase.drop_objection(this);
endtask	

/*----------------------------------------------------------------------------
			Test Class for AXI Incr - write
----------------------------------------------------------------------------*/
class axi_incr_seqs1_test extends axi_test;
	`uvm_component_utils(axi_incr_seqs1_test)

	//Declare Handles for seqs
	axi_rst_seqs axi_rst;	
	ahb_rst_seqs ahb_rst;			
	axi_incr_seqs1 incr_seqs1;
	ahb_seqs2 ahb_seqs;

	//Methods
	extern function new(string name = "axi_incr_seqs1_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//Constructor New
function axi_incr_seqs1_test::new(string name = "axi_incr_seqs1_test", uvm_component parent);
	super.new(name,parent);
endfunction

//Build Phase
function void axi_incr_seqs1_test::build_phase(uvm_phase phase);

	super.build_phase(phase);
endfunction

//Run phase
task axi_incr_seqs1_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	axi_rst = axi_rst_seqs::type_id::create("axi_rst");
	ahb_rst = ahb_rst_seqs::type_id::create("ahb_rst");
	incr_seqs1 = axi_incr_seqs1::type_id::create("incr_seqs1");
	ahb_seqs = ahb_seqs2::type_id::create("ahb_seqs");

	axi_rst.start(env.axi_rst_agt_toph.agnth[0].seqsr);
	ahb_rst.start(env.ahb_rst_agt_toph.agnth[0].seqsr);
	fork
	incr_seqs1.start(env.axi_agt_toph.agnth[0].seqsr);
	ahb_seqs.start(env.ahb_agt_toph.agnth[0].seqsr);	
	#1000000;
	join
	phase.drop_objection(this);
endtask	

/*----------------------------------------------------------------------------
			Test Class for AXI Incr - Read
----------------------------------------------------------------------------*/
class axi_incr_seqs2_test extends axi_test;
	`uvm_component_utils(axi_incr_seqs2_test)

	//Declare Handles for seqs
	axi_rst_seqs axi_rst;	
	ahb_rst_seqs ahb_rst;			
	axi_incr_seqs2 incr_seqs2;
	//ahb_seqs1 ahb_seqs;
	ahb_rd_seqs ahb_rd_seq;

	//Methods
	extern function new(string name = "axi_incr_seqs2_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//Constructor New
function axi_incr_seqs2_test::new(string name = "axi_incr_seqs2_test", uvm_component parent);
	super.new(name,parent);
endfunction

//Build Phase
function void axi_incr_seqs2_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

//Run phase
task axi_incr_seqs2_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	axi_rst = axi_rst_seqs::type_id::create("axi_rst");
	ahb_rst = ahb_rst_seqs::type_id::create("ahb_rst");
	incr_seqs2 = axi_incr_seqs2::type_id::create("incr_seqs2");
	//ahb_seqs = ahb_seqs1::type_id::create("ahb_seqs");
	ahb_rd_seq = ahb_rd_seqs::type_id::create("ahb_rd_seq");

	axi_rst.start(env.axi_rst_agt_toph.agnth[0].seqsr);
	ahb_rst.start(env.ahb_rst_agt_toph.agnth[0].seqsr);
//	fork
	incr_seqs2.start(env.axi_agt_toph.agnth[0].seqsr);
	#10;
	//ahb_seqs.start(env.ahb_agt_toph.agnth[0].seqsr);
	ahb_rd_seq.start(env.ahb_agt_toph.agnth[0].seqsr);	
	#1000000;
//	join	
	phase.drop_objection(this);
endtask	

/*----------------------------------------------------------------------------
			Test Class for AXI Wrap - write
----------------------------------------------------------------------------*/
class axi_wrap_seqs1_test extends axi_test;
	`uvm_component_utils(axi_wrap_seqs1_test)

	//Declare Handles for seqs
	axi_rst_seqs axi_rst;
	ahb_rst_seqs ahb_rst;				
	axi_wrap_seqs1 wrap_seqs1;
	ahb_seqs2 ahb_seqs;

	//Methods
	extern function new(string name = "axi_wrap_seqs1_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//Constructor New
function axi_wrap_seqs1_test::new(string name = "axi_wrap_seqs1_test", uvm_component parent);
	super.new(name,parent);
endfunction

//Build Phase
function void axi_wrap_seqs1_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

//Run phase
task axi_wrap_seqs1_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	axi_rst = axi_rst_seqs::type_id::create("axi_rst");
	ahb_rst = ahb_rst_seqs::type_id::create("ahb_rst");
	wrap_seqs1 = axi_wrap_seqs1::type_id::create("wrap_seqs1");
	ahb_seqs = ahb_seqs2::type_id::create("ahb_seqs");

	axi_rst.start(env.axi_rst_agt_toph.agnth[0].seqsr);
	ahb_rst.start(env.ahb_rst_agt_toph.agnth[0].seqsr);
	fork
	wrap_seqs1.start(env.axi_agt_toph.agnth[0].seqsr);
	ahb_seqs.start(env.ahb_agt_toph.agnth[0].seqsr);	
	#1000000;
	join
	phase.drop_objection(this);
endtask	

/*----------------------------------------------------------------------------
			Test Class for AXI Wrap - Read
----------------------------------------------------------------------------*/
class axi_wrap_seqs2_test extends axi_test;
	`uvm_component_utils(axi_wrap_seqs2_test)

	//Declare Handles for seqs
	axi_rst_seqs axi_rst;	
	ahb_rst_seqs ahb_rst;			
	axi_wrap_seqs2 wrap_seqs2;
	ahb_seqs2 ahb_seqs;

	//Methods
	extern function new(string name = "axi_wrap_seqs2_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//Constructor New
function axi_wrap_seqs2_test::new(string name = "axi_wrap_seqs2_test", uvm_component parent);
	super.new(name,parent);
endfunction

//Build Phase
function void axi_wrap_seqs2_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

//Run phase
task axi_wrap_seqs2_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	axi_rst = axi_rst_seqs::type_id::create("axi_rst");
	ahb_rst = ahb_rst_seqs::type_id::create("ahb_rst");
	wrap_seqs2 = axi_wrap_seqs2::type_id::create("wrap_seqs2");
	ahb_seqs = ahb_seqs2::type_id::create("ahb_seqs");

	axi_rst.start(env.axi_rst_agt_toph.agnth[0].seqsr);
	ahb_rst.start(env.ahb_rst_agt_toph.agnth[0].seqsr);
	fork
	wrap_seqs2.start(env.axi_agt_toph.agnth[0].seqsr);
	ahb_seqs.start(env.ahb_agt_toph.agnth[0].seqsr);	
	#1000000;
	join
	phase.drop_objection(this);
endtask	

