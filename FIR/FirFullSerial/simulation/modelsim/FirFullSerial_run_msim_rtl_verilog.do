transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/FilterVerilog/Chapter_4/E4_7/FirFullSerial/source {D:/FilterVerilog/Chapter_4/E4_7/FirFullSerial/source/FirFullSerial.v}
vlog -vlog01compat -work work +incdir+D:/FilterVerilog/Chapter_4/E4_7/FirFullSerial/ipcore {D:/FilterVerilog/Chapter_4/E4_7/FirFullSerial/ipcore/adder.v}
vlog -vlog01compat -work work +incdir+D:/FilterVerilog/Chapter_4/E4_7/FirFullSerial/ipcore {D:/FilterVerilog/Chapter_4/E4_7/FirFullSerial/ipcore/mult.v}

vlog -vlog01compat -work work +incdir+D:/FilterVerilog/Chapter_4/E4_7/FirFullSerial/simulation/modelsim {D:/FilterVerilog/Chapter_4/E4_7/FirFullSerial/simulation/modelsim/FirFullSerial.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  FirFullSerial_vlg_tst

add wave *
view structure
view signals
run -all
