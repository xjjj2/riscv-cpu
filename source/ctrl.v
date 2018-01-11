`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/01/04 19:24:29
// Design Name: 
// Module Name: ctrl
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


module ctrl(
    input wire rst,
    input wire stall_if,
    input wire stall_id,
    input wire stall_mem,
    output reg[5:0] stall
    );
    always @(*) begin
        if (rst==`avail) 
            stall<=6'b000000;
        if (stall_mem==`avail) 
            stall<=6'b011111;
        else 
        if(stall_id==`avail)
            stall<=6'b000111;
        else if(stall_if==`avail)
            stall<=6'b000111;
        else stall<=6'b000000;
     end
endmodule
