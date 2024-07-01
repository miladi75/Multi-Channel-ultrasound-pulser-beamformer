

# import numpy as np
# import pandas as pd

# def calculate_delays(num_transducers, d, c, angles, depths):
#     # Center element (0-based index for 16 elements, center is the 8th element, index 7)
#     center_index = (num_transducers // 2) - 1
    
#     # Initialize dictionaries to store delay values
#     steering_delays = {}
#     focusing_delays = {}
#     combined_delays = {}
    
#     # Calculate delays for each depth
#     for depth in depths:
#         steering_delays[depth] = {}
#         focusing_delays[depth] = {}
#         combined_delays[depth] = {}
        
#         # Calculate delays for each angle
#         for angle in angles:
#             steering_delays[depth][angle] = []
#             focusing_delays[depth][angle] = []
#             combined_delays[depth][angle] = []
            
#             for n in range(num_transducers):
#                 # Steering delay
#                 tau_steer = ((n - center_index) * d * np.sin(np.radians(angle))) / c
#                 steering_delays[depth][angle].append(tau_steer * 1e6)  # Convert to microseconds
                
#                 # Focusing delay
#                 x_n = (n - center_index) * d
#                 d_n = np.sqrt(x_n**2 + depth**2)
#                 d_0 = depth
#                 tau_focus = (d_n - d_0) / c
#                 focusing_delays[depth][angle].append(tau_focus * 1e6)  # Convert to microseconds
                
#                 # Combined delay
#                 tau_combined = tau_steer + tau_focus
#                 combined_delays[depth][angle].append(tau_combined * 1e6)  # Convert to microseconds
    
#     return steering_delays, focusing_delays, combined_delays

# # Parameters
# num_transducers = 16
# d = 0.005  # 5 mm
# c = 1500  # Speed of sound in m/s
# angles = np.linspace(-45, 45, 15)  # 15 Angles from -45 to 45 degrees
# depths = np.arange(1, 11, 1)  # Depths from 1 meter to 10 meters

# # Calculate delays
# steering_delays, focusing_delays, combined_delays = calculate_delays(num_transducers, d, c, angles, depths)

# # Print delay values in a nice table format
# for depth in depths:
#     print(f"\nFocusing Depth: {depth} meters")
#     for angle in angles:
#         print(f"Angle: {angle:.1f} degrees")
        
#         # Create a DataFrame for the delays
#         data = {
#             'Transducer': list(range(1, num_transducers + 1)),
#             'Steering Delay (us)': [round(tau, 3) for tau in steering_delays[depth][angle]],
#             'Focusing Delay (us)': [round(tau, 3) for tau in focusing_delays[depth][angle]],
#             'Combined Delay (us)': [round(tau, 3) for tau in combined_delays[depth][angle]]
#         }
#         df = pd.DataFrame(data)
#         print(df)



import numpy as np
import pandas as pd

def calculate_delays(num_transducers, d, c, angles, depths):
    # Center offset (center is between the 8th and 9th transducers)
    center_offset = (num_transducers - 1) / 2
    
    # Initialize dictionaries to store delay values
    steering_delays = {}
    focusing_delays = {}
    combined_delays = {}
    
    # Calculate delays for each depth
    for depth in depths:
        steering_delays[depth] = {}
        focusing_delays[depth] = {}
        combined_delays[depth] = {}
        
        # Calculate delays for each angle
        for angle in angles:
            steering_delays[depth][angle] = []
            focusing_delays[depth][angle] = []
            combined_delays[depth][angle] = []
            
            for n in range(num_transducers):
                # Steering delay
                tau_steer = ((n - center_offset) * d * np.sin(np.radians(angle))) / c
                steering_delays[depth][angle].append(tau_steer * 1e9)  
                
                # Focusing delay
                x_n = (n - center_offset) * d
                d_n = np.sqrt(x_n**2 + depth**2)
                d_0 = depth
                tau_focus = (d_n - d_0) / c
                focusing_delays[depth][angle].append(tau_focus * 1e9)  
                
                # Combined delay
                tau_combined = tau_steer + tau_focus
                combined_delays[depth][angle].append(tau_combined * 1e9)  
    
    return steering_delays, focusing_delays, combined_delays

# Parameters
num_transducers = 16
d = 0.005  # 5 mm
c = 1500  # Speed of sound in m/s
angles = np.linspace(0, 90, 15)  # 15 Angles from -45 to 45 degrees
depths = np.arange(1, 11, 2)  # Depths from 1 meter to 10 meters

# Calculate delays
steering_delays, focusing_delays, combined_delays = calculate_delays(num_transducers, d, c, angles, depths)

# Print delay values in a nice table format
for depth in depths:
    print(f"\nFocusing Depth: {depth} meters")
    for angle in angles:
        print(f"Angle: {angle:.1f} degrees")
        
        # Create a DataFrame for the delays
        data = {
            'Transducer': list(range(1, num_transducers + 1)),
            'Steering Delay (ns)': [round(tau, 3) for tau in steering_delays[depth][angle]],
            'Focusing Delay (ns)': [round(tau, 3) for tau in focusing_delays[depth][angle]],
            'Combined Delay (ns)': [round(tau, 3) for tau in combined_delays[depth][angle]]
        }
        df = pd.DataFrame(data)
        print(df)

