`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/26 00:13:38
// Design Name: 
// Module Name: fc
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


module fc(
    input wire clk,
    input wire rst,
    input wire[31:0] rom_data_i,
    input wire[31:0] ram_data_i,
    input wire stall_from_rom,
    input wire stall_from_ram,
    output wire[31:0] rom_addr_o,
    output wire rom_valid_o,
    output wire ram_valid,
    output wire ram_write,
    output wire [3:0] ram_byte,
    output wire [31:0] ram_addr,
    output wire [31:0] ram_store_data
    );
    //pc->if/id
    wire[31:0] wire1;
    wire[31:0] wire2;
    wire[31:0] wire3;
    wire[31:0] wire4;
    wire[31:0] wire5;
    wire[31:0] wire6;
    wire[4:0] wire7;
    wire wire8;
    wire[31:0] wire9;
    wire[4:0] wire10;
    wire wire11;
    wire[31:0] wire12;
    wire wire13;
    wire wire14;
    wire[31:0] wire15;
    wire[31:0] wire16; 
    wire[4:0] wire17;
    wire[4:0] wire18;
    wire[2:0] wire19;
    wire[6:0] wire20;
    wire wire21;
    wire [4:0] wire22;
    wire [4:0] wire23;
    wire wire24;
    wire [31:0] wire25;
    wire [31:0] wire26;
    wire [31:0] wire27;
    wire [31:0] wire28;
    wire [31:0] wire29;
    wire wire30;
    wire [4:0] wire31;
    wire [2:0] wire32;
    wire [6:0] wire33;
    wire [4:0] wire34;
    wire wire35;
    wire [31:0] wire36;
    wire wire37;
    wire [31:0] wire38;
    wire wire39;
    wire wire40;
    wire [31:0] wire41;
    wire [31:0] wire42;
    wire [31:0] wire43;
    wire [2:0] wire44;
    wire [6:0] wire45;
    wire [31:0] wire46;
    wire [31:0] wire47;
    wire [2:0] wire48;
    wire [6:0] wire49;
    wire [31:0] wire50;
    wire [5:0] wire51;//stall
    pc pc1(.clk(clk),.rst(rst),.pc_addr(wire1),.ce(rom_valid_o),.branch_addr(wire38),.branch_valid(wire37),.stall(wire51));
    if_id if_id1(.clk(clk),.rst(rst),.if_addr(wire1),.if_inst(rom_data_i),
                .id_addr(wire3),.id_inst(wire4),.flush(wire39),.stall(wire51));
    ID id1(.rst(rst),.addr(wire3),.inst(wire4),.r1data(wire5),.r2data(wire6),.ex_wreg(wire7),.ex_wvalid(wire8),.ex_wdata(wire9),
           .mem_wreg(wire10),.mem_wvalid(wire11),.mem_wdata(wire12),.ex_alusel(wire32),.r1valid(wire13),.r2valid(wire14),.r1(wire15),.r2(wire16),
           .r1addr(wire17),.r2addr(wire18),.alusel(wire19),.aluop(wire20),.wvalid(wire21),.waddr(wire22),.addr_pc(wire26),
           .branch_valid(wire37),.branch_addr(wire38),.flush_id(wire39),.stall_id(wire40),.store_imm(wire41));
    regfile regfile1(.clk(clk),.rst(rst),.r1valid(wire13),.r2valid(wire14),.r1addr(wire17),.r2addr(wire18),
                    .r1data(wire5),.r2data(wire6),.waddr(wire23),.wvalid(wire24),.wdata(wire25));
    id_ex id_ex1(.clk(clk),.rst(rst),.addr_pc(wire26),.r1(wire15),.r2(wire16),.wvalid(wire21),.waddr(wire22),
                 .alusel(wire19),.aluop(wire20),.store_imm(wire41),.stall(wire51),
                 .addr_pc_ex(wire27),.r1_ex(wire28),.r2_ex(wire29),.wvalid_ex(wire30),.waddr_ex(wire31),
                 .alusel_ex(wire32),.aluop_ex(wire33),.store_imm_ex(wire42));
    ex ex1(.clk(clk),.rst(rst),.addr_pc(wire27),.r1(wire28),.r2(wire29),.wvalid(wire30),.waddr(wire31),.alusel(wire32),.aluop(wire33),.store_imm(wire42),
           .wvalid_o(wire8),.wdata_o(wire9),.waddr_o(wire7),.mem_addr(wire43),.alusel_o(wire44),.aluop_o(wire45),.r2_o(wire46));          
    ex_mem ex_mem1(.clk(clk),.rst(rst),.waddr(wire7),.wvalid(wire8),.wdata(wire9),
                    .mem_addr(wire43),.alusel(wire44),.aluop(wire45),.r2(wire46),.stall(wire51),
                    
                    .waddr_mem(wire34),.wvalid_mem(wire35),.wdata_mem(wire36),
                    .mem_addr_o(wire47),.alusel_o(wire48),.aluop_o(wire49),.r2_o(wire50));
    mem mem1(.rst(rst),.wvalid(wire35),.wdata(wire36),.waddr(wire34),
             .mem_addr(wire47),.alusel(wire48),.aluop(wire49),.r2(wire50),.ram_data_i(ram_data_i),
             
             .wvalid_o(wire11),.waddr_o(wire10),.wdata_o(wire12),.ram_data_o(ram_store_data),
             .ram_write(ram_write),.ram_valid(ram_valid),.ram_addr(ram_addr),.ram_byte(ram_byte));
    mem_wb mem_wb1(.clk(clk),.rst(rst),.waddr(wire10),.wvalid(wire11),.wdata(wire12),.stall(wire51),
                   .wvalid_wb(wire24),.wdata_wb(wire25),.waddr_wb(wire23));     
    ctrl ctrl1(.stall_id(wire40),.stall(wire51),.rst(rst),.stall_if(stall_from_rom),.stall_mem(stall_from_ram));        
    assign rom_addr_o=wire1;
    
    
    
endmodule
