import numpy as np
import matplotlib.pyplot as plt

# Adding a known seed to get same results
np.random.seed(0)  
t = np.linspace(0, 1, 500)
TxPulse = np.exp(-100 * (t - 0.4)**2)
noise_lvl = 0.04
NrDelaySmp = 100
offsetYAxis = 1

Tx1 = 0.25 * TxPulse + noise_lvl * np.random.randn(500) - offsetYAxis
Tx2 = 0.25 * np.roll(TxPulse, NrDelaySmp) + noise_lvl * np.random.randn(500)
Tx3 = 0.25 * np.roll(TxPulse, 2*NrDelaySmp) + noise_lvl * np.random.randn(500) + offsetYAxis

# Properly delayed signals for alignment
delayed_Tx1 = Tx1
delayed_Tx2 = np.roll(Tx2, -NrDelaySmp)
delayed_Tx3 = np.roll(Tx3, -2*NrDelaySmp)


totTxNoDAS = Tx1 + Tx2 + Tx3
DAS = delayed_Tx1 + delayed_Tx2 + delayed_Tx3

# Plot all the tx channels with and without DAS applied
fig, axs = plt.subplots(2, 2, figsize=(10, 8))
axs[0, 0].plot(t, Tx1, label='Tx 1', color='blue')
axs[0, 0].plot(t, Tx2, label='Tx 2', color='brown')
axs[0, 0].plot(t, Tx3, label='Tx 3', color='green')
axs[0, 0].set_title('Transmitted Signals Tx(1-3), No Adjusted Delay')
axs[0, 0].legend(loc='upper right')


axs[0, 1].plot(t, delayed_Tx1, label='Tx 1', color='blue')
axs[0, 1].plot(t, delayed_Tx2, label='Tx 2', color='brown')
axs[0, 1].plot(t, delayed_Tx3, label='Tx 3', color='green')
axs[0, 1].set_title('Transmitted Signals Tx(1-3), Adjusted Delay')
axs[0, 1].legend(loc='upper right')

# No DAS added
axs[1, 0].plot(t, totTxNoDAS, color='black')
axs[1, 0].set_title('Sum of Signals Tx(1-3), No Adjusted Delay')
axs[1, 0].set_ylim([-0.5, 2])

# Proper delay added and summed 
axs[1, 1].plot(t, DAS, color='black')
axs[1, 1].set_title('Sum of Signals Tx(1-3), Adjusted Delay')
axs[1, 1].set_ylim([-0.5, 2])

for ax in axs.flat:
    ax.set(xlabel='Time [s]', ylabel='Amplitude')

plt.tight_layout()
plt.show()
