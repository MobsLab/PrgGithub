% functions for Epoch

% load positions and use epochs
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_Habituation
load('behavResources.mat')

plot(Data(Ytsd),Data(Xtsd))
hold on
plot(Data(Restrict(Ytsd,FreezeEpoch)),Data(Restrict(Xtsd,FreezeEpoch)),'*')


% create with threshold
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_SleepPreSound
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_SleepPreSound/LFPData/LFP0.mat')
load('StateEpochSB.mat')

cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_SleepPreSound
NoisyEpoch = thresholdIntervals(LFP,1*1e4,'Direction','Above');
% remove short things
NoisyEpoch = dropShortIntervals(NoisyEpoch,60*1e4);
% merge close epoch
NoisyEpoch = mergeCloseIntervals(NoisyEpoch,60*1e4);
% remove long things
NoisyEpoch = dropLongIntervals(NoisyEpoch,60*1e4);


% LFP stuff
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_SleepPreSound
load('ChannelsToAnalyse/EKG.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])

% Spectre
load('ChannelsToAnalyse/Bulb_deep.mat')
load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
% t is in seconds
Spec_tsd = tsd(t*1e4,Sp);

imagesc(Range(Spec_tsd),f,Data(Spec_tsd)'), axis xy
imagesc(Range(Spec_tsd),f,log(Data(Spec_tsd)')), axis xy


figure
plot(f,log(nanmean(Data(Restrict(Spec_tsd,REMEpoch)))))
hold on
plot(f,log(nanmean(Data(Restrict(Spec_tsd,Wake)))))
plot(f,log(nanmean(Data(Restrict(Spec_tsd,SWSEpoch)))))


%% 
[M,T] = PlotRipRaw(LFP,Start(deltas_PFCx,'s'),500,0,0);
imagesc(T)
plot(M(:,1),M(:,2))




%
Dir=PathForExperimentsSleepWithDrugs('FLX_NightSaline');

for k = 1:4
   cd(Dir.path{k}) 
   load('StateEpochSB.mat','REMEpoch','SWSEpoch')
   PercRem(k) = sum(Stop(REMEpoch)-Start(REMEpoch))./sum(Stop(SWSEpoch)-Start(SWSEpoch));
end

Dir=PathForExperimentsSleepWithDrugs('FLX_NightFlx');
for k = 1:4
   cd(Dir.path{k}) 
   load('StateEpochSB.mat','REMEpoch','SWSEpoch')
   PercRemF(k) = sum(Stop(REMEpoch)-Start(REMEpoch))./sum(Stop(SWSEpoch)-Start(SWSEpoch));
end

Dir=PathForExperimentsSleepWithDrugs('FLX_NightFlx24h');
for k = 1:4
   cd(Dir.path{k}) 
   load('StateEpochSB.mat','REMEpoch','SWSEpoch')
   PercRemF2(k) = sum(Stop(REMEpoch)-Start(REMEpoch))./sum(Stop(SWSEpoch)-Start(SWSEpoch));
end

PlotErrorBarN_KJ({PercRem,PercRemF,PercRemF2})


% FLX_DayPre
% FLX_NightPre
% FLX_DaySaline - injected 0.3mL of saline before recording
% FLX_NightSaline
% FLX_DayFlx - injection 0.3mL of Fluoxetine (15mg/kg) before recording
% FLX_NightFlx
% FLX_DayFlx24h
% FLX_NightFlx24h



