# Processor Design Project
This project involved the development of a Reduced Instruction Set Computing (RISC) style processor, featuring general registers, a bidirectional bus, an Arithmetic Logic Unit (ALU), a memory subsystem, and a control unit. The design was implemented onto a Cyclone board, providing a practical demonstration of its functionality.

## Table of Contents
1. [Requirements](#requirements)
2. [Design](#design)
3. [Implementation](#implementation)
4. [Testing](#testing)
5. [Contributor](#contributor)
6. [License](#license)

## Requirements
A computer with a Verilog compiler (such as Quartus II)
A simulator (such as ModelSim Altera)
The Verilog code for the processor

## Design
The specifications of a RISC processor are typically driven by the need to achieve high performance with low power consumption. To achieve this, the processor is designed to execute a small set of instructions quickly and efficiently, with a focus on executing the most common operations required by software.

The key design specifications of the processor include:

    • Implementation of a 32-bit carry look-ahead adder used for the addition and subtraction

    • A 32-bit multiplier with bit-pair recoding based on Booth's algorithm

    • A 32-bit signed integer division unit using the restoring division algorithm

    • Dedicated program counter incrementor

    • Input and output capabilities

    • Custom synchronous RAM module with read/write capabilities

    • Select and encode logic used to decode the instruction from RAM

    • CON FF logic used to implement branching features

    • Control unit used to assert enable and select signals based on the operation in the opcode

Due to a lack of time, the completed processor was not successfully implemented onto the Cyclone  board. However, most features of the processor are fully functional and with some more time, it could be implemented onto a chip. Future plans include the continuation of development to complete the processor and add more bonus features.

## Implementation
The processor is implemented in Verilog and can be simulated using a Verilog simulator. The instruction memory and register file are modeled as arrays, while the ALU and control unit are modeled as modules.

## Testing
The processor can be tested by running instruction produced by an assembler at this link: https://qu.pgaskin.net/ASM374/. A set of test programs are provided in the memory subsystem directory. To run a test, load the assembly instructions into the memory and run the simulation. The register file and ALU output can be observed to check the correctness of the processor.

## Contributor
Nicholas Seegobin

## License
This project is licensed under the MIT License.
