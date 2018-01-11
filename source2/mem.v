`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/28 03:06:09
// Design Name: 
// Module Name: mem
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


module mem(
    input wire rst,
    input wire wvalid,
    input wire[31:0] wdata,
    input wire[4:0] waddr,
    input wire[31:0] mem_addr,
    input wire[2:0] alusel,
    input wire[6:0] aluop,
    input wire[31:0] r2,
    input wire[31:0] ram_data_i, 
    output reg wvalid_o,
    output reg[31:0] wdata_o,
    output reg[4:0] waddr_o,
    output reg[31:0] ram_addr,
    output reg ram_write,
    output reg[3:0] ram_byte,
    output reg ram_valid,
    output reg[31:0] ram_data_o
    );
    always @(*) begin
        if (rst==`avail) begin
            wvalid_o<=`unavail;
            wdata_o<=`zeroword;
            waddr_o<=`zeroreg;
            ram_addr<=`zeroword;
            ram_write<=`unavail;
            ram_byte<=4'b0000;
            ram_valid<=`unavail;
            ram_data_o<=`zeroword;
        end
        else if(alusel==`load)begin
            wvalid_o<=wvalid;
            waddr_o<=waddr;
            ram_addr<=mem_addr;
            ram_write<=`unavail;
            ram_valid<=`avail;
            ram_data_o<=`zeroword;
            case (aluop)
                `op_lw:begin
                    ram_byte<=4'b1111;
                    wdata_o<=ram_data_i;
                 end
                `op_lh:begin
                    ram_byte<=4'b0011;
                    wdata_o<={{16{ram_data_i[15]}},ram_data_i[15:0]};
                 end
                `op_lb:begin
                    ram_byte<=4'b0001;
                    wdata_o<={{24{ram_data_i[7]}},ram_data_i[7:0]};
                 end 
                `op_lhu:begin
                     ram_byte<=4'b0011;
                     wdata_o<={{16'b0},ram_data_i[15:0]};
                  end
                 `op_lbu:begin
                     ram_byte<=4'b0001;
                     wdata_o<={{24'b0},ram_data_i[7:0]};
                  end                  
            endcase
         end
        else if(alusel==`store) begin
            wvalid_o<=wvalid;
            waddr_o<=waddr;
            wdata_o<=wdata;
            ram_addr<=mem_addr;
            ram_write<=`avail;
            ram_valid<=`avail;
            ram_data_o<=r2;   
            case(aluop)
                `op_sw:
                    ram_byte<=4'b1111;
                `op_sh:
                    ram_byte<=4'b0011;
                `op_sb:
                    ram_byte<=4'b0001;
            endcase                      
        end
        else begin
              wvalid_o<=wvalid;
              waddr_o<=waddr;
              wdata_o<=wdata;
              ram_addr<=`zeroword;
              ram_write<=`unavail;
              ram_valid<=`unavail;
              ram_data_o<=`zeroword;   
              ram_byte<=4'b0000;
        end
    end
    always @(*) begin
        if(alusel==`store)
            $display("store:%h\n",mem_addr);
        if(alusel==`store && mem_addr==32'h00000104) begin
            $display("%c\n",r2);
        end
    end
endmodule
