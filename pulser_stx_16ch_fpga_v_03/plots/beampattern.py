
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import numpy as np


# ------------------------------------------------------------------------------------------------------------------------------------
#                                           Plot the Beampattern from the given delay
# ------------------------------------------------------------------------------------------------------------------------------------
# Parameters
num_elements = 16
speed_of_sound = 1500  # m/s
freq = 1e6  # 1 MHz
lambda_ = speed_of_sound/freq

d = 5e-3  # Element spacing in meters
# d = lambda_/2  # Element spacing in meters
weights = np.ones(num_elements)  # Uniform weights
time_delay_ns = 600  # Example time delay in nanoseconds


alpha = 0.2  # 20% rising and falling edge
N = num_elements
trapezoid_weights = np.ones(N)
trapezoid_weights[:int(alpha*N)] = np.linspace(0, 1, int(alpha*N))
trapezoid_weights[-int(alpha*N):] = np.linspace(1, 0, int(alpha*N))


def calculate_delays_from_time_delay(num_elements, time_delay_ns):
    time_delay_s = time_delay_ns * 1e-9  # Convert ns to s
    n = np.arange(-num_elements // 2, num_elements // 2)
    delays = n * time_delay_s
    return delays

def delay_and_sum_beamforming(num_elements, freq, theta_scan, delays, weights, speed_of_sound, d):
    wavelength = speed_of_sound / freq
    k = 2 * np.pi / wavelength
    beam_pattern = np.zeros_like(theta_scan, dtype=float)
    for idx, theta in enumerate(theta_scan):
        steering_vector = np.exp(1j * (k * d * np.sin(np.radians(theta)) * np.arange(-num_elements // 2, num_elements // 2) - 2 * np.pi * freq * delays))
        beam_pattern[idx] = np.abs(np.dot(weights, steering_vector))**2
    return beam_pattern

def time_delay_to_angle(time_delay_ns, speed_of_sound, d):
    time_delay_s = time_delay_ns * 1e-9  # Convert ns to s
    ratio = time_delay_s * speed_of_sound / d
    angle_rad = np.arcsin(np.clip(ratio, -1, 1))
    angle_deg = np.degrees(angle_rad)
    return angle_deg

def steer_beam_pattern_with_time_delay(num_elements, freq, time_delay_ns, speed_of_sound, weights, d):
    delays = calculate_delays_from_time_delay(num_elements, time_delay_ns)
    theta_scan = np.linspace(-10, 90, 360)  
    beam_pattern = delay_and_sum_beamforming(num_elements, freq, theta_scan, delays, weights, speed_of_sound, d)
    return theta_scan, 20 * np.log10(beam_pattern / np.max(beam_pattern))



# Calculate beam pattern steered by time delay
theta_scan, beam_pattern_steered_uniform = steer_beam_pattern_with_time_delay(num_elements, freq, time_delay_ns, speed_of_sound, weights, d)

# For Trapeziod window function weights
theta_scan, beam_pattern_steered_trapWind = steer_beam_pattern_with_time_delay(num_elements, freq, time_delay_ns, speed_of_sound, trapezoid_weights, d)

# Calculate beam pattern with zero steering (for comparison)
theta_scan_zero, beam_pattern_zero = steer_beam_pattern_with_time_delay(num_elements, freq, 0, speed_of_sound, weights, d)

# Calculate the angle corresponding to the given time delay
angle = time_delay_to_angle(time_delay_ns, speed_of_sound, d)
print(f"The angle corresponding to a time delay of {time_delay_ns} ns is approximately {angle:.2f} degrees.")

def plot_bp(theta_scan, beam_pattern_steered, time_delay_ns, label, theta_scan_zero=theta_scan_zero, beam_pattern_zero=beam_pattern_zero):
    plt.figure(figsize=(12, 6))
    plt.plot(theta_scan_zero, beam_pattern_zero, label="(BP delay = 0 ns)", linestyle='--', color='black')
    plt.plot(theta_scan, beam_pattern_steered, label=f"(BP delay = {time_delay_ns} ns)")
    plt.title(label)
    # plt.ylim(-65, 2)
    # plt.xlim(-10, 180)
    plt.xlabel("Angle (degrees)")
    plt.ylabel("Normalized Magnitude (dB)")
    plt.grid(True)
    plt.legend()
    plt.show()

plot_bp(theta_scan, beam_pattern_steered_uniform, time_delay_ns, "Beampattern No delay vs Custom delay Uniform Weights")

plot_bp(theta_scan, beam_pattern_steered_trapWind, time_delay_ns, "Beampattern No delay vs Custom delay Trapeziod Weights")


# ------------------------------------------------------------------------------------------------------------------------------------
