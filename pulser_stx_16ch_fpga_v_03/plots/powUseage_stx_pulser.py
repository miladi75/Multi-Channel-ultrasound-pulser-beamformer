from scipy.signal import chirp
import numpy as np
import argparse
from ctypes import c_double
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import seaborn as sns

sns.set(style="whitegrid")

import time
import psutil

# This script has been written by Martin Ericcsson (Original author): martin.ericsson@norbit.com
# Modified and added other functionalities: Seyed Husseini



def get_cpu_usage_psutil():
    return psutil.cpu_percent(interval=1)

def get_cpu_temp_psutil():
    temps = psutil.sensors_temperatures()
    if 'coretemp' in temps:
        return temps['coretemp'][0].current
    else:
        return None


def calc_pow_usage_estimate(cpu_usage, base_power=40, alphaPCoeff=1.7):
    # baseline power usage estimate from: 
    # https://forums.tomshardware.com/threads/cpu-power-consumption-under-minimal-load.3813703/#:~:text=At%20true%20idle%20your%20CPU,10%20to%2011%20W%20SoC).
    power_usage = base_power + (alphaPCoeff * cpu_usage)
    return power_usage


def trapezoid_window(length, alpha=0.25):
    ramp_length = int(length * alpha)
    window = np.ones(length)
    window[:ramp_length] = np.linspace(0, 1, ramp_length)
    window[-ramp_length:] = np.linspace(1, 0, ramp_length)
    return window

def gen_chirp(freq, bw, plen, fs):
    t = np.arange(0, plen, 1. / fs)
    v = chirp(t, freq - (bw / 2), t[-1], freq + (bw / 2), method='linear')

    return v

def calc_tx_pulse(fc=1000e3, bw=80e3, plen=10e-3, fs=60e6, amp=15, buflen=2**17, alpha=0.75):
    amp = (16 - amp) / 15.
    

    if bw <= 0:
        b = gen_chirp(fc, -bw, plen, fs)[::-1]
    else:
        b = gen_chirp(fc, bw, plen, fs)

    b = np.arcsin(b) / (np.pi / 2)

    b = b * (trapezoid_window(len(b), alpha).clip(0., 1.))

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

    return pp

if __name__ == '__main__':
    
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
        default=80,
        dest="bw",
        help="Bandwidth of pulse (in kHz). Default: 80kHz.",
    )
    parser.add_argument(
        "--plen",
        action="store",
        type=float,
        # default=125,
        default=10000,
        dest="plen",
        help="Pulselength (in seconds). Default: 10000us (10ms) ",
    )
    parser.add_argument(
        "--fs",
        action="store",
        type=float,
        default=60,
        dest="fs",
        help="Sampling frequency of output buffer/clock (in MHz). Default: 60MHz.",
    )
    parser.add_argument(
        "--alpha",
        action="store",
        type=float,
        default=0.75,
        dest="alpha",
        help="Alpha value for the trapezoid window. Default: 0.75",
    )
    start_time = time.time()
    args = parser.parse_args()

    args.f = args.f * 1000
    args.bw = args.bw * 1000
    args.plen = args.plen * 1e-6
    args.fs = args.fs * 1e6

    # start_time = time.time()
    pulse = calc_tx_pulse(args.f, args.bw, args.plen, args.fs, alpha=args.alpha)
    trueplen = args.fs * args.plen
    posPulse = (c_double * len(pulse))()
    negPulse = (c_double * len(pulse))()

    for i, val in enumerate(pulse):
        if val > 0:
            posPulse[i] = 1
        elif val < 0:
            negPulse[i] = 1
    
    end_time = time.time()

    cpu_usage = get_cpu_usage_psutil()
    cpu_temp = get_cpu_temp_psutil()
    power_usage = calc_pow_usage_estimate(cpu_usage)

    print(f"CPU Usage: {cpu_usage}%")
    print(f"CPU Temperature: {cpu_temp}°C")
    print(f"Estimated Power Usage: {power_usage} watts")
    print(f"Task Duration: {round((end_time - start_time), 4)} seconds")



