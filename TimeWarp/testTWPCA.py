import numpy as np
np.random.seed(1234)
from scipy.ndimage.filters import convolve1d, gaussian_filter1d
from twpca import TWPCA
from twpca.regularizers import curvature
import itertools as itr
import seaborn as sns
import matplotlib
import matplotlib.pyplot as plt



n_time = 130
n_trial = 100
n_neuron = 50

tau = 10 # time constant for exponential decay of latent events
event_gap = 25 # average gap between events
n_events = 3 # number of events
max_jitter = 15 # maximum jitter of each event



# Randomly generate jitters
jitters = np.random.randint(-max_jitter, max_jitter, size=(n_trial, n_events))
ordering = np.argsort(jitters[:, 0])
jitters = jitters[ordering]

# Create one-hot matrix that encodes the location of latent events
events = np.zeros((n_trial, n_time))
for trial_idx, jitter in enumerate(jitters):
    trial_event_times = np.cumsum(event_gap + jitter)
    events[trial_idx, trial_event_times] = 1.0
avg_event = np.zeros(n_time)
avg_event[np.cumsum([event_gap] * n_events)] = 1.0

# Convolve latent events with an exponential filter
impulse_response = np.exp(-np.arange(n_time)/float(tau))
impulse_response /= impulse_response.sum()

latents = np.array([np.convolve(e, impulse_response, mode='full')[:n_time] for e in events])
avg_latent = np.convolve(avg_event, impulse_response, mode='full')[:n_time]

# Coupling from one dimensional latent state to each neuron
readout_weights = np.random.rand(n_neuron) + 0.1

# Probability of firing for each neuron
rates = np.exp(np.array([np.outer(latent, readout_weights) for latent in latents]))
rates -= rates.min()#(0, 1), keepdims=True)
rates /= rates.max()#0,1), keepdims=True)

# Sample spike trains
spikes = np.random.binomial(1, rates).astype(np.float32)
#spikes[80:, 60:75] = np.nan


# OPTIONS
n_components = 1
smooth_std = 1.0

warp_penalty_strength = 0.01
time_penalty_strength = 1.0



# Smooth spike trains
smoothed_spikes = gaussian_filter1d(spikes, smooth_std, axis=1)

# Add an L1 penalty on the second order finite difference of the warping functions
# This encourages the warping functions to be piecewise linear.
warp_regularizer = curvature(scale=warp_penalty_strength, power=1)
# Adds an L2 penatly on the second order finite difference of the temporal factors.
# Encourages the temporal factors to be smooth in time.
time_regularizer = curvature(scale=time_penalty_strength, power=2, axis=0)

model = TWPCA(n_components,
              warp_regularizer=warp_regularizer,
              time_regularizer=time_regularizer,
              fit_trial_factors=False,
              warpinit='zero')
# Fit model with gradient descent, starting with a learning rate of 1e-1 for 250 iterations,
# and then a learning rate of 1e-2 for 500 iterations
model.fit(smoothed_spikes, lr=(1e-1, 1e-2), niter=(250, 500))
# Extract model parameters and reconstruction of the data (X_pred)
params = model.params
X_pred = model.transform()





fig, ax = plt.subplots(figsize=(20,20))
ax1 = plt.subplot2grid((1,2),(0,0))
ax1.imshow(smoothed_spikes[:,:,0])

ax2 = plt.subplot2grid((1,2),(0,1))
ax2.imshow(X_pred[:,:,0])
plt.show()

fig = plt.figure()
plt.plot(avg_latent, '-k', lw=5, alpha=0.7, label='True')
time_fctr = params['time']
s = np.sign(np.sum(time_fctr))
s *= np.linalg.norm(avg_latent.ravel())/np.linalg.norm(time_fctr.ravel())
plt.plot(s*time_fctr, '-r', alpha=0.7, lw=4, label='twPCA')
plt.legend(loc='upper right')
plt.xlim(10, 110)
plt.show()