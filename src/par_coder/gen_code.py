import sys

if __name__ == "__main__":
    S_DATA_COUNT = int(sys.argv[1])

preamble = open('preamble.txt', 'r')
pre = preamble.read()
pre = pre.replace("S_DATA_COUNT = 2", f"S_DATA_COUNT = {S_DATA_COUNT}")
preamble.close()

code = open('par_coder.sv', 'w')
code.write(pre)
code.write(f"   (m_vec_i[{S_DATA_COUNT - 1}] ?  {S_DATA_COUNT - 1} : 0)\n")

for i in range(S_DATA_COUNT - 2, 0, -1):
    str = f"              | (m_vec_i[{i}] ?  {i} : 0)\n"
    code.write(str)

code.write("              | (m_vec_i[0] ?  0 : 0);")    
    
code.write('\n\nendmodule')
code.close()
    