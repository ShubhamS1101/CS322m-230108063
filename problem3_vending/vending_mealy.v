module vending_mealy(
    input wire clk,
    input wire rst,       // synchronous, active-high
    input wire [1:0] coin, // 01=5, 10=10, 00=idle
    output reg dispense,  // 1-cycle pulse
    output reg chg5       // 1-cycle pulse
);

    // State encoding
    parameter S0=2'd0, S5=2'd1, S10=2'd2, S15=2'd3;
    reg [1:0] state, next_state;

    // Next-state logic and Mealy outputs
    always @(*) begin
        dispense = 0;
        chg5 = 0;
        case(state)
            S0: case(coin)
                    2'b01: next_state = S5;
                    2'b10: next_state = S10;
                    default: next_state = S0;
                 endcase
            S5: case(coin)
                    2'b01: next_state = S10;
                    2'b10: next_state = S15;
                    default: next_state = S5;
                 endcase
            S10: case(coin)
                    2'b01: next_state = S15;
                    2'b10: begin
                        next_state = S0;
                        dispense = 1;
                    end
                    default: next_state = S10;
                 endcase
            S15: case(coin)
                    2'b01: begin
                        next_state = S0;
                        dispense = 1;
                    end
                    2'b10: begin
                        next_state = S0;
                        dispense = 1;
                        chg5 = 1;
                    end
                    default: next_state = S15;
                 endcase
            default: next_state = S0;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if(rst)
            state <= S0;
        else
            state <= next_state;
    end

endmodule
