conflict_finder:
	iverilog ./test/tb_conflict_finder.sv ./src/conflict_finder.sv -g2009 -o conflict_finder

request_gen:
	iverilog ./test/tb_request_gen.sv ./src/request_gen.sv -g2009 -o request_gen

n_request_gen:
	iverilog ./test/tb_n_request_gen.sv ./src/n_request_gen.sv -g2009 -o n_request_gen

fixed_prio_arb:
	iverilog ./test/tb_fixed_prio_arb.sv ./src/fixed_prio_arb/fixed_prio_arb.sv -g2009 -o fixed_prio_arb
	
clear:
	rm conflict_finder request_gen n_request_gen fixed_prio_arb