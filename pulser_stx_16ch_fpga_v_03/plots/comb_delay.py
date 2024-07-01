import numpy as np
# def calc_pulse(d, x_m, theta, R, c):
#     tau_foc = (x_m**2*np.cos(theta)**2)/2*R*c
#     tau_const

#     tau_tot = 

# def tau_const_ns(x_diff, d = 2.5e-3, c=1500, R=5 ):
#     tau_const = (x_diff**2 * d**2 / (c)) * 10**9
#     return round(tau_const, 3)

# def tau_foc_angle_ns(x_diff, theta,c = 1500, R=5):
#     return ((x_diff**2 * np.cos(np.deg2rad(theta))**2) / 2* R * c )*10**9

# # def tau_angle(x_diff, theta)
# print(tau_foc_angle_ns(0.5, 5 ))

# print(f' cos (angle) {np.cos(np.deg2rad(0))}')

# l1 = 0.5**2*2.5e-3**2/(2*5*1500)
# l2 = (0.5*2.5e-3)**2/(2*5*1500)
# print(l1)
# print(l2)


def tau_foc_angle_ns(x_diff, theta,d = 2.5e-3, c=1500, R=5):
    f_tau_const_ns = (x_diff**2 * d**2 / (c)) * 10**9
    f_tau_angle_ns = ((x_diff**2 * np.cos(np.deg2rad(theta))**2) / (2 * R * c)) * 10**9
    s_tau_angle_ns = x_diff*np.sin(np.deg2rad(theta))/c
    tau_tot = f_tau_angle_ns + f_tau_const_ns#- s_tau_angle_ns

    return round(tau_tot, 3)

# Example usage:
x_diff = 1.5  # example value
theta = 0   # example angle
result = tau_foc_angle_ns(x_diff, theta)
print(f'Total tau_foc_angle_ns: {result}')