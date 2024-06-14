`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description 1.0: This is the new architect of Toom Cook-3 for fused multiply and add, especially for merged floating and fixed data. Furthermore, the advanced shifting algorithm has accelerated the entire design. 
// Notes 1.0: The output of first stage is the sum and carry.
//////////////////////////////////////////////////////////////////////////////////

module Simple_Arc (
    input  [10:0] U_IN,
    input  [10:0] V_IN,
    output [21:0] Result
);

    // Internal variables
    wire [3:0] U0, U1, U2, V0, V1, V2;
    wire [5:0] A, B, C, D, E//WB0, WB1, WB2, WBm1, WBinf;
    wire [21:0] t1, t2, tm1, dU1, dV1;
    integer k, r, ss;

    // Extract slices
    assign U2 = U_IN[10:8];
    assign U1 = U_IN[7:4];
    assign U0 = U_IN[3:0];
    assign V2 = V_IN[10:8];
    assign V1 = V_IN[7:4];
    assign V0 = V_IN[3:0];

    // Perform Toom-Cook 3-way multiplication
    assign dU1 = U2 + U0;
    assign dV1 = V2 + V0;
    assign A   = U0 * V0;
    assign D = (dU1 - U1) * (dV1 - V1);
    assign dU1 = dU1 + U1;
    assign dV1 = dV1 + V1 ;
    assign B = dU1 * dV1;
    assign C = (((dU1 + U2) << 1) - U0) * ((dV1 + V2) << 1 - V0);
    assign E = U2 * V2;

    // Exact division by 2 and 3
    assign t2 = (C - D) / 3;
    assign tm1 = (B - D) >> 1;
    assign t1 = B - A;
    assign t2 = (t2 - t1) >> 1 - (E << 1);
    /*assign t1 = t1 - tm1 - E;
    assign tm1 = tm1 - t2;*/
    assign t1 = t1 - tm1;

    assign t2 = E * 16 + t2;
    assign tm1 = t1 * 16 + tm1;
    assign tm1 = tm1 - t2;

    assign Result = t2 * (16^3) + tm1 * 16 + t1;


endmodule