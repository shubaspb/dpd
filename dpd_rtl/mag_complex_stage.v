
module mag_complex_stage
    #(parameter NUM_STAGE = 0)  // number of stage rotate
    (
    input             reset_b,  // reset
    input             clk,      // clock
    input      [23:0] i_in,     // real part for current stage 
    input      [23:0] q_in,     // image part for current stage     
    output reg [23:0] i_out,    // real part for next stage  
    output reg [23:0] q_out     // image part for next stage    
    );
    
    wire [23:0] i_shift = { {(NUM_STAGE){i_in[23]}}, i_in[23:NUM_STAGE] };          
    wire [23:0] q_shift = { {(NUM_STAGE){q_in[23]}}, q_in[23:NUM_STAGE] };    
    wire neg_imag = q_in[23];       

    always @(posedge clk, negedge reset_b)
        if (~reset_b) begin
            i_out    <= 24'd0;    
            q_out    <= 24'd0;      
        end else begin
            if (neg_imag) begin
                i_out    <= i_in - q_shift;    
                q_out    <= q_in + i_shift;    
            end else begin
                i_out    <= i_in + q_shift;    
                q_out    <= q_in - i_shift;             
            end
        end
        
        
    
endmodule








