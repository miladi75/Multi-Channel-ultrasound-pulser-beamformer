

package require ::quartus::project


#----------------------------------------------------------------------

set_location_assignment PIN_H12  -to CLOCK_50_B7A


set_location_assignment PIN_Y23 -to PWM1[15]
set_location_assignment PIN_W20 -to PWM1[14]
set_location_assignment PIN_V20 -to PWM1[13]
set_location_assignment PIN_U20 -to PWM1[12]
set_location_assignment PIN_AD7 -to PWM1[11]
set_location_assignment PIN_AA7 -to PWM1[10]
set_location_assignment PIN_G26 -to PWM1[9]
set_location_assignment PIN_F26 -to PWM1[8]
set_location_assignment PIN_R9 -to PWM1[7]
set_location_assignment PIN_P8 -to PWM1[6]
set_location_assignment PIN_U19 -to PWM1[5]
set_location_assignment PIN_T22 -to PWM1[4]
set_location_assignment PIN_M21 -to PWM1[3]
set_location_assignment PIN_K26 -to PWM1[2]
set_location_assignment PIN_K25 -to PWM1[1]
set_location_assignment PIN_T21 -to PWM1[0]

# pwm-low-voltag circuits
set_location_assignment PIN_AA23 -to PWM2[15]
set_location_assignment PIN_Y24 -to PWM2[14]
set_location_assignment PIN_W21 -to PWM2[13]
set_location_assignment PIN_V22 -to PWM2[12]
set_location_assignment PIN_AD6 -to PWM2[11]
set_location_assignment PIN_AA6 -to PWM2[10]
set_location_assignment PIN_Y8 -to PWM2[9]
set_location_assignment PIN_Y9 -to PWM2[8]
set_location_assignment PIN_R10 -to PWM2[7]
set_location_assignment PIN_R8 -to PWM2[6]
set_location_assignment PIN_U22 -to PWM2[5]
set_location_assignment PIN_T19 -to PWM2[4]
set_location_assignment PIN_P20 -to PWM2[3]
set_location_assignment PIN_M26 -to PWM2[2]
set_location_assignment PIN_E26 -to PWM2[1]
set_location_assignment PIN_D26 -to PWM2[0]

# GPIO[32]
set_location_assignment PIN_AA22 -to chan_enable
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to chan_enable
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to chan_enable
set_instance_assignment -name SLEW_RATE 0 -to chan_enable

# KEY0 pin
# set_location_assignment PIN_P11 -to TRIG_IN

# GPIO35
set_location_assignment PIN_AC22 -to START_TX_TIMER_DEBUG
# GPIO34
# set_location_assignment PIN_AC23 -to TX_TRIGGER_TIMER_DEBUG 




set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM1[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM1[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM1[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM1[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM1[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM1[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM1[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM1[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM1[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM1[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM1[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM1[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM1[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM1[13]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM1[14]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM1[15]

set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM2[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM2[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM2[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM2[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM2[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM2[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM2[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM2[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM2[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM2[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM2[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM2[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM2[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM2[13]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM2[14]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to PWM2[15]

# set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to TRIG_IN

set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to START_TX_TIMER_DEBUG
# set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to TX_TRIGGER_TIMER_DEBUG  


set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM1[0]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM1[1]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM1[2]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM1[3]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM1[4]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM1[5]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM1[6]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM1[7]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM1[8]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM1[9]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM1[10]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM1[11]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM1[12]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM1[13]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM1[14]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM1[15]

set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM2[0]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM2[1]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM2[2]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM2[3]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM2[4]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM2[5]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM2[6]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM2[7]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM2[8]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM2[9]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM2[10]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM2[11]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM2[12]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM2[13]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM2[14]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to PWM2[15]


# set_instance_assignment -name SLEW_RATE 0 -to PWM_EN[0]

set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to START_TX_TIMER_DEBUG
# set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "40 MHz" -to TX_TRIGGER_TIMER_DEBUG  



set_instance_assignment -name SLEW_RATE 0 -to PWM1[0]
set_instance_assignment -name SLEW_RATE 0 -to PWM1[1]
set_instance_assignment -name SLEW_RATE 0 -to PWM1[2]
set_instance_assignment -name SLEW_RATE 0 -to PWM1[3]
set_instance_assignment -name SLEW_RATE 0 -to PWM1[4]
set_instance_assignment -name SLEW_RATE 0 -to PWM1[5]
set_instance_assignment -name SLEW_RATE 0 -to PWM1[6]
set_instance_assignment -name SLEW_RATE 0 -to PWM1[7]
set_instance_assignment -name SLEW_RATE 0 -to PWM1[8]
set_instance_assignment -name SLEW_RATE 0 -to PWM1[9]
set_instance_assignment -name SLEW_RATE 0 -to PWM1[10]
set_instance_assignment -name SLEW_RATE 0 -to PWM1[11]
set_instance_assignment -name SLEW_RATE 0 -to PWM1[12]
set_instance_assignment -name SLEW_RATE 0 -to PWM1[13]
set_instance_assignment -name SLEW_RATE 0 -to PWM1[14]
set_instance_assignment -name SLEW_RATE 0 -to PWM1[15]

set_instance_assignment -name SLEW_RATE 0 -to PWM2[0]
set_instance_assignment -name SLEW_RATE 0 -to PWM2[1]
set_instance_assignment -name SLEW_RATE 0 -to PWM2[2]
set_instance_assignment -name SLEW_RATE 0 -to PWM2[3]
set_instance_assignment -name SLEW_RATE 0 -to PWM2[4]
set_instance_assignment -name SLEW_RATE 0 -to PWM2[5]
set_instance_assignment -name SLEW_RATE 0 -to PWM2[6]
set_instance_assignment -name SLEW_RATE 0 -to PWM2[7]
set_instance_assignment -name SLEW_RATE 0 -to PWM2[8]
set_instance_assignment -name SLEW_RATE 0 -to PWM2[9]
set_instance_assignment -name SLEW_RATE 0 -to PWM2[10]
set_instance_assignment -name SLEW_RATE 0 -to PWM2[11]
set_instance_assignment -name SLEW_RATE 0 -to PWM2[12]
set_instance_assignment -name SLEW_RATE 0 -to PWM2[13]
set_instance_assignment -name SLEW_RATE 0 -to PWM2[14]
set_instance_assignment -name SLEW_RATE 0 -to PWM2[15]

# set_instance_assignment -name SLEW_RATE 0 -to TRIG_IN

set_instance_assignment -name SLEW_RATE 0 -to START_TX_TIMER_DEBUG
# set_instance_assignment -name SLEW_RATE 0 -to TX_TRIGGER_TIMER_DEBUG  


set_location_assignment PIN_P11 -to KEY[0]
set_location_assignment PIN_P12 -to KEY[1]
set_location_assignment PIN_Y15 -to KEY[2]
set_location_assignment PIN_Y16 -to KEY[3]

set_location_assignment PIN_H8 -to LEDR[16]
set_location_assignment PIN_B6 -to LEDR[15]
set_location_assignment PIN_A5 -to LEDR[14]
set_location_assignment PIN_E9 -to LEDR[13]
set_location_assignment PIN_D8 -to LEDR[12]
set_location_assignment PIN_K6 -to LEDR[11]
set_location_assignment PIN_L7 -to LEDR[10]
set_location_assignment PIN_J10 -to LEDR[9]
set_location_assignment PIN_H7 -to LEDR[8]
set_location_assignment PIN_K8 -to LEDR[7]
set_location_assignment PIN_K10 -to LEDR[6]
set_location_assignment PIN_J7 -to LEDR[5]
set_location_assignment PIN_J8 -to LEDR[4]
set_location_assignment PIN_G7 -to LEDR[3]
set_location_assignment PIN_G6 -to LEDR[2]
set_location_assignment PIN_F6 -to LEDR[1]
set_location_assignment PIN_F7 -to LEDR[0]

set_location_assignment PIN_AC9 -to SW[0]
set_location_assignment PIN_AE10 -to SW[1]
set_location_assignment PIN_AD13 -to SW[2]
set_location_assignment PIN_AC8 -to SW[3]
set_location_assignment PIN_M9 -to UART_RX
set_location_assignment PIN_L9 -to UART_TX
