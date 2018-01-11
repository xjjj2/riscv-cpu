`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/01/11 00:39:54
// Design Name: 
// Module Name: uart_send
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


module uart_send #(
    parameter CLOCK=100000000,
    parameter BAUD=9600 //串口波特率等于比特率
)(
    output reg Tx,
    input clk,
    input send_ce,
    input rst,
    output reg send_busy,
    input wire [7:0] send_data
    );
    integer counter;
    reg [1:0] send_status;//00-空闲 01-数据 10-结束
    localparam clock_per_bit=CLOCK/BAUD-1;
    reg [3:0] send_bit;
    
    always @(posedge clk or posedge rst) begin
        if (rst==`avail) begin
            send_busy<=`unavail;
            counter<=0;
            send_status<=2'b00;
        end
        else begin
            if (send_busy==`avail)
            if (counter==clock_per_bit) begin
                counter=0;
            end
            else counter=counter+1;
            if (send_ce==`avail && send_status==2'b00 || send_busy==`avail) begin
                case (send_status)
                    2'b00:begin
                        counter<=0;
                        send_busy<=`avail;
                        send_status<=2'b01;
                        Tx<=1'b1;
                        send_bit<=4'b0000;
                    end
                    2'b01:begin
                        if(counter==0) begin
                           Tx=send_data[send_bit];
                           send_bit=send_bit+1;
                           if (send_bit==4'b1000) send_status=2'b10;
                        end
                    end 
                    2'b10:begin
                       if(counter==0) begin
                         Tx=1;
                         send_status=2'b00;
                         send_busy=`unavail;
                       end                        
                    end
                endcase
            end
        end
    end
endmodule
