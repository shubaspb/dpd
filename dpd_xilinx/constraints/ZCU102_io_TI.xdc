
###############################################################################
# CLOCK CONSTRAINTS
###############################################################################

# Set Reference Clock
create_clock -period 3.333 -name osc [get_ports osc_p]



###############################################################################
# IO CONSTRAINTS
###############################################################################

set_property -dict {PACKAGE_PIN AL8 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports osc_p]
set_property -dict {PACKAGE_PIN AL7 IOSTANDARD LVDS} [get_ports osc_n]

set_property PACKAGE_PIN G28 [get_ports refauxclk_n]
set_property PACKAGE_PIN G27 [get_ports refauxclk_p]


set_property -dict {PACKAGE_PIN AE3 IOSTANDARD LVDS} [get_ports rx_syncp]
set_property -dict {PACKAGE_PIN AF3 IOSTANDARD LVDS} [get_ports rx_syncn]

set_property -dict {PACKAGE_PIN AH1 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysrefp]
set_property -dict {PACKAGE_PIN AJ1 IOSTANDARD LVDS} [get_ports sysrefn]

set_property -dict {PACKAGE_PIN AD10 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_p]
set_property -dict {PACKAGE_PIN AE9 IOSTANDARD LVDS} [get_ports tx_sync_n]







set_property -dict {PACKAGE_PIN AF15 IOSTANDARD LVCMOS33} [get_ports reset_sw]
set_property -dict {PACKAGE_PIN AE14 IOSTANDARD LVCMOS33} [get_ports if_sel]










create_clock -period 4.069 -name refclk -waveform {0.000 2.034} [get_pins ibufds_refclk_c/O]
create_clock -period 4.069 -name link_clk -waveform {0.000 2.034} [get_pins refclk_bufg_gt_c/O]

set_clock_groups -name osc -asynchronous -group [get_clocks [list osc pll_main_inst/inst/clk_in1 [get_clocks -of_objects [get_pins pll_main_inst/inst/plle4_adv_inst/CLKOUT0]]]]

create_clock -period 4.069 -name refauxclk_p -waveform {0.000 2.034} [get_ports refauxclk_p]
set_input_delay -clock [get_clocks refauxclk_p] -clock_fall -min -add_delay 2.000 [get_ports sysrefn]
set_input_delay -clock [get_clocks refauxclk_p] -clock_fall -max -add_delay 2.000 [get_ports sysrefn]
set_input_delay -clock [get_clocks refauxclk_p] -clock_fall -min -add_delay 2.000 [get_ports sysrefp]
set_input_delay -clock [get_clocks refauxclk_p] -clock_fall -max -add_delay 2.000 [get_ports sysrefp]
set_input_delay -clock [get_clocks refauxclk_p] -clock_fall -min -add_delay 2.000 [get_ports tx_sync_n]
set_input_delay -clock [get_clocks refauxclk_p] -clock_fall -max -add_delay 2.000 [get_ports tx_sync_n]
set_input_delay -clock [get_clocks refauxclk_p] -clock_fall -min -add_delay 2.000 [get_ports tx_sync_p]
set_input_delay -clock [get_clocks refauxclk_p] -clock_fall -max -add_delay 2.000 [get_ports tx_sync_p]
set_output_delay -clock [get_clocks refauxclk_p] -min -add_delay 0.000 [get_ports rx_syncn]
set_output_delay -clock [get_clocks refauxclk_p] -max -add_delay 2.000 [get_ports rx_syncn]
set_output_delay -clock [get_clocks refauxclk_p] -min -add_delay 0.000 [get_ports rx_syncp]
set_output_delay -clock [get_clocks refauxclk_p] -max -add_delay 2.000 [get_ports rx_syncp]

set_clock_groups -name dsp -asynchronous -group [get_clocks [list link_clk [get_clocks -of_objects [get_pins clk_wiz_0_inst/inst/mmcme4_adv_inst/CLKOUT0]] [get_clocks -of_objects [get_pins clk_wiz_0_inst/inst/mmcme4_adv_inst/CLKOUT1]] [get_clocks -of_objects [get_pins clk_wiz_0_inst/inst/mmcme4_adv_inst/CLKOUT2]] [get_clocks -of_objects [get_pins clk_wiz_0_inst/inst/mmcme4_adv_inst/CLKOUT3]]]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_20]

derive_clock_uncertainty
derive_pll_clocks
