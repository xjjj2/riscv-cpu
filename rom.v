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
    input wire[31:0] addr,
    input wire valid,
    input wire read_finish,
    input wire [31:0]read_data,
    output reg[31:0] inst,
    output wire busy,
    output reg[31:0] read_addr
    );
    reg [7:0] rom[0:8191];
    initial $readmemh("E:/riscv/sample.bin",rom);
    assign busy=valid & !read_finish;
    always @(*) begin
        if (valid==`avail) begin
            busy=`avail;
//              read_addr<=addr;
            #35 inst={rom[{addr[31:2],2'b11}],rom[{addr[31:2],2'b10}],rom[{addr[31:2],2'b01}],rom[{addr[31:2],2'b00}]};
            busy=`unavail; 
        end
        else begin
            busy<=`unavail;
            inst<=`zeroword;
        end
    end
endmodule
