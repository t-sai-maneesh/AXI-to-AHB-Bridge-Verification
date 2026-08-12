package axi_test_pkg;	
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	`include "axi_agt_config.sv"
	`include "axi_rst_agt_config.sv"
	`include "ahb_agt_config.sv"
	`include "ahb_rst_agt_config.sv"
	`include "env_config.sv"

	`include "axi_xtn.sv"
	`include "axi_seqsr.sv"
	`include "axi_seqs.sv"
	`include "axi_driver.sv"
	`include "axi_monitor.sv"
	`include "axi_agent.sv"
	`include "axi_agt_top.sv"

	`include "axi_rst_xtn.sv"
	`include "axi_rst_seqsr.sv"
	`include "axi_rst_seqs.sv"
	`include "axi_rst_driver.sv"
	`include "axi_rst_monitor.sv"
	`include "axi_rst_agent.sv"
	`include "axi_rst_agt_top.sv"

	`include "ahb_xtn.sv"
	`include "ahb_seqsr.sv"
	`include "ahb_seqs.sv"
	`include "ahb_driver.sv"
	`include "ahb_monitor.sv"
	`include "ahb_agent.sv"
	`include "ahb_agt_top.sv"

	`include "ahb_rst_xtn.sv"
	`include "ahb_rst_seqsr.sv"
	`include "ahb_rst_seqs.sv"
	`include "ahb_rst_driver.sv"
	`include "ahb_rst_monitor.sv"
	`include "ahb_rst_agent.sv"
	`include "ahb_rst_agt_top.sv"

	`include "axi_scoreboard.sv"

	`include "axi_env.sv"

	`include "axi_test.sv"
endpackage
