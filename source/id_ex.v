`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/26 00:53:11
// Design Name: 
// Module Name: id_ex
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module id_ex(
    input wire clk,
    input wire rst,
    input wire [31:0] addr_pc,
//    input wire [6:0] func7,
//    input wire [2:0] func3,
//    input wire [6:0] opcode,
    input wire [31:0] r1,
    input wire [31:0] r2,
    input wire wvalid,
    input wire [4:0] waddr,
    input wire [2:0] alusel,
    input wire [6:0] aluop,
    input wire [31:0] store_imm,
    input wire [5:0] stall,
    output reg [31:0] addr_pc_ex, 
//    output reg [6:0] func7_ex,
//    output reg [2:0] func3_ex,
//    output reg [6:0] opcode_ex,
    output reg [31:0] r1_ex,
    output reg [31:0] r2_ex,
    output reg wvalid_ex,
    output reg [4:0] waddr_ex,    
    output reg [2:0] alusel_ex,
    output reg [6:0] aluop_ex,
    output reg [31:0] store_imm_ex
    );
    always @(posedge clk) begin
        if (rst==`avail) begin
            addr_pc_ex<=`zeroword;
//            func7_ex<=`zero7;
//            func3_ex<=`zero3;
//            opcode_ex<=`OP_OP_IMM;
            r1_ex<=`zeroword;
            r2_ex<=`zeroword;
            wvalid_ex<=`unavail;
            waddr_ex<=`zeroreg;
            alusel_ex<=`nop;
            aluop_ex<=`op_nop;
            store_imm_ex<=`zeroword;
        end
        else if((stall[2]==`avail)&&(stall[3]==`unavail))begin
                    addr_pc_ex<=`zeroword;
//            func7_ex<=`zero7;
//            func3_ex<=`zero3;
//            opcode_ex<=`OP_OP_IMM;
                    r1_ex<=`zeroword;
                    r2_ex<=`zeroword;
                    wvalid_ex<=`unavail;
                    waddr_ex<=`zeroreg;
                    alusel_ex<=`nop;
                    aluop_ex<=`op_nop;
                    store_imm_ex<=`zeroword;
        end
        else if(stall[2]==`unavail) begin
            addr_pc_ex<=addr_pc;
//            func7_ex<=func7;
//            func3_ex<=func3;
//            opcode_ex<=opcode;
            r1_ex<=r1;
            r2_ex<=r2;
            wvalid_ex<=wvalid;
            waddr_ex<=waddr;
            alusel_ex<=alusel;
            aluop_ex<=aluop;
            store_imm_ex<=store_imm;
        end
    end
    
endmodule
