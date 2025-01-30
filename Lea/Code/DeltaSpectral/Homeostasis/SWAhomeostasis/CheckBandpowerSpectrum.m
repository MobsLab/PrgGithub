
%cd(Dir.path{16})


load('SleepSubstages.mat')
SWS = Epoch{strcmpi(NameEpoch,'SWS')} ;

load NoiseHomeostasisLP TotalNoiseEpoch 
cleanSWS= diff(SWS,TotalNoiseEpoch);

%load('ChannelsToAnalyse/Bulb_deep')
%load('ChannelsToAnalyse/PFCx_sup')
load('ChannelsToAnalyse/PFCx_deep')
%channel = 16 ; 
load('behavResources.mat', 'NewtsdZT')

[Sp,t,f] = LoadSpectrumML(channel,pwd,'low');

figure,

subplot(7,1,[2 3 4]), 
imagesc(t/3600 + min(Data(NewtsdZT))/(3600e4),f,10*log10(Sp)'), axis xy
%imagesc(t/60,f,10*log10(Sp)'), axis xy
xl = xlim ;

subplot(7,1,1),
plot_hypnogLP('newfig',0,'ZTtime',NewtsdZT);
xlim(xl);

subplot(7,1,[5 6 7]), 
[t_swa, y_swa, Homeo_res] = GetSWAchannel_LP(channel,'multifit_thresh',20,'epoch',cleanSWS,'plot',1,'newfig',0,'freqband',[0.5 4],'artefact_thresh','none') ;
xlim(xl);