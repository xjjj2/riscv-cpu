`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/19 13:59:47
// Design Name: 
// Module Name: IF
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


module IF(
    input wire clk,
    input wire rst,
    output reg[31:0] id_addr,
    output reg[31:0] id_inst
    );
    reg[31:0] pce;
    reg val;
    pc pc1(.clk(clk),.rst(rst),.ce(val),.pc_addr(pce));
    rom rom1(.valid(val),.addr(pce),.inst(id_inst));
    always @(*) begin
        id_addr<=pce;
    end
endmodule
