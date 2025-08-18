`timescale 1ns/1ps

module tb_vending_mealy;
    reg clk, rst;
    reg [1:0] coin;
    wire dispense, chg5;

    // Instantiate DUT
    vending_mealy dut(
        .clk(clk),
        .rst(rst),
        .coin(coin),
        .dispense(dispense),
        .chg5(chg5)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk; // 10 ns period

    // VCD dump
    initial begin
        $dumpfile("vending.vcd");
        $dumpvars(0, tb_vending_mealy);
    end

    // Test sequence
    initial begin
        rst = 1; coin = 2'b00;
        #10;
        rst = 0;

        coin = 2'b01; #10;
        coin = 2'b10; #10;
        coin = 2'b01; #10;
        coin = 2'b10; #10;
        coin = 2'b10; #10;
        coin = 2'b01; #10;
        coin = 2'b10; #10;

        coin = 2'b00; #20;

        $finish;
    end

endmodule
