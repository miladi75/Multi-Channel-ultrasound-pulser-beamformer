
# -----------------------------------------------------------------------------------------------------
#                                   3D plot of beampattern for N transducers with Hamming window      |
# -----------------------------------------------------------------------------------------------------
# import numpy as np
# import matplotlib.pyplot as plt
# from matplotlib import cm

# # Define constants
# N = 16  # number of transducers in the array
# f_center = 1e6  # center frequency in Hz
# bandwidth = 80e3  # bandwidth in Hz
# c = 1500  # speed of sound in m/s
# lambda_ = c / f_center
# # d = 0.005  # distance between transducers in meters
# d = lambda_ / 2

# f_start = f_center - bandwidth / 2
# f_end = f_center + bandwidth / 2
# frequencies = np.linspace(f_start, f_end, 300)  # Increase frequency resolution

# # Define the angles for the beam pattern
# theta = np.linspace(-np.pi / 3, np.pi / 3, 360)  # Increase angle resolution

# # Define Hamming window
# hamming_window = np.hamming(N)



# # Calculate the array factor for each frequency and angle
# AF = np.zeros((len(frequencies), len(theta)), dtype=complex)
# for i, freq in enumerate(frequencies):
#     k = 2 * np.pi * freq / c
#     for n in range(N):
#         # AF[i, :] += n_trapezoid_window[n] * np.exp(1j * k * n * d * np.sin(theta))
#         AF[i, :] += hamming_window[n] * np.exp(1j * k * n * d * np.sin(theta))

# # Normalize the array factor
# AF_norm = np.abs(AF) / np.max(np.abs(AF))

# # Convert to dB
# AF_dB = 20 * np.log10(AF_norm + 1e-12)  # Add a small value to avoid log(0)

# # Meshgrid for 3D plotting
# theta_deg = np.degrees(theta)
# Theta, Freq = np.meshgrid(theta_deg, frequencies / 1e3)  # Frequency in kHz for plotting

# # Plotting with Matplotlib
# fig = plt.figure(figsize=(12, 8))
# ax = fig.add_subplot(111, projection='3d')
# surf = ax.plot_surface(Theta, Freq, AF_dB, cmap=cm.viridis, edgecolor='none')

# # Enhance the appearance
# ax.set_facecolor('white')
# ax.grid(True, linestyle='--', color='gray', alpha=0.7)
# ax.view_init(elev=30, azim=135)  # Adjust the view angle

# # Labels and Titles
# ax.set_xlabel(r'Opening Angle $\theta$ [deg]', fontsize=12)  # Use'$\bar{T}$' , fontsize=12)
# ax.set_ylabel('Frequency [kHz]', fontsize=12)
# # ax.set_zlabel('Normalized Array Factor (dB)', fontsize=12)
# ax.set_title('Beampattern plot for Linear Array', fontsize=12)

# # Colorbar
# cbar = fig.colorbar(surf, shrink=0.5, aspect=20)  # Reduce colorbar size
# cbar.set_label('Normalized Array Factor (dB)', fontsize=12)
# cbar.ax.tick_params(labelsize=10)

# # Show the plot
# plt.tight_layout()  # Adjust layout to make space for the colorbar
# plt.show()
# -----------------------------------------------------------------------------------------------------





# -----------------------------------------------------------------------------------------------------
#                                   3D plot of beampattern for N transducers with Trapezoid window     |
# -----------------------------------------------------------------------------------------------------

import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm

# Define constants
N = 16  # number of transducers in the array
f_center = 1e6  # center frequency in Hz
bandwidth = 80e3  # bandwidth in Hz
c = 1500  # speed of sound in m/s
lambda_ = c / f_center
d = lambda_ / 2  # distance between transducers in meters
# d = 0.0025

f_start = f_center - bandwidth / 2
f_end = f_center + bandwidth / 2
frequencies = np.linspace(f_start, f_end, 300)  # Increase frequency resolution

# Define the angles for the beam pattern
theta = np.linspace(-np.pi / 3, np.pi / 3, 360)  # Increase angle resolution

# Function to create trapezoid window
def trapezoid_window(N, alpha):
    num_slope_points = int(N * alpha / 2)
    num_flat_points = N - 2 * num_slope_points

    trapezoid_slope_up = np.linspace(0, 1, num_slope_points)
    trapezoid_flat = np.ones(num_flat_points)
    trapezoid_slope_down = np.linspace(1, 0, num_slope_points)

    return np.concatenate((trapezoid_slope_up, trapezoid_flat, trapezoid_slope_down))

# Trapezoid windows for different alphas
alphas = [0.25, 0.5, 0.75]
trapezoid_windows = [trapezoid_window(N, alpha) for alpha in alphas]

# Create a figure for each alpha
for alpha, n_trapezoid_window in zip(alphas, trapezoid_windows):
    # Calculate the array factor for each frequency and angle
    AF = np.zeros((len(frequencies), len(theta)), dtype=complex)
    for i, freq in enumerate(frequencies):
        k = 2 * np.pi * freq / c
        for n in range(N):
            AF[i, :] += n_trapezoid_window[n] * np.exp(1j * k * n * d * np.sin(theta))

    # Normalize the array factor
    AF_norm = np.abs(AF) / np.max(np.abs(AF))

    # Convert to dB
    AF_dB = 20 * np.log10(AF_norm + 1e-12)  # Add a small value to avoid log(0)

    # Meshgrid for 3D plotting
    theta_deg = np.degrees(theta)
    Theta, Freq = np.meshgrid(theta_deg, frequencies / 1e3)  # Frequency in kHz for plotting

    # Plotting with Matplotlib
    fig = plt.figure(figsize=(12, 8))
    ax = fig.add_subplot(111, projection='3d')
    surf = ax.plot_surface(Theta, Freq, AF_dB, cmap=cm.viridis, edgecolor='none')

    # Enhance the appearance
    ax.set_facecolor('white')
    ax.grid(True, linestyle='--', color='gray', alpha=0.7)
    ax.view_init(elev=30, azim=135)  # Adjust the view angle

    # Labels and Titles
    ax.set_xlabel(r'Opening Angle $\theta$ [deg]', fontsize=12)
    ax.set_ylabel('Frequency [kHz]', fontsize=12)
    ax.set_title(f'Beampattern for Linear Array N={N}, d=$\lambda/2$, TrapSlope α = {alpha}', fontsize=14)

    # Colorbar
    cbar = fig.colorbar(surf, shrink=0.5, aspect=20)  # Reduce colorbar size
    cbar.set_label('Normalized Array Factor (dB)', fontsize=12)
    cbar.ax.tick_params(labelsize=10)

    # Show the plot
    plt.tight_layout()  # Adjust layout to make space for the colorbar
    plt.show()
# -----------------------------------------------------------------------------------------------------
