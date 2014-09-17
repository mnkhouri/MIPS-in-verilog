`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
// E:/UserData/Marc/Dropbox/Documents/School 13-14/Cmpen 331/Verilog/HW6/simulation
// Engineer: Marc Khouri	
//
// Create Date:	4/25/14	
// Design Name: CPU	
// Module Name: control unit    
// Project Name: HW6 for CMPEN 331
// Target Devices: 
// Tool versions:
// Description:		Handles all control signal for the cpu
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module control_unit
(
	rst,
	instruction,
	data_mem_wren,
	reg_file_wren,
	reg_file_dmux_select,
	reg_file_rmux_select,
	alu_mux_select,
	alu_control,
	alu_zero,
	alu_shamt,
	pc_control
);

	//--------------------------
	// Parameters
	//--------------------------	
	// None	
	
	
	//--------------------------
	// Input Ports
	//--------------------------
	// < Enter Input Ports  >
	input			rst;
	input 	[31:0]	instruction;
	input			alu_zero; 
	
	//--------------------------
	// Output Ports
	//--------------------------
	// < Enter Output Ports  >	
	output 	reg [3:0]	data_mem_wren;
	output	reg		reg_file_wren;
	output	reg		reg_file_dmux_select; // Refers to the mux that feeds the wdata bus of the register file
	output	reg		reg_file_rmux_select; // Refers to the mux that feeds the waddr bus of the register file
	output	reg		alu_mux_select;       // Refers to the mux that feeds the operand1 bus of the alu
	output	reg [3:0]	alu_control;
	output	reg [4:0]	alu_shamt;
	output	reg [3:0]	pc_control;
	
	//--------------------------
	// Bidirectional Ports
	//--------------------------
	// None
	
	///////////////////////////////////////////////////////////////////
	// Begin Design
	///////////////////////////////////////////////////////////////////
	//-------------------------------------------------
	// Signal Declarations: local params
	//-------------------------------------------------
	localparam //opcodes
		R = 	6'b000000,
		ADDI = 	6'b001000,
		ADDIU = 6'b001001,
		ANDI = 	6'b001100,
		ORI = 	6'b001101,
		SLTI = 	6'b001010,
		LW = 	6'b100011,
		LUI = 	6'b001111,
		SW = 	6'b101011,
		SH = 	6'b101001,
		SB = 	6'b101000,
		BEQ = 	6'b000100,
		BNE = 	6'b000100,
		J =		6'b000010;
		
	localparam //function codes
		ADD = 	6'b100000,
		ADDU = 	6'b100001,
		SUB = 	6'b100010,
		SUBU = 	6'b100011,
		AND = 	6'b100100,
		OR = 	6'b100101,
		XOR = 	6'b100110,
		NOR = 	6'b100111,
		SLT = 	6'b101010,
		SLL = 	6'b000000,
		SRL = 	6'b000010,
		SRA = 	6'b000011,
		JR = 	6'b000100;
	
	//ALU_control codes
	localparam C_AND 	= 4'b0000;
	localparam C_OR 	= 4'b0001;
	localparam C_XOR 	= 4'b0010;
	localparam C_NOR 	= 4'b0011;
	localparam C_ADDU	= 4'b0100;
	localparam C_ADD 	= 4'b0101;
	localparam C_SUBU 	= 4'b0110;
	localparam C_SUB	= 4'b0111;
	localparam C_SLT 	= 4'b1000;
	localparam C_SLL	= 4'b1001;
	localparam C_SRL	= 4'b1010;
	localparam C_SRA 	= 4'b1011;
	
	//-------------------------------------------------
	// Signal Declarations: reg
	//-------------------------------------------------
	// none
	
	//-------------------------------------------------
	// Signal Declarations: wire
	//-------------------------------------------------
	wire	[5:0]	op;
	wire	[5:0]	funct;
		
	//---------------------------------------------------------------
	// Instantiations
	//---------------------------------------------------------------
	// None

	//---------------------------------------------------------------
	// Combinatorial Logic
	//---------------------------------------------------------------
	// For each of the output signals, we define combinatorial logic
	
	assign op = instruction[31:26]; //continuously set opcode to first 6 bits of instruction
	assign funct = instruction[5:0];
	
	always @(instruction) begin
		//	output 	[3:0]	data_mem_wren;
		if (op == SW && !rst) begin
			data_mem_wren = 4'b1111;
		end else if (op == SH && !rst) begin
			data_mem_wren = 4'b0011;
		end else if (op == SB && !rst) begin
			data_mem_wren = 4'b0001;
		end else begin
			data_mem_wren = 4'b0000;			
		end
	
		// output			reg_file_wren;
		if (rst || op == SW || op == SH || op == SB || op == BEQ || op == BNE || op == J || op == JR) begin
			reg_file_wren = 0;
		end else begin
			reg_file_wren = 1;		
		end
		
		// output			reg_file_dmux_select; // Refers to the mux that feeds the wdata bus of the register file
		if (op == LW) begin
			reg_file_dmux_select = 0;
		end else begin
			reg_file_dmux_select = 1;
		end
		
		// output			reg_file_rmux_select; // Refers to the mux that feeds the waddr bus of the register file
		if (op == R) begin
			reg_file_rmux_select = 1;
		end else begin
			reg_file_rmux_select = 0;
		end
		
		// output			alu_mux_select;       // Refers to the mux that feeds the operand1 bus of the alu
		if (op == R || op == J) begin
			alu_mux_select = 0;
		end else begin // I-type
			alu_mux_select = 1;
		end
		
		// output	[3:0]	alu_control;
		if ((op == R && funct == ADD) || op == SW || op == SH || op == SB || op == ADDI || op == LW || op == LUI) begin
			alu_control = C_ADD;
		end else if ((op == R && funct == ADDU) || op == ADDIU) begin
			alu_control = C_ADDU; 
		end else if ((op == R && funct == SUB) || op == BNE || op == BEQ) begin
			alu_control = C_SUB;
		end else if ((op == R && funct == OR) || op == ORI) begin
			alu_control = C_OR;
		end else if ((op == R && funct == XOR)) begin
			alu_control = C_XOR;
		end else if ((op == R && funct == NOR)) begin
			alu_control = C_NOR;
		end else if ((op == R && funct == SUBU)) begin
			alu_control = C_SUBU;
		end else if ((op == R && funct == SLT) || op == SLTI) begin
			alu_control = C_SLT;
		end else if ((op == R && funct == SLL)) begin
			alu_control = C_SLL;
		end else if ((op == R && funct == SRL)) begin
			alu_control = C_SRL;
		end else if ((op == R && funct == SRA)) begin
			alu_control = C_SRA;
		end else if ((op == R && funct == AND) || op == ANDI) begin
			alu_control = C_AND;
		end else begin
			alu_control = 4'b1111;
		end	
		
		// output	[4:0]	alu_shamt; 
		if (op == R && (funct == SLL || funct == SRL || funct == SRA)) begin
			alu_shamt = instruction[10:6];
		end else begin
			alu_shamt = 4'b0000;
		end
		
		// output	[3:0]	pc_control;
		#0.5 
		if (op == J) begin
			pc_control = 3'b001;
		end else if (op == R && funct == JR) begin
			pc_control = 3'b010;
		end else if (op == BEQ && alu_zero == 1) begin
			pc_control = 3'b011;
		end else if (op == BNE && alu_zero == 0) begin
			pc_control = 3'b011;
		end else begin
			pc_control = 3'b000;
		end
		
	end
		
	//---------------------------------------------------------------
	// Sequential Logic
	//---------------------------------------------------------------
	//NONE
endmodule  


