
vlib work

set dir "../../dpd_rtl" 
set dir_lib "../../../dspb/" 

vlog -sv {*}$dir/package_dpd.svh +incdir+$dir

vlog -mfcu\
{*}$dir/dpd.sv\
{*}$dir/dpd_mem3.sv\
{*}$dir/mag_5.sv\
{*}$dir/dpd_test_sig.sv\
{*}$dir_lib/delay_rg.v\
{*}$dir_lib/compl_mult.v\
{*}$dir_lib/mult.v\
{*}$dir_lib/polar_cordic.v\
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
set s20 "add wave -color Green -analog -min -524287 -max 524287 -height 100 -radix decimal"
set u20 "add wave -color Green -analog -min 0 -max 1048575 -height 100 -radix unsigned"
set s24 "add wave -color Green -analog -min -8388607 -max 8388607 -height 100 -radix decimal"
set s32 "add wave -color Green -analog -min -1000000000 -max 1000000000 -height 50 -radix decimal"
##################################################################################################


{*}$bin dpd_adapt
{*}$bin dpd_tb/dpd_inst/dpd_adapt_sig
{*}$bin dpd_tb/dpd_inst/dpd_adapt_coeff 

{*}$u20 dpd_tb/magn_sig_in
{*}$u20 dpd_tb/magn_sig_out
{*}$u20 dpd_tb/magn_sig_pa_out
{*}$u20 dpd_tb/err_fit_mag

run 200 us