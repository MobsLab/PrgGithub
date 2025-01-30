




smootime = 3;
minduration = 3;
load('ChannelsToAnalyse/Bulb_deep.mat')
channel_bulb=channel;
foldername=pwd;
if foldername(end)~=filesep
    foldername(end+1)=filesep;
end

[SleepOB,SmoothGamma,Info_temp,microWakeEpochOB,microSleepEpochOB]= ...
    FindGammaEpoch_SleepScoring(Epoch, channel_bulb, minduration, 'foldername', foldername,...
    'smoothwindow', smootime);



figure
load('B_Middle_Spectrum.mat')
subplot(9,1,1:2)
imagesc(Spectro{2}/60 , Spectro{3} , runmean(runmean(log10((Spectro{3}.*Spectro{1})'),5)',300)'), axis xy
ylim([20 100])
ylabel('OB High spectrum')

subplot(913)
plot(Range(smooth_ghi,'s')/60 , runmean(Data(smooth_ghi),1e4),'k','LineWidth',2), box off
set(gca,'Yscale','log'), xlim([0 58.34])
ylabel('Gamma power (a.u.)')

load('PFCx_Low_Spectrum.mat')
subplot(9,1,4:5)
imagesc(Spectro{2}/60 , Spectro{3} , runmean(runmean(log10((Spectro{3}.*Spectro{1})'),2)',30)'), axis xy
ylabel('PFCx spectrum')

line([Start(and(Epoch{1} , Sleep))/60e4 Stop(and(Epoch{1} , Sleep))/60e4],[19 19],'Color',[0 0 0],'LineWidth',10)
line([Start(and(Epoch{2} , Sleep))/60e4 Stop(and(Epoch{2} , Sleep))/60e4],[19 19],'Color',[1 0 0],'LineWidth',10)
line([Start(and(Epoch{3} , Sleep))/60e4 Stop(and(Epoch{3} , Sleep))/60e4],[19 19],'Color','m','LineWidth',10)


subplot(916)
plot(Range(smooth_del_pfc,'s')/60 , runmean(Data(smooth_del_pfc),1e4),'k','LineWidth',2), box off
set(gca,'Yscale','log'), xlim([0 58.34])
ylim([2e2 1e3])
ylabel('Delta power (a.u.)')

load('H_Low_Spectrum.mat')
subplot(9,1,7:8)
imagesc(Spectro{2}/60 , Spectro{3} , runmean(runmean(log10((Spectro{3}.*Spectro{1})'),2)',30)'), axis xy
ylabel('HPC spectrum')

subplot(919)
for i=1:59
    SmallEpoch=intervalSet((i-1)*60e4 , i*60e4);
    RipDensity(i) = length(Restrict(tRipples , SmallEpoch))/60;
end
plot(RipDensity,'k','LineWidth',2), box off
xlim([0 58.34])
xlabel('time (min)'), ylabel('Rip density (#/s)')


load('B_Low_Spectrum.mat')
[Spectrum_Frequency , Power] = ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1} , 'bin_size',10);
load('HeartBeatInfo.mat', 'EKG')

figure
subplot(211)
plot(Range(Spectrum_Frequency,'s')/60 , movmean(Data(Spectrum_Frequency),20,'omitnan'),'k','LineWidth',2), box off
ylabel('Breathing (Hz)')
xlim([0 58.34])

subplot(212)
plot(Range(EKG.HBRate,'s')/60 , movmean(Data(EKG.HBRate),100,'omitnan'),'k','LineWidth',2), box off
ylabel('Heart rate (Hz)')
xlim([0 58.34])







load('ChannelsToAnalyse/dHPC_rip.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
FilDelta = FilterLFP(LFP,[2 5],1024); 
tEnveloppeDelta = tsd(Range(LFP), abs(hilbert(Data(FilDelta)))); 
smootime=3;
smooth_del_pfc = tsd(Range(tEnveloppeDelta), runmean(Data(tEnveloppeDelta), ...
    ceil(smootime/median(diff(Range(tEnveloppeDelta,'s'))))));

save('StateEpochSB.mat','smooth_del_pfc','-append')




load('ChannelsToAnalyse/dHPC_rip.mat')
[ThetaEpoch_OB, SmoothTheta, ~, Info_temp] = ...
    FindThetaEpoch_SleepScoring(Epoch, Epoch, channel, minduration, 'foldername', foldername,...
    'smoothwindow', smootime,'continuity',1);

        
        
       save('SleepScoring_OBGamma.mat','ThetaEpoch_OB','SmoothTheta','-append') 
        
        

