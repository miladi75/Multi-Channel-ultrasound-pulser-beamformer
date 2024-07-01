import subprocess
import argparse
# ctrl_ping_rate=12000000 ctrl_pulse_length=600000 ctrl_pwm_width=27 ctrl_custom_delay=0 ctrl_start_slope=1048 ctrl_slope_rate=305 ctrl_trap_slope=600000 LEDR=2
# part of this module is taken from the the VHDLWhiz.com website: https://vhdlwhiz.com/product/vhdl-registers-uart-test-interface-generator/
# Define the predefined modes
MODES = {
    'mode1': {
        'ctrl_ping_rate': '2400000',   # ping rate = 1/(2.4e6*8.33e-9) = 50Hz
        #'ctrl_ping_rate': '12000000',    # ping rate 10Hz
        # 'ctrl_pulse_length': '600000',  # pulseLength = 600e3*16.66e-9 = 10ms
        'ctrl_pulse_length': '600000',  
        'ctrl_trap_slope': '1200000',    # Sould be set the same as pulse_length
        'ctrl_pwm_width': '27',         
        'ctrl_custom_delay': '72',      # Delay[ns] = 72*8.333=600ns
        'ctrl_start_slope': '1048',     # center frquency 1MHz 
        'ctrl_slope_rate': '305',       # bandwidth 80kHz
        'LEDR': '4'                    # Channel[15..0] Enable
    },
    'mode2': {
        'ctrl_ping_rate': '12000480',  # ping rate 10Hz
        'ctrl_pulse_length': '600000', # pulse length 1ms
        'ctrl_pwm_width': '35',        # PWM max width
        'ctrl_custom_delay': '0',      # Delay[ns] = 0
        'ctrl_start_slope': '1152',    # center frquency 1MHz
        'ctrl_slope_rate': '1048',     # bandwidth 80kHz
        'ctrl_trap_slope': '600000',   # Window length same as pulse length
        'LEDR': '15'                    # Change to 2^16 to activate all channels
    },
    
    'mode3': {
        'ctrl_ping_rate': '24000000',     # Ping rate = 5Hz
        'ctrl_pulse_length': '60000',     # pulse Length = 100us
        'ctrl_pwm_width': '30',
        'ctrl_custom_delay': '180',
        'ctrl_start_slope': '1048',
        'ctrl_slope_rate': '300',
        'ctrl_trap_slope': '60000',
        'LEDR': '4' # change this to 65535 to activate all the LEDS
    },
    
    'mode4': {
        'ctrl_ping_rate': '24000000',
        'ctrl_pulse_length': '48000',	# Pulselength=800us
        'ctrl_pwm_width': '30',
        'ctrl_custom_delay': '12',
        'ctrl_start_slope': '2048',
        'ctrl_slope_rate': '300',
        'ctrl_trap_slope': '480000',
        'LEDR': '3'
    },
}

def manual_prompt_set_regs(): 
    #  User settings can be set manually here manually
    register_values = {}
    register_values['ctrl_ping_rate'] = input("Enter value for ctrl_ping_rate: ")
    register_values['ctrl_pulse_length'] = input("Enter value for ctrl_pulse_length: ")
    register_values['ctrl_pwm_width'] = input("Enter value for ctrl_pwm_width: ")
    register_values['ctrl_custom_delay'] = input("Enter value for ctrl_custom_delay: ")
    register_values['ctrl_start_slope'] = input("Enter value for ctrl_start_slope: ")
    register_values['ctrl_slope_rate'] = input("Enter value for ctrl_slope_rate: ")
    register_values['ctrl_trap_slope'] = input("Enter value for ctrl_trap_slope: ")
    register_values['LEDR'] = input("Enter value for LEDR: ")
    return register_values

def construct_command(register_values):
    """Construct the command for uart_regs.py with the given register values."""
    command = ['python3', 'uart_regs.py', '-w']
    for key, value in register_values.items():
        command.append(f"{key}={value}")
    return command

def main():
    print("Example of running: python3 uart_reg_ctrl.py --mode mode1")
    parser = argparse.ArgumentParser(description='Control UART Registers')
    parser.add_argument('--mode', type=str, choices=MODES.keys(),
                        help='Select a predefined mode')
    parser.add_argument('--manual', action='store_true',
                        help='Manually input register values')
    args = parser.parse_args()

    if args.mode:
        # Use predefined mode
        print(f"Using mode: {args.mode}")
        register_values = MODES[args.mode]
    elif args.manual:
        # Manually input register values
        print("Manually input register values")
        register_values = manual_prompt_set_regs()
    else:
        print("Please provide either --mode or --manual modes: (mode1, mode2, mode3, mode4)")
	    
        return
    

    # Construct the command
    command = construct_command(register_values)
    # print(command)

    
    print(f"Register access type: {command[2]}, and ctrl accessible registers: {' '.join(command[3:])}")

    
    try:
        subprocess.run(command, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error occurred: {e}")

if __name__ == '__main__':
    main()
