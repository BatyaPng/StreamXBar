import sys

if len(sys.argv) == 3:
    file_path_prefix = str(sys.argv[2])
else:
    file_path_prefix = ""

file_path_preamble = file_path_prefix + "preamble.txt"
file_path_dst      = file_path_prefix + "bit_add_nor.sv"

if __name__ == "__main__":
    NUM_TERMS = int(sys.argv[1])

preamble = open(file_path_preamble, 'r')
pre = preamble.read()
pre = pre.replace("NUM_TERMS = 3", f"NUM_TERMS = {NUM_TERMS}")
preamble.close()

code = open(file_path_dst, 'w')
code.write(pre)
code.write(f"   terms_i[{NUM_TERMS - 1}]\n")

for i in range(NUM_TERMS - 2, 0, -1):
    str = f"             | terms_i[{i}]\n"
    code.write(str)

code.write("             | terms_i[0];")    
    
code.write('\n\nendmodule')
code.close()