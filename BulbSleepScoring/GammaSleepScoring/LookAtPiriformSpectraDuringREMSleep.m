FileName ={'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161116',
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161123',
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126',
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170130',
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170202'};

for mm = 1:length(FileName)
    cd(FileName{mm})
    
    load('LFPData/DigInfo4.mat')
    Laser=DigTSD;
    StimsTTL=thresholdIntervals(Laser,0.9998,'Direction','Above');
    StimsTTL = mergeCloseIntervals(StimsTTL,10*1e4);
    
    load('ChannelsToAnalyse/PiCx_left.mat')
    load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
    sptsd=tsd(t*1e4,Sp);
    load('StateEpoch','REMEpoch','SWSEpoch');
    Mean_Rem(mm,:) = nanmean(Data(Restrict(sptsd,REMEpoch-StimsTTL)));
    Mean_NREM(mm,:) = nanmean(Data(Restrict(sptsd,SWSEpoch-StimsTTL)));
end
Mean_Rem(2,:)=[];

figure
[hl,hp]=boundedline(f,nanmean(Mean_NREM),[stdError(Mean_NREM);stdError(Mean_NREM)]','k');
hold on
[hl,hp]=boundedline(f,nanmean(Mean_Rem),[stdError(Mean_Rem);stdError(Mean_Rem)]','r');

figure
[hl,hp]=boundedline(f,nanmean(log(Mean_NREM)),[stdError(log(Mean_NREM));stdError(log(Mean_NREM))]','k');
hold on
[hl,hp]=boundedline(f,nanmean(log(Mean_Rem)),[stdError(log(Mean_Rem));stdError(log(Mean_Rem))]','r');
