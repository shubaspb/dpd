module main(
    input   osc_p,// 300 MHz
    input   osc_n,
    input   refauxclk_n,
    input   refauxclk_p,
    output  rx_syncn,
    output  rx_syncp,
    input   sysrefn,
    input   sysrefp,
    input   tx_sync_n,
    input   tx_sync_p,
    input   reset_sw,
    input   if_sel
    );

    wire tx_sync;
    IBUFDS IBUFDS_inst5 (
      .O(tx_sync),  
      .I(tx_sync_p),
      .IB(tx_sync_n)
    ); 

    wire osc;
    IBUFDS IBUFDS_inst2 (
      .O(osc),  
      .I(osc_p),
      .IB(osc_n)
    ); 

    wire clk_main_100;
    wire pll_locked;    
    pll_main pll_main_inst
     (
        .clk_out1 (clk_main_100),
        .reset    (1'b0),
        .locked   (pll_locked),
        .clk_in1  (osc)
     ); 

    reg [31:0] cntx;
    always @(posedge clk_main_100, negedge pll_locked)
        if (!pll_locked) begin
                cntx <= 32'd0;
        end else begin
                cntx <= cntx + tx_sync;        
            end    
    assign reset_b = &cntx;  // 10 ms

    wire clk_125 = clk_main_100;
    wire dsp_pll_locked = reset_b;

    wire signed [19:0] sig_gen_i = {cntx[29:20], cntx[9:0]};
    wire signed [19:0] sig_gen_q = {cntx[9:0], cntx[19:10]};
    wire adapt_out = cntx[11];
    wire signed [19:0] sig_pa_out_i = {cntx[9:0], cntx[19:0]};
    wire signed [19:0] sig_pa_out_q = {cntx[15:6], cntx[25:16]};   
    
    wire signed [19:0] sig_out_i;
    wire signed [19:0] sig_out_q;
    dpd #(.DELAY(507)) dpd_inst(
        .clk        (clk_125),
        .reset_b    (dsp_pll_locked),
        .dpd_adapt  (adapt_out  ),
        .sig_in_i   (sig_gen_i), 
        .sig_in_q   (sig_gen_q),
        .sig_pa_i   (sig_pa_out_i),
        .sig_pa_q   (sig_pa_out_q),
        .sig_out_i  (sig_out_i),
        .sig_out_q  (sig_out_q)
    );

    reg signed [19:0] sig_all;
    always @(posedge clk_125, negedge dsp_pll_locked)
        if (!dsp_pll_locked) begin
            sig_all <= 20'd0;  
        end else begin
            sig_all <= sig_out_i + sig_out_q;  
        end
    
    wire rx_sync = ^sig_all;
    OBUFDS OBUFDS_inst4 (
      .I(rx_sync),  
      .O(rx_syncp),
      .OB(rx_syncn)
    );

endmodule





