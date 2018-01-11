`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/01/11 14:51:27
// Design Name: 
// Module Name: uart_recv
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


module uart_recv #(
    parameter CLOCK=100000000,
    parameter BAUD=9600 //串口波特率等于比特率
)(
    input Rx,
    input clk,
    input rst,
    output reg recv_busy,
    output reg[7:0]recv_data,
    output reg fault
    );
    localparam clock_per_bit=CLOCK/BAUD-1;
    reg [3:0] recv_bit;
    reg [1:0] recv_status;
    integer recv_counter;
    wire get_data=recv_counter==clock_per_bit/2;
    always @(posedge clk or posedge rst) begin
        if(rst==`avail) begin
            recv_busy<=`unavail;
            recv_data<=8'h0;
            recv_bit<=4'b0000;
            recv_counter<=0;
            fault<=`unavail;
        end
        else begin
            if (recv_busy==`avail)
            if (recv_counter==clock_per_bit) begin
                   recv_counter=0;
              end
              else recv_counter=recv_counter+1;
            if (Rx==1'b0) begin
                recv_busy=`avail;
                recv_bit<=4'b0000;
                recv_counter<=0;
                recv_data<=8'h0;
                recv_status<=2'b01;
                fault<=`unavail;
            end
            else if(get_data==`avail)begin
                case (recv_status)
                    2'b01:
                        if (Rx==1'b0) begin
                            recv_status<=2'b10;
                        end 
                        else begin
                            recv_status<=2'b00;
                            recv_counter<=0;
                            fault<=`avail;
                            recv_busy<=`unavail;
                        end
                    2'b10:begin
                        recv_data[recv_bit]=Rx;
                        recv_bit=recv_bit+1;
                        if (recv_bit==4'b1000) begin
                            recv_status=2'b11;
                        end
                    end
                    2'b11:begin
                        recv_status<=2'b00;
                        recv_busy<=`unavail;
                    end
                endcase
            end
        end
    end
endmodule
