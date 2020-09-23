transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/AXL_Rapid/Desktop/Modified\ Booth\ Radix-4 {C:/Users/AXL_Rapid/Desktop/Modified Booth Radix-4/MBA_module.v}

vlog -vlog01compat -work work +incdir+C:/Users/AXL_Rapid/Desktop/Modified\ Booth\ Radix-4 {C:/Users/AXL_Rapid/Desktop/Modified Booth Radix-4/MBA_mod_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  MBA_mod_tb

add wave *
view structure
view signals
run 10 ms
