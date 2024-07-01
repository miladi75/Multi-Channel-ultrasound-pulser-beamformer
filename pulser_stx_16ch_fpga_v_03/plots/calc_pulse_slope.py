

# def calculate_slopes(fc, bw, pulse_length, fs=60e6, G_DATA_WIDTH=16):
#     # Calculate start_slope
#     start_slope = int(2 * ((fc - (bw / 2)) / fs) * (2 ** G_DATA_WIDTH))
#     start_slope_hex = hex(start_slope)
    
#     # Calculate dslope using the provided pulse length
#     dslope = int(((2 ** G_DATA_WIDTH) * bw) / (pulse_length * fs))
#     dslope_hex = hex(dslope)
    
#     return {
#         "start_slope_decimal": start_slope,
#         "start_slope_hex": start_slope_hex,
#         "dslope_decimal": dslope,
#         "dslope_hex": dslope_hex
#     }

# # Example usage
# fc = 1e6  # Center frequency in Hz (1 MHz)
# bw = 80e3  # Bandwidth in Hz (80 kHz)
# pulse_length = 600000  # Pulse length in samples (for 10 ms pulse length)

# slopes = calculate_slopes(fc, bw, pulse_length)
# print(f"Center Frequency: {fc} Hz, Bandwidth: {bw} Hz")
# print(f"Start Slope (decimal): {slopes['start_slope_decimal']}, Start Slope (hex): {slopes['start_slope_hex']}")
# print(f"Dslope (decimal): {slopes['dslope_decimal']}, Dslope (hex): {slopes['dslope_hex']}")


# fc = 1e6  # Center frequency in Hz (1 MHz)
# bw = 80e3  # Bandwidth in Hz (80 kHz)
# fs = 120e6  # Sampling frequency in Hz
# G_DATA_WIDTH = 16
# pulse_length = 600000  # Pulse length in samples

# # Calculate using the updated formula with correct pulse length
# start_slope_calculated = int(2 * ((fc - (bw / 2)) / fs) * (2 ** G_DATA_WIDTH))
# dslope_calculated = int(((2 ** G_DATA_WIDTH) * bw) / (pulse_length * fs))

# print(f"Calculated Start Slope: {start_slope_calculated} (hex: {hex(start_slope_calculated)}), Known Start Slope: 1048 (hex: 0x418)")
# print(f"Calculated Dslope: {dslope_calculated} (hex: {hex(dslope_calculated)}), Known Dslope: 305 (hex: 0x131)")



# def calculate_slopes(fc, bw, pulse_length_hex, fs=120e6, G_DATA_WIDTH=16):
#     # Convert pulse_length_hex to decimal
#     pulse_length = int(pulse_length_hex, 16)

#     # Calculate start_slope
#     start_slope = int(2 * ((fc - (bw / 2)) / fs) * (2 ** G_DATA_WIDTH))
#     start_slope_hex = hex(start_slope)

#     # Calculate dslope using the provided pulse length
#     dslope = int(((2 ** G_DATA_WIDTH) * bw) / (pulse_length * fs))
#     dslope_hex = hex(dslope)

#     return {
#         "start_slope_decimal": start_slope,
#         "start_slope_hex": start_slope_hex,
#         "dslope_decimal": dslope,
#         "dslope_hex": dslope_hex
#     }

# # Example usage
# fc = 960e3  # Center frequency in Hz (1 MHz)
# bw = 80e3  # Bandwidth in Hz (80 kHz)
# pulse_length_hex = "000927c0"  # Pulse length in hexadecimal (for 10 ms pulse length)

# slopes = calculate_slopes(fc, bw, pulse_length_hex)
# print(f"Center Frequency: {fc} Hz, Bandwidth: {bw} Hz")
# print(f"Start Slope (decimal): {slopes['start_slope_decimal']}, Start Slope (hex): {slopes['start_slope_hex']}")
# print(f"Dslope (decimal): {slopes['dslope_decimal']}, Dslope (hex): {slopes['dslope_hex']}")



def calculate_slopes(fc, bw, pulse_length_hex, fs=120e6, G_DATA_WIDTH=16):
    # Convert pulse_length_hex to decimal
    pulse_length_samples = int(pulse_length_hex, 16)

    # Convert pulse length from samples to seconds
    pulse_length_seconds = pulse_length_samples * 16.666e-6

    # Calculate start_slope
    start_slope = int(2 * ((fc - (bw / 2)) / fs) * (2 ** G_DATA_WIDTH))
    start_slope_hex = hex(start_slope)

    # Calculate dslope using the provided pulse length
    dslope = int(((2 ** G_DATA_WIDTH) * bw) / (pulse_length_seconds * fc))
    dslope_hex = hex(dslope)

    return {
        "start_slope_decimal": start_slope,
        "start_slope_hex": start_slope_hex,
        "dslope_decimal": dslope,
        "dslope_hex": dslope_hex
    }

# Example usage
fc = 960e3  # Center frequency in Hz (1 MHz)
bw = 40e3  # Bandwidth in Hz (80 kHz)
pulse_length_hex = "000927c0"  # Pulse length in hexadecimal (for 10 ms pulse length)

slopes = calculate_slopes(fc, bw, pulse_length_hex)
print(f"Center Frequency: {fc} Hz, Bandwidth: {bw} Hz")
print(f"Start Slope (decimal): {slopes['start_slope_decimal']}, Start Slope (hex): {slopes['start_slope_hex']}")
print(f"Dslope (decimal): {slopes['dslope_decimal']}, Dslope (hex): {slopes['dslope_hex']}")




# -----------------------------------------------------------------------------
#      FROM TENREC written by Gergely Ivanyi <gergely.ivanyi@norbit.com>
# -----------------------------------------------------------------------------

# import numpy as np

# def calc_tx_pulse_param(fs, fc, bw, sweepType, pulseLen):
#     dslope_scale = 2**20
#     MAXC = 2**16*dslope_scale

#     f0 = fc - bw / 2 if sweepType == 0 else fc + bw / 2
#     # bw = bw if sweepType == 0 else -1 * bw

#     dSlope = (MAXC*4) * bw / (pulseLen * fs)
#     # print('fc, dSlope pre')
#     # print(fc, dSlope)
#     # print('dSlope:', np.round(dSlope))
#     dSlope = int(np.round(dSlope))
#     # print('fc, dSlope post')
#     # print(fc, dSlope)

#     # c0 = int(np.round(f0 / fs * MAXC))
#     c0 = int(f0 / fs * MAXC / dslope_scale)
#     # print('c0')
#     # print(c0)

#     # print('starting slope:', c0)
#     # print('dSlope:', dSlope)

#     # print('1.0 * c0 * fs / MAXC', 1.0 * c0*dslop_scale * fs / MAXC)

#     return c0, dSlope



# fs = 60e6
# freq = 1e6
# bw = 80e3
# sweepType = 0
# pulseLen = 12

# print(calc_tx_pulse_param(fs, fc, bw, sweepType, pulseLen))



# # def calc_tx_pulse(fs, fc, bw, sweepType, pulseLen):
# #     dslope_scale = 2**19
# #     counter = 0
# #     sawtooth = list()
# #     slope, dSlope = calc_tx_pulse_param(fs, fc, bw, sweepType, pulseLen)
# #     dSlope = dSlope / dslope_scale / 4
# #     MAXC = 2**16
# #     midval = MAXC//2

# #     to_neg = 0
# #     to_pos = 0
# #     min_pulse_width = 1

# #     for i in range(pulseLen):

# #         if i >= 1:
# #             if counter > midval and sawtooth[i-1] < midval:
# #                 to_pos = i

# #                 if to_neg > 0:
# #                     # print('i pos')
# #                     # print(i)
# #                     if (to_pos - to_neg)/fs < min_pulse_width:
# #                         # print('i_pos: %d' % i)
# #                         # print('min_pulse_width upd from %f (%d, 0x%x)' % (min_pulse_width, int(min_pulse_width*fs), int(min_pulse_width*fs)))
# #                         min_pulse_width = (to_pos - to_neg)/fs
# #                         # print(min_pulse_width)
# #                         # print('maxF [kHz]')
# #                         # print(1/min_pulse_width/2/1e3)

# #             elif counter < midval and sawtooth[i-1] > midval:
# #                 to_neg = i

# #                 if to_pos > 0:
# #                     # print('i neg')
# #                     # print(i)
# #                     if (to_neg - to_pos)/fs < min_pulse_width:
# #                         # print('i_neg: %d' % i)
# #                         # print('min_pulse_width upd from %f (%d, 0x%x)' % (min_pulse_width, int(min_pulse_width*fs), int(min_pulse_width*fs)))
# #                         min_pulse_width = (to_neg - to_pos)/fs
# #                         # print(min_pulse_width)
# #                         # print('maxF [kHz]')
# #                         # print(1/min_pulse_width/2/1e3)

# #         sawtooth.append(counter)
# #         counter = (counter + slope) % MAXC
# #         slope += dSlope

# #     return min_pulse_width


# # maxwidth = calc_tx_pulse(fs=60e6, fc=freq[i//2], bw=bw[i%2], sweepType=0, pulseLen=int(t_pulse_len[i]*60e6))

# -----------------------------------------------------------------------------