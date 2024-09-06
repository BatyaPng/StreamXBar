import sys

if __name__ == "__main__":
    NUM_REQUEST = int(sys.argv[1])

preamble = open('preamble.txt', 'r')
pre = preamble.read()
pre = pre.replace("NUM_REQUEST = 4", f"NUM_REQUEST = {NUM_REQUEST}")
preamble.close()

code = open('fixed_prio_arb.sv', 'w')
code.write(pre + '\n' + '\n')
code.write("assign grant_o[0]  = request_i[0];\n")

for i in range(1, NUM_REQUEST):
    str = f"assign grant_o[{i}]  = request_i[{i}]"
    for j in range(i - 1, -1, -1):
        str += f" & ~request_i[{j}]"
    code.write(str + ';\n')
    
code.write('\nendmodule')
code.close()