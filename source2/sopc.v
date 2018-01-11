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
    rom rom1(.addr_if(rom_addr),.inst(rom_data),.ce(rom_ce),.busy_if(rom_busy),
    .rst(rst),.store_data(ram_store_data),.write(ram_write),.valid(ram_ce),.addr(ram_addr),.byte(ram_byte),
             .data_o(ram_data_out),.busy_mem(ram_busy));
endmodule
