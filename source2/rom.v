`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/25 22:07:09
// Design Name: 
// Module Name: rom
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
module rom(
    input wire[31:0] addr_if,
    input wire ce,
    output reg[31:0] inst,
    input wire rst,
    input wire[31:0]store_data,
    input wire[3:0]byte,
    input wire valid,
    input wire write,
    input wire [31:0]addr,
    output reg [31:0] data_o,
    output reg busy_if,
    output reg busy_mem
    );
    reg [7:0] rom[0:65535];
    initial $readmemh("E:/riscv/sample.bin",rom);
    always @(*) begin
        if (ce==`avail) begin
            busy_if=`avail;
//              read_addr<=addr;
             inst={rom[{addr_if[31:2],2'b11}],rom[{addr_if[31:2],2'b10}],rom[{addr_if[31:2],2'b01}],rom[{addr_if[31:2],2'b00}]};
            busy_if=`unavail; 
        end
        else if(ce==`unavail)begin
            busy_if<=`unavail;
            inst<=`zeroword;
        end
    end
     wire [31:0]addr_0;
       wire [31:0]addr_1;
       wire [31:0]addr_2;
       wire [31:0]addr_3;
       assign addr_0=addr;
       assign addr_1=addr+1;
       assign addr_2=addr+2;
       assign addr_3=addr+3;
       always @(*) begin
           if (rst==`avail) begin
               data_o<=`zeroword;
               busy_mem<=`unavail;
           end
           else if(valid==`unavail) begin
               data_o<=`zeroword;
               busy_mem<=`unavail;
           end
           else if(valid==`avail)begin
               busy_mem=`avail;
           if(write==`avail)begin
               data_o<=`zeroword;
               if (byte[0]==`avail) rom[addr_0]<=store_data[7:0];
               if (byte[1]==`avail) rom[addr_1]<=store_data[15:8];
               if (byte[2]==`avail) rom[addr_2]<=store_data[23:16];
               if (byte[3]==`avail) rom[addr_3]<=store_data[31:24];
           end
           else begin
               if (byte[0]==`avail) data_o[7:0]<=rom[addr_0];
               if (byte[1]==`avail) data_o[15:8]<=rom[addr_1];
               if (byte[2]==`avail) data_o[23:16]<=rom[addr_2];
               if (byte[3]==`avail) data_o[31:24]<=rom[addr_3];
           end
            busy_mem=`unavail;
           end
       end
endmodule
