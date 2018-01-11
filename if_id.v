`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/19 13:59:47
// Design Name: 
// Module Name: if_id
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
module if_id(
    input wire clk,
    input wire rst,
    input wire flush,
    input wire [5:0] stall,
    input wire[31:0] if_addr,
    input wire[31:0] if_inst,
    output reg[31:0] id_addr,
    output reg[31:0] id_inst
    );
    always @(posedge clk)begin
        if (rst==`avail) begin
           id_addr<=32'h00000000;
           id_inst<=32'h00000000;
        end
        else if ((stall[1]==`avail)&&(stall[2]==`unavail)) begin
            id_addr<=32'h00000000;
            id_inst<=32'h00000000;
        end
        else if ((stall[1]==`avail)&&(stall[2]==`avail)) begin
            
        end
        else if (flush==`avail)begin
           id_addr<=`zeroword;
           id_inst<=`zeroword; 
        end
        else begin
            id_addr<=if_addr;
            id_inst<=if_inst;
        end
    end
endmodule
