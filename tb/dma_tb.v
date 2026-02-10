`timescale 1ns/1ps
module mem_model (
    input clk,
    input mem_r_en,
    input mem_w_en,
    input [31:0] mem_addr,
    input [31:0] mem_write,
    output reg [31:0] mem_read
    );

    reg [31:0] mem [0:255];

    always @(posedge clk) begin
        if (mem_r_en)
            mem_read <= mem[mem_addr >> 2];
    end

    always @(posedge clk) begin
        if (mem_w_en)
            mem[mem_addr >> 2] <= mem_write;
    end

endmodule

module dmacontoller_tb;

    reg clk;
    reg rst;
    reg start;

    reg [31:0] src_addr;
    reg [31:0] dest_addr;
    reg [31:0] len;

    wire busy;
    wire done;

    wire [31:0] mem_addr;
    wire [31:0] mem_write;
    wire mem_r_en;
    wire mem_w_en;
    wire [31:0] mem_read;

    // clock: 10ns period
    always #5 clk = ~clk;

    // DUT
    dma dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .src_addr(src_addr),
        .dest_addr(dest_addr),
        .len(len),
        .busy(busy),
        .done(done),
        .mem_addr(mem_addr),
        .mem_write(mem_write),
        .mem_r_en(mem_r_en),
        .mem_w_en(mem_w_en),
        .mem_read(mem_read)
    );

    // Memory
    

    mem_model mem (
        .clk(clk),
        .mem_r_en(mem_r_en),
        .mem_w_en(mem_w_en),
        .mem_addr(mem_addr),
        .mem_write(mem_write),
        .mem_read(mem_read)
    );

    integer i;

    initial begin
        clk = 0;
        rst = 1;
        start = 0;

        src_addr  = 32'h0000_0000;
        dest_addr = 32'h0000_0040; // destination offset
        len = 4; // 4 words

        #20 rst = 0;

        // init source memory
        for (i = 0; i < 4; i = i + 1)
            mem.mem[i] = 32'hA0A0_0000 + i;

        #10 start = 1;
        #10 start = 0;

        wait(done);

        #20;
        $finish;
    end
    initial begin
    $dumpfile("dma.vcd");
    $dumpvars(0, dmacontoller_tb);
    end


endmodule
