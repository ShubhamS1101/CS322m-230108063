module comparator_1bit(
    input wire A,
    input wire B,
    output wire o1, // A > B
    output wire o2, // A == B
    output wire o3  // A < B
);

assign o1 = A & ~B;
assign o2 = ~(A ^ B);
assign o3 = ~A & B;

endmodule
