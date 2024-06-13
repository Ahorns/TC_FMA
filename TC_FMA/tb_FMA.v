`timescale 1ns/1ps

module FMA_Top_TB;

    // Inputs
    reg clk;
    reg rst_n;
    reg [15:0] A_input;
    reg [15:0] B_input;
    reg [31:0] M_input;
    reg float;

    // Outputs
    wire [31:0] out;

    // Instantiate the module
    FMA_Top UUT (
        .clk(clk),
        .rst_n(rst_n),
        .A_input(A_input),
        .B_input(B_input),
        .M_input(M_input),
        .float(float),
        .out(out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 1;
        rst_n = 0;
        A_input = 16'h2E66; // 0.1
        B_input = 16'h2E66; // 0.1
        M_input = 32'h3DCCCCCD; // 0.1
        float = 1'b1;

        // Reset
        #28;

        rst_n = 1;

        // Wait for some time
        #40;

        // Change inputs
        A_input = 16'h3F00; // 0.5
        B_input = 16'h4000; // 2.0
        M_input = 32'h40400000; // 3.0
        float = 1'b1;

        // Wait for some time
        #20;

        // Change to fixed-point mode
        float = 1'b0;

        // Wait for some time
        #100;
        A_input = 16'h3C00; // 1.0
        B_input = 16'h3C00; // 1.0
        M_input = 32'h40800000; // 4.0
        #100;

        $finish;
    end

    // Monitor the output
    always @(posedge clk) begin
        if (rst_n)
            $display("Time: %0t, out = %0h", $time, out);
    end

endmodule