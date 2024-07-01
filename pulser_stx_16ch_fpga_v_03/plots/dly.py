import numpy as np

# Written by Gergely Ivanyi <gergely.ivanyi@norbit.com>
# modified : Seyed

def calc_delay_sec(self, el, angle, dist=400.1):
    """ Calculate delay times for a given element, steering angle, focus distance
        el    = 0..127        element ID
        angle = -30..30 [deg] steering angle. If el0 is the foremost, and + angle
                                                means forward => el0 delay is largest*
        dist  = 1.9..400  [m] focus point distance from center element
    """
    # max steering angle is 30 degrees => center element delay is
    # at least 31.5*el_pitch*sin(30)/c (128 ch: 63.5*el_pitch*sin(30)/c)
    c = 1500  # s.v. [m/s]
    el_relative = self.center_el - el
    # const_dly_center_el = self.center_el*self.el_pitch*np.sin(30*np.pi/180) / c  # only steering
    const_dly_center_el_str = self.center_el*self.el_pitch*np.sin(30*np.pi/180) / c  # steering
    # const_dly_center_el_foc = self.center_el**2 * self.el_pitch**2 * np.cos(0*np.pi/180)**2 / 2 / 0.5 / c  # focus (0.5 m min.)
    const_dly_center_el_foc = self.center_el**2 * self.el_pitch**2 * np.cos(0*np.pi/180)**2 / 2 / 1 / c  # focus (1 m min.)
    const_dly_center_el_tot = const_dly_center_el_str + const_dly_center_el_foc  # focus and steering


    # Steering
    dly_s = el_relative * self.el_pitch * np.sin(angle*np.pi/180) / c
    # Focusing
    if dist <= 1000:
        dly_f = el_relative**2 * self.el_pitch**2 * np.cos(angle*np.pi/180)**2 / 2 / dist / c
    else:  # infinite
        dly_f = 0

    # *convention: if el_relative = self.center_el - el => d_cent + dly_s
    dly = const_dly_center_el_tot + dly_s - dly_f


    return dly


calc_delay_sec()