conflict_finder:
	iverilog ./test/tb_conflict_finder.sv ./src/conflict_finder.sv -g2009 -o conflict_finder

request_gen:
	iverilog ./test/tb_request_gen.sv ./src/request_gen.sv -g2009 -o request_gen

fixed_prio_arb:
	iverilog ./test/tb_fixed_prio_arb.sv ./src/fixed_prio_arb/fixed_prio_arb.sv -g2009 -o fixed_prio_arb

round_robin:
	iverilog ./test/tb_round_robin.sv ./src/round_robin.sv ./src/fixed_prio_arb/fixed_prio_arb.sv -g2009 -o round_robin

com:
	iverilog ./test/tb_com.sv ./src/com.sv -g2009 -o com
	
clear:
	rm conflict_finder request_gen fixed_prio_arb round_robin com