import sys
from scipy.signal import chirp
import numpy as np
import argparse
from ctypes import c_double
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import seaborn as sns

sns.set(style="whitegrid")
import psutil
import time
import os

# Orginal Author: Martine Ericcson: martin.ericsson@norbit.com
# changed by Seyed M Husseini

def monitor_cpu_usage():
    while True:
        cpu_usage = p.cpu_percent(interval=1)
        print(f"CPU Usage: {cpu_usage}%")
        time.sleep(1)


def trapezoid_window(length, alpha=0.25):
    ramp_length = int(length * alpha)
    window = np.ones(length)
    window[:ramp_length] = np.linspace(0, 1, ramp_length)
    window[-ramp_length:] = np.linspace(1, 0, ramp_length)
    return window

def gen_chirp(freq, bw, plen, fs):
    t = np.arange(0, plen, 1. / fs)
    v = chirp(t, freq - (bw / 2), t[-1], freq + (bw / 2), method='linear')

    # Uncomment this to plot the FFT of the pulse
    fig, ax = plt.subplots()
    freqs = np.linspace(0, fs, len(v))
    ax.plot(freqs, abs(np.fft.fft(v)))
    ax.set_xlabel('Frequency')
    ax.set_xlim(600e3, 1.5e6)
    ax.set_title('FFT of TX pulse')
    plt.show()

    return v

def calc_tx_pulse(fc=1000e3, bw=100e3, plen=125e-6, fs=100e6, amp=15, buflen=2**17, alpha=0.25):
    amp = (16 - amp) / 15.

    if bw <= 0:
        b = gen_chirp(fc, -bw, plen, fs)[::-1]
    else:
        b = gen_chirp(fc, bw, plen, fs)

    b = np.arcsin(b) / (np.pi / 2)

    fig, axs = plt.subplots(3)
    fig.suptitle(r'Binary pulse with Trap window, $\alpha = 0.25$')
    axs[0].plot(b, label='TX Pulse')
    axs[0].legend()

    b = b * (trapezoid_window(len(b), alpha).clip(0., 1.))
    axs[1].plot(b, label='Trapezoid Window Applied', alpha=0.7)
    axs[1].legend()

    if len(b) < buflen:
        pulse = np.zeros(buflen)
        stix = (buflen - len(b)) // 2
        pulse[stix:stix + len(b)] = b
    elif len(b) == buflen:
        pulse = b
    else:
        stix = (len(b) - buflen) // 2
        pulse = b[stix:stix + buflen]

    pp = 1. * (pulse > amp) - 1. * (pulse < -amp)

    bix = np.where(np.abs(pp[:-1] - pp[1:]) > 1)
    pp[bix[0]] = 0
    pp[bix[0] + 1] = 0

    bix = np.where(np.abs(pp[:-2] - pp[2:]) > 1)
    pp[bix[0]] = 0

    axs[2].plot(pp, label='TX Pulse Bit Stream after Trapezoid Window.')
    axs[2].legend()

    plt.show()

    return pp

if __name__ == '__main__':
    # python txp_trap.py --f 1000 --bw 80 --plen 200 --fs 10
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--f",
        action="store",
        type=int,
        default=1000,
        dest='f',
        help="Center frequency (in kHz). Default: 1MHz.",
    )
    parser.add_argument(
        "--bw",
        action="store",
        type=int,
        default=100,
        dest="bw",
        help="Bandwidth of pulse (in kHz). Default: 100kHz.",
    )
    parser.add_argument(
        "--plen",
        action="store",
        type=float,
        default=125,
        dest="plen",
        help="Pulselength (in seconds). Default: 125us ",
    )
    parser.add_argument(
        "--fs",
        action="store",
        type=float,
        default=30,
        dest="fs",
        help="Sampling frequency of output buffer/clock (in MHz). Default: 30MHz.",
    )
    parser.add_argument(
        "--alpha",
        action="store",
        type=float,
        default=0.25,
        dest="alpha",
        help="Alpha value for the trapezoid window. Default: 0.25",
    )
    args = parser.parse_args()

    args.f = args.f * 1000
    args.bw = args.bw * 1000
    args.plen = args.plen * 1e-6
    args.fs = args.fs * 1e6

    print('Generating a pulse with frequency of {} kHz, bandwidth of {} kHz, length of {} microseconds and sampling frequency of {} MHz'
          .format(args.f * 1e-3, args.bw * 1e-3, args.plen * 1e6, args.fs * 1e-6))

    pulse = calc_tx_pulse(args.f, args.bw, args.plen, args.fs, alpha=args.alpha)
    trueplen = args.fs * args.plen

    posPulse = (c_double * len(pulse))()
    negPulse = (c_double * len(pulse))()

    for i, val in enumerate(pulse):
        if val > 0:
            posPulse[i] = 1
        elif val < 0:
            negPulse[i] = 1

    fig2, ax2 = plt.subplots()
    fig2.suptitle('TX pulse bit stream in two separate arrays')
    ax2.plot(posPulse, label='TX_Pos')
    ax2.plot(negPulse, label='TX_Neg')
    plt.grid()
    ax2.legend()
    plt.show()



# pid = os.getpid()
# p = psutil.Process(pid)
# monitor_cpu_usage()