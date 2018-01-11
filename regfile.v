`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/19 20:22:13
// Design Name: 
// Module Name: regfile
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
module regfile(
    input wire clk,
    input wire rst,
    input wire[4:0] waddr,
    input wire[31:0] wdata,
    input wire wvalid,
    input wire[4:0] r1addr,
    input wire r1valid,
    input wire r2valid,
    input wire[4:0] r2addr,
    output reg[31:0]r1data,
    output reg[31:0]r2data
    );
    reg [31:0] regis [31:0];
    integer i;
    always @(posedge clk)begin
        if (rst==`unavail) begin
           if ((wvalid==`avail)&&(waddr!=`zeroreg)) begin
                regis[waddr]<=wdata;
           end 
        end
        else begin
            for (i=0;i<32;i=i+1) begin
               regis[i]<=`zeroword;
            end
        end
    end
    always @(*) begin
        if (rst==`avail) begin
            r1data<=`zeroword;
        end
        else if (r1addr==`zeroreg) begin
            r1data<=`zeroword;
        end
        else if ((r1valid==`avail)&&(wvalid==`avail)&&(r1addr==waddr)) begin
            r1data<=wdata;
        end
        else if (r1valid==`avail) begin
            r1data<=regis[r1addr];
        end
        else begin
            r1data<=`zeroword;
        end
    end
    always @(*) begin
            if (rst==`avail) begin
                r2data<=`zeroword;
            end
            else if (r2addr==`zeroreg) begin
                r2data<=`zeroword;
            end
            else if ((r2valid==`avail)&&(wvalid==`avail)&&(r2addr==waddr)) begin
                r2data<=wdata;
            end
            else if (r2valid==`avail) begin
                r2data<=regis[r2addr];
            end
            else begin
                r2data<=`zeroword;
            end
        end
endmodule
