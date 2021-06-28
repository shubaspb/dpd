
vlib work

set dir "../../dpd_rtl" 

vlog -sv {*}$dir/package_dpd.svh +incdir+$dir

vlog -mfcu\
{*}$dir/dpd.sv\
{*}$dir/dpd_mem3.sv\
{*}$dir/mag_complex.sv\
{*}$dir/mag_complex_stage.sv\
{*}$dir/mag_5.sv\
{*}$dir/mult.v\
{*}$dir/compl_mult.v\
{*}$dir/delay_rg.v\
{*}$dir/dpd_test_sig.sv\
gen_signal.sv\
dds_signal_generator.v\
dpd_tb.sv\
+incdir+$dir


vsim -voptargs=+acc work.dpd_tb

#vsim work.dpd_tb



################ macros ##########################################################################
set bin "add wave -color Green"
set lit "add wave -color Green -literal -height 2"
set dec "add wave -color Green -literal -height 2 -radix decimal"
set s12 "add wave -color Green -analog -min -2047 -max 2047 -height 100 -radix decimal"
set s16 "add wave -color Green -analog -min -32767 -max 32767 -height 100 -radix decimal"
set s20 "add wave -color Green -analog-interpolated -min -524287 -max 524287 -height 100 -radix decimal"
set u20 "add wave -color Green -analog-interpolated -min 0 -max 1048575 -height 100 -radix unsigned"
set s24 "add wave -color Green -analog-interpolated -min -8388607 -max 8388607 -height 100 -radix decimal"
set s32 "add wave -color Green -analog-interpolated -min -1000000000 -max 1000000000 -height 50 -radix decimal"
##################################################################################################


{*}$bin dpd_adapt
{*}$bin dpd_tb/dpd_inst/dpd_adapt_sig
{*}$bin dpd_tb/dpd_inst/dpd_adapt_coeff 

{*}$s20 dpd_tb/dpd_inst/sig_del_reg_i
{*}$s20 dpd_tb/dpd_inst/sig_dpd_reg_i

{*}$s20 dpd_tb/dpd_inst/fit1_i
{*}$s20 dpd_tb/dpd_inst/fit1_q

{*}$u20 dpd_tb/magn_sig_in
{*}$u20 dpd_tb/magn_sig_out
{*}$u20 dpd_tb/magn_sig_pa_out

{*}$s20 dpd_tb/sig_in_i
{*}$s20 dpd_tb/sig_in_q

{*}$s20 dpd_tb/sig_out_i
{*}$s20 dpd_tb/sig_out_q

{*}$s20 dpd_tb/sig_pa_out_i
{*}$s20 dpd_tb/sig_pa_out_q

{*}$dec dpd_tb/sig_in_i   
{*}$dec dpd_tb/sig_in_q 

add wave sim:/dpd_tb/dpd_inst/dpd_mem3_inst2/mag_5_inst/*


run 200 us





















