

# ----------------------------------------------------------------------------------------
# ------------------------------- pkg and user defined types  ----------------------------
# ----------------------------------------------------------------------------------------
set_global_assignment -library work -name VHDL_FILE ../src/packages/types_pkg.vhd
# ----------------------------------------------------------------------------------------


# ----------------------------------------------------------------------------------------
# ---------------------------------- CLK_RST_GEN  ----------------------------------------
# ----------------------------------------------------------------------------------------
set_global_assignment -library work -name VHDL_FILE ../src/general/shift_reg16.vhd
set_global_assignment -library work -name VHDL_FILE ../src/general/reset_sync.vhd
set_global_assignment -library work -name VHDL_FILE ../src/general/clk_rst_gen.vhd
# ----------------------------------------------------------------------------------------


# ----------------------------------------------------------------------------------------
# ---------------------------------- Pulser TOP  -----------------------------------------
# ----------------------------------------------------------------------------------------
set_global_assignment -library work -name VHDL_FILE ../src/pulser_stx_top.vhd
# ----------------------------------------------------------------------------------------


# ----------------------------------------------------------------------------------------
# ---------------------------------- uart interface --------------------------------------
# ----------------------------------------------------------------------------------------
set_global_assignment -library work -name VHDL_FILE ../src/uart/uart_rx.vhd
set_global_assignment -library work -name VHDL_FILE ../src/uart/uart_tx.vhd
set_global_assignment -library work -name VHDL_FILE ../src/uart/uart_interface.vhd
set_global_assignment -library work -name VHDL_FILE ../src/uart/uart_fsm.vhd
# ----------------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
# ---------------------------------- General modules -------------------------------------
# ----------------------------------------------------------------------------------------
set_global_assignment -library work -name VHDL_FILE ../src/general/time_ctrl.vhd
set_global_assignment -library work -name VHDL_FILE ../src/general/scdpram.vhd
# ----------------------------------------------------------------------------------------



# ----------------------------------------------------------------------------------------
# ---------------------------------- TX control ------------------------------------------
# ----------------------------------------------------------------------------------------
set_global_assignment -library work -name VHDL_FILE ../src/tx_core/tx_ram_ctrl.vhd
set_global_assignment -library work -name VHDL_FILE ../src/tx_core/tx_delay.vhd
set_global_assignment -library work -name VHDL_FILE ../src/tx_core/tx_gen_lfm.vhd
set_global_assignment -library work -name VHDL_FILE ../src/tx_core/tx_core.vhd
set_global_assignment -library work -name VHDL_FILE ../src/tx_core/tx_mult.vhd
set_global_assignment -library work -name VHDL_FILE ../src/tx_core/tx_pwm.vhd
set_global_assignment -library work -name VHDL_FILE ../src/tx_core/tx_wind.vhd
# ----------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------
# ---------------------------------- IP and SDC ------------------------------------------
# ----------------------------------------------------------------------------------------
set_global_assignment -name QIP_FILE ../src/ip/pll_50.qip
set_global_assignment -name SDC_FILE pulser_stx_16ch_fpga.sdc
# ----------------------------------------------------------------------------------------