`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/01/03 23:45:43
// Design Name: 
// Module Name: sopc
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


module sopc(
    input wire clk,
    input wire rst,
    input Rx,
    output Tx
    );
    wire rom_ce;
    wire [31:0] rom_addr;
    wire [31:0] rom_data;
    wire rom_busy;
    wire [31:0] ram_data_out;
    wire [31:0] ram_store_data;
    wire ram_write;
    wire ram_ce;
    wire [31:0]ram_addr;
    wire [3:0]ram_byte;
    wire ram_busy;
    wire uart_send_using;
    wire uart_recv_using;
    wire [31:0] data_from_recv;
    wire recv_fault;
    wire [7:0] send_data;
    wire send_ce;
    fc fc1(.clk(clk),.rst(rst),.rom_valid_o(rom_ce),.rom_addr_o(rom_addr),.rom_data_i(rom_data),.stall_from_rom(rom_busy),
            .ram_data_i(ram_data_out),.ram_store_data(ram_store_data),.ram_write(ram_write),.ram_valid(ram_ce),
            .ram_addr(ram_addr),.ram_byte(ram_byte),.stall_from_ram(ram_busy));
//    rom rom1(.addr_if(rom_addr),.inst(rom_data),.ce(rom_ce),.busy_if(rom_busy),
//    .rst(rst),.store_data(ram_store_data),.write(ram_write),.valid(ram_ce),.addr(ram_addr),.byte(ram_byte),
//             .data_o(ram_data_out),.busy_mem(ram_busy));
    uart_top uart_top1(.clk(clk),.rst(rst),.addr_if(rom_addr),.ce_if(rom_ce),.uart_send_using(uart_send_using),
                       .uart_recv_using(uart_recv_using),.mem_we(ram_write),.mem_ce(ram_ce),.mem_addr(ram_addr),
                       .mem_write_data(ram_store_data),.mem_byte(ram_byte),.recv_data(data_from_recv),
                       .recv_fault(recv_fault),
                       
                       .send_data(send_data),.stall_if(rom_busy),.stall_mem(ram_busy),.if_data(rom_data),.mem_data(ram_data_out),
                       .send_ce(send_ce));
    uart_send uart_send1(.clk(clk),.rst(rst),.send_ce(send_ce),.send_data(send_data),
                         .send_busy(uart_send_using),.Tx(Tx));
    uart_recv uart_recv1(.clk(clk),.rst(rst),.Rx(Rx),.recv_busy(uart_recv_using),.recv_data(data_from_recv),.fault(recv_fault));
endmodule
