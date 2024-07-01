puts "\nSDC: Generating constraints...\n"

create_clock -name CLOCK_50_B7A -period "50 MHz" [get_ports {CLOCK_50_B7A}]

# Create generated clocks based on PLLs
derive_pll_clocks -create_base_clocks

# Generate uncertainty for PLL clocks
derive_clock_uncertainty


# Input / Output delays
set in_del_max  0.4
set in_del_min -0.4



