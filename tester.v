`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/01/03 23:58:17
// Design Name: 
// Module Name: tester
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


module tester(

    );
    reg clock_50;
    reg rst;
    initial begin
        clock_50=1'b0;
        forever #10 clock_50=~clock_50;
    end
    initial begin
        rst=1'b1;
        #195 rst=1'b0;
        #1000 $stop;
    end
    sopc sopc1(.clk(clock_50),.rst(rst));
endmodule
