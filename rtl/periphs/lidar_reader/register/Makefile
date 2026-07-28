Target = register

OBJS = register.v \
       acc_check_sum.v \
       comp_check_sum.v \
       comp_contador.v \
       comp_frame_byte.v \
       contador_register.v \
       mux_register.v \
       register_control.v \
       TOF_data_register.v 

ECP5_SIM_CELLS=/home/marute/snoopy-le-sabe/rtl/periphs/lidar_reader/register/lattice_sim


sim:
	rm -f a.out *.vcd
	iverilog -g2012 -DBENCH $(Target)_TB.v $(OBJS)
	vvp a.out
	gtkwave $(Target)_TB.vcd

sim_post_syn:
	yosys -v3 -l synth.log -p 'read_verilog -sv $(OBJS); synth_ecp5 -top $(Target) -json $(Target)_synth.json; write_verilog -attr2comment $(Target)_synth.v'
	iverilog -g2012 -I ./lattice_sim $(Target)_TB.v $(Target)_synth.v $(ECP5_SIM_CELLS)
	vvp a.out
	gtkwave $(Target)_TB.vcd

svg:
	rm -rf *.svg *.out *.dot *.json
	yosys -p "read_verilog -sv $(OBJS); prep -top $(Target); memory_map; opt; opt_expr; techmap; abc -g AND,OR,XOR; write_json $(Target)_synth.json"
	netlistsvg $(Target)_synth.json -o $(Target)_synth.svg

clean:
	rm -rf *.svg *.out *.dot a.out *.vcd *.json $(Target)_synth.v *.log
	