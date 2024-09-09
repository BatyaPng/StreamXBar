import sys

if len(sys.argv) != 4:
    print("Неверное количество аргументов\nНеобходимо указать:\nT_DATA_WIDTH\nS_DATA_COUNT\nM_DATA_COUNT")
elif __name__ == "__main__":
    T_DATA_WIDTH = int(sys.argv[1])
    S_DATA_COUNT = int(sys.argv[2])
    M_DATA_COUNT = int(sys.argv[3])
    
f_src_stream_xbar   = open("../src/stream_xbar.sv", 'r')
conf_stram_xbar  = f_src_stream_xbar.read()
f_src_stream_xbar.close()

f_conf_stream_xbar = open("./modelsim/stream_xbar.sv", 'w')
conf_stram_xbar  = conf_stram_xbar.replace("T_DATA_WIDTH = 8", f"T_DATA_WIDTH = {T_DATA_WIDTH}")
conf_stram_xbar  = conf_stram_xbar.replace("S_DATA_COUNT = 2", f"S_DATA_COUNT = {S_DATA_COUNT}")
conf_stram_xbar  = conf_stram_xbar.replace("M_DATA_COUNT = 3", f"M_DATA_COUNT = {M_DATA_COUNT}")
f_conf_stream_xbar.write(conf_stram_xbar)
f_conf_stream_xbar.close()

f_src_makefile  = open("preamble_makefile.txt", 'r')
conf_makefile    = f_src_makefile.read()
f_src_makefile.close()

f_conf_makefile = open("./modelsim/makefile", 'w')
conf_makefile   = conf_makefile.replace("S_DATA_COUNT = 2", f"S_DATA_COUNT = {S_DATA_COUNT}")
conf_makefile   = conf_makefile.replace("M_DATA_COUNT = 3", f"M_DATA_COUNT = {M_DATA_COUNT}")
f_conf_makefile.write(conf_makefile)
f_conf_makefile.close()

f_src_top = open("../test/top.sv", 'r')
conf_top  = f_src_top.read()
f_src_top.close()

f_conf_top = open("./modelsim/top.sv", 'w')
conf_top = conf_top.replace("T_DATA_WIDTH = 8", f"T_DATA_WIDTH = {T_DATA_WIDTH}")
conf_top = conf_top.replace("S_DATA_COUNT = 2", f"S_DATA_COUNT = {S_DATA_COUNT}")
conf_top = conf_top.replace("M_DATA_COUNT = 3", f"M_DATA_COUNT = {M_DATA_COUNT}")
f_conf_top.write(conf_top)
f_conf_top.close()