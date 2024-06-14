`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description 1.0: This is the new architect of Toom Cook-3 for fused multiply and add, especially for merged floating and fixed data. Furthermore, the advanced shifting algorithm has accelerated the entire design. 
// Notes 1.0: The output of first stage is the sum and carry.
//////////////////////////////////////////////////////////////////////////////////


module Simple_Arc(
    input [255:0] a,
    input [255:0] b,
    output [511:0] result
);

    // 将输入a和b分成3个部分
    wire [63:0] a0, a1, a2;
    wire [63:0] b0, b1, b2;
    assign {a2, a1, a0} = a;
    assign {b2, b1, b0} = b;

    // 计算中间结果
    wire [127:0] v0, v1, v2, vm1, vinf;
    wire [127:0] da1, db1, t1, t2, tm1;

    assign v0 = a0 * b0;
    assign da1 = a2 + a0;
    assign db1 = b2 + b0;
    assign vm1 = (da1 - a1) * (db1 - b1);
    assign da1 = da1 + a1;
    assign db1 = db1 + b1;
    assign v1 = da1 * db1;
    assign v2 = (da1 + a2) << 1 - a0 * (db1 + b2 << 1 - b0);
    assign vinf = a2 * b2;

    // 执行除法操作
    assign t2 = (v2 - vm1) / 3;
    assign tm1 = (v1 - vm1) >> 1;
    assign t1 = v1 - v0;
    assign t2 = (t2 - t1) >> 1;
    assign t1 = t1 - tm1 - vinf;
    assign t2 = t2 - (vinf << 1);
    assign tm1 = tm1 - t2;

    // 组合最终结果
    assign result = {vinf << (3*64), t2 << (2*64), t1 << 64, tm1, v0};

endmodule
