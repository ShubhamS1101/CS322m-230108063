module comparator_4bit_eq(
    input wire [3:0] A,
    input wire [3:0] B,
    output wire equal
);

assign equal = (A == B);

endmodule
