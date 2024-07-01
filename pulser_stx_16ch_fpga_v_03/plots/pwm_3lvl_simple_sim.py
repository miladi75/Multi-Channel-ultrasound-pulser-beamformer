#______________________________________________________________________________________________________________
# 3 Level pulse simple simulations for report
#______________________________________________________________________________________________________________
import matplotlib.pyplot as plt
import numpy as np

# High-Voltage level (+-100V) 
HV = 1          
totsimTimeDuration = 20 
stepIncr = 0.01       
simTime = np.arange(0, totsimTimeDuration, stepIncr)
pulseDuration = 0.8*HV  

centerTime = totsimTimeDuration / 2
# PWM simulation with offset around zero
dutyCycle = 0.5 + 0.4 * (1 - np.abs((simTime - centerTime) / centerTime))



waveform = np.zeros_like(simTime)
for i, t in enumerate(simTime):
    pulseDuration = dutyCycle[i] * 0.3 * HV 
    t_mod = t % (4 * pulseDuration)
    if t_mod < pulseDuration:
        waveform[i] = 0
    elif t_mod < 2 * pulseDuration:
        waveform[i] = HV
    elif t_mod < 3 * pulseDuration:
        waveform[i] = 0
    else:
        waveform[i] = -HV

# Plot the waveform
plt.figure(figsize=(8, 2))
plt.plot(simTime, waveform)
# plt.title(r'3-Level Pulsed Waveform around $\pm$ HV', fontsize=10)
# plt.title(r'2-Level Pulsed Waveform around GND and HV', fontsize=10)
plt.title(r'PWM 3-Level Pulsed Waveform around $\pm$HV', fontsize=10)
plt.xlabel('T [s]', fontsize=12)
plt.ylabel('Voltage [V]', fontsize=10)
plt.ylim(-1.1, HV * 1.1)
# plt.ylim(-0.1, 1.1)
plt.axhline(0, color='black', linewidth=0.5)
plt.xticks([])  
plt.yticks([-HV, 0, HV], ['-HV', 'GND', '+HV'])
# plt.yticks([0, HV], ['GND', '+HV'])
plt.legend()
plt.show()

