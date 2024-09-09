import sys

if len(sys.argv) == 3:
    file_path_prefix = str(sys.argv[2])
else:
    file_path_prefix = ""

file_path_preamble = file_path_prefix + "preamble.txt"
file_path_dst      = file_path_prefix + "seq_coder.sv"

if __name__ == "__main__":
    S_DATA_COUNT = int(sys.argv[1])

preamble = open(file_path_preamble , 'r')
pre = preamble.read()
pre = pre.replace("S_DATA_COUNT = 2", f"S_DATA_COUNT = {S_DATA_COUNT}")
preamble.close()

code = open(file_path_dst, 'w')
code.write(pre)
code.write(f" m_vec_i[{S_DATA_COUNT - 1}] ?  0 :\n")

for i in range(S_DATA_COUNT - 2, 0, -1):
    str = f"              m_vec_i[{i}] ?  0 :\n"
    code.write(str)

code.write("              m_vec_i[0] ?  0 : 1;")    
    
code.write('\n\nendmodule')
code.close()
    