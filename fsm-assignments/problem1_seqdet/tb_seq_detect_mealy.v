module tb_seq_detect_mealy;
    reg clk, rst, din;
    wire y;

  
    seq_detect_mealy dut (.clk(clk), .rst(rst), .din(din), .y(y));

    // Clock generation (100MHz -> 10ns period)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_seq_detect_mealy);

        // Initialize
        clk = 0; rst = 1; din = 0;
        #10; 
        rst = 0;

        // Test input stream: 11011011101
        repeat (1) begin
            din = 1; #10;
            din = 1; #10;
            din = 0; #10;
            din = 1; #10;
            din = 1; #10;
            din = 0; #10;
            din = 1; #10;
            din = 1; #10;
            din = 1; #10;
            din = 0; #10;
            din = 1; #10;
        end

        #20 $finish;
    end
endmodule
