`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description 1.0: This is the new architect of Toom Cook-3 for fused multiply and add, especially for merged floating and fixed data. Furthermore, the advanced shifting algorithm has accelerated the entire design. 
// Notes 8.0: The output of first stage is the sum and carry.
//////////////////////////////////////////////////////////////////////////////////


module FMA_Top
(
    input clk,
    input rst_n,
    input  [15:0] A_input, B_input,
    input  [31:0] M_input,
    input         float,
    output [31:0] out
);



    wire [22:0] fraction_ss_out;
    wire [22:0] fraction_cc_out;
    wire [5:0] exponent_Ans_out;
    wire [7:0] shift_s_out;
    wire [24:0] fra_M_out;
    wire sign_M_out;
    wire sign1_out,flag_S_out,stick_out, guard_bit_out;
    
    
    Top_Merged_Multi Top_Merged_Multi_inst (
        .float(float),
        .A_input(A_input),
        .B_input(B_input),
        .M_input(M_input),
        .fraction_ss_out(fraction_ss_out),
        .fraction_cc_out(fraction_cc_out),
        .exponent_Ans_out(exponent_Ans_out),
        .shift_s_out(shift_s_out),
        .fra_M_out(fra_M_out),
        .sign_M_out(sign_M_out),
        .sign1_out(sign1_out),
        .flag_S_out(flag_S_out),
        .stick_out(stick_out),
        .guard_bit_out(guard_bit_out)
    );
    reg [31:0] M_d1;
    reg [22:0] fraction_ss_out_d1;
    reg [22:0] fraction_cc_out_d1;
    reg [5:0] exponent_Ans_out_d1;
    reg [7:0] shift_s_out_d1;
    reg [24:0] fra_M_out_d1;
    reg sign_M_out_d1;
    reg sign1_out_d1;
    reg float_d1;
    reg flag_S_out_d1;
    reg stick_out_d1;
    reg guard_bit_out_d1;
    wire [31:0]fraction_M_out_d1;
    wire stick2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            M_d1 <= 32'b0;
            fraction_ss_out_d1 <= 23'b0;
            fraction_cc_out_d1 <= 23'b0;
            exponent_Ans_out_d1 <= 5'b0;
            shift_s_out_d1 <= 8'b0;
            fra_M_out_d1 <= 67'b0;
            sign_M_out_d1 <= 1'b0;
            sign1_out_d1 <= 1'b0;
            float_d1<=1'b0;
            flag_S_out_d1 <= 1'b0;
            stick_out_d1 <= 1'b0;
            guard_bit_out_d1 <= 1'b0;
        end
        else begin
            M_d1 <= M_input;
            fraction_ss_out_d1 <= fraction_ss_out;
            fraction_cc_out_d1 <= fraction_cc_out;
            exponent_Ans_out_d1 <= exponent_Ans_out;
            shift_s_out_d1 <= shift_s_out;
            fra_M_out_d1 <= fra_M_out;
            sign_M_out_d1 <= sign_M_out;
            sign1_out_d1 <= sign1_out;
            float_d1<=float;
            flag_S_out_d1 <= flag_S_out;
            stick_out_d1 <= stick_out;
            guard_bit_out_d1 <= guard_bit_out;
        end
    end

    //Level 2
    FMA_add_sc FMA_add_sc_inst (
        .fraction_ss_out(fraction_ss_out_d1),
        .fraction_cc_out(fraction_cc_out_d1),
        .float(float_d1),
        .sign1(sign1_out_d1),
        .sign_M(sign_M_out_d1),
        .exponent(exponent_Ans_out_d1),
        .shift_s(shift_s_out_d1),
        .flag_S_out_d1(flag_S_out_d1),
        .fraction_M_out(fraction_M_out_d1),
        .stick2(stick2)
    );
    wire [66:0] fraction_Ans;
    wire [7:0] exponent_Ans;
    wire [7:0] exponent_1_d1;
    wire [7:0] exponent_2_d1;
    wire sign_1_d1;
    wire sign_2_d1;
    wire inf_1_d1;
    wire inf_2_d1;
    wire nan_1_d1;
    wire nan_2_d1;
    wire sign_Ans_d1;
    wire [31:0] outFixed;

    fpadder_pre u_fpadder_pre (
        .src1(M_d1),
        .src2(fraction_M_out_d1),
        .float(float_d1),
        .fraction_Ans(fraction_Ans),
        .exponent_Ans(exponent_Ans),
        .exponent_1(exponent_1_d1),
        .exponent_2(exponent_2_d1),
        .sign_1(sign_1_d1),
        .sign_2(sign_2_d1),
        .inf_1(inf_1_d1),
        .inf_2(inf_2_d1),
        .nan_1(nan_1_d1),
        .nan_2(nan_2_d1),
        .sign_Ans(sign_Ans_d1),
        .outFixed(outFixed)
    );

    reg [24:0] fraction_Ans_d2;
    reg [7:0] exponent_Ans_d2;
    reg sign_Ans_d2;
    reg [7:0] exponent_1_d2;
    reg [7:0] exponent_2_d2;
    reg sign_1_d2;
    reg sign_2_d2;
    reg inf_1_d2;
    reg inf_2_d2;
    reg nan_1_d2;
    reg nan_2_d2;
    reg float_d2, stick_d2;
    reg [31:0] outFixed_reg;

    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            fraction_Ans_d2 <= 0;
            exponent_Ans_d2 <= 0;
            sign_Ans_d2     <= 0;
            exponent_1_d2   <= 0;
            exponent_2_d2   <= 0;
            sign_1_d2       <= 0;
            sign_2_d2       <= 0;
            inf_1_d2        <= 0;
            inf_2_d2        <= 0;
            nan_1_d2        <= 0;
            nan_2_d2        <= 0;
            float_d2        <= 0;
            outFixed_reg    <= 0;
        end
        else begin
            fraction_Ans_d2 <= fraction_Ans;
            exponent_Ans_d2 <= exponent_Ans;
            sign_Ans_d2     <= sign_Ans_d1;
            exponent_1_d2   <= exponent_1_d1;
            exponent_2_d2   <= exponent_2_d1;
            sign_1_d2       <= sign_1_d1;
            sign_2_d2       <= sign_2_d1;
            inf_1_d2        <= inf_1_d1;
            inf_2_d2        <= inf_2_d1;
            nan_1_d2        <= nan_1_d1;
            nan_2_d2        <= nan_2_d1;
            float_d2        <= float_d1;
            outFixed_reg    <= outFixed;
            stick_d2        <= stick2^stick_out_d1;
        end
    end

    // Level 3

    fpadder_post u_fpadder_post (
        .fraction_Ans(fraction_Ans_d2),
        .exponent_Ans(exponent_Ans_d2),
        .sign_Ans(sign_Ans_d2),
        .exponent_1(exponent_1_d2),
        .exponent_2(exponent_2_d2),
        .sign_1(sign_1_d2),
        .sign_2(sign_2_d2),
        .inf_1(inf_1_d2),
        .inf_2(inf_2_d2),
        .nan_1(nan_1_d2),
        .nan_2(nan_2_d2),
        .float(float_d2),
        .outFixed(outFixed_reg),
        .out(out),
        .guard_bit(guard_bit_out_d1),
        .stick(stick_d2)
    );
endmodule
