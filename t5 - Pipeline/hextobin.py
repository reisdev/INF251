from binascii import unhexlify,hexlify

file = open("im_data1.txt","r")

for line in file.readlines():
    line = str.encode(line.strip('\n'))
    line = unhexlify(line)
    print("Hex: ",line)

