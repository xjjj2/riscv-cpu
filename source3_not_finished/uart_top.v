`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/01/10 17:57:12
// Design Name: 
// Module Name: uart_top
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


module uart_top(
    input wire clk,
    input wire rst,
    input wire[31:0] addr_if,
    input wire ce_if,
    input wire uart_send_using,
    input wire uart_recv_using,
    input wire mem_we,
    input wire mem_ce,
    input wire[31:0] mem_addr,
    input wire[31:0] mem_write_data,
    input wire[3:0] mem_byte,
    input wire [7:0] recv_data,
    input wire recv_fault,
    output reg [7:0] send_data,
    output reg stall_if,
    output reg stall_mem,
    output reg [31:0] if_data,
    output reg [31:0] mem_data,
    output reg send_ce
    );
      reg [7:0] read_buf [3:0];
//    reg [3:0]r_cnt;
//    reg [3:0]r_ptr;
//    reg [15:0] write_buf [15:0];
//    reg [3:0]w_cnt;
//    reg [3:0]w_ptr;
    reg busy_if;
    reg busy_load_mem;
    reg busy_store_mem;
    reg [2:0]send_counter;
    reg [2:0]recv_counter;
    reg [31:0] read_data;
    reg finish_if;
    reg finish_mem;
    wire using;
    reg read_using;
    reg write_using;
    reg send_data_get;
    assign using=read_using | write_using;
    reg [3:0]write_counter;
    reg [7:0] write_buf[7:0];
    always @(*) begin
        if (rst==`avail) begin
    //            r_cnt<=4'b0000;
    //            w_cnt<=4'b0000;
    //            r_ptr<=4'b0000;
    //            w_ptr<=4'b0000;
                  send_counter<=3'b000;
                  read_using<=`unavail;
                  read_data<=`zeroword;
                  recv_counter<=3'b000;
                  finish_if<=`unavail;
                  finish_mem<=`unavail;
            end
        else
        if (busy_load_mem==`unavail && busy_store_mem==`unavail && using==`unavail && ce_if==`avail && finish_if==`unavail) begin
            busy_if<=`avail;
            send_counter<=3'b000;
            recv_counter<=3'b000;
            read_buf[0]<=addr_if[7:0];
            read_buf[1]<=addr_if[15:8];
            read_buf[2]<=addr_if[23:16];
            read_buf[3]<=addr_if[31:24];
            read_using<=`avail;
            send_ce<=`avail;
            send_data<=`zeroword;
        end
        else if (busy_if==`unavail && using==`unavail && mem_we==`unavail && mem_ce==`avail &&
                 finish_mem==`unavail) begin
                 busy_load_mem<=`avail;
                 send_counter<=3'b000;
                 recv_counter<=3'b000;
                 read_buf[0]<=mem_addr[7:0];
                 read_buf[1]<=mem_addr[15:8];
                 read_buf[2]<=mem_addr[23:16];
                 read_buf[3]<=mem_addr[31:24];
                 read_using<=`avail;
                 send_ce<=`avail;
                 send_data<=`zeroword;
               end
        else
        if (busy_if==`unavail && using==`unavail && mem_we==`avail && mem_ce==`avail 
            && finish_mem==`unavail) begin
                 busy_store_mem<=`avail;
                 write_counter<=4'b0000;
                 write_buf[0]<=mem_addr[7:0];
                 write_buf[1]<=mem_addr[15:8];
                 write_buf[2]<=mem_addr[23:16];
                 write_buf[3]<=mem_addr[31:24];
                 write_buf[4]<=mem_write_data[7:0];
                 write_buf[5]<=mem_write_data[15:8];
                 write_buf[6]<=mem_write_data[23:16];
                 write_buf[7]<=mem_write_data[31:24];
                 write_using<=`avail;
                 send_ce<=`avail;
                 send_data<={4'b1000,mem_byte};     
           end         
        else
        if (read_using==`avail && send_counter[2]==1'b0 && uart_send_using==1'b0) begin
            send_data=read_buf[send_counter];
            send_counter=send_counter+1;
            send_ce=`avail;
        end
        else if(uart_send_using==`unavail && write_using==`avail && write_counter[3]==`unavail)begin
                    send_data=write_buf[write_counter];
                    write_counter=write_counter+1;
                    send_ce=`avail;
        end 
        else if(send_counter[2]==1'b1) begin
            send_ce<=`unavail;
            
        end
        else if(write_counter[3]==1'b1) begin
            send_ce<=`unavail;
        end
//        else
//        if(finish_if==`avail) begin
//           busy_if<=`unavail;
//           send_ce<=`unavail;
//           stall_if<=`unavail;
//        end
    end
    always @(*) begin
        if (busy_if==`unavail) begin
            finish_if<=`avail;
        end
        else finish_if<=`unavail;
    end
    
    always @(*) begin
        if(uart_send_using==1'b1)
            send_ce=`unavail; 
    end
    always @(uart_recv_using) begin
            if (uart_recv_using==`unavail && rst==`unavail && recv_fault==`unavail) begin
                case (recv_counter[1:0])
                    2'b00:
                        read_data[7:0]<=recv_data;
                    2'b01:
                        read_data[15:8]<=recv_data;
                    2'b10:
                        read_data[23:16]<=recv_data;
                    2'b11:
                        read_data[31:24]<=recv_data;
                endcase
                recv_counter<=recv_counter+1;
            end
        end
    always @(*) begin
      if (recv_counter[2]==`avail && rst==`unavail) begin
                read_using<=`unavail;
            end
    end    
    always @(read_using or rst) begin
        if (read_using==`unavail && rst==`unavail)
            if (busy_if==`avail) begin
                if_data=read_data;
                finish_if=`avail;
            end
            else if(busy_load_mem==`avail) begin
                mem_data=read_data;
                finish_mem=`avail;
            end
        end
        
    always @(mem_ce or mem_we or mem_data or mem_addr) begin
       finish_mem<=`unavail;
       if (mem_ce==`avail) begin
            stall_mem<=`avail;
       end
    end
    always @(*)
       if(finish_mem==`avail) begin
          busy_load_mem<=`unavail; 
          busy_store_mem<=`unavail;
          stall_mem<=`unavail;
       end
    
    
    
    //store
   
    always @(*) begin
        if(uart_send_using==`avail)
            send_ce=`unavail;
    end
    always @(*) begin
        if (write_counter[3]==`avail) begin
            write_using=`unavail;
            finish_mem=`avail;
            send_ce=`unavail;
            busy_store_mem=`unavail;
            stall_mem=`unavail;
        end
    end 
endmodule
