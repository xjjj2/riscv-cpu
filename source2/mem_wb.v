`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/28 03:04:07
// Design Name: 
// Module Name: mem_wb
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


module mem_wb(
    input wire clk,
    input wire rst,
    input wire wvalid,
    input wire[31:0] wdata,
    input wire[4:0] waddr, 
    input wire[5:0] stall,
    output reg wvalid_wb,
    output reg[31:0] wdata_wb,
    output reg[4:0] waddr_wb
    );
    always @(posedge clk) begin
        if (rst==`avail) begin
            wvalid_wb<=`unavail;
            wdata_wb<=`zeroword;
            waddr_wb<=`zeroreg;
        end
        else if((stall[4]==`avail)&&(stall[5]==`unavail))begin
            wvalid_wb<=`unavail;
            wdata_wb<=`zeroword;
            waddr_wb<=`zeroreg;            
        end
        else if(stall[4]==`unavail)begin
            wvalid_wb<=wvalid;
            wdata_wb<=wdata;
            waddr_wb<=waddr;           
        end
    end
endmodule
