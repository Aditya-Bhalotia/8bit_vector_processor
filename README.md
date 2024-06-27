# 8bit_vector_processor
************************************************DOCUMENTATION*****************************************************

the project is an 8bit processor, which performs the general arithmetic and logical operations, along with other
general purpose operations on standard 8bit scalars, as well as vectors containing 8bit elements. 

for simplicity,
the vectors are NECESSARILY of dimension 8, i.e. this processor ONLY supports vectors of length 8, each element
of which is an 8 bit entity.

------------------------------------------------INDIVIDUAL MODULES------------------------------------------------

mux32bit:
take in 3 inputs-a 32bit bitstream, a 26bit bitstream, and a select line
if sel is 0, choose 32bit, else (6'b000000) + 26bit

mux64bit:
take in 3 inputs-two 64bit bitstreams, and a select line
if sel is 0, choose first 64bit, else second 64bit

mux:
take in 3 inputs-two 8bit bitstreams, and a select line
if sel is 0, choose first 8bit, else second 8bit

Register_File:
contains 32 8bit registers for general purpose scalar operations
takes in clk, 2 5bit register addresses to read data from, a 5bit register address to write data to, 
a write_enable signal, 2 8bit registers to read data to, and an 8bit write_data i.e. the data to be written
read operations occur at posedge of the clock, where the data from the specified addresses is read onto the output 
registers except when the address is 5'b11111. similar operation for write, except that it occurs at the negedge

VectorRegisterFile:
contains 3 64bit registers for vector operations
takes in clk, 2 5bit register addresses to read data from, a 5bit register address to write data to, 
a write_enable signal, 2 64bit registers to read data to, and a 64bit write_data i.e. the data to be written
read operations occur at posedge of the clock, where the data from the specified addresses is read onto the output 
registers except when the address is 5'b11111. similar operation for write, except that it occurs at the negedge

VPU:
the vector processing unit
takes in a clk, 2 64bit operands (vectors), an enable signal, a 6bit opcode, and a 64bit output
performs add, subtract and dot product operations. returns 64bit output, of which the last 8bits are relevant for
dot product, and all 64bits for add and subtract.

ALU:
the arithmetic and logical unit
takes in clk, 2 8bit operands, an enable signal, a 6bit opcode, an 8bit output, a zero register and an overflow
register. returns 8bit output of the respective a/l/s operation.

Control_Unit:
takes in a 32bit instruction. returns a 16bit bitstream of controlsignals, with various flags.

ProgramCounter:
takes in clk, a reset, zero, branch, jump flags, a 32bit register address, and a pc output. if the reset flag is 
high, then the pc is set to 0th location; if branch and zero are high, or the jump signal is high, 
then the pc is set to the regAddress value, else it is set to the next location i.e. pc+1.

CPU:
the highest level entity, which instantiates all the modules above.
takes in clk, rst, a 32bit instruction, and a 64bit input data path from the main memory. for output, contains
a 64bit output data path to the main memory, the final program counter, a 12bit output memory location, and 
flags like vector_write_access, memory_read_access, load_vector_flag, load_word_flag
all the intermediate wires and registers are used in the instantiations of the different modules.

--------------------------------------------------OPCODE MAPPING--------------------------------------------------

the ISA uses 26 instructions, which are coded using a 6bit opcode, in a 32bit instruction, where the first 6 bits
among 32 represent the opcode

6'b000000 -> Addition with register inputs
6'b000001 -> Subtraction with register inputs
6'b000010 -> Multiplication with register inputs

6'b000100 -> Logical AND with register inputs
6'b000101 -> Logical OR with register inputs
6'b000100 -> Logical XOR with register inputs

6'b001000 -> Logical SHIFTLEFT with register inputs
6'b001001 -> Logical SHIFTRIGHT with register inputs
6'b001010 -> Logical SET IF LESS THAN with register inputs
6'b001011 -> Logical SET IF EQUAL with register inputs

6'b010000 -> Vector Addition with register inputs
6'b010001 -> Vector Subtraction with register inputs
6'b010010 -> Vector Dot Product with register inputs

6'b001101 -> Addition with immediate inputs
6'b001110 -> Logical AND with immediate inputs
6'b001111 -> Logical XOR immediate inputs

6'b100011 -> Branch if EQUAL flag is set
6'b100011 -> Branch if GREATER THAN flag is set

6'b101101 -> Load Vector
6'b101110 -> Store Vector

6'b100101 -> Load Word
6'b100101 -> Store Word
6'b101000 -> Logical SET IF LESS THAN with immediate inputs
6'b110000 -> Jump 
6'b101100 -> Register Address Write
6'b101111 -> Register Address Read

All the instructions have their usual meaning as used in general literature, as mentioned in Prof. Sarangi's 
Textbook "Basic Computer Architecture"

------------------------------------------------INSTRUCTION SYNTAX------------------------------------------------

In this architecture, all instructions are 32bit wide, and there are 32 8bit registers. For memory, the address
length is taken to be 12bit wide.

By default, all 32bit instructions have their first 6bits as the opcode. The syntax for the instructions is as 
follows:
1. Register-based instructions: opcode[6bit] + destination register address[5bit] + source register1 address[5bit] + source register2 address[5bit]
2. Immediate-based instructions: opcode[6bit] + destination register address[5bit] + source register1 address[5bit] + immediate value[8bit] + DC[8bit]
3. Branch instructions: opcode[6bit] + DC[13bit] + source register address[5bit] + immediate value[8bit]
4. Load instructions: opcode[6bit] + destination register address[5bit] + DC[9bit] + memory address[12bit]
5. Store instructions: opcode[6bit] + DC[5bit] + source register address[5bit] + DC[4bit] + memory address[12bit]
6. Jump instructions: opcode[6bit] + final instruction address[26bit]
*DC -> Don't care (can either be zeros or ones)
*The Register Address Write instruction is to be given just before initializing the loop statement, while the Register
Address Read is to be given just before giving a branch instruction always.

------------------------------------------------ADDITIONAL NOTES-------------------------------------------------

In this implementation, it is implicit that the Instruction memory and Main memory are not integrated into the
processor, and rather would be attached as external blocks. Also, they must not be synchronised to the clk, since
it has already been taken care of in implmenting the other modules.

Regarding the pincount for the processor, there are a total of 210 pins, as the processor takes in clk, rst, 
a 32bit instruction, and a 64bit input data path from the main memory, while for output, it contains a 64bit output
data path to the main memory, the final 32bit program counter, a 12bit output memory location, and flags like 
vector_write_access, memory_read_access, load_vector_flag, load_word_flag.

******************************************************************************************************************
