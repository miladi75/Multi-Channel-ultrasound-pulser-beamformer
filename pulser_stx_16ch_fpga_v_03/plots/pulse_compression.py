import matplotlib

matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import numpy as np
from scipy.signal import correlate, chirp



# ----------------------------------------------------------------------------------------------
# ------------------------------------ (REPORT) Chirp pulse ------------------------------------
# ----------------------------------------------------------------------------------------------





# # Set parameters for the signal
# fs = 1e6  # Sampling frequency (Hz)
# f0 = 10e3  # Start frequency of the chirp
# f1 = 100e3  # End frequency of the chirp (same as f0 for constant frequency)
# pulse_duration = 1e-3  # Pulse duration (s)
# total_duration = 60e-3  # Total duration for plots (s)
# shift_echo = int(30e-3 * fs)  # Shift for the echo

# # Generate time vectors
# t_total = np.arange(0, total_duration, 1/fs)
# t_total_ms = t_total * 1000

# # Generate chirp pulse
# pulse2 = np.zeros_like(t_total)
# start_pulse2 = int(10e-3 * fs)  # Adjust this to change where the pulse starts
# end_pulse2 = int(start_pulse2 + pulse_duration * fs)
# pulse2[start_pulse2:end_pulse2] = chirp(t_total[start_pulse2:end_pulse2] - t_total[start_pulse2],
#                                         f0=f0, f1=f1, t1=pulse_duration, method='linear')

# # Generate noise
# noise = np.random.normal(0, 0.25, size=t_total.shape)

# # Create a simulated echo in noise with chirp
# echo_in_noise = noise.copy()
# echo_in_noise[shift_echo:int(shift_echo + pulse_duration * fs)] += 0.5*pulse2[start_pulse2:end_pulse2]

# # Cross-correlate the echo with the chirp pulse
# matched_filter_output = correlate(echo_in_noise, pulse2, mode='same')
# matched_filter_output /= np.max(np.abs(matched_filter_output))  # Normalize the output

# # Plot the results
# fig, axs = plt.subplots(3, 1, figsize=(10, 6))

# # Plot chirp pulse
# axs[0].plot(t_total_ms, pulse2)
# axs[0].set_title('Chirp Pulse Replica')
# axs[0].set_xlabel('Time [ms]')

# # Plot simulated echo in noise
# axs[1].plot(t_total_ms, echo_in_noise)
# axs[1].set_title('Simulated echo in noise with Chirp')
# axs[1].set_xlabel('Time [ms]')
# axs[1].set_ylim([-2.1, 2.1])

# time_shift_ms = (shift_echo / fs) * 1000# * t_total
# print(time_shift_ms)

# # To adjust for correlate(echo_in_noise, pulse2, mode='full')
# # correlation_time_ms = np.linspace(-total_duration *0.5 * 1000,
# #                                   total_duration *0.5 * 1000,
# #                                   len(matched_filter_output))



# # Plot the matched filter output with the correct time axis
# axs[2].plot(t_total_ms, matched_filter_output)
# axs[2].set_title('Matched Filter Output for Chirp')
# axs[2].set_xlabel('Time [ms]')
# # axs[2].set_xlim([t_total_ms[0], t_total_ms[-1]])
# axs[2].set_ylim([-0.1, 1.1])

# plt.tight_layout()
# plt.show()
