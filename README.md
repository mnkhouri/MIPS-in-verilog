MIPS-in-verilog
===============

A MIPS CPU described in verilog. The CPU performs all operations in a  single  clock  cycle. 

Upon assertion of the “rst” signal the program counter is asynchronously cleared to 
“0”.    The  program  counter  is  presented  as  an  address  to  the  instruction  memory.    The  instruction 
memory  subsequently  outputs  the  32-bit  instruction.    The  32-bit  instruction  is  presented  to  several 
datapath components and the Control Unit.    The Control Unit generates the signals to (1) appropriately 
control  the  flow  of  data  throughout  the  datapath,  (2)  enable/disable  register  file  update,  (3)  enable 
disable data memory write, and (4) control the PC update mode.    At the rising edge of “clk” the program 
counter, register file, and data memory are updated as determined by the Control Unit.     
