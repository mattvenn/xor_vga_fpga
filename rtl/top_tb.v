module test;

    reg clk = 0;
    reg px_clk = 0;
    reg reset_n = 0;
    localparam DAY = 60 * 60 * 60;

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,test);
        # 4
        reset_n = 1;
        # DAY;
        $finish;
    end

    top top_0(.clk(px_clk), .reset_n(reset_n));
    always #4 clk = !clk;
    always #1 px_clk = !px_clk;

endmodule
