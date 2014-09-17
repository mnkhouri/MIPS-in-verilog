`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company:    Penn State		
//					
// Engineer: Marc Khouri & Matt Henry
//
// Create Date:	3/23/14
// Design Name: program_counter.v
// Module Name: program_counter
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

module program_counter
(
    //--------------------------
	// Input Ports
	//--------------------------
	input				clk,
	input				rst,
	input		[3:0]	pc_control,
	input		[25:0]	jump_address,
	input		[15:0]	branch_offset,
	input		[31:0] 	reg_address,
	
    //--------------------------
    // Output Ports
    //--------------------------
    output 	reg [31:0] 	pc

); 
      
    ///////////////////////////////////////////////////////////////////
    // Begin Design
    ///////////////////////////////////////////////////////////////////
    //-------------------------------------------------
    // Signal Declarations: local params
    //-------------------------------------------------
	
    //-------------------------------------------------
    // Signal Declarations: reg
    //-------------------------------------------------    
	reg [31:0] branch_offset_extended;
    reg [27:0] jump_address_4x;
	
    //-------------------------------------------------
    // Signal Declarations: wire
    //-------------------------------------------------
	
	//---------------------------------------------------------------
	// Instantiations
	//---------------------------------------------------------------
	// None

	//---------------------------------------------------------------
	// Combinatorial Logic
	//---------------------------------------------------------------

	
	//---------------------------------------------------------------
	// Sequential Logic
	//---------------------------------------------------------------
    always @ (posedge clk or posedge rst)
	if (rst) begin
        pc = 0;
    end
    else begin
        case (pc_control)
    		//PC is updated to the next sequential instruction address.
    		4'b0000: pc = pc + 4;
    		//When the CPU executes an unconditional Jump instruction the new 32-bit PC is the concatenation of the upper 4-bits of PC and the 28-bit result of the jump address multiplied by 4. See definition of the Jump instruction (opcode 2)
    		4'b0001: begin
                jump_address_4x = jump_address*4;
                pc = {pc[31:28] , jump_address_4x[27:0]};
            end
    		//PC is updated with the value contained in the register specified in the instruction. “reg_address” holds the value of the specified register.
    		4'b0010: pc = reg_address;
    		//PC is updated with the sum of PC+4 and the branch offset multiplied by 4. 16-bit to 32-bit sign extension of the branch offset is necessary.
    		4'b0011: begin 
    			branch_offset_extended = { {16{branch_offset[15]}}, branch_offset[15:0]};
    			pc = (pc + 4) + (branch_offset_extended*4);
    		end
    		//control signals 4'b0100 - 4'b1111 have undefined behaviour, reset PC to 0
    		default: pc = 32'hFFFFFFFF;
    	endcase	
	end
	
 endmodule  



