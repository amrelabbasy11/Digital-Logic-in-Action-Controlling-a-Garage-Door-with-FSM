module Automatic_Garage_Door_Controller(
    input wire UP_Max,  // (Sensor) becomes high when the Door is completely open.
    input wire DN_Max,  // (Sensor) becomes high when the Door is completely closed.
    input wire Activate, 
    input wire CLK,
    input wire RST,
    output reg UP_M,   // Output -> up motor
    output reg DN_M    // Output -> down motor
);

// State definitions
localparam IDLE_state = 0, Mv_UP = 1, Mv_DOWN = 2;
reg [1:0] current_state, next_state;

// The First Always Block (State Transition)
always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        current_state <= IDLE_state;   // Reset state to IDLE when reset is low
    end else begin
        current_state <= next_state;   // Update to next state
    end
end 

// The Second Always Block (Next State Logic)
always @(*) begin
    case (current_state)
        IDLE_state: begin
            if (Activate && !UP_Max) begin
                next_state = Mv_UP;
            end else if (Activate && !DN_Max) begin
                next_state = Mv_DOWN;
            end else begin
                next_state = IDLE_state;
            end
        end

        Mv_UP: begin
            if (UP_Max) begin
                next_state = IDLE_state;
            end else begin
                next_state = Mv_UP;
            end
        end

        Mv_DOWN: begin
            if (DN_Max) begin
                next_state = IDLE_state;
            end else begin
                next_state = Mv_DOWN;
            end
        end

        default: next_state = IDLE_state;
    endcase
end

// The Third Always Block (Output Logic)
always @(*) begin
    case (current_state)
        Mv_UP: begin
            UP_M = 1;   // Activate UP motor
            DN_M = 0;   // Deactivate DOWN motor
        end
        Mv_DOWN: begin
            UP_M = 0;   // Deactivate UP motor
            DN_M = 1;   // Activate DOWN motor
        end
        default: begin
            UP_M = 0;   // Deactivate UP motor
            DN_M = 0;   // Deactivate DOWN motor
        end
    endcase
end

endmodule
