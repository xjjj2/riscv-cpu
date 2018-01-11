`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/01/06 05:17:35
// Design Name: 
// Module Name: ram
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


module ram(
    input wire rst,
    input wire[31:0]store_data,
    input wire[3:0]byte,
    input wire valid,
    input wire write,
    input wire [31:0]addr,
    output reg [31:0] data_o,
    output reg busy
    );
    reg [7:0] ram[1023:0];
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
            busy<=`unavail;
        end
        else if(valid==`unavail) begin
            data_o<=`zeroword;
            busy<=`unavail;
        end
        else begin
            busy=`avail;
        if(write==`avail)begin
            data_o<=`zeroword;
            if (byte[0]==`avail) ram[addr_0]<=store_data[7:0];
            if (byte[1]==`avail) ram[addr_1]<=store_data[15:8];
            if (byte[2]==`avail) ram[addr_2]<=store_data[23:16];
            if (byte[3]==`avail) ram[addr_3]<=store_data[31:24];
        end
        else begin
            if (byte[0]==`avail) data_o[7:0]<=ram[addr_0];
            if (byte[1]==`avail) data_o[15:8]<=ram[addr_1];
            if (byte[2]==`avail) data_o[23:16]<=ram[addr_2];
            if (byte[3]==`avail) data_o[31:24]<=ram[addr_3];
        end
        #35 busy=`unavail;
        end
    end
endmodule
