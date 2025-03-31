


clear channel
load('ChannelsToAnalyse/Bulb_deep.mat')
channel;
MiddleSpectrum_BM([cd filesep],channel,'B')


Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
Sptsd_Wake=Restrict(Sptsd,Wake);
Sptsd_NREM=Restrict(Sptsd,SWSEpoch);
Sptsd_REM=Restrict(Sptsd,REMEpoch);

Sptsd_N1=Restrict(Sptsd,Epoch{1});
Sptsd_N2=Restrict(Sptsd,Epoch{2});
Sptsd_N3=Restrict(Sptsd,Epoch{3});




figure
subplot(311)
imagesc(Range(Sptsd_Wake)/1e4 , Spectro{3} , Data(Sptsd_Wake)'); axis xy; caxis([0 4e4])
title('Wake'); ylabel('Frequency (Hz)')
hline(47,'-r'); hline(80,'-r'); 
subplot(312)
imagesc(Range(Sptsd_NREM)/1e4 , Spectro{3} , Data(Sptsd_NREM)'); axis xy; caxis([0 2e4])
title('NREM'); ylabel('Frequency (Hz)')
hline(22,'-r'); hline(32,'-r'); 
subplot(313)
imagesc(Range(Sptsd_REM)/1e4 , Spectro{3} , Data(Sptsd_REM)'); axis xy; caxis([0 1e4])
title('REM'); ylabel('Frequency (Hz)')
xlabel('time (a.u.)')
hline(24,'-r'); hline(47,'-r'); 
a=suptitle('OB Spectrogram, baseline sleep'); a.FontSize=20;

figure
plot(Spectro{3} , nanmean(Data(Sptsd_Wake)),'b')
hold on
plot(Spectro{3} , nanmean(Data(Sptsd_NREM)),'r')
plot(Spectro{3} , nanmean(Data(Sptsd_REM)),'g')
legend('Wake','NREM','REM')
makepretty
ylim([0 3e4])
vline(47,'--b'); vline(80,'--b'); 
vline(22,'--r'); vline(32,'--r'); 
vline(24,'--g'); vline(47,'--g'); 
ylabel('Power (A.U.)')
xlabel('Frequency (Hz)')
title('OB oscillations during baseline sleep')


figure
plot(Spectro{3} , nanmean(Data(Sptsd_N1)),'b')
hold on
plot(Spectro{3} , nanmean(Data(Sptsd_N2)),'r')
plot(Spectro{3} , nanmean(Data(Sptsd_N3)),'g')
legend('Wake','NREM','REM')
makepretty
ylim([0 3e4])
vline(47,'--b'); vline(80,'--b'); 
vline(22,'--r'); vline(32,'--r'); 
vline(24,'--g'); vline(47,'--g'); 
ylabel('Power (A.U.)')
xlabel('Frequency (Hz)')
title('OB oscillations during baseline sleep')




figure
subplot(211)
imagesc(Spectro{2},Spectro{3},Spectro{1}')
axis xy; caxis([0 4e4])
subplot(212)
plot(Spectro{3},nanmean(Spectro{1}))

figure
imagesc(Spectro{2},Spectro{3},Spectro{1})
subplot(211)
imagesc(Spectro{2},Spectro{3},Spectro{1}')
axis xy; caxis([0 4e5])
subplot(212)
plot(Spectro{3},nanmean(Spectro{1}))

figure
imagesc(Spectro{2},Spectro{3},Spectro{1})
subplot(211)
imagesc(Spectro{2},Spectro{3},Spectro{1}')
axis xy; caxis([0 4e4])
subplot(212)
plot(Spectro{3},nanmean(Spectro{1}))





%%

Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
Sptsd_Wake=Restrict(Sptsd,Wake);
Sptsd_NREM=Restrict(Sptsd,SWSEpoch);
Sptsd_REM=Restrict(Sptsd,REMEpoch);





figure
subplot(311)
imagesc(Range(Sptsd_Wake) , Spectro{3} , Data(Sptsd_Wake)'); axis xy; caxis([0 4e5])
subplot(312)
imagesc(Range(Sptsd_NREM) , Spectro{3} , Data(Sptsd_NREM)'); axis xy; caxis([0 4e5])
subplot(313)
imagesc(Range(Sptsd_REM) , Spectro{3} , Data(Sptsd_REM)'); axis xy; caxis([0 4e5])




Start(REMEpoch)
figure
imagesc(Spectro{2},Spectro{3},Spectro{1}')
axis xy; caxis([0 4e5])
vline(Start(REMEpoch)/1e4,'-g')
vline(Stop(REMEpoch)/1e4,'-r')

u=Stop_REM-Start_REM; sum(u>2e5);

Start_REM=Start(REMEpoch);
Stop_REM=Stop(REMEpoch);
t=1;
for i=1:length(Start(REMEpoch))
    if Stop_REM(i)-Start_REM(i)>2e5
        subplot(5,5,t)
        SmallEpoch=intervalSet(Start_REM(i),Stop_REM(i));
        Spectro_Small=Restrict(Sptsd,SmallEpoch);
        
        [P,F]=max(Data(Spectro_Small)');
        plot(P)
        %imagesc(Data(Spectro_Small)'); axis xy; caxis([0 4e5])
        t=t+1;
    end
end

figure; hist(Stop(REMEpoch)-Start(REMEpoch))



%%
LFP_Bulb_Wake=Restrict(LFP,Wake);
LFP_Bulb_NREM=Restrict(LFP,SWSEpoch);
LFP_Bulb_REM=Restrict(LFP,REMEpoch);

% High OB on Low OB LFP [2 5]
[P,f,VBinnedPhase]=PrefPhaseSpectrum(LFP_Bulb_Wake,Spectro{1},Spectro{2},Spectro{3},[2 5],30)
a=suptitle('High OB spectro on Low OB phase, Wake'); a.FontSize=20;
ylim([20 100]); caxis([0 5e3])

[P,f,VBinnedPhase]=PrefPhaseSpectrum(LFP_Bulb_NREM,Spectro{1},Spectro{2},Spectro{3},[2 5],30)
a=suptitle('High OB spectro on Low OB phase, NREM'); a.FontSize=20;
ylim([20 100]); caxis([0 1e4])

[P,f,VBinnedPhase]=PrefPhaseSpectrum(LFP_Bulb_REM,Spectro{1},Spectro{2},Spectro{3},[2 5],30)
a=suptitle('High OB spectro on Low OB phase, REM'); a.FontSize=20;
ylim([20 100]); caxis([0 5e3])




load('/media/nas4/ProjetEmbReact/Mouse750/20180702/ProjectEmbReact_M750_20180702_BaselineSleep/LFPData/LFP2.mat')
LFP_HPC_REM=Restrict(LFP,REMEpoch);
LFP_HPC_Wake=Restrict(LFP,Wake);

% High OB on Low OB LFP [2 5]
[P,f,VBinnedPhase]=PrefPhaseSpectrum(LFP_HPC_REM,Spectro{1},Spectro{2},Spectro{3},[5 10],30)
a=suptitle('High OB spectro on Low HPC phase, REM'); a.FontSize=20;
ylim([20 100]); caxis([0 4.5e3])

[P,f,VBinnedPhase]=PrefPhaseSpectrum(LFP_HPC_Wake,Spectro{1},Spectro{2},Spectro{3},[5 10],30)
a=suptitle('High OB spectro on Low HPC phase, Wake'); a.FontSize=20;
ylim([20 100]); caxis([0 2e4])



%%




figure

subplot(231)
plot(Spectro{3} , squeeze(OutPutData.ob_high.raw(:,1,:))')
makepretty
ylabel('Power (A.U.)')
legend('Mouse 1','Mouse 2','Mouse 3','Mouse 4','Mouse 5','Mouse 6','Mouse 7','Mouse 8','Mouse 9')
xlabel('Frequency (Hz)')
title('Wake')

subplot(232)
plot(Spectro{3} , squeeze(OutPutData.ob_high.raw(:,2,:))')
makepretty
ylabel('Power (A.U.)')
xlabel('Frequency (Hz)')
title('NREM')
ylim([1e2 5e3])

subplot(233)
plot(Spectro{3} , squeeze(OutPutData.ob_high.raw(:,3,:))')
makepretty
ylabel('Power (A.U.)')
xlabel('Frequency (Hz)')
title('REM')
ylim([1e2 5e3])


subplot(234)
plot(Spectro{3} , squeeze(OutPutData.ob_low.raw(:,1,:))')
makepretty
ylabel('Power (A.U.)')
title('Wake')
xlabel('Frequency (Hz)')
ylim([1e2 6e5])

subplot(235)
plot(Spectro{3} , squeeze(OutPutData.ob_low.raw(:,2,:))')
makepretty
ylabel('Power (A.U.)')
title('NREM')
xlabel('Frequency (Hz)')
ylim([1e2 6e5])

subplot(236)
plot(Spectro{3} , squeeze(OutPutData.ob_low.raw(:,3,:))')
makepretty
ylabel('Power (A.U.)')
title('REM')
xlabel('Frequency (Hz)')
ylim([1e2 6e5])


a=suptitle('High & Low OB mean spectrum, baseline sleep, n=9'); a.FontSize=20;



%%

figure

subplot(231)
plot(Spectro{3} , squeeze(OutPutData.ob_high.raw(:,1,:))')
makepretty
ylabel('Power (A.U.)')
legend('Mouse 1','Mouse 2','Mouse 3','Mouse 4','Mouse 5','Mouse 6','Mouse 7','Mouse 8','Mouse 9')
xlabel('Frequency (Hz)')
title('Wake')
set(gca,'yscale','log')

subplot(232)
plot(Spectro{3} , squeeze(OutPutData.ob_high.raw(:,2,:))')
makepretty
ylabel('Power (A.U.)')
xlabel('Frequency (Hz)')
title('NREM')
set(gca,'yscale','log')
ylim([1e2 1e5])

subplot(233)
plot(Spectro{3} , squeeze(OutPutData.ob_high.raw(:,3,:))')
makepretty
ylabel('Power (A.U.)')
xlabel('Frequency (Hz)')
title('REM')
set(gca,'yscale','log')
ylim([1e2 1e5])


subplot(234)
plot(Spectro{3} , squeeze(OutPutData.ob_low.raw(:,1,:))')
makepretty
ylabel('Power (A.U.)')
set(gca,'yscale','normal')
title('Wake')
xlabel('Frequency (Hz)')
ylim([1e2 1e6])

subplot(235)
plot(Spectro{3} , squeeze(OutPutData.ob_low.raw(:,2,:))')
makepretty
ylabel('Power (A.U.)')
title('NREM')
set(gca,'yscale','log')
xlabel('Frequency (Hz)')
ylim([1e2 1e6])

subplot(236)
plot(Spectro{3} , squeeze(OutPutData.ob_low.raw(:,3,:))')
makepretty
ylabel('Power (A.U.)')
title('REM')
set(gca,'yscale','log')
xlabel('Frequency (Hz)')
ylim([1e2 1e6])


a=suptitle('High & Low OB mean spectrum, baseline sleep, n=9'); a.FontSize=20;


%%

clear channel
load('ChannelsToAnalyse/Bulb_deep.mat')
channel;
MiddleSpectrum_BM([cd filesep],channel,'B')



Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
Sptsd_Wake=Restrict(Sptsd,Wake);
Sptsd_NREM=Restrict(Sptsd,SWSEpoch);
Sptsd_REM=Restrict(Sptsd,REMEpoch);


figure
subplot(311)
imagesc(Range(Sptsd_Wake)/1e4 , Spectro{3} , Data(Sptsd_Wake)'); axis xy; caxis([0 1e4])
title('Wake'); ylabel('Frequency (Hz)')
hline(47,'-r'); hline(80,'-r'); 
subplot(312)
imagesc(Range(Sptsd_NREM)/1e4 , Spectro{3} , Data(Sptsd_NREM)'); axis xy; caxis([0 5e3])
title('NREM'); ylabel('Frequency (Hz)')
hline(22,'-r'); hline(32,'-r'); 
subplot(313)
imagesc(Range(Sptsd_REM)/1e4 , Spectro{3} , Data(Sptsd_REM)'); axis xy; caxis([0 3e3])
title('REM'); ylabel('Frequency (Hz)')
xlabel('time (a.u.)')
hline(24,'-r'); hline(47,'-r'); 
a=suptitle('OB Spectrogram, baseline sleep'); a.FontSize=20;

figure
plot(Spectro{3} , nanmean(Data(Sptsd_Wake)),'b')
hold on
plot(Spectro{3} , nanmean(Data(Sptsd_NREM)),'r')
plot(Spectro{3} , nanmean(Data(Sptsd_REM)),'g')
legend('Wake','NREM','REM')
makepretty
ylim([0 3e4])
vline(47,'--b'); vline(80,'--b'); 
vline(22,'--r'); vline(32,'--r'); 
vline(24,'--g'); vline(47,'--g'); 
ylabel('Power (A.U.)')
xlabel('Frequency (Hz)')





%%

Mouse=[739 740 750 775 849 829 851 856 857];
for mouse = 1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    BaselineSleepSess.(Mouse_names{mouse}) = GetBaselineSleepSessions_BM(Mouse(mouse));
    BaselineSleepSess.(Mouse_names{mouse}) = [{BaselineSleepSess.(Mouse_names{mouse}){1}}];
end


for mouse = 1:length(Mouse)
    
    cd(BaselineSleepSess.(Mouse_names{mouse}){1})
    
    load('B_Middle_Spectrum.mat')
    load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    Sptsd_Wake=Restrict(Sptsd,Wake);
    Sptsd_REM=Restrict(Sptsd,REMEpoch);
    
    AllSpectroWake(mouse,:)=nanmean(Data(Sptsd_Wake));
    AllSpectroREM(mouse,:)=nanmean(Data(Sptsd_REM));
    
end

figure
subplot(121)
plot(Spectro{3} , AllSpectroWake)
makepretty
ylim([0 2e4])
legend(Mouse_names)
xlabel('Frequency (Hz)')
ylabel('Power (A.U.)')
title('Wake')

subplot(122)
plot(Spectro{3} , AllSpectroREM)
makepretty
ylim([0 0.5e4])
xlabel('Frequency (Hz)')
title('REM')


figure
subplot(121)
Conf_Inter=nanstd(AllSpectroWake)/sqrt(size(AllSpectroWake,1));
shadedErrorBar(Spectro{3} , nanmean(AllSpectroWake) , Conf_Inter,'-b',1); 
makepretty
ylim([0 1e4])
xlabel('Frequency (Hz)')
ylabel('Power (A.U.)')
title('Wake')

subplot(122)
Conf_Inter=nanstd(AllSpectroREM)/sqrt(size(AllSpectroREM,1));
shadedErrorBar(Spectro{3} , nanmean(AllSpectroREM) , Conf_Inter,'-r',1); 
makepretty
ylim([0 3e3])
xlabel('Frequency (Hz)')
title('REM')



Mouse=[739 740 750 775 849 829 851 856 857];








