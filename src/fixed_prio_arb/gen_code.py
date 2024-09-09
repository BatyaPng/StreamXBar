import sys

if len(sys.argv) == 3:
    file_path_prefix = str(sys.argv[2])
else:
    file_path_prefix = ""

file_path_preamble = file_path_prefix + "preamble.txt"
file_path_dst      = file_path_prefix + "fixed_prio_arb.sv"

if __name__ == "__main__":
    NUM_REQUEST = int(sys.argv[1])

preamble = open(file_path_preamble, 'r')
pre = preamble.read()
pre = pre.replace("NUM_REQUEST = 4", f"NUM_REQUEST = {NUM_REQUEST}")
preamble.close()

code = open(file_path_dst, 'w')
code.write(pre + '\n' + '\n')
code.write("assign grant_o[0]  = request_i[0];\n")

for i in range(1, NUM_REQUEST):
    str = f"assign grant_o[{i}]  = request_i[{i}]"
    for j in range(i - 1, -1, -1):
        str += f" & ~request_i[{j}]"
    code.write(str + ';\n')
    
code.write('\nendmodule')
code.close()