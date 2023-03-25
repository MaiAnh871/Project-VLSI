vlib work

vlog full_adder.v
vlog carry_lookahead_adder.v
vlog tb.v

vsim -t 1ns -wlf behavior.wlf -voptargs="+acc" work.tb
log -r /*
run -a

add wave -position insertpoint  \
sim:/tb/r_RESET_N \
sim:/tb/r_CLK \
sim:/tb/r_ADDEND_0 \
sim:/tb/r_ADDEND_1 \
sim:/tb/w_SUM 