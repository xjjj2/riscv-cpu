`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/25 00:55:28
// Design Name: 
// Module Name: ex
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

module ex(
    input wire clk,
    input wire rst,
    input wire [31:0] addr_pc, 
//    input wire [6:0] func7,
//    input wire [2:0] func3,
//    input wire [6:0] opcode,
    input wire [31:0] r1,
    input wire [31:0] r2,
    input wire wvalid,
    input wire [4:0] waddr,
    input wire [2:0] alusel,
    input wire [6:0] aluop,
    input wire [31:0]store_imm,
    output reg wvalid_o,
    output reg[4:0] waddr_o,
    output reg[31:0] wdata_o,
    output reg[31:0] mem_addr,
    output reg[2:0] alusel_o,
    output reg[6:0] aluop_o,
    output reg[31:0] r2_o
//    output reg branch_valid,
//    output reg [31:0] branch_addr,
//    output reg flush_id
    );
    reg [31:0]logicout;
    reg [31:0]mathout;
    reg [31:0]shiftout;
    reg [31:0]branchout;
    always @(*) begin
        if (rst==`avail) begin
            wvalid_o<=`unavail;
            waddr_o<=`zeroreg;
            aluop_o<=`op_nop;
            alusel_o<=`nop;
            r2_o<=`zeroword;
        end
        else begin
            waddr_o<=waddr;
            wvalid_o<=wvalid;
            aluop_o<=aluop;
            alusel_o<=alusel;    
            r2_o<=r2;       
        end
    end
    
    //dataselect
    always @(*) begin
        if (rst==`avail) begin
             wdata_o<=`zeroword;
             mem_addr<=`zeroword;
        end 
        else begin
            case (alusel)
                `nop:
                    wdata_o<=`zeroword;
                `math:
                    wdata_o<=mathout;
                `shift:
                    wdata_o<=shiftout;
                `logic:
                    wdata_o<=logicout; 
                `j:
                    wdata_o<=branchout;
                 default:
                    wdata_o<=`zeroword;
            endcase
        end
     end   
    
    //logic
    always @(*) begin
        if (rst==`avail) begin
            logicout<=`zeroword;
        end
        else begin
            case (aluop)
                `op_and:
                    logicout<=r1 & r2;
                `op_or:
                    logicout<=r1 | r2;
                `op_xor:
                    logicout<=r1 ^ r2;
                 default:
                    logicout<=`zeroword;
            endcase
         end
    end
    
    //shift
    always @(*) begin
        if (rst==`avail) begin
             shiftout<=`zeroword;
        end
        else begin
            case (aluop)
                `op_sll:
                    shiftout<= (r1)<<(r2[4:0]);
                `op_slr:
                    shiftout<= (r1)>>(r2[4:0]);
                `op_sar:
                    shiftout<= ({32{r1[31]}}<<(5'd32-r2[4:0])) | (r1>>r2[4:0]);
                default:
                    shiftout<=`zeroword;             
            endcase
        end
    end
   
    //math
    wire [31:0] r2_mux;
    wire [31:0] r_sum;
    wire [31:0] r_lt;
    assign r2_mux=((aluop==`op_sub)||(aluop==`op_slt))?((~r2)+1):r2;
    assign r_sum=r1+r2_mux;
    assign r_lt=(aluop==`op_slt)?((r1[31] && !r2[31])||(r1[31] && r2[31] && r_sum[31])||(!r1[31] && !r2[31] && r_sum[31]))
                :(r1<r2);
    always @(*) begin
        if (rst==`avail) begin
            mathout<=`zeroword;
        end
        else begin
            case (aluop) 
                `op_slt,`op_sltu:
                    mathout<=r_lt;
                `op_add,`op_sub:
                    mathout<=r_sum;
                default:
                    mathout<=`zeroword;
            endcase 
        end
    end
    
    //j
    always @(*) begin
        if (rst==`avail) begin
              branchout<=`zeroword;
        end
        else begin
            case(aluop)
                `op_jal,`op_jalr:
                    branchout<=addr_pc+4;
                default:
                    branchout<=`zeroword;
            endcase
        end
    end
    
    //mem_addr
    always @(*) begin
        if (rst==`avail) begin
            mem_addr<=`zeroword;
        end
        else begin
            case (alusel)
                `load:
                    mem_addr<=r1+r2;
                `store:
                    mem_addr<=r1+store_imm;
            endcase
        end
    end
    
endmodule
