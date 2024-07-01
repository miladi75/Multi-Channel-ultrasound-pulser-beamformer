onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/clk
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/rst_n
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/polarity
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/trigger
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/trigger_rate
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/pulse_starts
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/cnt_pulse
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/pulse_id
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/tx_trigger
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/start_tx
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/start_tx_d
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/long_tx_trigger
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/trigger_reg
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/trigger_reg_i
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/trigger_start
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/tick_40mhz
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/cnt_40mhz
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/cnt_1khz
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/tick_1khz
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/trigger_en_n
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/limit_cnt
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/start_cnt
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/cnt_pwr_trig
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/smp_cnt
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/start_tx_i
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/trigger_start2
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/pwm_level_i
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/cnt_pulse_i
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/pulse_id_i
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/trig_cnt
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/counter
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/FREQ_SYS_CLK
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/BASE_SAMPLE_RATE
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/PRESCALER_MAX
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/PRESCALER_1KHZ_RATE
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/PRESCALER_1KHZ_MAX
add wave -noupdate -height 19 -expand -group DUT /timer_tb/DUT/C_TRIG_CNT_MAX
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {29 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 101
configure wave -valuecolwidth 45
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {107 ns}
