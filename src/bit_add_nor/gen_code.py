import sys

if __name__ == "__main__":
    NUM_TERMS = int(sys.argv[1])

preamble = open('preamble.txt', 'r')
pre = preamble.read()
pre = pre.replace("NUM_TERMS = 3", f"NUM_TERMS = {NUM_TERMS}")
preamble.close()

code = open('bit_add_or.sv', 'w')
code.write(pre)
code.write(f"   terms_i[{NUM_TERMS - 1}]\n")

for i in range(NUM_TERMS - 2, 0, -1):
    str = f"             | terms_i[{i}]\n"
    code.write(str)

code.write("             | terms_i[0];")    
    
code.write('\n\nendmodule')
code.close()