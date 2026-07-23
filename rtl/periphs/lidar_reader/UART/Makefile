Target = uart

OBJS = uart.v \
       rsr_rx_data.v \
       mux.v \
       contador.v \
       contador_dec.v \
       comparador_time_bit.v \
       uart_control.v

ECP5_SIM_CELLS=/home/marute/snoopy-le-sabe/rtl/periphs/lidar_reader/UART/lattice_sim/cells_sim_ecp5.v


sim:
	rm -f a.out *.vcd
	iverilog -DBENCH $(Target)_TB.v $(OBJS)
	vvp a.out
	gtkwave $(Target)_TB.vcd

sim_post_syn:
	yosys -v3 -l synth.log -p 'synth_ecp5 -top $(Target) -json $(Target)_synth.json; write_verilog -attr2comment $(Target)_synth.v' $(OBJS)
	iverilog -I ./lattice_sim $(Target)_TB.v $(Target)_synth.v $(ECP5_SIM_CELLS)
	vvp a.out
	gtkwave $(Target)_TB.vcd

svg:
	rm -rf *.svg *.out *.dot *.json
	yosys -p "read_verilog $(OBJS); prep -top $(Target); memory_map; opt; opt_expr; techmap; abc -g AND,OR,XOR; write_json $(Target)_synth.json"
	netlistsvg $(Target)_synth.json -o $(Target)_synth.svg

clean:
	rm -rf *.svg *.out *.dot a.out *.vcd *.json $(Target)_synth.v *.log
	