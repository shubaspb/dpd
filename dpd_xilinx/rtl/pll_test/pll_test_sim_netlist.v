// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Thu Feb 18 13:22:24 2021
// Host        : yayushin-pc running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode funcsim D:/WORK/afe7700_xilinx/rtl/pll_test/pll_test_sim_netlist.v
// Design      : pll_test
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu9eg-ffvb1156-2-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* NotValidForBitStream *)
module pll_test
   (clk_out1,
    reset,
    locked,
    clk_in1);
  output clk_out1;
  input reset;
  output locked;
  input clk_in1;

  (* IBUF_LOW_PWR *) wire clk_in1;
  wire clk_out1;
  wire locked;
  wire reset;

  pll_test_pll_test_clk_wiz inst
       (.clk_in1(clk_in1),
        .clk_out1(clk_out1),
        .locked(locked),
        .reset(reset));
endmodule

(* ORIG_REF_NAME = "pll_test_clk_wiz" *) 
module pll_test_pll_test_clk_wiz
   (clk_out1,
    reset,
    locked,
    clk_in1);
  output clk_out1;
  input reset;
  output locked;
  input clk_in1;

  wire clk_in1;
  wire clk_in1_pll_test;
  wire clk_out1;
  wire clk_out1_pll_test;
  wire locked;
  wire reset;
  wire NLW_plle4_adv_inst_CLKFBIN_UNCONNECTED;
  wire NLW_plle4_adv_inst_CLKFBOUT_UNCONNECTED;
  wire NLW_plle4_adv_inst_CLKOUT0B_UNCONNECTED;
  wire NLW_plle4_adv_inst_CLKOUT1_UNCONNECTED;
  wire NLW_plle4_adv_inst_CLKOUT1B_UNCONNECTED;
  wire NLW_plle4_adv_inst_CLKOUTPHY_UNCONNECTED;
  wire NLW_plle4_adv_inst_DRDY_UNCONNECTED;
  wire [15:0]NLW_plle4_adv_inst_DO_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* CAPACITANCE = "DONT_CARE" *) 
  (* IBUF_DELAY_VALUE = "0" *) 
  (* IFD_DELAY_VALUE = "AUTO" *) 
  IBUF #(
    .IOSTANDARD("DEFAULT")) 
    clkin1_ibuf
       (.I(clk_in1),
        .O(clk_in1_pll_test));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* XILINX_LEGACY_PRIM = "BUFG" *) 
  BUFGCE #(
    .CE_TYPE("ASYNC"),
    .SIM_DEVICE("ULTRASCALE_PLUS")) 
    clkout1_buf
       (.CE(1'b1),
        .I(clk_out1_pll_test),
        .O(clk_out1));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "MLO" *) 
  PLLE4_ADV #(
    .CLKFBOUT_MULT(6),
    .CLKFBOUT_PHASE(0.000000),
    .CLKIN_PERIOD(8.000000),
    .CLKOUT0_DIVIDE(30),
    .CLKOUT0_DUTY_CYCLE(0.500000),
    .CLKOUT0_PHASE(0.000000),
    .CLKOUT1_DIVIDE(1),
    .CLKOUT1_DUTY_CYCLE(0.500000),
    .CLKOUT1_PHASE(0.000000),
    .CLKOUTPHY_MODE("VCO_2X"),
    .COMPENSATION("INTERNAL"),
    .DIVCLK_DIVIDE(1),
    .IS_CLKFBIN_INVERTED(1'b0),
    .IS_CLKIN_INVERTED(1'b0),
    .IS_PWRDWN_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b0),
    .REF_JITTER(0.010000),
    .STARTUP_WAIT("FALSE")) 
    plle4_adv_inst
       (.CLKFBIN(NLW_plle4_adv_inst_CLKFBIN_UNCONNECTED),
        .CLKFBOUT(NLW_plle4_adv_inst_CLKFBOUT_UNCONNECTED),
        .CLKIN(clk_in1_pll_test),
        .CLKOUT0(clk_out1_pll_test),
        .CLKOUT0B(NLW_plle4_adv_inst_CLKOUT0B_UNCONNECTED),
        .CLKOUT1(NLW_plle4_adv_inst_CLKOUT1_UNCONNECTED),
        .CLKOUT1B(NLW_plle4_adv_inst_CLKOUT1B_UNCONNECTED),
        .CLKOUTPHY(NLW_plle4_adv_inst_CLKOUTPHY_UNCONNECTED),
        .CLKOUTPHYEN(1'b0),
        .DADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DCLK(1'b0),
        .DEN(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DO(NLW_plle4_adv_inst_DO_UNCONNECTED[15:0]),
        .DRDY(NLW_plle4_adv_inst_DRDY_UNCONNECTED),
        .DWE(1'b0),
        .LOCKED(locked),
        .PWRDWN(1'b0),
        .RST(reset));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
