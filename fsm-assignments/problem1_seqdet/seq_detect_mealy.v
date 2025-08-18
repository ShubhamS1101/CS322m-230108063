module seq_detect_mealy(
    input  wire clk,
    input  wire rst,   // sync active-high reset
    input  wire din,
    output reg  y
);

    // State encoding with clear names
    parameter STATE_IDLE = 2'b00;   // no match
    parameter STATE_1    = 2'b01;   // matched "1"
    parameter STATE_11   = 2'b10;   // matched "11"
    parameter STATE_110  = 2'b11;   // matched "110"

    reg [1:0] state_present, state_next;

    // Next state logic + Mealy output
    always @(*) begin
        y = 0; // default
        case (state_present)
            STATE_IDLE: begin
                if (din) state_next = STATE_1;
                else     state_next = STATE_IDLE;
            end

            STATE_1: begin
                if (din) state_next = STATE_11;
                else     state_next = STATE_IDLE;
            end

            STATE_11: begin
                if (din) state_next = STATE_11;   // still "11"
                else     state_next = STATE_110;  // got "110"
            end

            STATE_110: begin
                if (din) begin
                    y = 1;                  // found "1101"
                    state_next = STATE_1;   // overlap (last bit = "1")
                end else begin
                    state_next = STATE_IDLE;
                end
            end

            default: state_next = STATE_IDLE;
        endcase
    end

    // State register (synchronous reset)
    always @(posedge clk) begin
        if (rst) begin
            state_present <= STATE_IDLE;
        end else begin
            state_present <= state_next;
        end
    end

endmodule
