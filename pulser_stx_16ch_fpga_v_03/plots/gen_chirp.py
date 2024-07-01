import numpy as np
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
from scipy.fft import fft
from scipy.signal import chirp


# def plot_spectrum(signal, sampling_rate):
    # # Number of sample points
    # N = len(signal)
    # # FFT of the signal
    # signal_fft = fft(signal)
    # # Corresponding frequencies
    # freq = np.fft.fftfreq(N, d=1/sampling_rate)
    # # Magnitude of the FFT
    # magnitude = np.abs(signal_fft)
    
    # # Plot the spectrum
    # plt.figure(figsize=(10, 4))
    # plt.plot(freq / 1e3, magnitude)  # freq is divided by 1e3 to convert Hz to kHz
    # plt.title('Spectrum for an LFM waveform')
    # plt.xlabel('Frequency - kHz')
    # plt.ylabel('Magnitude spectrum')
    # plt.grid(True)
    # plt.xlim([freq.min()/1e3, freq.max()/1e3])  # Limit x-axis to frequencies range
    # plt.show()

def plot_spectrum(signal, sampling_rate):
    # Number of sample points
    N = len(signal)
    # FFT of the signal
    signal_fft = fft(signal)
    # Take the magnitude of the FFT
    magnitude = np.abs(signal_fft)
    # Generate frequency axis
    freq = np.fft.fftfreq(N, d=1/sampling_rate)
    # Shift the zero frequency to the center
    freq_shifted = np.fft.fftshift(freq)
    magnitude_shifted = np.fft.fftshift(magnitude)

    # Only take the positive frequencies (second half)
    positive_freqs = freq_shifted[N//2:]
    positive_magnitude = magnitude_shifted[N//2:]

    # Plot the spectrum
    plt.figure(figsize=(10, 4))
    plt.plot(positive_freqs / 1e3, positive_magnitude)  # Convert Hz to kHz
    plt.title('Spectrum for an LFM waveform')
    plt.xlabel('Frequency - kHz')
    plt.ylabel('Magnitude spectrum')
    plt.grid(True)
    plt.show()

# Plotting the spectrum


def generate_chirp(start_freq, end_freq, duration, sampling_rate):
    t = np.linspace(0, duration, int(sampling_rate * duration), endpoint=False)
    signal = chirp(t, f0=start_freq, f1=end_freq, t1=duration, method='linear')
    return t, signal



# Parameters
start_frequency = 2  # Start frequency in Hz
end_frequency = 100
duration = 2            
sampling_rate = 50e3   # Sampling rate in Hz

# Generate the chirp signal
time, chirp_signal = generate_chirp(start_frequency, end_frequency, duration, sampling_rate)

# Plotting the chirp signal
plt.figure(figsize=(10, 4))
plt.plot(time, chirp_signal)
plt.title('LFM Signal. f0=2Hz, f1=100Hz ')
plt.xlabel('Time [s]')
plt.ylabel('Amplitude')
plt.grid(True)
plt.show()

# Plotting the spectrum
# plot_spectrum(chirp_signal, sampling_rate)

# plot_spectrum(chirp_signal, sampling_rate)




# generates a continuous sawtooth chirp waveform starting from 960 kHz and ending at 1.04 MHz

# Simulation parameters
sampling_rate = 10e6  # 10 MHz sampling rate
duration = 10e-3  # 1 millisecond duration
num_samples = int(duration * sampling_rate)  # Number of samples

# Chirp parameters
start_freq = 960e3  # 960 kHz start frequency
end_freq = 1.04e6  # 1.04 MHz end frequency
bandwidth = end_freq - start_freq  # 80 kHz bandwidth

# Generate time vector
time = np.arange(num_samples) / sampling_rate

# Generate chirp signal
chirp_rate = bandwidth / duration  # Hz/s
chirp = np.sin(2 * np.pi * (start_freq * time + chirp_rate * time**2 / 2))

# Generate sawtooth waveform
sawtooth_chirp = np.zeros_like(chirp)
for i in range(num_samples):
    t = time[i]
    sawtooth_chirp[i] = 2 * (t * bandwidth + start_freq * duration - np.floor(t * bandwidth + start_freq * duration)) / duration - 1

# Plot the waveforms
plt.figure(figsize=(12, 6))
plt.subplot(2, 1, 1)
plt.plot(time * 1e3, chirp)  # Time in milliseconds
plt.title('Continuous Chirp Waveform')
plt.xlabel('Time (ms)')
plt.ylabel('Amplitude')

plt.subplot(2, 1, 2)
plt.plot(time * 1e3, sawtooth_chirp)  # Time in milliseconds
plt.title('Sawtooth Chirp Waveform')
plt.xlabel('Time (ms)')
plt.ylabel('Amplitude')

plt.tight_layout()
plt.show()


# From: https://stackoverflow.com/questions/76764612/how-to-plot-a-sawtooth-chirp-waveform-using-an-array-of-frequency-and-time-for-a
import numpy as np
from scipy import signal
import matplotlib.pyplot as plt

## Make a single chirp signal
t_chirp = np.linspace(0, 2, 500)
w_chirp = signal.chirp(t_chirp, f0=1, f1=6, t1=2, method='linear')
fs = 1/(2/500)

## Repeating the chirp signal 5 times
num_repeats = 7
t = np.linspace(0, 2*num_repeats, 500*num_repeats)
w = np.copy(w_chirp)
for i in range(num_repeats-1):
    w = np.hstack((w, w_chirp))

## Finding the instantaneous frequency
analytic_signal = signal.hilbert(w)
instantaneous_phase = np.unwrap(np.angle(analytic_signal))
instantaneous_frequency = (np.diff(instantaneous_phase) / (2.0*np.pi) * fs)

fig, ax = plt.subplots(nrows=1, ncols=2, figsize=(10,4))
ax[0].plot(t, w)
ax[0].set_title("Linear Chirp")
ax[0].set_xlabel('t (sec)')

ax[1].plot(t[:-1], instantaneous_frequency)
ax[1].set_title("Instantaneous Frequency")
ax[1].set_xlabel('t (sec)')
ax[1].set_ylabel("Frequency (Hz)")

plt.tight_layout()
plt.show()
