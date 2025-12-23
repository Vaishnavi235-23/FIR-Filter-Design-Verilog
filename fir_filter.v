// Code your design here
// -------------------------------------------------------------
// 8-TAP MOVING AVERAGE FIR FILTER
// Verilog RTL Design (EDA Playground Ready)
// -------------------------------------------------------------
`timescale 1ns/1ps

module fir_filter (
    input  wire clk,
    input  wire rst_n,
    input  wire signed [15:0] x_in,
    output reg  signed [15:0] y_out
);

    // 8-sample shift register
    reg signed [15:0] s [0:7];
    integer i;

    // 19-bit accumulator: 16-bit × 8 additions (safe)
    reg signed [18:0] acc;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1)
                s[i] <= 0;

            y_out <= 0;
            acc   <= 0;
        end

        else begin
            // shift register
            for (i = 7; i > 0; i = i - 1)
                s[i] <= s[i-1];
            s[0] <= x_in;

            // accumulate all taps
            acc <= s[0] + s[1] + s[2] + s[3] +
                   s[4] + s[5] + s[6] + s[7];

            // Moving average: divide by 8 → shift right 3
            y_out <= acc >>> 3;
        end
    end

endmodule
