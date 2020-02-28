class my_monitor_in extends uvm_monitor;
    `uvm_component_utils(my_monitor_in)

	uvm_analysis_port #(my_sequence_item) monitor_port;
	virtual	my_interface intf;
	my_sequence_item seq_itm;
	
	function new (string name = "my_monitor_in", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		monitor_port = new("monitor_port", this);
		if (!uvm_config_db#(virtual my_interface)::get(this, "*", "my_interface", intf))
		begin
			`uvm_fatal("MONITOR_IN", "Could not get vif")
		end
	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("MONITOR_IN","RUN PHASE", UVM_MEDIUM);
		
        forever begin
            @(posedge intf.clk);
		    seq_itm = my_sequence_item::type_id::create("seq_itm",this); //should I create this here??
		    if(intf.pushin == 1)
            begin
                seq_itm.ctl = intf.ctl;
			    seq_itm.test_bit_c = intf.a;
			    seq_itm.test_bit_d = intf.b;
			    `uvm_info("MONITOR_IN", $sformatf("IF a=%d, b= %d, ctl=%d",seq_itm.test_bit_c, seq_itm.test_bit_d, seq_itm.ctl), UVM_NONE)
                monitor_port.write(seq_itm);
            end
            else
            begin 
                seq_itm.ctl = seq_itm.ctl;
			    seq_itm.test_bit_c = seq_itm.test_bit_c;
			    seq_itm.test_bit_d = seq_itm.test_bit_d;
			    `uvm_info("MONITOR_IN", $sformatf("ELSE a=%d, b= %d, ctl=%d",seq_itm.test_bit_c, seq_itm.test_bit_d, seq_itm.ctl), UVM_NONE)
                monitor_port.write(seq_itm);
            end
            #10;
		end	
	endtask

endclass : my_monitor_in
