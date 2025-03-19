
%%
load('SleepScoring_OBGamma.mat','Wake','SWSEpoch','REMEpoch','TotalNoiseEpoch')
Wake=WakeWiNoise;
%injection period
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;
%define time epoch
durtotal = max([max(End(Wake)),max(End(SWSEpoch))]);
%pre injectionclear
epoch_pre = intervalSet(0,en_epoch_preInj);
%post injection
epoch_post= intervalSet(st_epoch_postInj,durtotal);
%3h post injection
epoch_3hPostInj=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
 

%%
%==========================================================================
%                            SPECTRO
%==========================================================================
%%load spectro
%PFC
SpectroP = load('PFCx_deep_Low_Spectrum','Spectro');
freqP = SpectroP.Spectro{3};
sptsdP = tsd(SpectroP.Spectro{2}*1e4, SpectroP.Spectro{1});
%HPC
SpectroH = load('dHPC_deep_Low_Spectrum','Spectro');
freqH = SpectroH.Spectro{3};
sptsdH = tsd(SpectroH.Spectro{2}*1e4, SpectroH.Spectro{1});
%OBhigh
SpectroOBhigh = load('B_High_Spectrum','Spectro');
freqOBhigh = SpectroOBhigh.Spectro{3};
sptsdOBhigh = tsd(SpectroOBhigh.Spectro{2}*1e4, SpectroOBhigh.Spectro{1});
%OBlow
SpectroOBlow = load('Bulb_deep_Low_Spectrum','Spectro');
freqOBlow = SpectroOBlow.Spectro{3};
sptsdOBlow = tsd(SpectroOBlow.Spectro{2}*1e4, SpectroOBlow.Spectro{1});
%get time vector in hours of the day
VecTimeDay = GetTimeOfTheDay_MC(Range(sptsdOBlow), 0);

%%
figure,
%hypnogramme
subplot(4,6,[1:3]), SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
%spectrogrammes
subplot(4,6,[7:9]),imagesc(VecTimeDay, freqP, 10*log10(SpectroOBlow.Spectro{1}')), axis xy, colorbar, ylabel('OB low'), caxis([20 50])
colormap(jet)
line([13 13],ylim,'color','k','linestyle','--','linewidth',2)
subplot(4,6,[13:15]), imagesc(VecTimeDay, freqP, 10*log10(SpectroP.Spectro{1}')), axis xy, colorbar, ylabel('PFC'), caxis([20 50])
colormap(jet)
line([13 13],ylim,'color','k','linestyle','--','linewidth',2)
subplot(4,6,[19:21]), imagesc(VecTimeDay, freqH, 10*log10(SpectroH.Spectro{1}')), axis xy, colorbar, ylabel('HPC'), caxis([20 50])
colormap(jet)
line([13 13],ylim,'color','k','linestyle','--','linewidth',2)
xlabel('ZT time')

%%mean OB spectrum for each state
ax_OBlow(1)=subplot(4,6,10), plot(freqOBlow,mean(10*(Data(Restrict(sptsdOBlow, and(Wake,epoch_pre))))),':k','linewidth',2); hold on
plot(freqOBlow,mean(10*(Data(Restrict(sptsdOBlow, and(Wake,epoch_post))))),'k','linewidth',2);
legend({'pre','post'})
title('WAKE')
ylabel('Power (a.u)')
ax_OBlow(2)=subplot(4,6,11),  plot(freqOBlow,mean(10*(Data(Restrict(sptsdOBlow, and(SWSEpoch,epoch_pre))))),':b','linewidth',2); hold on
plot(freqOBlow,mean(10*(Data(Restrict(sptsdOBlow, and(SWSEpoch,epoch_post))))),'b','linewidth',2);
title('NREM')
ax_OBlow(3)=subplot(4,6,12), plot(freqOBlow,mean(10*(Data(Restrict(sptsdOBlow, and(REMEpoch,epoch_pre))))),':r','linewidth',2); hold on
plot(freqOBlow,mean(10*(Data(Restrict(sptsdOBlow, and(REMEpoch,epoch_post))))),'r','linewidth',2);
title('REM')
set(ax_OBlow,'ylim',[0 4e6],'xlim',[0 15]); 

%%mean PFC spectrum for each state
ax_PFC(1)=subplot(4,6,16), plot(freqP,mean(10*(Data(Restrict(sptsdP, and(Wake,epoch_pre))))),':k','linewidth',2); hold on
plot(freqP,mean(10*(Data(Restrict(sptsdP, and(Wake,epoch_post))))),'k','linewidth',2);
ylabel('Power (a.u)')
ax_PFC(2)=subplot(4,6,17),  plot(freqP,mean(10*(Data(Restrict(sptsdP, and(SWSEpoch,epoch_pre))))),':b','linewidth',2); hold on
plot(freqP,mean(10*(Data(Restrict(sptsdP, and(SWSEpoch,epoch_post))))),'b','linewidth',2);
ax_PFC(3)=subplot(4,6,18), plot(freqP,mean(10*(Data(Restrict(sptsdP, and(REMEpoch,epoch_pre))))),':r','linewidth',2); hold on
plot(freqP,mean(10*(Data(Restrict(sptsdP, and(REMEpoch,epoch_post))))),'r','linewidth',2);
set(ax_PFC,'ylim',[0 2e6],'xlim',[0 15]);

%%mean HPC spectrum for each state
ax_HPC(1)=subplot(4,6,22), plot(freqH,mean(10*(Data(Restrict(sptsdH, and(Wake,epoch_pre))))),':k','linewidth',2); hold on
plot(freqH,mean(10*(Data(Restrict(sptsdH, and(Wake,epoch_post))))),'k','linewidth',2);
ylabel('Power (a.u)')
xlabel('Frequency (Hz)')

ax_HPC(2)=subplot(4,6,23),  plot(freqH,mean(10*(Data(Restrict(sptsdH, and(SWSEpoch,epoch_pre))))),':b','linewidth',2); hold on
plot(freqH,mean(10*(Data(Restrict(sptsdH, and(SWSEpoch,epoch_post))))),'b','linewidth',2);
xlabel('Frequency (Hz)')

ax_HPC(3)=subplot(4,6,24), plot(freqH,mean(10*(Data(Restrict(sptsdH, and(REMEpoch,epoch_pre))))),':r','linewidth',2); hold on
plot(freqH,mean(10*(Data(Restrict(sptsdH, and(REMEpoch,epoch_post))))),'r','linewidth',2);
xlabel('Frequency (Hz)')
set(ax_HPC,'ylim',[0 2e6],'xlim',[0 15]);



%%
%==========================================================================
%                          GENERAL SLEEP
%==========================================================================
%%percentage overtime
density_WAKE=DensitySleepStage_MC(Wake,SWSEpoch,REMEpoch,'wake',50);
density_SWS=DensitySleepStage_MC(Wake,SWSEpoch,REMEpoch,'sws',50);
density_REM=DensitySleepStage_MC(Wake,SWSEpoch,REMEpoch,'rem',50);
VecTimeDay = GetTimeOfTheDay_MC(Range(density_WAKE), 0);

figure, subplot(2,3,[1:3]),
hold on
plot(runmean(Data(density_WAKE),5),'k'), hold on
plot(runmean(Data(density_SWS),5),'b')
plot(runmean(Data(density_REM),5),'r')

% plot(VecTimeDay,runmean(Data(density_WAKE),5),'k'), hold on
% plot(VecTimeDay,runmean(Data(density_SWS),5),'b')
% plot(VecTimeDay,runmean(Data(density_REM),5),'r')
% line([13 13],ylim,'color','k','linestyle','--')
ylim([0 100])
% xlim([8 19])
makepretty
xlabel('Time (hours)')
legend({'WAKE','NREM','REM'})

%%percentage (bars)
Res=ComputeSleepStagesPercentagesMC(Wake,SWSEpoch,REMEpoch);
% Res(x,2) first half / pre injection
% Res(x,3) second half / post injection
% Res(x,4) restricted to 3 hours post injection
wake_pre=Res(1,2);
sws_pre=Res(2,2);
rem_pre=Res(3,2);

wake_post=Res(1,4);
sws_post=Res(2,4);
rem_post=Res(3,4);

subplot(2,3,4)
b1=bar([wake_pre wake_post; sws_pre sws_post; rem_pre rem_post],'linewidth',2);
xticks([1:3]); xticklabels({'WAKE','NREM','REM'}); 
b1(1).FaceColor=[1 1 1];
b1(2).FaceColor=[0.3 0.3 0.3];
ylabel('Percentage of time (%)')
makepretty

%%number of bouts
%number of bouts pre injection
NumSWS_pre=length(length(and(SWSEpoch,epoch_pre)));
NumWAKE_pre=length(length(and(Wake,epoch_pre)));
NumREM_pre=length(length(and(REMEpoch,epoch_pre)));
%number of bouts post injection
NumSWS_post=length(length(and(SWSEpoch,epoch_3hPostInj)));
NumWAKE_post=length(length(and(Wake,epoch_3hPostInj)));
NumREM_post=length(length(and(REMEpoch,epoch_3hPostInj)));

subplot(2,3,5)
b1=bar([NumWAKE_pre NumWAKE_post; NumSWS_pre NumSWS_post; NumREM_pre NumREM_post],'linewidth',2);
xticks([1:3]); xticklabels({'WAKE','NREM','REM'}); 
b1(1).FaceColor=[1 1 1];
b1(2).FaceColor=[0.3 0.3 0.3];
ylabel('Number')
makepretty

%%mean duration of bouts
%duration of bouts pre injection
durWAKE_pre=mean(End(and(Wake,epoch_pre))-Start(and(Wake,epoch_pre)))/1E4;
durSWS_pre=mean(End(and(SWSEpoch,epoch_pre))-Start(and(SWSEpoch,epoch_pre)))/1E4;
durREM_pre=mean(End(and(REMEpoch,epoch_pre))-Start(and(REMEpoch,epoch_pre)))/1E4;
%duration of bouts post injection
durWAKE_post=mean(End(and(Wake,epoch_3hPostInj))-Start(and(Wake,epoch_3hPostInj)))/1E4;
durSWS_post=mean(End(and(SWSEpoch,epoch_3hPostInj))-Start(and(SWSEpoch,epoch_3hPostInj)))/1E4;
durREM_post=mean(End(and(REMEpoch,epoch_3hPostInj))-Start(and(REMEpoch,epoch_3hPostInj)))/1E4;

subplot(2,3,6)
b1=bar([durWAKE_pre durWAKE_post; durSWS_pre durSWS_post; durREM_pre durREM_post],'linewidth',2);
xticks([1:3]); xticklabels({'WAKE','NREM','REM'}); 
legend({'pre injection','post injection'})
b1(1).FaceColor=[1 1 1];
b1(2).FaceColor=[0.3 0.3 0.3];
ylabel('Mean duration (s)')
makepretty

%%
%==========================================================================
%                           SUBSTAGES
%==========================================================================
%%percentage of time of substages (overtime)
load('SleepSubstages.mat')
N1 = Epoch{1};
N2 = Epoch{2};
N3 = Epoch{3};
REMEpoch= Epoch{4};
Wake= Epoch{5};
SWSEpoch= Epoch{7};

[D_N1]=DensitySleepSubStage_MC(N1,N2,N3,REMEpoch,Wake,SWSEpoch,'n1',200);
[D_N2]=DensitySleepSubStage_MC(N1,N2,N3,REMEpoch,Wake,SWSEpoch,'n2',200);
[D_N3]=DensitySleepSubStage_MC(N1,N2,N3,REMEpoch,Wake,SWSEpoch,'n3',200);
[D_REM]=DensitySleepSubStage_MC(N1,N2,N3,REMEpoch,Wake,SWSEpoch,'rem',200);
[D_WAKE]=DensitySleepSubStage_MC(N1,N2,N3,REMEpoch,Wake,SWSEpoch,'wake',200);

VecTimeDay = GetTimeOfTheDay_MC(Range(D_WAKE), 0);

figure, subplot(2,3,[1:3]),
hold on
plot(VecTimeDay,runmean(Data(D_N1),5),'color',[0.4 0.8 1])
plot(VecTimeDay,runmean(Data(D_N2),5),'color',[0 0.6 1])
plot(VecTimeDay,runmean(Data(D_N3),5),'color',[0 0 1])
plot(VecTimeDay,runmean(Data(D_REM),5),'r')
plot(VecTimeDay,runmean(Data(D_WAKE),5),'k')
line([13 13],ylim,'color','k','linestyle','--')
legend({'N1','N2','N3','REM','WAKE','injection'})
xlim([8 19])
makepretty

%%percentage of time of substages (bars)
Restemp=ComputeSleepSubStagesPercentagesMC(Epoch,0);
%%percentage pre injection
percN1_pre = Restemp(1,2);
percN2_pre = Restemp(2,2);
percN3_pre = Restemp(3,2);
percWAKE_pre = Restemp(4,2);
percREM_pre = Restemp(5,2);
%%percentage post injection
percN1_post = Restemp(1,3);
percN2_post = Restemp(2,3);
percN3_post = Restemp(3,3);
percWAKE_post = Restemp(4,3);
percREM_post = Restemp(5,3);
    
subplot(2,3,4)
b1=bar([percN1_pre percN1_post; percN2_pre percN2_post; percN3_pre percN3_post; percREM_pre percREM_post; percWAKE_pre percWAKE_post],'linewidth',2);
xticks([1:5]); xticklabels({'N1','N2','N3','REM','WAKE'}); 
legend({'pre injection','post injection'})
b1(1).FaceColor=[1 1 1];
b1(2).FaceColor=[0.3 0.3 0.3];
ylabel('Percentage of time (%)')
makepretty

%%number of substages
%number of bouts pre injection
NumN1_pre = length(length(and(N1,epoch_pre)));
NumN2_pre = length(length(and(N2,epoch_pre)));
NumN3_pre = length(length(and(N3,epoch_pre)));
NumREM_pre = length(length(and(REMEpoch,epoch_pre)));
NumWAKE_pre = length(length(and(Wake,epoch_pre)));
%number of bouts post injection
NumN1_post = length(length(and(N1,epoch_post)));
NumN2_post = length(length(and(N2,epoch_post)));
NumN3_post = length(length(and(N3,epoch_post)));
NumREM_post = length(length(and(REMEpoch,epoch_post)));
NumWAKE_post = length(length(and(Wake,epoch_post)));

subplot(2,3,5)
b1=bar([NumN1_pre NumN1_post; NumN2_pre NumN2_post; NumN3_pre NumN3_post; NumREM_pre NumREM_post; NumWAKE_pre NumWAKE_post],'linewidth',2);
xticks([1:5]); xticklabels({'N1','N2','N3','REM','WAKE'}); 
legend({'pre injection','post injection'})
b1(1).FaceColor=[1 1 1];
b1(2).FaceColor=[0.3 0.3 0.3];
ylabel('Number')
makepretty
    
%%mean duration of substages
%duration of bouts pre injection
durN1_pre = mean(End(and(N1,epoch_pre))-Start(and(N1,epoch_pre)))/1E4;
durN2_pre = mean(End(and(N2,epoch_pre))-Start(and(N2,epoch_pre)))/1E4;
durN3_pre = mean(End(and(N3,epoch_pre))-Start(and(N3,epoch_pre)))/1E4;
durREM_pre = mean(End(and(REMEpoch,epoch_pre))-Start(and(REMEpoch,epoch_pre)))/1E4;
durWAKE_pre = mean(End(and(Wake,epoch_pre))-Start(and(Wake,epoch_pre)))/1E4;
%duration of bouts post injection
durN1_post = mean(End(and(N1,epoch_post))-Start(and(N1,epoch_post)))/1E4;
durN2_post = mean(End(and(N2,epoch_post))-Start(and(N2,epoch_post)))/1E4;
durN3_post = mean(End(and(N3,epoch_post))-Start(and(N3,epoch_post)))/1E4;
durREM_post = mean(End(and(REMEpoch,epoch_post))-Start(and(REMEpoch,epoch_post)))/1E4;
durWAKE_post = mean(End(and(Wake,epoch_post))-Start(and(Wake,epoch_post)))/1E4;
    
subplot(2,3,6)
b1=bar([durN1_pre durN1_post; durN2_pre durN2_post; durN3_pre durN3_post; durREM_pre durREM_post; durWAKE_pre durWAKE_post],'linewidth',2);
xticks([1:5]); xticklabels({'N1','N2','N3','REM','WAKE'}); 
legend({'pre injection','post injection'})
b1(1).FaceColor=[1 1 1];
b1(2).FaceColor=[0.3 0.3 0.3];
ylabel('Mean duration (s)')
makepretty


%%
%==========================================================================
%                            RIPPLES
%==========================================================================
%%RIPPLES : get data
%%load ripples
if exist('SWR.mat')
    ripp= load('SWR','RipplesEpoch');
else
    ripp = load('Ripples','RipplesEpoch');
end

%get ripples density
[Ripples_tsd] = GetRipplesDensityTSD_MC(ripp.RipplesEpoch);
%get ripples in specific epoch
rippDensity_SWSbefore = Restrict(Ripples_tsd, and(SWSEpoch, epoch_pre));
rippDensity_SWSafter = Restrict(Ripples_tsd, and(SWSEpoch, epoch_post));
rippDensity_Wakebefore = Restrict(Ripples_tsd, and(Wake, epoch_pre));
rippDensity_Wakeafter = Restrict(Ripples_tsd, and(Wake, epoch_post));
rippDensity_REMbefore = Restrict(Ripples_tsd, and(REMEpoch, epoch_pre));
rippDensity_REMafter = Restrict(Ripples_tsd, and(REMEpoch, epoch_post));
%mean number of ripples per sec
avRippPerMin_Wake_pre = nanmean(Data(rippDensity_Wakebefore));
avRippPerMin_Wake_post = nanmean(Data(rippDensity_Wakeafter));
avRippPerMin_SWS_pre = nanmean(Data(rippDensity_SWSbefore));
avRippPerMin_SWS_post = nanmean(Data(rippDensity_SWSafter));
avRippPerMin_REM_pre = nanmean(Data(rippDensity_REMbefore));
avRippPerMin_REM_post = nanmean(Data(rippDensity_REMafter));
%%get time vectors for each epoch (for ripples overtime)
VecTimeDay_WAKE = GetTimeOfTheDay_MC(Range(Restrict(Ripples_tsd,Wake)), 0);
VecTimeDay_SWS = GetTimeOfTheDay_MC(Range(Restrict(Ripples_tsd,SWSEpoch)), 0);
VecTimeDay_REM = GetTimeOfTheDay_MC(Range(Restrict(Ripples_tsd,REMEpoch)), 0);

%%get waveform
%WAKE
[M_pre,M_post,M_3h,M_all, T_pre,T_post,T_3h,T_all] = PlotWaveformRipples_MC(Wake,SWSEpoch,REMEpoch,ripp.RipplesEpoch,'wake',0);
dataRipp_WakePre = T_pre;
dataRipp_WakePost = T_post;
stdErr_WakePre = M_pre(:,4);
stdErr_WakePost = M_post(:,4);
%REM
[M_pre,M_post,M_3h,M_all, T_pre,T_post,T_3h,T_all] = PlotWaveformRipples_MC(Wake,SWSEpoch,REMEpoch,ripp.RipplesEpoch,'rem',0);
dataRipp_REMPre = T_pre;
if isempty(T_post) % in case there is no REM after injection
    dataRipp_REMPost(:,1001) = NaN;
else
    dataRipp_REMPost = T_post;
end
stdErr_REMPre= M_pre(:,4);
if isempty(M_post) % in case there is no REM after injection
    stdErr_REMPost= zeros(1001,4);
    stdErr_REMPost(:,:) = NaN;
else
    stdErr_REMPost= M_post(:,4);
end
%NREM
[M_pre,M_post,M_3h,M_all, T_pre,T_post,T_3h,T_all] = PlotWaveformRipples_MC(Wake,SWSEpoch,REMEpoch,ripp.RipplesEpoch,'sws',0);
dataRipp_SWSPre = T_pre;
dataRipp_SWSPost= T_post;
stdErr_SWSPre= M_pre(:,4);
stdErr_SWSPost = M_post(:,4);

%%RIPPLES : figure
figure,
%%mean waveform
ax(1)=subplot(3,4,1)
shadedErrorBar(M_pre(:,1),nanmean(dataRipp_WakePre),stdErr_WakePre,':k',1); hold on
shadedErrorBar(M_pre(:,1),nanmean(dataRipp_WakePost),stdErr_WakePost,'k',1)
line([0 0],ylim,'color','k','linestyle','--')
ylabel('WAKE')
title('Waveform')
makepretty
ax(2)=subplot(3,4,5)
shadedErrorBar(M_pre(:,1),nanmean(dataRipp_SWSPre),stdErr_SWSPre,':b',1); hold on
shadedErrorBar(M_pre(:,1),nanmean(dataRipp_SWSPost),stdErr_SWSPost,'b',1)
line([0 0],ylim,'color','k','linestyle','--')
ylabel('NREM')
makepretty
ax(3)=subplot(3,4,9)
shadedErrorBar(M_pre(:,1),nanmean(dataRipp_REMPre),stdErr_REMPre,':r',1); hold on
% shadedErrorBar(M_pre(:,1),nanmean(dataRipp_REMPost),stdErr_REMPost,'r',1)
line([0 0],ylim,'color','k','linestyle','--')
ylabel('REM')
makepretty
set(ax,'xlim',[-0.2 0.3],'ylim',[-2000 4000])

%%ripples density overtime
ax1(1)=subplot(3,4,[2,3])
plot(VecTimeDay_WAKE, runmean(Data(Restrict(Ripples_tsd,Wake)),70),'.k'), hold on
line([13 13],ylim,'color','k','linestyle','--')
ylabel('Ripples/s')
title('Ripples density (overtime)')
makepretty
ax1(2)=subplot(3,4,[6,7])
plot(VecTimeDay_SWS, runmean(Data(Restrict(Ripples_tsd,SWSEpoch)),70),'.b'), hold on
line([13 13],ylim,'color','k','linestyle','--')
ylabel('Ripples/s')
makepretty
ax1(3)=subplot(3,4,[10,11])
plot(VecTimeDay_REM, runmean(Data(Restrict(Ripples_tsd,REMEpoch)),70),'.r'), hold on
line([13 13],ylim,'color','k','linestyle','--')
ylabel('Ripples/s')
xlabel('Time (hours)')
makepretty
set(ax1,'xlim',[8 19],'ylim',[0 2])

%%ripples density pre vs post (barplot)
ax2(1)=subplot(3,4,4)
b1=bar([avRippPerMin_Wake_pre avRippPerMin_Wake_post],'linewidth',2);
xticks([1:2]); xticklabels({'pre','post'}); 
b1.FaceColor=[0 0 0];
ylabel('Ripples/s')
title('Ripples density (mean)')
makepretty
ax2(2)=subplot(3,4,8)
b2=bar([avRippPerMin_SWS_pre; avRippPerMin_SWS_post],'linewidth',2);
xticks([1:2]); xticklabels({'pre','post'}); 
b2.FaceColor=[0 0 1];
ylabel('Ripples/s')
makepretty
ax2(3)=subplot(3,4,12)
b3=bar([avRippPerMin_REM_pre; avRippPerMin_REM_post],'linewidth',2);
xticks([1:2]); xticklabels({'pre','post'}); 
b3.FaceColor=[1 0 0];
ylabel('Ripples/s')
makepretty
set(ax2,'ylim',[0 1.5])


%%
%==========================================================================
%                            DELTAS
%==========================================================================
%%DELTAS : get data
%%load deltas
delt = load('DeltaWaves.mat','alldeltas_PFCx')
%get deltas density
[Delta_tsd] = GetDeltasDensityTSD_MC(delt.alldeltas_PFCx);
%get ripples in specific epoch
deltDensity_SWSbefore = Restrict(Delta_tsd, and(SWSEpoch, epoch_pre));
deltDensity_SWSafter = Restrict(Delta_tsd, and(SWSEpoch, epoch_post));
deltDensity_Wakebefore = Restrict(Delta_tsd, and(Wake, epoch_pre));
deltDensity_Wakeafter = Restrict(Delta_tsd, and(Wake, epoch_post));
deltDensity_REMbefore = Restrict(Delta_tsd, and(REMEpoch, epoch_pre));
deltDensity_REMafter = Restrict(Delta_tsd, and(REMEpoch, epoch_post));
%mean number of deltas per sec
avDeltPerMin_Wake_pre = nanmean(Data(deltDensity_Wakebefore));
avDeltPerMin_Wake_post = nanmean(Data(deltDensity_Wakeafter));
avDeltPerMin_SWS_pre = nanmean(Data(deltDensity_SWSbefore));
avDeltPerMin_SWS_post = nanmean(Data(deltDensity_SWSafter));
avDeltPerMin_REM_pre = nanmean(Data(deltDensity_REMbefore));
avDeltPerMin_REM_post = nanmean(Data(deltDensity_REMafter));
%%get time vectors for each epoch (for deltas overtime)
VecTimeDay_WAKE = GetTimeOfTheDay_MC(Range(Restrict(Delta_tsd,Wake)), 0);
VecTimeDay_SWS = GetTimeOfTheDay_MC(Range(Restrict(Delta_tsd,SWSEpoch)), 0);
VecTimeDay_REM = GetTimeOfTheDay_MC(Range(Restrict(Delta_tsd,REMEpoch)), 0);

%%get waveform
%WAKE
[Mdeep_pre, Mdeep_post, Msup_pre, Msup_post, Tdeep_pre, Tdeep_post, Tsup_pre, Tsup_post] = PlotWaveformDeltas_MC(Wake,SWSEpoch,REMEpoch,delt.alldeltas_PFCx,'wake');
dataDeltDeep_WakePre = Tdeep_pre;
dataDeltDeep_WakePost = Tdeep_post;
dataDeltSup_WakePre = Tsup_pre;
dataDeltSup_WakePost = Tsup_post;
stdErrDeltDeep_WakePre = Mdeep_pre(:,4);
stdErrDeltDeep_WakePost = Mdeep_post(:,4);
stdErrDeltSup_WakePre = Msup_pre(:,4);
stdErrDeltSup_WakePost = Msup_post(:,4);

%REM
[Mdeep_pre, Mdeep_post, Msup_pre, Msup_post, Tdeep_pre, Tdeep_post, Tsup_pre, Tsup_post] = PlotWaveformDeltas_MC(Wake,SWSEpoch,REMEpoch,delt.alldeltas_PFCx,'rem');
dataDeltDeep_REMPre = Tdeep_pre;
dataDeltSup_REMPre = Tsup_pre;
if isempty(Tdeep_post) % in case there is no REM after injection
    dataDeltDeep_REMPost(:,1001) = NaN;
    dataDeltSup_REMPost(:,1001) = NaN;
else
    dataDeltDeep_REMPost = Tdeep_post;
    dataDeltSup_REMPost = Tsup_post;
end
stdErrDeltDeep_REMPre= Mdeep_pre(:,4);
stdErrDeltSup_REMPre= Msup_pre(:,4);
if isempty(Mdeep_post) % in case there is no REM after injection
    stdErrDeltDeep_REMPost= zeros(1001,4);
    stdErrDeltDeep_REMPost(:,:) = NaN;
    stdErrDeltSup_REMPost= zeros(1001,4);
    stdErrDeltSup_REMPost(:,:) = NaN;
else
    stdErrDeltDeep_REMPost= Mdeep_post(:,4);
    stdErrDeltSup_REMPost= Msup_post(:,4);
end

%NREM
[Mdeep_pre, Mdeep_post, Msup_pre, Msup_post, Tdeep_pre, Tdeep_post, Tsup_pre, Tsup_post] = PlotWaveformDeltas_MC(Wake,SWSEpoch,REMEpoch,delt.alldeltas_PFCx,'sws');
dataDeltDeep_SWSPre = Tdeep_pre;
dataDeltDeep_SWSPost= Tdeep_post;
dataDeltSup_SWSPre = Tsup_pre;
dataDeltSup_SWSPost= Tsup_post;
stdErrDeltDeep_SWSPre= Mdeep_pre(:,4);
stdErrDeltDeep_SWSPost = Mdeep_post(:,4);
stdErrDeltSup_SWSPre= Msup_pre(:,4);
stdErrDeltSup_SWSPost = Msup_post(:,4);

%%DELTAS : figure
figure,
%%mean waveform
ax(1)=subplot(3,4,1)
shadedErrorBar(M_pre(:,1),nanmean(dataDeltDeep_WakePre),stdErrDeltDeep_WakePre,':k',1); hold on
shadedErrorBar(M_pre(:,1),nanmean(dataDeltDeep_WakePost),stdErrDeltDeep_WakePost,'k',1)
shadedErrorBar(M_pre(:,1),nanmean(dataDeltSup_WakePre),stdErrDeltSup_WakePre,':k',1); hold on
shadedErrorBar(M_pre(:,1),nanmean(dataDeltSup_WakePost),stdErrDeltSup_WakePost,'k',1)
ylabel('WAKE')
title('Waveform')
makepretty
ax(2)=subplot(3,4,5)
shadedErrorBar(M_pre(:,1),nanmean(dataDeltDeep_SWSPre),stdErrDeltDeep_SWSPre,':b',1); hold on
shadedErrorBar(M_pre(:,1),nanmean(dataDeltDeep_SWSPost),stdErrDeltDeep_SWSPost,'b',1)
shadedErrorBar(M_pre(:,1),nanmean(dataDeltSup_SWSPre),stdErrDeltSup_SWSPre,':b',1); hold on
shadedErrorBar(M_pre(:,1),nanmean(dataDeltSup_SWSPost),stdErrDeltSup_SWSPost,'b',1)
ylabel('NREM')
makepretty
ax(3)=subplot(3,4,9)
shadedErrorBar(M_pre(:,1),nanmean(dataDeltDeep_REMPre),stdErrDeltDeep_REMPre,':r',1); hold on
% shadedErrorBar(M_pre(:,1),nanmean(dataDeltDeep_REMPost),stdErrDeltDeep_REMPost,'r',1)
shadedErrorBar(M_pre(:,1),nanmean(dataDeltSup_REMPre),stdErrDeltSup_REMPre,':r',1); hold on
% shadedErrorBar(M_pre(:,1),nanmean(dataDeltSup_REMPost),stdErrDeltSup_REMPost,'r',1)
ylabel('REM')
makepretty
set(ax,'xlim',[-0.2 0.3],'ylim',[-1500 2000])

%%Deltas density overtime
ax1(1)=subplot(3,4,[2,3])
plot(VecTimeDay_WAKE, runmean(Data(Restrict(Delta_tsd,Wake)),70),'.k'), hold on
line([13 13],ylim,'color','k','linestyle','--')
ylabel('Deltas/s')
title('Deltas density (overtime)')
makepretty
ax1(2)=subplot(3,4,[6,7])
plot(VecTimeDay_SWS, runmean(Data(Restrict(Delta_tsd,SWSEpoch)),70),'.b'), hold on
line([13 13],ylim,'color','k','linestyle','--')
ylabel('Deltas/s')
makepretty
ax1(3)=subplot(3,4,[10,11])
plot(VecTimeDay_REM, runmean(Data(Restrict(Delta_tsd,REMEpoch)),70),'.r'), hold on
line([13 13],ylim,'color','k','linestyle','--')
ylabel('Deltas/s')
xlabel('Time (hours)')
makepretty
set(ax1,'xlim',[8 19],'ylim',[0 2])

%%Deltas density pre vs post (barplot)
ax2(1)=subplot(3,4,4)
b1=bar([avDeltPerMin_Wake_pre avDeltPerMin_Wake_post],'linewidth',2);
xticks([1:2]); xticklabels({'pre','post'}); 
b1.FaceColor=[0 0 0];
ylabel('Deltas/s')
title('Deltas density (mean)')
makepretty
ax2(2)=subplot(3,4,8)
b2=bar([avDeltPerMin_SWS_pre; avDeltPerMin_SWS_post],'linewidth',2);
xticks([1:2]); xticklabels({'pre','post'}); 
b2.FaceColor=[0 0 1];
ylabel('Deltas/s')
makepretty
ax2(3)=subplot(3,4,12)
b3=bar([avDeltPerMin_REM_pre; avDeltPerMin_REM_post],'linewidth',2);
xticks([1:2]); xticklabels({'pre','post'}); 
b3.FaceColor=[1 0 0];
ylabel('Deltas/s')
makepretty
set(ax2,'ylim',[0 1.5])

