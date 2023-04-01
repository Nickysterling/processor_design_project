# Processor Design Project
This project involves the design and implementation of a simple processor using Verilog. The processor is capable of executing a subset of the MIPS instruction set.

## Table of Contents
1. [Requirements](#requirements)
2. [Design](#design)
3. [Implementation](#implementation)
4. [Testing](#testing)
5. [Contributors](#contributors)
6. [License](#license)

## Requirements
A computer with a Verilog compiler (such as Xilinx or Altera)
A simulator (such as ModelSim or Icarus Verilog)
The Verilog code for the processor

## Design
The processor has the following components:

An instruction memory to store the program
A register file to store data
An ALU to perform arithmetic and logic operations
A control unit to control the flow of the program

## Implementation
The processor is implemented in Verilog and can be simulated using a Verilog simulator. The instruction memory and register file are modeled as arrays, while the ALU and control unit are modeled as modules.

## Testing
The processor can be tested by running assembly programs on the simulator. A set of test programs are provided in the tests directory. To run a test, load the assembly file into the instruction memory and run the simulation. The register file and ALU output can be observed to check the correctness of the processor.

## Creator
Nicholas Seegobin

## License
This project is licensed under the MIT License.