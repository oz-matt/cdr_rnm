`ifndef TOP_TEST_SV
`define TOP_TEST_SV

`include "top_env.sv"

class top_test extends uvm_test;
  `uvm_component_utils(top_test)

  top_env m_env;
  
  UVM_FILE debugf;
  
  uvm_root root;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void start_of_simulation_phase(uvm_phase phase);
  extern function void final_phase(uvm_phase phase);
  
endclass : top_test


function top_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void top_test::build_phase(uvm_phase phase);
  m_env = top_env::type_id::create("m_env", this);
endfunction : build_phase

function void top_test::start_of_simulation_phase(uvm_phase phase);
  `uvm_info("start_of_simulation_phase", "Entered ...",UVM_LOW)
  super.start_of_simulation_phase(phase);
      
  debugf = $fopen("./logs/debug.log", "w");

  root = uvm_root::get();

  root.set_report_default_file_hier(debugf);
   
  root.set_report_verbosity_level_hier(UVM_HIGH);
  root.set_report_severity_id_action_hier(UVM_INFO, "wp", UVM_DISPLAY | UVM_LOG);
  root.set_report_severity_action_hier(UVM_WARNING, UVM_DISPLAY | UVM_LOG);
  root.set_report_severity_action_hier(UVM_ERROR, UVM_DISPLAY | UVM_COUNT |  UVM_LOG);
  root.set_report_severity_action_hier(UVM_FATAL, UVM_DISPLAY| UVM_EXIT | UVM_LOG );

  `uvm_info("start_of_simulation_phase", "Exiting ...",UVM_LOW)

endfunction : start_of_simulation_phase

function void top_test::final_phase(uvm_phase phase);
    uvm_report_server svr;
    `uvm_info("final_phase", "Entered ...",UVM_LOW)

    super.final_phase(phase);
    svr = uvm_report_server::get_server();
    
    if (svr.get_severity_count(UVM_FATAL)||  
        svr.get_severity_count(UVM_ERROR)|| 
        svr.get_severity_count(UVM_WARNING))
      `uvm_info("final_phase", "\nSvtTestEpilog: Failed\n", UVM_LOW)
    else
      `uvm_info("final_phase", "\nSvtTestEpilog: Passed\n", UVM_LOW)

    `uvm_info("final_phase", "Exiting ...",UVM_LOW)
    
endfunction : final_phase
  

`endif

