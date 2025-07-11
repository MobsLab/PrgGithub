import sys
import tables
import scipy
import numpy as np
#import matplotlib
#import matplotlib.pyplot as plt
from twpca import TWPCA
from twpca.regularizers import curvature
from scipy.ndimage.filters import gaussian_filter1d



# pathToFile = '/home/mobshamilton/Dropbox/MOBS_workingON/TimeWarpAlgorithm/testHigh.mat'
# learningRate = 1e-2
# nIter = 1000
# warp_penalty_strength = 0.01
# time_penalty_strength = 1.0
pathToFile =                 (sys.argv[1])
nComponents =             int(sys.argv[2])
learningRate =          float(sys.argv[3])
nIter =                   int(sys.argv[4])
warp_penalty_strength = float(sys.argv[5])
time_penalty_strength = float(sys.argv[6])


f = tables.open_file(pathToFile)
jitteredData = np.array(f.root.jitteredData.Data)
jitteredData = np.swapaxes(jitteredData[:,:,:],2,0)


smooth_std = 1.0
smoothedData = gaussian_filter1d(jitteredData, smooth_std, axis=1)


warp_regularizer = curvature(scale=warp_penalty_strength, power=1)
time_regularizer = curvature(scale=time_penalty_strength, power=2, axis=0)

model = TWPCA(nComponents, 
                warp_regularizer=warp_regularizer,
                time_regularizer=time_regularizer,
                fit_trial_factors=False,
                warpinit='zero')
model.fit(smoothedData, lr=learningRate, niter=nIter)
alignedData = model.transform()
params = model.params

outputDict = {'alignedData':alignedData}
for key in params.keys():
    outputDict[key+'Param'] = params[key]
pathToOutput = pathToFile[:len(pathToFile)-4] + '_aligned.mat'
scipy.io.savemat(pathToOutput, outputDict)






#fig, ax = plt.subplots(figsize=(20,20))
#ax1 = plt.subplot2grid((1,2),(0,0))
#ax1.imshow(smoothedData[:,:,0], aspect='auto')

#ax2 = plt.subplot2grid((1,2),(0,1))
#ax2.imshow(alignedData[:,:,0], aspect='auto')
#plt.show()

