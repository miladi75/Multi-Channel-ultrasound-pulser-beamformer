
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import numpy as np


# --------------------------------------------------------------------------------------------
# ----------------- PLOT Trapeziod model similar to wind function used in FPGA  --------------
# --------------------------------------------------------------------------------------------

# Parameters
# windLength = int("927C0", 16)  # Convert hex string to integer
# trapWindSlopeRate = int("0008BCF6", 16)  # Convert hex string to integer
# C_WIND_VAL_ONE32 = 2**(8 + 16)
# C_DATA_CNT_MAX32 = (1 << 32)

# # Initialize signals
# data_cnt32 = 0
# slope_up = True
# slope_down = False
# window_valid = False
# done_i = False
# first = False
# full_smp_cnt = 0
# hold_end_smp = windLength + 2  # Initial value for hold_end_smp

# # Generate trapezoid window
# window_data = []
# while not done_i:
#     if data_cnt32 >= C_DATA_CNT_MAX32:
#         wind_data = C_WIND_VAL_ONE32 >> 16  # Only take the higher 8 bits
#     else:
#         wind_data = data_cnt32 >> 24  # Only take the higher 8 bits

#     window_data.append(wind_data)

#     if slope_up and data_cnt32 >= C_DATA_CNT_MAX32:
#         slope_up = False
#         hold_end_smp = windLength - full_smp_cnt

#     if full_smp_cnt >= hold_end_smp:
#         slope_down = not done_i

#     if slope_down and data_cnt32 == C_WIND_VAL_ONE32:
#         slope_down = False
#         done_i = True
#         first = False

#     if not done_i:
#         window_valid = True
#         full_smp_cnt += 1
#         if slope_up:
#             data_cnt32 += trapWindSlopeRate
#         elif slope_down:
#             data_cnt32 -= trapWindSlopeRate

#         if not first:
#             first = True
#             data_cnt32 = C_WIND_VAL_ONE32

# # Normalize window data to [0, 1] range
# window_data = np.array(window_data, dtype=float) / (C_WIND_VAL_ONE32 >> 16)

# # Plot the trapezoid window
# plt.figure(figsize=(10, 4))
# plt.plot(window_data, label="Trapezoid Window")
# plt.title("Trapezoid Window Function")
# plt.xlabel("Sample Index")
# plt.ylabel("Amplitude")
# plt.grid(True)
# plt.legend()
# plt.show()

# --------------------------------------------------------------------------------------------




"""
Calcuates the hex value needed for window module. 
Not finished
"""
def calc_window_trap(rise_time, pulse_len):
    fs=60e6
    max_val = 2**32-1
    if rise_time > pulse_len/2:
        print("Limiting the window rise time to half of pulse length")
        # Limit rise time to 1/2 pulse lenght
        rise_time = min(pulse_len/2, rise_time)

        if rise_time < 0:
            slope_sample = max_val
        else: 
            slope_time = max_val / rise_time
            slope_sample = slope_time / fs
        slope = int(np.round(slope_sample)) 
        print("Window slope value: 0x%x" % slope)
    print("risetime less than")
    

rise_time = 1e-2
pulse_len = 10e-3


calc_window_trap(rise_time, pulse_len)