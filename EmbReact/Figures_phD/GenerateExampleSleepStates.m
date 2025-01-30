load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_SleepPost/LFPData/LFP35.mat')
PFC1 = LFP;
PFC1 = FilterLFP(PFC1,[0.5 200],1024);
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_SleepPost/LFPData/LFP47.mat')
PFC2 = LFP;
PFC2 = FilterLFP(PFC2,[0.5 200],1024);

load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_SleepPost/LFPData/LFP1.mat')
HPC1 = LFP;
HPC1 = FilterLFP(HPC1,[0.5 200],1024);
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_SleepPost/LFPData/LFP11.mat')
HPC2 = LFP;
HPC2 = FilterLFP(HPC2,[0.5 200],1024);

load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_SleepPost/LFPData/LFP40.mat')
EMG = LFP;
EMG = FilterLFP(EMG,[20 400],1024);

clf
plot(Range(PFC1,'s'),Data(PFC1),'color','r')
hold on
plot(Range(PFC2,'s'),Data(PFC2)-0.3E4,'color','r')

plot(Range(HPC1,'s'),Data(HPC1)-1.5E4,'color','b')
plot(Range(HPC2,'s'),Data(HPC2)-1.8E4,'color','b')
xlim([1855 1890])

plot(Range(EMG,'s'),Data(EMG)-2.9E4,'color','k')

load('SpikeData.mat')
[numNeuronsP, numtt, TT]=GetSpikesFromStructure('PFCx');
[numNeuronsH, numtt, TT]=GetSpikesFromStructure('dHPC');
for i=1 : length(numNeuronsP)
    plot(Range(S{numNeuronsP(i)},'s'),Range(S{numNeuronsP(i)},'s')*0-0.5E4-i*0.02E4,'r.')
end
for i=1 : length(numNeuronsH)
    plot(Range(S{numNeuronsH(i)},'s'),Range(S{numNeuronsH(i)},'s')*0-2.15E4-i*0.02E4,'b.')
end


%NREM
xlim([2047.8 2048.15]),ylim([-3.3E4 3200])
% ripple
xlim([2047.8 2048.15]),ylim([-3.3E4 3200])
% REM
xlim([3600 3605]+99),ylim([-3.3E4 3200])
% Wake
xlim([502 507]),ylim([-3.3E4 3200])

clf
hold on
plot(Range(HPC1,'s'),Data(HPC1)-1.5E4,'color','b')
plot(Range(HPC2,'s'),Data(HPC2)-1.8E4,'color','b')
xlim([1855 1890])

load('SpikeData.mat')
[numNeuronsP, numtt, TT]=GetSpikesFromStructure('PFCx');
[numNeuronsH, numtt, TT]=GetSpikesFromStructure('dHPC');
for i=1 : length(numNeuronsH)
    plot(Range(S{numNeuronsH(i)},'s'),Range(S{numNeuronsH(i)},'s')*0-2.5E4-i*0.02E4,'b.')
end
xlim([2047.8 2048.15]),ylim([-3.3E4 3200])


