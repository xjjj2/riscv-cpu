`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/28 02:46:52
// Design Name: 
// Module Name: ex_mem
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


module ex_mem(
    input wire clk,
    input wire rst,
    input wire [4:0] waddr,
    input wire [31:0] wdata,
    input wire wvalid,
    input wire [5:0] stall,
    input wire [31:0] mem_addr,
    input wire [2:0] alusel,
    input wire [6:0] aluop,
    input wire [31:0] r2,
    output reg [4:0] waddr_mem,
    output reg [31:0] wdata_mem,
    output reg wvalid_mem,
    output reg [31:0] mem_addr_o,
    output reg [2:0] alusel_o,
    output reg [6:0] aluop_o,
    output reg [31:0] r2_o
    );
    always @(posedge clk) begin
        if (rst==`avail) begin
            waddr_mem<=`zeroreg;
            wdata_mem<=`zeroword;
            wvalid_mem<=`unavail;
            mem_addr_o<=`zeroreg;
            alusel_o<=`nop;
            aluop_o<=`op_nop;
            r2_o<=`zeroword;
        end
        else if ((stall[3]==`avail)&&(stall[4]==`unavail)) begin
            waddr_mem<=`zeroreg;
            wdata_mem<=`zeroword;
            wvalid_mem<=`unavail; 
            mem_addr_o<=`zeroreg;
            alusel_o<=`nop;
            aluop_o<=`op_nop;
            r2_o<=`zeroword;                       
        end
        else if (stall[3]==`unavail)begin
             waddr_mem<=waddr;
             wdata_mem<=wdata;
             wvalid_mem<=wvalid;       
             mem_addr_o<=mem_addr;
             alusel_o<=alusel;
             aluop_o<=aluop;
             r2_o<=r2;                 
        end
    end
endmodule
