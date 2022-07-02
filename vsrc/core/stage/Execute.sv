`include "vsrc/include/width_param.sv"
`include "vsrc/include/opreation.sv"

module Execute(
    //stage info
    id_stage_if.i id_info,
    ex_stage_if.o ex_info
);

    wire [`ALU_OP_WIDTH - 1 : 0] alu_op;//TODO
    wire [`DATA_WIDTH - 1 : 0 ]alu_res;
    wire cout;
    ALU alu_0 (
    .op(alu_op),
    .oprand1(id_info.oprand1),
    .oprand2(id_info.oprand2),
    .result(alu_res)
    );
    assign ex_info.inst = id_info.inst;
    assign ex_info.inst = id_info.pc;
    assign ex_info.lsu_data = id_info.lsu_data;
    assign ex_info.lsu_op = id_info.lsu_op;
    assign ex_info.rw_en = id_info.rw_en;
    assign ex_info.rw_addr = id_info.rw_addr;
    assign ex_info.ex_result = alu_res;//TODO
endmodule

module ALU(
    input [`ALU_OP_WIDTH-1:0] op,
    input [`DATA_WIDTH - 1 : 0] oprand1,
    input [`DATA_WIDTH - 1 : 0] oprand2,
    output logic [`DATA_WIDTH - 1 : 0] result
);
    wire signed [31:0] temp_oper;   //带符号数的临时变量
    assign temp_oper = operand1;    //方便后面对alu_src1进行算数右移
    always_comb begin:ALU
        case (op)
            `ALU_ADD_W   : {cout,result} = oprand1 + oprand2;
            `ALU_SUB_W   : {cout,result} = oprand1 + ~oprand2 + 1;
            `ALU_AND     : result = oprand1 & oprand2;//and
            `ALU_OR      : result = oprand1 | oprand2;//or
            `ALU_XOR     : result = oprand1 ^ oprand2;//xor
            `ALU_NOR     : result = ~(oprand1|oprand2);//nor
            `ALU_SLL_W   : result = oprand1 << oprand2;//sll.w
            `ALU_SRL_W   : result = oprand1 >> oprand2;//srl.w
            `ALU_SRA_W   : result = temp_oper >>> oprand2;//sra.w
            `ALU_SLT     : result = alu_res[31] ? 1'b1 : 1'b0;//slt
            `ALU_SLTU    : result = cout ? 1'b0 : 1'b1;//sltu
            `ALU_MUL_W   : result = oprand1 * oprand2;
            `ALU_MULH_W  : result = oprand1 * oprand2;
            `ALU_MULH_WU : result = oprand1 * oprand2;
            `ALU_DIV_W   : result = oprand1 / oprand2;
            `ALU_DIV_WU  : result = oprand1 / oprand2;
            `ALU_MOD_W   : result = oprand1 % oprand2;
            `ALU_MOD_WU  : result = oprand1 % oprand2;
        default:
                result = 0;
        endcase
    end
endmodule