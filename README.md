# Design of a 8-bit vector processor

## Overview
The project is based on the design of an 8-bit processor that performs general arithmetic, logical operations, and other general-purpose operations on standard 8-bit scalars as well as vectors containing 8-bit elements. For simplicity, the vectors are necessarily of dimension 8, meaning this processor only supports vectors of length 8, where each element is 8-bit wide.

## Individual Modules

### mux32bit
- **Inputs**: 32-bit bitstream, 26-bit bitstream, select line
- **Function**: If `sel` is 0, choose 32-bit, else (6'b000000) + 26-bit

### mux64bit
- **Inputs**: Two 64-bit bitstreams, select line
- **Function**: If `sel` is 0, choose first 64-bit, else second 64-bit

### mux
- **Inputs**: Two 8-bit bitstreams, select line
- **Function**: If `sel` is 0, choose first 8-bit, else second 8-bit

### Register_File
- **Description**: Contains 32 8-bit registers for general-purpose scalar operations
- **Inputs**: `clk`, two 5-bit register addresses to specify read location, a 5-bit register address to specify write location, a `write_enable` signal, and an 8-bit `write_data` specifying the data to be written
- **Outputs**: two 8-bit wide path corresponding to the two read address inputs.
- **Operations**: 
  - All read operations from register bank occur at the posedge of the clock, where the data from the specified addresses is read onto the output data bus
  - Note that there are 32 register and thus its decided to mark 5'b11111 register address as invalid.
  - All write operations in the register bank occur at the negedge of the clock.
- **NOTE** :The contents that can be read/written in these words will be referred as words. 

### VectorRegisterFile
- **Description**: Contains 3 64-bit registers for vector operations
- **Inputs**: `clk`, two 5-bit register addresses to specify read location, a 5-bit register address to specify write location, a `write_enable` signal, and a 64-bit `write_data` specifying the data to be written
-  **Outputs**: two 64-bit wide path corresponding to the two read address inputs.
- **Operations**:
  - All read operations from register bank occur at the posedge of the clock, where the data from the specified addresses is read onto the output data bus
  - Note that there are 3 vector registers. We decided to mark 5'b11111 register address as invalid. Ensure that the read/write address does not exceed 5'b00011.
  - All write operations in the register bank occur at the negedge of the clock.
- **NOTE** :The contents that can be read/written in these words will be referred as words.

### VPU
- **Description**: The vector processing unit
- **Inputs**: `clk`, two 64-bit operands (vectors), an `enable` signal, a 6-bit `opcode`
- **Output**:  A 64-bit output
- **Operations**: 
  - Performs add, subtract, and dot product operations.
  - Returns 64-bit output, of which the last 8 bits are relevant for dot product, and all 64 bits for add and subtract.

### ALU
- **Description**: The arithmetic and logical unit
- **Inputs**: `clk`, two 8-bit operands, an `enable` signal, a 6-bit `opcode`
- **Outputs**: A 8-bit output, a zero register, and an overflow register
- **Operations**: Returns 8-bit output of the respective arithmetic/logic operation.
- **NOTE**: This unit operates on words.
  
### Control_Unit
- **Inputs**: 32-bit instruction
- **Outputs**: 16-bit wide control signal, with various flags like enable signals, input to select line of mux, etc.
- **CAUTION: It is advised not to change this part of code. If you are making changes then please ensure you have appropraitely mapped the function of various bits in control signal.**

### ProgramCounter
- **Inputs**: `clk`, `reset`, `zero`, `branch`, `jump` flags, a 32-bit register address
- **Outputs**: `pc` output
- **Operations**: 
  - If the reset flag is high, then the `pc` is set to 0.
  - If branch and zero are high, or the jump signal is high, then the `pc` is set to the regAddress value.
  - Else, it is set to the next location (`pc + 1`).

### CPU
- **Description**: The highest level entity, which instantiates all the modules above
- **Inputs**: `clk`, `rst`, a 32-bit instruction, and a 64-bit input data path from the main memory
- **Outputs**: 
  - 64-bit output data path to the main memory
  - Final program counter (To be provided as input to instruction_memory_module)
  - 12-bit output memory location (To be provided to main_memory_module for read and write operation)
  - Flags: `vector_write_access`, `memory_read_access`, `load_vector_flag`, `load_word_flag`
- **Notes**: All the intermediate wires and registers in the code are used in the instantiations of the different modules.

## Opcode Mapping

The ISA uses 26 instructions, which are coded using a 6-bit opcode in a 32-bit instruction, where the first 6 bits among 32 represent the opcode.

| Opcode     | Operation                                    |
|------------|----------------------------------------------|
| 6'b000000  | Addition with register inputs                |
| 6'b000001  | Subtraction with register inputs             |
| 6'b000010  | Multiplication with register inputs          |
| 6'b000100  | Logical AND with register inputs             |
| 6'b000101  | Logical OR with register inputs              |
| 6'b000110  | Logical XOR with register inputs             |
| 6'b001000  | Logical SHIFTLEFT with register inputs       |
| 6'b001001  | Logical SHIFTRIGHT with register inputs      |
| 6'b001010  | Logical SET IF LESS THAN with register inputs|
| 6'b001011  | Logical SET IF EQUAL with register inputs    |
| 6'b010000  | Vector Addition with register inputs         |
| 6'b010001  | Vector Subtraction with register inputs      |
| 6'b010010  | Vector Dot Product with register inputs      |
| 6'b001101  | Addition with immediate inputs               |
| 6'b001110  | Logical AND with immediate inputs            |
| 6'b001111  | Logical XOR immediate inputs                 |
| 6'b100011  | Branch if EQUAL flag is set                  |
| 6'b100100  | Branch if GREATER THAN flag is set           |
| 6'b101101  | Load Vector                                  |
| 6'b101110  | Store Vector                                 |
| 6'b100101  | Load Word                                    |
| 6'b100110  | Store Word                                   |
| 6'b101000  | Logical SET IF LESS THAN with immediate inputs|
| 6'b110000  | Jump                                         |
| 6'b101100  | Register Address Write                       |
| 6'b101111  | Register Address Read                        |

All the instructions have their usual meaning as used in general literature and also mentioned in Prof. Smruti Ranjan Sarangi's textbook "Basic Computer Architecture."

## Instruction Syntax

In this architecture, all instructions are 32-bit wide, and there are 32 8-bit registers. For memory, the address length is taken to be 12-bit wide.

By default, all 32-bit instructions have their first 6 bits as the opcode. The syntax for the instructions is as follows:
1. **Register-based instructions**: `opcode[6bit] + destination register address[5bit] + source register1 address[5bit] + source register2 address[5bit]`
2. **Immediate-based instructions**: `opcode[6bit] + destination register address[5bit] + source register1 address[5bit] + immediate value[8bit] + DC[8bit]`
3. **Branch instructions**: `opcode[6bit] + DC[13bit] + source register address[5bit] + immediate value[8bit]`
4. **Load instructions**: `opcode[6bit] + destination register address[5bit] + DC[9bit] + memory address[12bit]`
5. **Store instructions**: `opcode[6bit] + DC[5bit] + source register address[5bit] + DC[4bit] + memory address[12bit]`
6. **Jump instructions**: `opcode[6bit] + final instruction address[26bit]`

*DC -> Don't care (can be filled with any bit. Generally filled with zeros)

*The Register Address Write instruction is to be given just before initializing the loop statement, while the Register Address Read is to be given just before giving a branch instruction always. This ensures that you have appropraitely remembered your program counter location. (Refer to "Basic Computer Architecture" book to know about the reason for it)

## Additional Notes

In this implementation, it is implicit that the instruction memory and main memory are not integrated into the processor and rather would be attached as external blocks. Also, they must not be synchronized to the clock, since it has already been taken care of in implementing the other modules.

Regarding the pin count for the processor, there are a total of 210 pins, as the processor takes in `clk`, `rst`, a 32-bit instruction, and a 64-bit input data path from the main memory. For output, it contains a 64-bit output data path to the main memory, the final 32-bit program counter, a 12-bit output memory location, and flags like `vector_write_access`, `memory_read_access`, `load_vector_flag`, `load_word_flag`.
