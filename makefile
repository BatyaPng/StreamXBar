S_DATA_COUNT = 2   # кол-во master-устройств
M_DATA_COUNT = 3   # кол-во slave-устройств

all:
	python3 ./src/bit_add_nor/gen_code.py    $(M_DATA_COUNT)
	python3 ./src/fixed_prio_arb/gen_code.py $(S_DATA_COUNT)
	python3 ./src/par_coder/gen_code.py	     $(S_DATA_COUNT)
	python3 ./src/seq_coder/gen_code.py      $(S_DATA_COUNT)

	iverilog ./test/tb_stream_xbar.sv ./src/stream_xbar.sv ./src/request_gen.sv ./src/fixed_prio_arb/fixed_prio_arb.sv ./src/round_robin.sv ./src/com.sv -g2009 -o stream_xbar

request_gen:
	iverilog ./test/tb_request_gen.sv ./src/request_gen.sv -g2009 -o request_gen

fixed_prio_arb:
	iverilog ./test/tb_fixed_prio_arb.sv ./src/fixed_prio_arb/fixed_prio_arb.sv -g2009 -o fixed_prio_arb

round_robin:
	iverilog ./test/tb_round_robin.sv ./src/round_robin.sv ./src/fixed_prio_arb/fixed_prio_arb.sv -g2009 -o round_robin

com:
	iverilog ./test/tb_com.sv ./src/com.sv -g2009 -o com
	
clear:
	rm stream_xbar request_gen fixed_prio_arb round_robin com