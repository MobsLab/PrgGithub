import os
import sys
import datetime
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from scipy.stats import gaussian_kde
from scipy.optimize import curve_fit

def parabola(x,*p):
    a,b,c = p
    x = np.array(x)
    return a*(x**2)+b*x+c

# file = '~/Documents/dataset/RatCatanese/_resultsForRnn_2019-06-21_13:32.npz' # first really good 0.36 window
# file = '~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-25_shuffledSpike50ms.npz'
file = '~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-25_trueUnshuffled.npz'
# file = '~/Documents/dataset/RatCatanese/_resultsForRnn_temp.npz'



# ### shuffled learning
# x = [0,50,100,200,300,400,500,600,700,800,900,1000,1100,1200,1400,1600,1800,2000,2500]
# filesFullFlow = ['~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-25_trueUnshuffled.npz']
# filesFullFlow.append('~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-25_shuffledSpikes50ms.npz')
# filesFullFlow.append('~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-25_shuffledSpikes100ms.npz')
# filesFullFlow.append('~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-25_shuffledSpikes200ms.npz')
# filesFullFlow.append('~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-26_shuffledSpikes300ms.npz')
# filesFullFlow.append('~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-26_shuffledSpikes400ms.npz')
# filesFullFlow.append('~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-26_shuffledSpikes500ms.npz')
# filesFullFlow.append('~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-26_shuffledSpikes600ms.npz')
# filesFullFlow.append('~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-26_shuffledSpikes700ms.npz')
# filesFullFlow.append('~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-26_shuffledSpikes800ms.npz')
# filesFullFlow.append('~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-27_shuffledSpikes900ms.npz')
# filesFullFlow.append('~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-27_shuffledSpikes1000ms.npz')
# filesFullFlow.append('~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-27_shuffledSpikes1100ms.npz')
# filesFullFlow.append('~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-27_shuffledSpikes1200ms.npz')
# filesFullFlow.append('~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-27_shuffledSpikes1400ms.npz')
# filesFullFlow.append('~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-27_shuffledSpikes1600ms.npz')
# filesFullFlow.append('~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-27_shuffledSpikes1800ms.npz')
# filesFullFlow.append('~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-27_shuffledSpikes2000ms.npz')
# filesFullFlow.append('~/Documents/dataset/RatCatanese/_resultsForRnn_2019-09-27_shuffledSpikes2500ms.npz')
try:
    print(Data.keys())
except:
    Data = np.load('/home/mobshamilton/Documents/dataset/RatCatanese/mobsEncoding_2019-05-06_15:10/_data.npy').item()
# filesBayesFlow = ['~/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecodingUnshuffled.npz']
# filesBayesFlow.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecodingShuffling50ms.npz')
# filesBayesFlow.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecodingShuffling100ms.npz')
# filesBayesFlow.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecodingShuffling200ms.npz')
# filesBayesFlow.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecodingShuffling300ms.npz')
# filesBayesFlow.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecodingShuffling400ms.npz')
# filesBayesFlow.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecodingShuffling500ms.npz')
# filesBayesFlow.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecodingShuffling600ms.npz')
# filesBayesFlow.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecodingShuffling700ms.npz')
# filesBayesFlow.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecodingShuffling800ms.npz')
# filesBayesFlow.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecodingShuffling900ms.npz')
# filesBayesFlow.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecodingShuffling1000ms.npz')
# filesBayesFlow.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecodingShuffling1100ms.npz')
# filesBayesFlow.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecodingShuffling1200ms.npz')
# filesBayesFlow.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecodingShuffling1400ms.npz')
# filesBayesFlow.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecodingShuffling1600ms.npz')
# filesBayesFlow.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecodingShuffling1800ms.npz')
# filesBayesFlow.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecodingShuffling2000ms.npz')
# # filesBayesFlow.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecodingShuffling2500ms.npz')

# filesTrueLabels = ['~/Documents/dataset/RatCatanese/mobsEncoding_2019-10-04_shuffledTrueLabels/_simDecodingUnshuffled.npz']
# filesTrueLabels.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-10-04_shuffledTrueLabels/_simDecodingShuffling50ms.npz')
# filesTrueLabels.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-10-04_shuffledTrueLabels/_simDecodingShuffling100ms.npz')
# filesTrueLabels.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-10-04_shuffledTrueLabels/_simDecodingShuffling200ms.npz')
# filesTrueLabels.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-10-04_shuffledTrueLabels/_simDecodingShuffling300ms.npz')
# filesTrueLabels.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-10-04_shuffledTrueLabels/_simDecodingShuffling400ms.npz')
# filesTrueLabels.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-10-04_shuffledTrueLabels/_simDecodingShuffling500ms.npz')
# filesTrueLabels.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-10-04_shuffledTrueLabels/_simDecodingShuffling600ms.npz')
# filesTrueLabels.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-10-04_shuffledTrueLabels/_simDecodingShuffling700ms.npz')
# filesTrueLabels.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-10-04_shuffledTrueLabels/_simDecodingShuffling800ms.npz')
# filesTrueLabels.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-10-04_shuffledTrueLabels/_simDecodingShuffling900ms.npz')
# filesTrueLabels.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-10-04_shuffledTrueLabels/_simDecodingShuffling1000ms.npz')
# filesTrueLabels.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-10-04_shuffledTrueLabels/_simDecodingShuffling1100ms.npz')
# filesTrueLabels.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-10-04_shuffledTrueLabels/_simDecodingShuffling1200ms.npz')
# filesTrueLabels.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-10-04_shuffledTrueLabels/_simDecodingShuffling1400ms.npz')
# filesTrueLabels.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-10-04_shuffledTrueLabels/_simDecodingShuffling1600ms.npz')
# filesTrueLabels.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-10-04_shuffledTrueLabels/_simDecodingShuffling1800ms.npz')
# filesTrueLabels.append('~/Documents/dataset/RatCatanese/mobsEncoding_2019-10-04_shuffledTrueLabels/_simDecodingShuffling2000ms.npz')

# test = []
# fullFlowErrorShuffledPosition = []
# for i in range(15):
#     bayesFlowErrorShuffledPosition = []
#     for shuffle in x:
#         Bins = Data['Bins']
#         Results = np.load(os.path.expanduser(filesBayesFlow[0]))
#         position_proba = Results['position_proba']
#         position = Results['position'].tolist()

#         X_proba = [np.sum(position_proba[n,:,:], axis=1) for n in range(len(position_proba))]
#         Y_proba = [np.sum(position_proba[n,:,:], axis=0) for n in range(len(position_proba))]

#         displ = (np.random.random()*2*shuffle/1000 - shuffle/1000)//0.036
#         X_true, Y_true = [], []
#         for n in range(len(position)):
#             idx = n + displ
#             idx = max(0, idx)
#             idx = min(len(position)-1, idx)
#             X_true.append(position[int(idx)][0])
#             Y_true.append(position[int(idx)][1])
#         X_guessed = [np.average( Bins[0], weights=X_proba[n] ) for n in range(len(X_proba))]
#         Y_guessed = [np.average( Bins[1], weights=Y_proba[n] ) for n in range(len(Y_proba))]
#         X_err = [np.abs(X_true[n] - X_guessed[n]) for n in range(len(X_true))]
#         Y_err = [np.abs(Y_true[n] - Y_guessed[n]) for n in range(len(Y_true))]
#         Error = [np.sqrt(X_err[n]**2 + Y_err[n]**2) for n in range(len(X_err))]

#         bayesFlowErrorShuffledPosition.append(np.mean(Error))
#     test.append(bayesFlowErrorShuffledPosition.copy())
# bayesFlowErrorShuffledPosition = np.array(test).mean(axis=0)


# bayesMeanError = []
# bayesMeanErrorSelection = []
# for file in range(len(filesBayesFlow)):
#     Bins = Data['Bins']
#     Results = np.load(os.path.expanduser(filesBayesFlow[file]))
#     position_proba = Results['position_proba']
#     position = Results['position'].tolist()

#     X_proba = [np.sum(position_proba[n,:,:], axis=1) for n in range(len(position_proba))]
#     Y_proba = [np.sum(position_proba[n,:,:], axis=0) for n in range(len(position_proba))]

#     X_true = [position[n][0] for n in range(len(position))]
#     Y_true = [position[n][1] for n in range(len(position))]
#     X_guessed = [np.average( Bins[0], weights=X_proba[n] ) for n in range(len(X_proba))]
#     Y_guessed = [np.average( Bins[1], weights=Y_proba[n] ) for n in range(len(Y_proba))]
#     X_err = [np.abs(X_true[n] - X_guessed[n]) for n in range(len(X_true))]
#     Y_err = [np.abs(Y_true[n] - Y_guessed[n]) for n in range(len(Y_true))]
#     Error = [np.sqrt(X_err[n]**2 + Y_err[n]**2) for n in range(len(X_err))]
#     X_standdev = np.sqrt([np.sum([X_proba[n][x]*(Bins[0][x]-X_guessed[n])**2 for x in range(Bins[0].size)]) for n in range(len(position_proba))])
#     Y_standdev = np.sqrt([np.sum([Y_proba[n][y]*(Bins[1][y]-Y_guessed[n])**2 for y in range(Bins[1].size)]) for n in range(len(position_proba))])
#     Standdev   = np.sqrt(np.power(X_standdev,2) + np.power(Y_standdev,2))

#     temp = Standdev
#     temp2 = temp.argsort()
#     thresh = temp[temp2[int(len(temp2)*0.2)]]
#     selection = Standdev<thresh
#     frames = np.where(selection)[0]

#     bayesMeanError.append(np.mean(Error))
#     bayesMeanErrorSelection.append(np.mean(np.array(Error)[frames.astype(int)]))

# trueLabelsError = []
# trueLabelsErrorSelection = []
# for file in range(len(filesTrueLabels)):
#     Bins = Data['Bins']
#     Results = np.load(os.path.expanduser(filesTrueLabels[file]))
#     position_proba = Results['position_proba']
#     position = Results['position'].tolist()
#     for n in range(len(position_proba)):
#         if np.sum(position_proba[n,:,:])==0.0:
#             position_proba[n,:,:] = np.ones([45,45]) / np.sum([45,45])

#     X_proba = [np.sum(position_proba[n,:,:], axis=1) for n in range(len(position_proba))]
#     Y_proba = [np.sum(position_proba[n,:,:], axis=0) for n in range(len(position_proba))]

#     X_true = [position[n][0] for n in range(len(position))]
#     Y_true = [position[n][1] for n in range(len(position))]
#     X_guessed = [np.average( Bins[0], weights=X_proba[n] ) for n in range(len(X_proba))]
#     Y_guessed = [np.average( Bins[1], weights=Y_proba[n] ) for n in range(len(Y_proba))]
#     X_err = [np.abs(X_true[n] - X_guessed[n]) for n in range(len(X_true))]
#     Y_err = [np.abs(Y_true[n] - Y_guessed[n]) for n in range(len(Y_true))]
#     Error = [np.sqrt(X_err[n]**2 + Y_err[n]**2) for n in range(len(X_err))]
#     X_standdev = np.sqrt([np.sum([X_proba[n][x]*(Bins[0][x]-X_guessed[n])**2 for x in range(Bins[0].size)]) for n in range(len(position_proba))])
#     Y_standdev = np.sqrt([np.sum([Y_proba[n][y]*(Bins[1][y]-Y_guessed[n])**2 for y in range(Bins[1].size)]) for n in range(len(position_proba))])
#     Standdev   = np.sqrt(np.power(X_standdev,2) + np.power(Y_standdev,2))

#     temp = Standdev
#     temp2 = temp.argsort()
#     thresh = temp[temp2[int(len(temp2)*0.2)]]
#     selection = Standdev<thresh
#     frames = np.where(selection)[0]

#     trueLabelsError.append(np.mean(Error))
#     trueLabelsErrorSelection.append(np.mean(np.array(Error)[frames.astype(int)]))


# meanError = []
# meanError20pct = []
# for file in range(len(filesFullFlow)):
#     results = np.load(os.path.expanduser(filesFullFlow[file]))
#     Y_test = results['arr_0']
#     speed = results['arr_1']
#     testOutput = results['arr_2']
#     trainLosses = results['arr_3']
#     block=True
#     lossSelection = .2
#     maxPos = 253.92

#     temp = testOutput[:,2]
#     temp2 = temp.argsort()
#     thresh = temp[temp2[int(len(temp2)*lossSelection)]]
#     selection = testOutput[:,2]<thresh
#     frames = np.where(selection)[0]
    
#     xError = np.abs(testOutput[:,0] - Y_test[:,0])
#     yError = np.abs(testOutput[:,1] - Y_test[:,1])
#     Error = np.array([np.sqrt(xError[n]**2 + yError[n]**2) for n in range(len(xError))])

#     meanError.append(np.nanmean(Error)*maxPos)
#     meanError20pct.append(np.nanmean(Error[frames])*maxPos)

allStdv = []
for group in range(Data['nGroups']):
   for label in range(Data['clustersPerGroup'][group]):
        temp = Data['Rate_functions'][group][label] / Data['Rate_functions'][group][label].sum()
        xStdv = temp.sum(axis=1).std()
        yStdv = temp.sum(axis=0).std()
        allStdv.append(np.sqrt(np.power(xStdv,2) + np.power(yStdv,2)))
# plt.figure(figsize=(15,11))
temp = np.argsort(allStdv)
Bins = Data['Bins']
pmGroup, pmCluster = [], []
for i in range(1,4):
    n = temp[-i-1]
    for group in range(Data['nGroups']):
        if n < len(Data['Rate_functions'][group]):
            pmGroup.append(group)
            pmCluster.append(n)
            plt.figure()
            plt.imshow(Data['Rate_functions'][group][n] / Data['Rate_functions'][group][n].sum(), extent=[Bins[1][0],Bins[1][-1],Bins[0][-1],Bins[0][0]], cmap='jet')
            plt.plot([125,170,170,215,215,210,60,45,45,90,90], [35,70,110,210,225,250,250,225,210,110,35], color="white")
            plt.plot([125,125,115,90,90,115,125], [100,215,225,220,185,100,100], color="white")
            n = 135; nn=2*n
            plt.plot([nn-125,nn-125,nn-115,nn-90,nn-90,nn-115,nn-125], [100,215,225,220,185,100,100], color="white")
            plt.savefig(os.path.expanduser('~/Dropbox/Mobs_member/Thibault/Poster Chicago Thibault/newPlaceMap'+str(i)+'.png'), bbox_inches='tight')
            break
        else:
            n -= len(Data['Rate_functions'][group])
plt.show()
# for col in range(6):
#     if col != 0:
#         Data = np.load('/home/mobshamilton/Documents/dataset/RatCatanese/mobsEncoding_2019-10-01_shuffledSpikes'+str(500*col)+'ms/_data.npy').item()
#     for row in range(5):
#         ax = plt.subplot2grid((5,6),(row,col))
#         ax.imshow(Data['Rate_functions'][pmGroup[row]][pmCluster[row]] /Data['Rate_functions'][pmGroup[row]][pmCluster[row]].sum(),cmap=plt.get_cmap('jet'))
#         ax.axis("off")
#         if row == 0:
#             ax.title.set_text('shuffling '+str(500*col)+'ms')
# plt.figure()
# plt.plot(x, meanError, label='mean error (CNN + LSTM)')
# plt.plot(x[:len(bayesMeanError)], bayesMeanError, label='mean error (CNN + bayesian)')
# plt.plot(x, bayesFlowErrorShuffledPosition, label='mean error when shuffling position (CNN + bayesian)')
# plt.plot(x[:len(trueLabelsError)], trueLabelsError, label='mean error (spk sorting + bayesian)')
# plt.ylabel('mean error')
# plt.xlabel('random shuffling in ms')
# plt.title('mean error when displacing spikes (all time bins)')
# plt.legend()
# plt.figure()
# plt.plot(x, meanError20pct, label='mean error (CNN + LSTM)')
# plt.plot(x[:len(bayesMeanError)], bayesMeanErrorSelection, label='mean error (CNN + bayesian)')
# plt.plot(x[:len(trueLabelsError)], trueLabelsErrorSelection, label='mean error (spk sorting + bayesian)')
# plt.legend()
# plt.ylabel('mean error')
# plt.xlabel('random shuffling in ms')
# plt.title('mean error when displacing spikes (selected bins)')
# plt.show()

# plt.figure(figsize=(15,9))
# n=0;lw=2;titles=['no shuffling', 'shuffling 500ms', 'shuffling 2000ms']
# for file in [0,6,-1]:
#     ax2 = plt.subplot2grid((3,1),(n,0))
#     print(filesBayesFlow[file])
#     Bins = Data['Bins']
#     Results = np.load(os.path.expanduser(filesBayesFlow[file]))
#     position_proba = Results['position_proba']
#     position = Results['position'].tolist()

#     X_proba = [np.sum(position_proba[n,:,:], axis=1) for n in range(len(position_proba))]
#     Y_proba = [np.sum(position_proba[n,:,:], axis=0) for n in range(len(position_proba))]

#     X_true = [position[n][0] for n in range(len(position))]
#     Y_true = [position[n][1] for n in range(len(position))]
#     X_guessed = [np.average( Bins[0], weights=X_proba[n] ) for n in range(len(X_proba))]
#     Y_guessed = [np.average( Bins[1], weights=Y_proba[n] ) for n in range(len(Y_proba))]
#     X_err = [np.abs(X_true[n] - X_guessed[n]) for n in range(len(X_true))]
#     Y_err = [np.abs(Y_true[n] - Y_guessed[n]) for n in range(len(Y_true))]
#     Error = [np.sqrt(X_err[n]**2 + Y_err[n]**2) for n in range(len(X_err))]
#     X_standdev = np.sqrt([np.sum([X_proba[n][x]*(Bins[0][x]-X_guessed[n])**2 for x in range(Bins[0].size)]) for n in range(len(position_proba))])
#     Y_standdev = np.sqrt([np.sum([Y_proba[n][y]*(Bins[1][y]-Y_guessed[n])**2 for y in range(Bins[1].size)]) for n in range(len(position_proba))])
#     Standdev   = np.sqrt(np.power(X_standdev,2) + np.power(Y_standdev,2))

#     temp = Standdev
#     temp2 = temp.argsort()
#     thresh = temp[temp2[int(len(temp2)*0.2)]]
#     selection = np.array(Standdev)<thresh

#     ax2.plot(np.where(selection)[0]*0.036, np.array(Y_guessed)[selection], color='xkcd:dark pink', markersize=10, label='inferred position', linewidth=lw)
#     ax2.plot([n*0.036 for n in range(len(position))], np.array(position)[:,1], label='true position', color='k', linewidth=lw)
#     ax2.legend(loc="lower right", fontsize=10)
#     ax2.title.set_text(titles[n])
#     n+=1
# plt.show()
# sys.exit(0)





# try:
#     print(Data.keys())
# except:
#     Data = np.load('/home/mobshamilton/Documents/dataset/RatCatanese/mobsEncoding_2019-05-06_15:10/_data.npy').item()
# Bins = Data['Bins']
# X_guessed, Y_guessed, X_true, Y_true, Error, position_proba = [],[],[],[],[],[]
# # true, CNN
# for file in ['/home/mobshamilton/Documents/dataset/RatCatanese/mobsEncoding_2019-10-04_shuffledTrueLabels/_simDecodingUnshuffled.npz', '/home/mobshamilton/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecodingUnshuffled.npz']:
#     Results = np.load(os.path.expanduser(file))
#     position_proba.append(Results['position_proba'])
#     position = Results['position'].tolist()
#     for n in range(len(position_proba[-1])):
#         if np.sum(position_proba[-1][n,:,:])==0.0:
#             position_proba[-1][n,:,:] = np.ones([45,45]) / np.sum([45,45])

#     X_proba = [np.sum(position_proba[-1][n,:,:], axis=1) for n in range(len(position_proba[-1]))]
#     Y_proba = [np.sum(position_proba[-1][n,:,:], axis=0) for n in range(len(position_proba[-1]))]

#     X_true.append( [position[n][0] for n in range(len(position))])
#     Y_true.append( [position[n][1] for n in range(len(position))])
#     X_guessed.append( [np.average( Bins[0], weights=X_proba[n] ) for n in range(len(X_proba))])
#     Y_guessed.append( [np.average( Bins[1], weights=Y_proba[n] ) for n in range(len(Y_proba))])
#     X_err = [np.abs(X_true[-1][n] - X_guessed[-1][n]) for n in range(len(X_true[-1]))]
#     Y_err = [np.abs(Y_true[-1][n] - Y_guessed[-1][n]) for n in range(len(Y_true[-1]))]
#     Error.append([np.sqrt(X_err[n]**2 + Y_err[n]**2) for n in range(len(X_err))])
#     X_standdev = np.sqrt([np.sum([X_proba[n][x]*(Bins[0][x]-X_guessed[-1][n])**2 for x in range(Bins[0].size)]) for n in range(len(position_proba))])
#     Y_standdev = np.sqrt([np.sum([Y_proba[n][y]*(Bins[1][y]-Y_guessed[-1][n])**2 for y in range(Bins[1].size)]) for n in range(len(position_proba))])
#     Standdev   = np.sqrt(np.power(X_standdev,2) + np.power(Y_standdev,2))

#     temp = Standdev
#     temp2 = temp.argsort()
#     thresh = temp[temp2[int(len(temp2)*0.2)]]
#     selection = np.array(Standdev)<thresh
# disagreement = np.abs(np.array(Error[0]) - np.array(Error[1]))
# plt.plot(Error[0], label='decoding error (spk sorting + bayesian)')
# plt.plot(Error[1], label='decoding error (CNN + bayesian)')
# plt.plot(disagreement, label='difference')
# plt.legend(loc="upper right")
# plt.figure()
# _,edges,_=plt.hist(disagreement, bins=100, alpha=0.5, edgecolor='k')
# plt.hist(Error[1], bins=edges, alpha=0.5, edgecolor='k')


# unAgreeableBins = np.where(disagreement > np.mean(disagreement))[0]
# print(np.mean(np.array(Error[0])[unAgreeableBins]))
# print(np.mean(np.array(Error[1])[unAgreeableBins]))

# for n in range(len(unAgreeableBins)):
#     plt.figure(figsize=(10,20))
#     ax = plt.subplot2grid((2,1),(0,0))
#     plt.imshow(position_proba[0][unAgreeableBins[n]],extent=[Bins[1][0],Bins[1][-1],Bins[0][-1],Bins[0][0]])
#     plt.plot([Y_true[0][unAgreeableBins[n]]],[X_true[0][unAgreeableBins[n]]], marker='o', color='r', markersize=15)
#     ax.title.set_text("sorted spikes")
#     ax = plt.subplot2grid((2,1),(1,0))
#     plt.imshow(position_proba[1][unAgreeableBins[n]],extent=[Bins[1][0],Bins[1][-1],Bins[0][-1],Bins[0][0]])
#     plt.plot([Y_true[0][unAgreeableBins[n]]],[X_true[0][unAgreeableBins[n]]], marker='o', color='r', markersize=15)
#     ax.title.set_text("CNN")
#     plt.show(block=True)
bbbb


# def timedelta_to_ms(timedelta):
#     ms = 0
#     ms = ms + 3600*24*1000*timedelta.days
#     ms = ms + 1000*timedelta.seconds
#     ms = ms + timedelta.microseconds/1000
#     return ms
# Results = np.load('/home/mobshamilton/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_simDecoding.npz')
# times = Results['times']
# fig = plt.figure(figsize=(15,9))
# plt.hist(times[1:],bins=100, alpha=0.5,edgecolor='k', label='Model: classifier + statistical inference')

# Results = np.load('/home/mobshamilton/Documents/dataset/RatCatanese/_resultsForRnn_2019-10-10_normalWithTimeStamps.npz')
# times = Results['times']
# plt.hist(times[1:],bins=100, alpha=0.5,edgecolor='k', label='Model: classifier + LSTM')
# plt.xlabel('computing time in ms', fontsize=20)
# plt.legend(fontsize=25, loc="upper right")
# fig.axes[0].tick_params(axis="x", labelsize=17)
# plt.savefig(os.path.expanduser('~/Dropbox/Mobs_member/Thibault/Poster Chicago Thibault/bayesComputingTime.png'), bbox_inches='tight')
# plt.show(block=False)








results = np.load(os.path.expanduser(file))
Y_test = results['arr_0']
speed = results['arr_1']
testOutput = results['arr_2']
trainLosses = results['arr_3']
block=True
lossSelection = .2
maxPos = 253.92

temp = testOutput[:,2]
temp2 = temp.argsort()
thresh = temp[temp2[int(len(temp2)*lossSelection)]]
selection = testOutput[:,2]<thresh
frames = np.where(selection)[0]

fig = plt.figure(figsize=(8,8))
plt.plot(trainLosses[:,0]) 
plt.plot(trainLosses[:,1]) 
# plt.show(block=block)


# # ERROR & STD
xError = np.abs(testOutput[:,0] - Y_test[:,0])
yError = np.abs(testOutput[:,1] - Y_test[:,1])
Error = np.array([np.sqrt(xError[n]**2 + yError[n]**2) for n in range(len(xError))])

def scattWithError(metric, label):
    xy = np.vstack([Error, metric])
    z = gaussian_kde(xy)(xy)
    fig, ax1 = plt.subplots(figsize=(15,15))
    # ax1 = plt.subplot2grid((3,1),(0,0), rowspan=2)
    ax1.scatter(Error, metric[:], c=z, s=13, label='error and inferred error for each time bin')
    # ax1.axhline(thresh, color='k', label='selection threshold')

    ax1.set_ylabel(label, fontsize=25)
    ax1.set_xlabel('true error', fontsize=25)
    # ax1.legend()
    # plt.suptitle('Decoding error vs inferred error',size=20)

    ax2 = ax1
    # ax2 = plt.subplot2grid((3,1),(2,0), sharex=ax1)
    nBins = 20
    _, edges = np.histogram(Error, nBins)
    histIdx = []
    for bin in range(nBins):
        temp=[]
        for n in range(len(Error)):
            if Error[n]<=edges[bin+1] and Error[n]>edges[bin]:
                temp.append(n)
        histIdx.append(temp)
    err=np.array([
        [np.median(metric[histIdx[n]])-np.percentile(metric[histIdx[n]],30) for n in range(nBins)],
        [np.percentile(metric[histIdx[n]],70)-np.median(metric[histIdx[n]]) for n in range(nBins)]])
    coeff, var_matrix = curve_fit(
        parabola, 
        [(edges[n+1]+edges[n])/2 for n in range(nBins)], 
        [np.median(metric[histIdx[n]]) for n in range(nBins)], 
        p0=[-1,0,.5])
    # print(coeff)
    # print(var_matrix)
    ax2.errorbar(
        [(edges[n+1]+edges[n])/2 for n in range(nBins)],
        [np.median(metric[histIdx[n]]) for n in range(nBins)], c='xkcd:cherry red', 
        yerr = err, 
        label=r'$median \pm 20 percentile$',
        linewidth=3)
    # ax2.errorbar(
    #     [(edges[n+1]+edges[n])/2 for n in range(nBins)],
    #     [np.mean(metric[histIdx[n]]) for n in range(nBins)],
    #     yerr=np.array([np.std(metric[histIdx[n]]) for n in range(nBins)])/np.array([np.sqrt(len(histIdx[n])) for n in range(nBins)]),
    #     label=r'$mean \pm \sigma$')
    # ax2.plot(
    #     [(edges[n+1]+edges[n])/2 for n in range(nBins)],
    #     parabola([(edges[n+1]+edges[n])/2 for n in range(nBins)], *coeff),
    #     label='fit of median')
    ax2.legend(loc="upper right", fontsize=25)
    ax2.tick_params(axis="x", labelsize=20)
    ax2.tick_params(axis="y", labelsize=20)
scattWithError(testOutput[:,2], 'inferred error')
# plt.savefig(os.path.expanduser('~/Dropbox/Mobs_member/Thibault/Poster Chicago Thibault/lstmError.png'), bbox_inches='tight')
plt.show(block=block)
scattWithError(speed, 'speed')
# plt.savefig(os.path.expanduser('~/Dropbox/Mobs_member/Thibault/Poster Chicago Thibault/lstmErrorSpeed.png'), bbox_inches='tight')
plt.show(block=block)









### points of lowest speed : bottom right of U shape points to reward locations
tri = np.argsort(speed)
selectionHigh = np.where(np.logical_and(
    speed < speed[tri[2*len(tri)//6]],
    testOutput[:,2] > 0.03))
selectionLowRight = np.where(np.logical_and(
    speed < speed[tri[2*len(tri)//6]],
    np.logical_and(
        testOutput[:,2] < 0.03,
        Error > 0.35)))
selectionLowLeft = np.where(np.logical_and(
    speed < speed[tri[2*len(tri)//6]],
    np.logical_and(
        testOutput[:,2] < 0.03,
        Error < 0.35)))
fig, ax = plt.subplots(figsize=(9,15))
ax1 = plt.subplot2grid((3,2),(0,0))
ax1.scatter(Error[selectionHigh], testOutput[selectionHigh,2], s=5, c='black')
ax1.scatter(Error[selectionLowLeft], testOutput[selectionLowLeft,2], s=5, c='xkcd:light gray')
ax1.scatter(Error[selectionLowRight], testOutput[selectionLowRight,2], s=5, c='xkcd:light gray')
ax1.set_ylabel('evaluated loss')
ax1.set_xlabel('decoding error')

ax2 = plt.subplot2grid((3,2),(1,0), sharex=ax1, sharey=ax1)
ax2.scatter(Error[selectionLowLeft], testOutput[selectionLowLeft,2], s=5, c='black')
ax2.scatter(Error[selectionHigh], testOutput[selectionHigh,2], s=5, c='xkcd:light gray')
ax2.scatter(Error[selectionLowRight], testOutput[selectionLowRight,2], s=5, c='xkcd:light gray')
ax2.set_ylabel('evaluated loss')
ax2.set_xlabel('decoding error')

ax5 = plt.subplot2grid((3,2),(2,0), sharex=ax1, sharey=ax1)
ax5.scatter(Error[selectionLowRight], testOutput[selectionLowRight,2], s=5, c='black')
ax5.scatter(Error[selectionHigh], testOutput[selectionHigh,2], s=5, c='xkcd:light gray')
ax5.scatter(Error[selectionLowLeft], testOutput[selectionLowLeft,2], s=5, c='xkcd:light gray')
ax5.set_ylabel('evaluated loss')
ax5.set_xlabel('decoding error')

# plt.tight_layout()
# plt.savefig(os.path.expanduser('~/Pictures/_tempFig.png'), bbox_inches='tight')


ax3 = plt.subplot2grid((3,2),(0,1))
ax3.scatter(testOutput[selectionHigh,1]*maxPos, testOutput[selectionHigh,0]*maxPos, marker='P',color='green',label='guessed position')
ax3.scatter(Y_test[selectionHigh,1]*maxPos, Y_test[selectionHigh,0]*maxPos, marker='o',color='red',label='true position')
ax3.plot([125,170,170,215,215,210,60,45,45,90,90], [35,70,110,210,225,250,250,225,210,110,35], color="red")
ax3.plot([125,125,115,90,90,115,125], [100,215,225,220,185,100,100], color="red")
n = 135; nn=2*n
ax3.plot([nn-125,nn-125,nn-115,nn-90,nn-90,nn-115,nn-125], [100,215,225,220,185,100,100], color="red")
ax3.legend()

ax4 = plt.subplot2grid((3,2),(1,1))
ax4.scatter(testOutput[selectionLowLeft,1]*maxPos, testOutput[selectionLowLeft,0]*maxPos, marker='P',color='green',label='guessed position')
ax4.scatter(Y_test[selectionLowLeft,1]*maxPos, Y_test[selectionLowLeft,0]*maxPos, marker='o',color='red',label='true position')
ax4.plot([125,170,170,215,215,210,60,45,45,90,90], [35,70,110,210,225,250,250,225,210,110,35], color="red")
ax4.plot([125,125,115,90,90,115,125], [100,215,225,220,185,100,100], color="red")
n = 135; nn=2*n
ax4.plot([nn-125,nn-125,nn-115,nn-90,nn-90,nn-115,nn-125], [100,215,225,220,185,100,100], color="red")
ax4.legend()

ax6 = plt.subplot2grid((3,2),(2,1))
ax6.scatter(testOutput[selectionLowRight,1]*maxPos, testOutput[selectionLowRight,0]*maxPos, marker='P',color='green',label='guessed position')
ax6.scatter(Y_test[selectionLowRight,1]*maxPos, Y_test[selectionLowRight,0]*maxPos, marker='o',color='red',label='true position')
ax6.plot([125,170,170,215,215,210,60,45,45,90,90], [35,70,110,210,225,250,250,225,210,110,35], color="red")
ax6.plot([125,125,115,90,90,115,125], [100,215,225,220,185,100,100], color="red")
n = 135; nn=2*n
ax6.plot([nn-125,nn-125,nn-115,nn-90,nn-90,nn-115,nn-125], [100,215,225,220,185,100,100], color="red")
ax6.legend()

plt.suptitle('Points of lowest speed (33%) : \nbottom right of U shape points to reward locations', size=20)
# plt.savefig(os.path.expanduser('~/Pictures/_tempAmbivalentDecoding.png'), bbox_inches='tight')








print('mean error is:', np.mean(Error))
print('mean error is:', np.mean(Error)*maxPos)
tri = np.argsort(testOutput[:,2])
Selected_errors = np.array([ 
        np.mean(Error[ tri[0:1*len(tri)//10] ]), 
        np.mean(Error[ tri[1*len(tri)//10:2*len(tri)//10] ]),
        np.mean(Error[ tri[2*len(tri)//10:3*len(tri)//10] ]),
        np.mean(Error[ tri[3*len(tri)//10:4*len(tri)//10] ]),
        np.mean(Error[ tri[4*len(tri)//10:5*len(tri)//10] ]),
        np.mean(Error[ tri[5*len(tri)//10:6*len(tri)//10] ]),
        np.mean(Error[ tri[6*len(tri)//10:7*len(tri)//10] ]),
        np.mean(Error[ tri[7*len(tri)//10:8*len(tri)//10] ]),
        np.mean(Error[ tri[8*len(tri)//10:9*len(tri)//10] ]),
        np.mean(Error[ tri[9*len(tri)//10:len(tri)]       ]) ])
print("----Selected errors----")
print(Selected_errors)



#selection is good
fig = plt.figure(figsize=(15,9))
_, edges, _ = plt.hist(Error, 150, label='error for all points (n='+str(len(Error))+')', density=True, alpha=0.5, edgecolor='k')
plt.hist(Error[selection], bins=edges, label='error for selected points (n='+str(len(Error[selection]))+')', density=True, alpha=0.5, edgecolor='k')
plt.suptitle('Normalized error histogram for all points and selected points',size=20)
plt.legend()


# Overview
lw=5
fig, ax1 = plt.subplots(figsize=(20,12))
# ax1 = plt.subplot2grid((2,1),(0,0))
# ax1.plot(testOutput[:,0], label='guessed X')
# ax1.plot(np.where(selection)[0], testOutput[selection,0], linestyle='', marker='.', color='k', markersize=10, label='guessed X selection')
ax1.plot(np.where(selection)[0]*0.036, testOutput[selection,0]+0.8, color='xkcd:dark pink', markersize=10, label=None, linewidth=lw)
ax1.plot([n*0.036 for n in range(len(Y_test))], Y_test[:,0]+0.8, label=None, color='k', linewidth=lw)
# ax1.legend()
ax1.axis('off')
# ax1.set_title('position X')

ax2 = ax1
# ax2 = plt.subplot2grid((2,1),(1,0), sharex=ax1)
# ax2.plot(testOutput[:,1], label='guessed Y')
# ax2.plot(np.where(selection)[0], testOutput[selection,1], linestyle='', marker='.', color='k', markersize=10, label='guessed Y selection')
ax2.plot(np.where(selection)[0]*0.036, testOutput[selection,1], color='xkcd:dark pink', markersize=10, label='inferred position', linewidth=lw)
ax2.plot([n*0.036 for n in range(len(Y_test))], Y_test[:,1], label='true position', color='k', linewidth=lw)
ax2.legend(loc="lower right", fontsize=25)
ax2.axis('off')
plt.xlim(100,170)
plt.savefig(os.path.expanduser('~/Dropbox/Mobs_member/Thibault/Poster Chicago Thibault/lstmResults.png'), bbox_inches='tight')
# ax2.set_title('position Y')

# plt.show(block=block)


### Sequences of error
bound = [-20,20]
allLocalisedError = []
selectedLocalisedError = []
for n in range(len(selection)):
    if n < bound[1]:
        continue
    if n >= len(selection)+bound[0]:
        break
    
    if selection[n]:
        selectedLocalisedError += [Error[n+bound[0]:n+bound[1]].copy()]
    allLocalisedError += [Error[n+bound[0]:n+bound[1]].copy()]
selectedLocalisedError = np.array(selectedLocalisedError)
allLocalisedError = np.array(allLocalisedError)

fig,ax = plt.subplots(figsize=(15,9))
ax.errorbar(np.array([n for n in range(bound[0],bound[1])])*0.036, 
    selectedLocalisedError.mean(axis=0), 
    yerr=selectedLocalisedError.std(axis=0)/np.sqrt(selectedLocalisedError.shape[0]),
    label='selected errors')
ax.axhline(np.mean(Error), linestyle='-', color='k', label='mean error')
ax.axhline(np.mean(Error) + np.std(Error)/np.sqrt(len(Error)), linestyle='--', color='k')
ax.axhline(np.mean(Error) - np.std(Error)/np.sqrt(len(Error)), linestyle='--', color='k')
ax.errorbar(np.array([n for n in range(bound[0],bound[1])])*0.036, 
    allLocalisedError.mean(axis=0), 
    yerr=allLocalisedError.std(axis=0)/np.sqrt(allLocalisedError.shape[0]),
    label='all errors')
ax.legend()
plt.suptitle('Sequences of error: error of neighbooring points', size=20)
ax.set_xlabel('time in seconds')
ax.set_ylabel('error')
plt.show(block=block)



# # Movie
# fig, ax = plt.subplots(figsize=(10,10))
# ax1 = plt.subplot2grid((1,1),(0,0))
# im2, = ax1.plot([Y_test[0,1]*maxPos],[Y_test[0,0]*maxPos],marker='o', markersize=15, color="red")
# im2b, = ax1.plot([testOutput[0,1]*maxPos],[testOutput[0,0]*maxPos],marker='P', markersize=15, color="green")

# im3 = ax1.plot([125,170,170,215,215,210,60,45,45,90,90], [35,70,110,210,225,250,250,225,210,110,35], color="red")
# im4 = ax1.plot([125,125,115,90,90,115,125], [100,215,225,220,185,100,100], color="red")
# n = 135; nn=2*n
# im4 = ax1.plot([nn-125,nn-125,nn-115,nn-90,nn-90,nn-115,nn-125], [100,215,225,220,185,100,100], color="red")
# ax1.set_title('Decoding using full stack decoder', size=25)
# ax1.get_xaxis().set_visible(False)
# ax1.get_yaxis().set_visible(False)

# def updatefig(frame, *args):
#     reduced_frame = frame % len(frames)
#     selected_frame = frames[reduced_frame]
#     im2.set_data([Y_test[selected_frame,1]*maxPos],[Y_test[selected_frame,0]*maxPos])
#     im2b.set_data([testOutput[selected_frame,1]*maxPos],[testOutput[selected_frame,0]*maxPos])
#     return im2,im2b

# save_len = len(frames)
# ani = animation.FuncAnimation(fig,updatefig,interval=250, save_count=save_len)
# fig.show()

