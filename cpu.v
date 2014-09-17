`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Engineer: Marc Khouri	
//
// Create Date:	4/26/14	
// Design Name: CPU	
// Module Name: CPU    
// Project Name:	
// Target Devices: 
// Tool versions:
// Description:	Connects all modules that make up the CPU	
//
// Dependencies:
//
// Revision:
//
//
// Additional Comments:
// Instantiate all the necessary components in this file. Connect them as appropriate using wires.  Use the figure
// provided in the specification as a guide.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module cpu
(
	clk,
	rst
);

	//--------------------------
	// Parameters
	//--------------------------	
	
    //--------------------------
	// Input Ports
	//--------------------------
	// < Enter Input Ports  >
    input 					clk;
	input 					rst;
	
	//--------------------------
    // Output Ports
    //--------------------------
    // < Enter Output Ports  >
    
	
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
	wire [31:0] pc;
	wire [31:0] instruction;
	wire [31:0] instruction_signextended;

	wire [3:0]	data_mem_wren;
	wire		reg_file_wren;
	wire		reg_file_dmux_select;
	wire		reg_file_rmux_select;
	wire		alu_mux_select;
	wire [3:0]	alu_control;
	wire [3:0]	pc_control;

	wire [4:0] 	waddr;

	wire [31:0]	rdata0;
	wire [31:0]	rdata1;
	wire [31:0]	wdata;

	wire [31:0] alu_operand1;

	wire [31:0] alu_result;
	wire [4:0] 	shamt;

	wire alu_flag_overflow;
	wire alu_zero;

	wire [31:0] datamemory_rdata;

	wire [4:0] radd0;
	wire [4:0] radd1;

	//---------------------------------------------------------------
	// Instantiations
	//---------------------------------------------------------------
	program_counter	prog_cnt (.clk(clk),
							.rst(rst),
							.pc_control(pc_control),
							.jump_address(instruction[25:0]),
							.branch_offset(instruction[15:0]),
							.reg_address(rdata0),
							.pc(pc));

	instruction_memory inst_mem (.address(pc),
								 .instruction(instruction));

	control_unit cntrlUnit (.instruction(instruction),
							.rst(rst),
							.data_mem_wren(data_mem_wren),
							.reg_file_wren(reg_file_wren),
							.reg_file_dmux_select(reg_file_dmux_select),
							.reg_file_rmux_select(reg_file_rmux_select),
							.alu_mux_select(alu_mux_select),
							.alu_control(alu_control),
							.alu_zero(alu_zero),
							.alu_shamt(shamt),
							.pc_control(pc_control));

	sign_extension instrSignExtend (.in(instruction[15:0]),
								   .out(instruction_signextended));

	mux_2to1 #(.DWIDTH(5)) instructionRegFileSelectMux (.in0(radd1),
										  .in1(instruction[15:11]),
										  .out(waddr),
										  .sel(reg_file_rmux_select));

	register_file regFile (.clk(clk),
						   .raddr0(radd0),
						   .rdata0(rdata0),
						   .raddr1(radd1),
						   .rdata1(rdata1),
						   .waddr(waddr),
						   .wdata(wdata),
						   .wren(reg_file_wren));

	mux_2to1 aluOperand1SelectMux (.in0(rdata1),
								   .in1(instruction_signextended),
								   .out(alu_operand1),
								   .sel(alu_mux_select));

	alu alu(.control(alu_control),
							  .operand0(rdata0),
							  .operand1(alu_operand1),
							  .result(alu_result),
							  .overflow(alu_flag_overflow),
							  .zero(alu_flag_zero),
							  .shamt(shamt));

	data_memory dataMemory (.clk(clk),
							.addr(alu_result),
							.rdata(datamemory_rdata),
							.wdata(rdata1),
							.wren(data_mem_wren));

	mux_2to1 dataMemoryRDataSelectMux (.in0(datamemory_rdata),
									   .in1(alu_result),
								       .out(wdata),
									   .sel(reg_file_dmux_select));
    	
	//---------------------------------------------------------------
	// Combinatorial Logic
	//---------------------------------------------------------------
	assign radd0 = instruction[25:21];
	assign radd1 = instruction[20:16];
	
	always @(posedge clk)
	begin
		//we dont' actually need to do anything!
	end
	
	//---------------------------------------------------------------
	// Sequential Logic
	//---------------------------------------------------------------
endmodule
