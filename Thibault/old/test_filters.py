import scipy
from scipy import signal
from scipy import io
import numpy as np
import math
import struct
import bisect
import datetime
import matplotlib as mpl 
import matplotlib.pyplot as plt

def timedelta_to_ms(timedelta):
    ms = 0
    ms = ms + 3600*24*1000*timedelta.days
    ms = ms + 1000*timedelta.seconds
    ms = ms + timedelta.microseconds/1000
    return ms

def timedelta_to_s(timedelta):
    return timedelta_to_ms(timedelta)/1000

def order1highpass(fe, fc):
    Te = 1/fe
    w = 2*math.pi*fc
    wc = 2*math.tan(w*Te/2)/Te
    C = wc*Te/2
    a = [1.0, (C-1)/(C+1)]
    b = [1/(C+1), -1/(C+1)]

    return b, a


def order2highpass(fe, fc, Q):
    Te = 1/fe
    w = 2*math.pi*fc
    wc = 2*math.tan(w*Te/2)/Te
    C1 = 2/(Q*Te*wc)
    C2 = 4/(Te*Te*wc*wc)
    C0 = 1 + C1 + C2
    b = [C2/C0, -2*C2/C0, C2/C0]
    a = [1.0, (2-2*C2)/C0, (1+C2-C1)/C0]

    return b, a

def order2bandpass(fe, fc1, fc2, Q):
    Te = 1/fe
    fc = (fc1+fc2)/2
    w = 2*math.pi*fc
    wc = 2*math.tan(w*Te/2)/Te
    C1 = 2*Q/(Te*wc)
    C2 = Te*Q*wc/2;
    C0 = 1+C1 + C2
    b = [1/C0, 0.0, -1/C0]
    a = [1.0, (2*C2-2*C1)/C0, (C0-2)/C0]

    return b, a

def meanDownSample(signal, downsampledFreq):
    n = int(20000//downsampledFreq)
    end = n * int(len(signal)/n)
    return np.mean(signal[:end].reshape(-1, n), 1)

def preProcess(signal, downsampledFreq):
    gammaFilter = scipy.signal.firwin(333, [50,70], pass_zero=False, nyq=downsampledFreq/2)
    return scipy.signal.filtfilt( gammaFilter, [1.0], meanDownSample(signal,downsampledFreq) )

def gammaPower(signal):

    downsampledFreq = 321.5
    downSampledSignal = preProcess(signal, downsampledFreq)
    

    signalLength = len(downSampledSignal)
    windowLength = 3. # in seconds
    windowSamples = int(windowLength * downsampledFreq)
    filteredSignal = np.zeros(signalLength)

    for spl in range(len(filteredSignal)):
        if spl < windowSamples - 1:
            continue
        elif spl == windowSamples - 1:
            window = [downSampledSignal[i] for i in range(windowSamples)]
            window.reverse()
        else:
            window.pop()
            window.insert(0, downSampledSignal[spl])

        filteredSignal[spl] = math.log10(np.mean(np.abs(scipy.signal.hilbert(window))))
    
    return filteredSignal

def medianFilter(signal, N):

    signalLength = len(signal)
    filteredSignal = np.zeros(signalLength)

    for spl in range(signalLength):

        if spl < N:
            window = [signal[0]] * (N-spl-1)
            window = window + list(signal[0:spl+2+N])
            window.sort()

        elif spl > signalLength - N - 2:
            window = [signal[signalLength-1]] * (N+spl-signalLength+2)
            window = list(signal[spl-N+1:signalLength]) + window
            window.sort()

        else:
            # window.pop(window.index(signal[spl-N]))
            window.pop( bisect.bisect_left(window, signal[spl-N]) )
            bisect.insort(window, signal[spl+1+N])
        
        # print(window)
        filteredSignal[spl] = window[N]

        if spl % 50000 == 0:
            print('filtering, sample '+str(spl))

    return filteredSignal

def INTANfilter(signal, cutoff):
    signalLength = len(signal)
    filteredSignal = np.zeros(signalLength)
    a = math.exp(-2*math.pi*cutoff/20000)
    b = 1-a

    filterState = 0

    for spl in range(signalLength):
        filteredSignal[spl] = signal[spl] - filterState
        filterState = a*filterState + b*signal[spl]

    return filteredSignal






    
wn = [400/10000, 9000/10000];
wp = [350/10000, 7500/10000];
ws = [250/10000, 8500/10000];

N = 5;
gpass = 0.1;
gstop = 50;


b1, a1 = order1highpass(20000, 300)
b2, a2 = order2highpass(20000, 300, 100)
bb, ab = order2bandpass(20000, 300, 6000, 0.5)
bf, af = scipy.signal.iirfilter(N, wn)
bd, ad = scipy.signal.iirdesign(wp,ws,gpass,gstop)

mdict = {'bandpassNa': af,
         'bandpassNb': bf,
         'designa':ad,
         'designb':bd,
         'bandpass2a': ab,
         'bandpass2b': bb}
scipy.io.savemat('/home/mobshamilton/Documents/dataset/Mouse-509/filters.mat', mdict)


[W1, h1] = scipy.signal.freqz(b1,a1)
[W2, h2] = scipy.signal.freqz(b2,a2)
[Wb, hb] = scipy.signal.freqz(bb,ab)
[Wf, hf] = scipy.signal.freqz(bf,af)
[Wd, hd] = scipy.signal.freqz(bd,ad)

# plt.figure(figsize=(15,15))
# plt.plot(W1/(2*math.pi), 20*np.log10(np.abs(h1)),color='xkcd:baby blue', label='order 1 highpass')
# plt.plot(W2/(2*math.pi), 20*np.log10(np.abs(h2)),color='xkcd:blue', label='order 2 highpass')
# plt.plot(Wb/(2*math.pi), 20*np.log10(np.abs(hb)),color='xkcd:dark blue', label='order 2 bandpass')
# plt.plot(Wf/(2*math.pi), 20*np.log10(np.abs(hf)),'g', label='order '+str(N)+' bandpass')
# plt.plot(Wd/(2*math.pi), 20*np.log10(np.abs(hd)),'r', label='test design')
# plt.legend(loc='lower left')
# plt.xlabel('f/fe')
# plt.ylabel('GdB')
# plt.grid()
# plt.show()




b = bd
a = ad
clu_path = '/home/mobshamilton/Documents/dataset/Mouse-509/ProjectEmbReact_M509_20170204_Habituation.'
# clu_path = '/home/mobshamilton/Documents/dataset/Mouse-743-all/ERC-Mouse-743-01062018-Hab_SpikeRef.'
Nchannels = 71
n_sample = 1200000
tetrode = 1
samplingRate = 20000
thresholdFactor = 1.1
windowHalfSize = 10


with open(
            clu_path + 'clu.' + str(tetrode), 'r') as fClu, open(
            clu_path + 'res.' + str(tetrode), 'r') as fRes, open(
            clu_path + 'spk.' + str(tetrode), 'rb') as fSpk:
    clu_str = fClu.readlines()
    res_str = fRes.readlines()
    n_clu = int(clu_str[0])-1
    n_channels = 4
    spikeReader = struct.iter_unpack(str(32*n_channels)+'h', fSpk.read())

    labels = np.array([[1. if int(clu_str[n+1])==l else 0. for l in range(n_clu+1)] for n in range(len(clu_str)-1)])
    spike_time = np.array([[float(res_str[n])/samplingRate] for n in range(len(clu_str)-1)])
    n=0
    spikes = []
    for it in spikeReader:
        spike = np.reshape(np.array(it), [32,n_channels])
        spikes.append(np.transpose(spike))
        n = n+1
    spikes = np.array(spikes, dtype=float)



with open(clu_path + 'dat', 'rb') as fDat:
    datReader = struct.iter_unpack(str(Nchannels)+'h', fDat.read())

    
    n=0
    allChannels = []
    for it in datReader:
        data = np.array(it)
        allChannels.append(np.transpose(data))
        n = n + 1
        if n % 50000 == 0:
            print('still going, sample '+str(n))
        if n == n_sample:
            break
    allChannels = np.array(allChannels, dtype=float)
    plotchannel1 = allChannels[:, 0]
    plotchannel2 = allChannels[:, 1]
    plotchannel3 = allChannels[:, 2]
    plotchannel4 = allChannels[:, 3]

# with open(clu_path + 'fil', 'rb') as fFil:
#     filReader = struct.iter_unpack(str(Nchannels)+'h', fFil.read())

    
#     n=0
#     allFiltered = []
#     for it in filReader:
#         data = np.array(it)
#         allFiltered.append(np.transpose(data))
#         n = n + 1
#         if n % 50000 == 0:
#             print('still going, sample '+str(n))
#         if n == n_sample:
#             break
#     allFiltered = np.array(allFiltered, dtype=float)
#     plotchannel1 = allFiltered[:, 0]
#     plotchannel2 = allFiltered[:, 1]
#     plotchannel3 = allFiltered[:, 2]
#     plotchannel4 = allFiltered[:, 3]



spikeSelection = np.array(spike_time[np.where(spike_time[:,0]*samplingRate<n_sample)]*samplingRate, dtype=int)

channel1 = allChannels[:, 0]
channel2 = allChannels[:, 1]
channel3 = allChannels[:, 2]
channel4 = allChannels[:, 3]
# channels = [0,1,2,3,4,5,6,7,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,56,57,58,59,60,61,62,63]
# MEAN = np.mean(allChannels[:, channels], 1)
# channel1 = channel1 - MEAN
# channel2 = channel2 - MEAN
# channel3 = channel3 - MEAN
# channel4 = channel4 - MEAN
# zi =   scipy.signal.lfilter_zi(b,a)
# z1, _ = scipy.signal.lfilter(b, a, channel1, zi=zi*channel1[0])
# zi =   scipy.signal.lfilter_zi(b,a)
# z2, _ = scipy.signal.lfilter(b, a, channel2, zi=zi*channel2[0])
# zi =   scipy.signal.lfilter_zi(b,a)
# z3, _ = scipy.signal.lfilter(b, a, channel3, zi=zi*channel3[0])
# zi =   scipy.signal.lfilter_zi(b,a)
# z4, _ = scipy.signal.lfilter(b, a, channel4, zi=zi*channel4[0])
CLOCK1 = datetime.datetime.now()
# z1 = channel1 - medianFilter(channel1, windowHalfSize)
# z2 = channel2 - medianFilter(channel2, windowHalfSize)
# z3 = channel3 - medianFilter(channel3, windowHalfSize)
# z4 = channel4 - medianFilter(channel4, windowHalfSize)
# zz1 = INTANfilter(channel1, 350.)
# zz2 = INTANfilter(channel2, 350.)
# zz3 = INTANfilter(channel3, 350.)
# zz4 = INTANfilter(channel4, 350.)
z1 = gammaPower(channel1)
z2 = gammaPower(channel2)
z3 = gammaPower(channel3)
z4 = gammaPower(channel4)
CLOCK2 = datetime.datetime.now()
duration = timedelta_to_s(CLOCK2 - CLOCK1)/(4*n_sample/(20000*60))
print('Filtering took : ', str(duration), 'sec per minute per channel')
threshold1 = np.sqrt(np.mean(z1**2))*thresholdFactor
threshold2 = np.sqrt(np.mean(z2**2))*thresholdFactor
threshold3 = np.sqrt(np.mean(z3**2))*thresholdFactor
threshold4 = np.sqrt(np.mean(z4**2))*thresholdFactor



fig, ax = plt.subplots(figsize=(50,50))

ax2 = plt.subplot2grid((2,2),(0,0))
ax2.plot(plotchannel1)
ax2.plot(z1)

ax3 = plt.subplot2grid((2,2),(1,0), sharex=ax2, sharey=ax2)
ax3.plot(plotchannel2)
ax3.plot(z2)

ax1 = plt.subplot2grid((2,2),(0,1), sharex=ax2, sharey=ax2)
ax1.plot(plotchannel3)
ax1.plot(z3)

ax4 = plt.subplot2grid((2,2),(1,1), sharex=ax2, sharey=ax2)
ax4.plot(plotchannel4)
ax4.plot(z4)

plt.show()

# def compare():
#     spikeint=0
#     while 1:
#         fig, ax = plt.subplots(figsize=(50,50))
#         ax1 = plt.subplot2grid((4,3),(0,0))
#         ax2 = plt.subplot2grid((4,3),(1,0))
#         ax3 = plt.subplot2grid((4,3),(2,0))
#         ax4 = plt.subplot2grid((4,3),(3,0))
#         ax5 = plt.subplot2grid((4,3),(0,1))
#         ax6 = plt.subplot2grid((4,3),(1,1))
#         ax7 = plt.subplot2grid((4,3),(2,1))
#         ax8 = plt.subplot2grid((4,3),(3,1))
#         ax9 = plt.subplot2grid((4,3),(0,2))
#         ax10= plt.subplot2grid((4,3),(1,2))
#         ax11= plt.subplot2grid((4,3),(2,2))
#         ax12= plt.subplot2grid((4,3),(3,2))

#         ax1.set_title('Spike sorting')
#         ax1.plot(spikes[spikeint,0,:])
#         ax2.plot(spikes[spikeint,1,:])
#         ax3.plot(spikes[spikeint,2,:])
#         # ax4.plot(spikes[spikeint,3,:])

#         ax5.set_title('Median based filter')
#         # ax5.plot(z1[spikeSelection[spikeint,0]-15:spikeSelection[spikeint,0]+17])
#         ax6.plot(z2[spikeSelection[spikeint,0]-15:spikeSelection[spikeint,0]+17])
#         ax7.plot(z3[spikeSelection[spikeint,0]-15:spikeSelection[spikeint,0]+17])
#         ax8.plot(z4[spikeSelection[spikeint,0]-15:spikeSelection[spikeint,0]+17])
        
#         ax9.set_title('INTAN filter')
#         # ax9.plot(zz1[spikeSelection[spikeint,0]-15:spikeSelection[spikeint,0]+17])
#         ax10.plot(zz2[spikeSelection[spikeint,0]-15:spikeSelection[spikeint,0]+17])
#         ax11.plot(zz3[spikeSelection[spikeint,0]-15:spikeSelection[spikeint,0]+17])
#         ax12.plot(zz4[spikeSelection[spikeint,0]-15:spikeSelection[spikeint,0]+17])


#         # plt.show()

#         yield fig
#         spikeint = spikeint + 1

# generator = compare()


# print('There was '+str(len(spikeSelection))+' found previously')

# oldThreshold = 0.
# threshold1 = np.sqrt(np.mean(zz1**2))*thresholdFactor
# while True:
#     spl = 0
#     spikeTest = []
#     spikeTest.append(0)
#     while spl < (len(zz1)):
#         if zz1[spl]>threshold1:
#             temp = np.argmax(zz1[spl:spl+20])
#             if temp != 0 and temp != 19:
#                 spl = temp + spl
#                 if (spl-spikeTest[-1])>17:
#                     spikeTest.append(spl)
#                     spl = spl + 16

#         elif zz1[spl]<(-threshold1):
#             temp = np.argmin(zz1[spl:spl+20])
#             if temp != 0 and temp != 19:
#                 spl = np.argmin(zz1[spl:spl+20]) + spl
#                 if (spl-spikeTest[-1])>17:
#                     spikeTest.append(spl)
#                     spl = spl + 16


#         spl = spl + 1

#     print('We found '+str(len(spikeTest)-1)+' spikes with INTAN')

#     temp = threshold1
#     if np.abs(len(spikeTest)-len(spikeSelection))/len(spikeSelection) < 0.05:
#         break
#     elif len(spikeTest) > len(spikeSelection):
#         if oldThreshold < threshold1:
#             threshold1 = 2*threshold1 - oldThreshold
#         else:
#             threshold1 = threshold1 + (oldThreshold - threshold1)/2
#     else:
#         if oldThreshold < threshold1:
#             threshold1 = oldThreshold + (threshold1 - oldThreshold)/2
#         else:
#             threshold1 = 2*threshold1 - oldThreshold
#     oldThreshold = temp

# print('We found '+str(len(spikeTest)-1)+' spikes with INTAN')


# oldThreshold=0.
# threshold1 = np.sqrt(np.mean(z1**2))*thresholdFactor
# while True:
#     spl = 0
#     spikeTestIntan = []
#     spikeTestIntan.append(0)
#     while spl < (len(z1)):
#         if z1[spl]>threshold1:
#             temp = np.argmax(z1[spl:spl+20])
#             if temp != 0 and temp != 19:
#                 spl = temp + spl
#                 if (spl-spikeTestIntan[-1])>17:
#                     spikeTestIntan.append(spl)
#                     spl = spl + 16

#         elif z1[spl]<(-threshold1):
#             temp = np.argmin(z1[spl:spl+20])
#             if temp != 0 and temp != 19:
#                 spl = temp + spl
#                 if (spl-spikeTestIntan[-1])>17:
#                     spikeTestIntan.append(spl)
#                     spl = spl + 16


#         spl = spl + 1


#     print('We found '+str(len(spikeTestIntan)-1)+' spikes with median')

#     temp = threshold1
#     if np.abs(len(spikeTestIntan)-len(spikeSelection))/len(spikeSelection) < 0.05:
#         break
#     elif len(spikeTestIntan) > len(spikeSelection):
#         if oldThreshold < threshold1:
#             threshold1 = 2*threshold1 - oldThreshold
#         else:
#             threshold1 = threshold1 + (oldThreshold - threshold1)/2
#     else:
#         if oldThreshold < threshold1:
#             threshold1 = oldThreshold + (threshold1 - oldThreshold)/2
#         else:
#             threshold1 = 2*threshold1 - oldThreshold
#     oldThreshold = temp

# print('We found '+str(len(spikeTestIntan)-1)+' spikes with median')