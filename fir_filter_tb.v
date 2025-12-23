// Code your testbench here
// or browse Examples
// -------------------------------------------------------------
// TESTBENCH FOR FIR FILTER
// -------------------------------------------------------------
`timescale 1ns/1ps

module tb_fir_filter;

    reg clk;
    reg rst_n;
    reg signed [15:0] x_in;
    wire signed [15:0] y_out;

    // DUT Instantiation
    fir_filter dut (
        .clk(clk),
        .rst_n(rst_n),
        .x_in(x_in),
        .y_out(y_out)
    );

    // Clock Generation: 10 ns (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Waveform dump (for GTKWave)
    initial begin
        $dumpfile("fir.vcd");
        $dumpvars(0, tb_fir_filter);
    end

    integer k;

    initial begin
        rst_n = 0;
        x_in  = 0;
        #20;
        rst_n = 1;

        // -----------------------
        // 1) IMPULSE INPUT
        // -----------------------
        @(posedge clk);
        x_in <= 16'd20000;   // impulse
        @(posedge clk);
        x_in <= 0;

        // wait to observe impulse response
        repeat(10) @(posedge clk);

        // -----------------------
        // 2) STEP INPUT
        // -----------------------
        for (k = 0; k < 16; k = k + 1) begin
            x_in <= 16'd10000;
            @(posedge clk);
        end

        x_in <= 0;
        repeat(10) @(posedge clk);

        // Finish
        $display("Simulation Finished.");
        $finish;
    end

endmodule
