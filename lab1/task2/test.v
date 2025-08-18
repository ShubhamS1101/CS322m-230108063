`timescale 1ns/1ps

module tb;

    reg [3:0] A, B;
    wire equal;

    comparator_4bit_eq uut (
        .A(A),
        .B(B),
        .equal(equal)
    );

    initial begin
        $dumpfile("comparator_4bit_eq.vcd");
        $dumpvars(0, tb);

        $display("   A    B   | equal");
        A = 4'b0000; B = 4'b0000; #10; $display("%b %b |   %b", A, B, equal);
        A = 4'b1010; B = 4'b1010; #10; $display("%b %b |   %b", A, B, equal);
        A = 4'b1111; B = 4'b1110; #10; $display("%b %b |   %b", A, B, equal);
        A = 4'b1001; B = 4'b0110; #10; $display("%b %b |   %b", A, B, equal);

        $finish;
    end

endmodule
