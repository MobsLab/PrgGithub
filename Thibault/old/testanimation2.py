import tables
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import matplotlib.animation as animation


f = tables.open_file('/home/mobshamilton/Documents/dataset/RatCatanese/13-Dec-2017_17:34/decoding_results_100ms.mat')
Occupation = f.root.Occupation[:]
position_proba = f.root.position_proba[:]
position = f.root.position[:]
spike_rate = f.root.spike_rate[:]

OccupationG = Occupation>(np.amax(Occupation)/15)



fig = plt.figure()

ims = []



for i in range(60):
    im = plt.imshow(position_proba[i,:,:], animated=True)
    ims.append([im])

ani = animation.ArtistAnimation(fig, ims, interval=100, blit=True,
                                repeat_delay=1000)

# ani.save('dynamic_images.mp4')

plt.show()