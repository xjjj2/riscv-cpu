`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/19 13:59:47
// Design Name: 
// Module Name: pc
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
`include "define.v"

module pc(
    input wire clk,
    input wire rst,
    input wire branch_valid,
    input wire [31:0]branch_addr,
    input wire [5:0] stall,
    output reg[31:0] pc_addr,
    output reg ce
    );
    reg npc;
    always @(posedge clk)begin
        if (rst==`avail) begin
            ce<=1'b0;
        end
        else begin
            ce<=1'b1;
        end
    end
    always @(posedge clk)begin
        if (ce==`unavail) begin
           pc_addr<=`zeroword;
        end
        else if (stall[0]==`unavail) begin
               if (branch_valid==`avail) 
                    pc_addr<=branch_addr;
               else 
                    pc_addr<=pc_addr+4; 
        end
     end
endmodule
