
module mag_complex_stage
    #(parameter NUM_STAGE = 0)
    (
    input       clk,
    input  s24  i_in,
    input  s24  q_in,
    output s24  i_out,
    output s24  q_out
    );

    s24 i_shift;
    s24 q_shift;
    always_comb begin
        i_shift = { {(NUM_STAGE){i_in[23]}}, i_in[23:NUM_STAGE] };
        q_shift = { {(NUM_STAGE){q_in[23]}}, q_in[23:NUM_STAGE] };
    end

    always_ff @(posedge clk)
        begin
            if (q_in[23]) begin
                i_out <= i_in - q_shift;
                q_out <= q_in + i_shift;
            end else begin
                i_out <= i_in + q_shift;
                q_out <= q_in - i_shift;
            end
        end
    
endmodule