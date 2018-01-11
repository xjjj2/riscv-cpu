`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/20 20:58:21
// Design Name: 
// Module Name: ID
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
module ID(
    input wire rst,
    input wire [31:0] addr,
    input wire [31:0] inst,
    input wire [31:0] r1data,
    input wire [31:0] r2data,
    input wire [4:0] ex_wreg,
    input wire ex_wvalid,
    input wire [31:0] ex_wdata,
    input wire [4:0] mem_wreg,
    input wire mem_wvalid,
    input wire [31:0] mem_wdata,
    input wire [2:0]ex_alusel,
    output reg [31:0] addr_pc,
    output reg r1valid,
    output reg r2valid,
    output reg [4:0] r1addr,
    output reg [4:0] r2addr,
//    output reg [6:0] func7,
//    output reg [2:0] func3,
//    output reg [6:0] opcode,
    output reg [31:0] r1,
    output reg [31:0] store_imm,
    output reg [2:0] alusel,
    output reg [6:0] aluop,
    output reg [31:0] r2,
    output reg wvalid,
    output reg [4:0] waddr,
    output reg branch_valid,
    output reg [31:0] branch_addr,
    output reg flush_id,
    output wire stall_id
    );
    wire [6:0] op=inst[6:0];
    wire [6:0] f7=inst[31:25];
    wire [6:0] f3=inst[14:12];
    wire [31:0] sum;
    wire [31:0] branchadr;
    reg [31:0] imm;
    reg if_imm;
    reg stall_r1;
    reg stall_r2;
    reg if_r1_imm;
    reg r1_imm;
    assign stall_id=stall_r1|stall_r2;
    assign branchadr=addr+{{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0};
    assign sum=r1+{{20{inst[31]}},inst[31:20]};
    always @(*) begin
        if (rst==`avail) begin
            addr_pc<=`zeroword;
//            opcode<=`OP_OP_IMM;
//            func7<=`zero7;
//            func3<=`zero3;
            r2addr<=`zeroreg;
            r1addr<=`zeroreg;
            r1valid<=`unavail;
            r2valid<=`unavail;
            wvalid<=`unavail;
            waddr<=`zeroreg;
            alusel<=`nop;
            aluop<=`op_nop;
            branch_valid<=`unavail;
            branch_addr<=`zeroword;
            flush_id<=`unavail;
            store_imm<=`zeroword;
            imm<=`zeroword;
            if_imm<=`unavail;
            r1_imm<=`zeroword;
            if_r1_imm<=`unavail;
        end else begin
                   addr_pc<=addr;
//                   opcode<=op;
//                   func7<=f7;
//                   func3<=f3;
                   r2addr<=inst[24:20];
                   r1addr<=inst[19:15];
                   r1valid<=`unavail;
                   r2valid<=`unavail;
                   wvalid<=`unavail;
                   waddr<=inst[11:7];
                   branch_valid<=`unavail;
                   branch_addr<=`zeroword;
                   flush_id<=`unavail;
                   store_imm<=`zeroword;
                   imm<=`zeroword;
                   r1_imm<=`zeroword;
                   if_r1_imm<=`unavail;
        case (op)
            `OP_OP_IMM: begin
                case(f3)
                `FUNCT3_ADDI :begin
                    r1valid<=`avail;
                    imm<={{20{inst[31]}},inst[31:20]};
                    if_imm<=`avail;
                    wvalid<=`avail;
                    alusel<=`math;
                    aluop<=`op_add;
                end    
                `FUNCT3_SLTI:begin
                     r1valid<=`avail;
                     imm<={{20{inst[31]}},inst[31:20]};
                     if_imm<=`avail;
                     wvalid<=`avail;
                     alusel<=`math;
                     aluop<=`op_slt;
                end
                `FUNCT3_SLTIU:begin
                     r1valid<=`avail;
                     imm<={{20{inst[31]}},inst[31:20]};
                     if_imm<=`avail;
                     wvalid<=`avail;
                     alusel<=`math;
                     aluop<=`op_sltu;
                end
                `FUNCT3_ORI:begin                 
                    r1valid<=`avail;
                    imm<={{20{inst[31]}},inst[31:20]};
                    if_imm<=`avail;
                    wvalid<=`avail;
                    alusel<=`logic;
                    aluop<=`op_or;
                end
                `FUNCT3_XORI:begin
                    r1valid<=`avail;
                    imm<={{20{inst[31]}},inst[31:20]};
                    if_imm<=`avail;
                    wvalid<=`avail;
                    alusel<=`logic;
                    aluop<=`op_xor;
                end
                `FUNCT3_ANDI:begin
                    r1valid<=`avail;
                    imm<={{20{inst[31]}},inst[31:20]};
                    if_imm<=`avail;
                    wvalid<=`avail;
                    alusel<=`logic;
                    aluop<=`op_and;                
                end
                `FUNCT3_SLLI:begin
                     r1valid<=`avail;
                     imm<={27'b0,inst[24:20]};
                     if_imm<=`avail;
                     wvalid<=`avail;
                     alusel<=`shift;
                     aluop<=`op_sll;                                     
                end
                `FUNCT3_SRLI_SRAI:begin
                     r1valid<=`avail;
                     imm<={27'b0,inst[24:20]};
                     if_imm<=`avail;
                     wvalid<=`avail;
                     alusel<=`shift;
                     case (f7)
                        `FUNCT7_SRLI:begin
                            aluop<=`op_slr;
                         end
                        `FUNCT7_SRAI:begin
                            aluop<=`op_sar;
                         end
                     endcase                 
                end
                endcase
            end
            `OP_LUI:begin
                 r1_imm<=`zeroword;
                 if_r1_imm<=`avail;
                 imm<={inst[31:12],12'b0};
                 if_imm<=`avail;
                 wvalid<=`avail;
                 alusel<=`math;
                 aluop<=`op_add;
            end
            `OP_AUIPC:begin
                r1_imm<=addr;
                if_r1_imm<=`avail;
                imm<={inst[31:12],12'b0};
                if_imm<=`avail;
                wvalid<=`avail;
                alusel<=`math;
                aluop<=`op_add;
             end
            `OP_OP:begin
                    r1valid<=`avail;
                    r2valid<=`avail;
                    wvalid<=`avail;
                    case (f3)
                        `FUNCT3_ADD_SUB:begin
                            alusel<=`math;
                            case (f7)
                                `FUNCT7_ADD:
                                    aluop<=`op_add;
                                `FUNCT7_SUB:
                                    aluop<=`op_sub;
                            endcase
                        end
                        `FUNCT3_SLT:begin
                            alusel<=`math;
                            aluop<=`op_slt;
                        end
                        `FUNCT3_SLTU:begin
                            alusel<=`math;
                            aluop<=`op_sltu;
                        end                 
                        `FUNCT3_XOR:begin
                            alusel<=`logic;
                            aluop<=`op_xor;
                        end       
                        `FUNCT3_AND:begin
                            alusel<=`logic;
                            aluop<=`op_and;
                        end                 
                        `FUNCT3_OR:begin
                            alusel<=`logic;
                            aluop<=`op_or;
                        end                  
                        `FUNCT3_SLL:begin
                            alusel<=`shift;
                            aluop<=`op_sll;
                        end
                        `FUNCT3_SRL_SRA:begin
                            alusel<=`shift;
                            case (f7)
                                `FUNCT7_SRL:
                                     aluop<=`op_slr;
                                `FUNCT7_SRA:
                                     aluop<=`op_sar;
                            endcase
                        end                                                                      
                    endcase
             end
            `OP_JAL:begin
                wvalid<=`avail;
                aluop<=`op_jal;
                alusel<=`j;
                branch_valid<=`avail;
                branch_addr<=addr+{{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0};
                flush_id<=`avail;
//                r1<=addr;
//                r2<={{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0};
            end
            `OP_JALR:begin
                 wvalid<=`avail;
                 r1valid<=`avail;
                 aluop<=`op_jalr;
                 alusel<=`j;
                 branch_valid<=`avail;
                 branch_addr<={sum[31:1],1'b0};   
                 flush_id<=`avail;  
//                 r2<={20'b0,inst[31:20]};   
            end
            `OP_BRANCH:begin
                r1valid<=`avail;
                r2valid<=`avail;
                aluop<=`op_nop;
                alusel<=`nop;
                case (f3)
                    `FUNCT3_BEQ:
                        if (r1==r2) begin
                            branch_valid<=`avail;
                            flush_id<=`avail;
                            branch_addr<=branchadr;
                        end
                    `FUNCT3_BNE:
                        if (r1!=r2) begin
                            branch_valid<=`avail;
                            flush_id<=`avail;
                            branch_addr<=branchadr;
                        end                        
                    `FUNCT3_BLTU:
                        if (r1<r2) begin
                             branch_valid<=`avail;
                             flush_id<=`avail;
                             branch_addr<=branchadr;                       
                        end
                    `FUNCT3_BLT:
                        if($signed(r1)<$signed(r2)) begin
                            branch_valid<=`avail;
                            flush_id<=`avail;
                            branch_addr<=branchadr;                        
                        end
                    `FUNCT3_BGEU:
                        if(r1>=r2) begin
                             branch_valid<=`avail;
                             flush_id<=`avail;
                             branch_addr<=branchadr;                       
                        end
                    `FUNCT3_BGE:
                        if($signed(r1)>=$signed(r2)) begin
                               branch_valid<=`avail;
                               flush_id<=`avail;
                               branch_addr<=branchadr;                        
                        end
                endcase
            end
            `OP_LOAD:begin
                r1valid<=`avail;
                wvalid<=`avail;
                imm<={{20{inst[31]}},inst[31:20]};
                if_imm<=`avail;
                alusel<=`load;
                case (f3)
                    `FUNCT3_LW:
                        aluop<=`op_lw;
                    `FUNCT3_LH:
                        aluop<=`op_lh;
                    `FUNCT3_LB:
                        aluop<=`op_lb;
                    `FUNCT3_LHU:
                        aluop<=`op_lhu;
                    `FUNCT3_LBU:
                        aluop<=`op_lbu;
                endcase
            end
            `OP_STORE:begin
                r1valid<=`avail;
                r2valid<=`avail;
                store_imm<={{20{inst[31]}},inst[31:25],inst[11:7]};
                alusel<=`store;
                case (f3)
                     `FUNCT3_SW:
                        aluop<=`op_sw;
                     `FUNCT3_SH:
                        aluop<=`op_sh;
                     `FUNCT3_SB:
                        aluop<=`op_sb;
                 endcase                
            end
       endcase
    end
    end
    always @(*) begin
        stall_r1<=`unavail;
        if (rst==`avail) begin
            r1<=`zeroword;
        end
        else if((ex_alusel==`load)&&(r1valid==`avail)&&(r1addr==ex_wreg))begin
            stall_r1<=`avail;
        end
        else if ((r1valid==`avail)&&(r1addr==ex_wreg)&&(ex_wvalid==`avail))begin
            r1<=ex_wdata;
        end
        else if ((r1valid==`avail)&&(r1addr==mem_wreg)&&(mem_wvalid==`avail))begin
            r1<=mem_wdata;
        end
        else if (r1valid==`avail) begin
            r1<=r1data;
        end
        else if (if_r1_imm==`avail) begin
            r1<=r1_imm;
        end
    end
    always @(*) begin
            stall_r2<=`unavail;
            if (rst==`avail) begin
                r2<=`zeroword;
            end
            else if((ex_alusel==`load)&&(r2valid==`avail)&&(r2addr==ex_wreg))begin
                stall_r2<=`avail;
            end
            else if ((r2valid==`avail)&&(r2addr==ex_wreg)&&(ex_wvalid==`avail))begin
                r2<=ex_wdata;
            end
            else if ((r2valid==`avail)&&(r2addr==mem_wreg)&&(mem_wvalid==`avail))begin
                r2<=mem_wdata;
            end
            else if (r2valid==`avail) begin
                r2<=r2data;
            end
            else if (if_imm==`avail) begin 
                r2<=imm;
            end
        end
endmodule
