`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company:    Penn State        
//    				
// Engineer: Marc Khouri & Matt Henry
//
// Create Date:	3/23/14
// Design Name: alu.v
// Module Name: alu
// Project Name: MIPS CPU
//
// Dependencies:
//
// Revision: 1
//
//
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
module alu 
(
    //--------------------------
    // Input Ports
    //--------------------------
    input	[31:0]	operand0, 
	input	[31:0]	operand1, 
	input	[3:0]	control,
    //--------------------------
    // Output Ports
    //--------------------------
    output	[31:0]	result,
	output			zero,
	output			overflow
);
    //--------------------------
    // Bidirectional Ports
    //--------------------------
    // < Enter Bidirectional Ports in Alphabetical Order >
    // None
      
    ///////////////////////////////////////////////////////////////////
    // Begin Design
    ///////////////////////////////////////////////////////////////////
    //-------------------------------------------------
    // Signal Declarations: local params
    //-------------------------------------------------
    
    //-------------------------------------------------
    // Signal Declarations: reg
    //-------------------------------------------------  
 
    //-------------------------------------------------
    // Signal Declarations: wire
    //-------------------------------------------------      

	assign result 	= alu_function(control, operand0, operand1);
	assign zero 	= (result == 0) ? 1'b1 : 1'b0;
	assign overflow = (operand0[31] == operand1[31]) && (result[31] != operand0[31]);

	function [31:0] alu_function;
		input [3:0] control;
        input [31:0] operand0;
        input [31:0] operand1;
		begin
			case (control)
				//AND
				4'b0000: alu_function = operand0 & operand1;
				//OR
				4'b0001: alu_function = operand0 | operand1;
				//XOR
				4'b0010: alu_function = operand0 ^ operand1;
				//NOR
				4'b0011: alu_function = operand0 ~| operand1;
				//ADD
				4'b0100: alu_function = operand0 + operand1;
				//SIGNED ADD
				4'b0101: alu_function = $signed(operand0) + $signed(operand1);
				//SUB
				4'b0110: alu_function = operand0 - operand1;
				//SIGNED SUB
				4'b0111: alu_function = $signed(operand0) - $signed(operand1);
				//SET ON LESS THAN
				4'b1000: alu_function = operand0 < operand1;
				//SHIFT LEFT
				4'b1001: alu_function = operand0 << operand1;
				//SHIFT RIGHT
				4'b1010: alu_function = operand0 >> operand1;
				//SHIFT RIGHT ARITHMETIC
				4'b1011: alu_function = $signed(operand0) >>> operand1;
			endcase
		end
	endfunction
         
endmodule

