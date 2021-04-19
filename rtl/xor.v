`default_nettype none
module xor_vga (
    input wire clk, 
    input wire reset_n,
    input wire but1,
    input wire but2,
    input wire but3,
    output wire hsync,
    output wire vsync,
    output wire [5:0] rrggbb
    );

    wire reset = !reset_n;

    wire [9:0] x_px;          // X position for actual pixel.
    wire [9:0] y_px;          // Y position for actual pixel.

    // the magic
    assign rrggbb = ((x_px ^ y_px) % 10'd9) == 1 ? 6'b111111 : 6'b000000;

    // the VGA module
    wire activevideo;
    wire px_clk;
    assign px_clk = clk;
    VgaSyncGen vga_0 (.px_clk(px_clk), .hsync(hsync), .vsync(vsync), .x_px(x_px), .y_px(y_px), .activevideo(activevideo), .reset(reset));

endmodule
`default_nettype wire
