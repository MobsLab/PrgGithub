


OB_Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});

OB_Wake = Restrict(OB_Sp_tsd , Wake);
OB_NREM = Restrict(OB_Sp_tsd , SWSEpoch);
OB_REM = Restrict(OB_Sp_tsd , REMEpoch);

PFC_Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});

PFC_Wake = Restrict(PFC_Sp_tsd , Wake);
PFC_NREM = Restrict(PFC_Sp_tsd , SWSEpoch);
PFC_REM = Restrict(PFC_Sp_tsd , REMEpoch);


figure
subplot(231)
imagesc(linspace(0,1,length(OB_Wake)) , Spectro{3} , 10*log10(Data(OB_Wake))'), axis xy
ylim([0 15])
ylabel('Frequency (Hz)')
title('Wake')

subplot(232)
imagesc(linspace(0,1,length(OB_NREM)) , Spectro{3} , 10*log10(Data(OB_NREM))'), axis xy
ylim([0 15])
title('NREM')

subplot(233)
imagesc(linspace(0,1,length(OB_REM)) , Spectro{3} , 10*log10(Data(OB_REM))'), axis xy
ylim([0 15])
title('REM')

subplot(234)
imagesc(linspace(0,1,length(PFC_Wake)) , Spectro{3} , 10*log10(Data(PFC_Wake))'), axis xy
ylabel('Frequency (Hz)')
ylim([0 15])

subplot(235)
imagesc(linspace(0,1,length(PFC_NREM)) , Spectro{3} , 10*log10(Data(PFC_NREM))'), axis xy
ylim([0 15])

subplot(236)
imagesc(linspace(0,1,length(PFC_REM)) , Spectro{3} , 10*log10(Data(PFC_REM))'), axis xy
ylim([0 15])



load('ChannelsToAnalyse/Bulb_deep.mat'), load(['LFPData/LFP' num2str(channel) '.mat'])
LFP_bulb = LFP;
load('ChannelsToAnalyse/PFCx_deep.mat'), load(['LFPData/LFP' num2str(channel) '.mat'])
LFP_pfc = LFP;
params.Fs=1/median(diff(Range(LFP_bulb,'s'))); params.tapers=[3 5]; params.fpass=[0.1 20]; params.err=[2,0.05]; params.pad=0; movingwin=[3 0.2];


[Ctemp_wake,phi_wake,S12,S1temp,S2temp,t,f,confC,phitemp,Cerr] = cohgramc(Data(Restrict(LFP_bulb,Wake)) , Data(Restrict(LFP_pfc,Wake)) , movingwin , params);
[Ctemp_nrem,phi_nrem,S12,S1temp,S2temp,t,f,confC,phitemp,Cerr] = cohgramc(Data(Restrict(LFP_bulb,SWSEpoch)) , Data(Restrict(LFP_pfc,SWSEpoch)) , movingwin , params);
[Ctemp_rem,phi_rem,S12,S1temp,S2temp,t,f,confC,phitemp,Cerr] = cohgramc(Data(Restrict(LFP_bulb,REMEpoch)) , Data(Restrict(LFP_pfc,REMEpoch)) , movingwin , params);



figure
subplot(231)
imagesc(linspace(0,1,length(Ctemp_wake)) , f , runmean(Ctemp_wake',5)), axis xy
ylim([0 15])
ylabel('Frequency (Hz)')
title('Wake'), %xlim([.65 .658])
subplot(232)
imagesc(linspace(0,1,length(Ctemp_nrem)) , f , runmean(Ctemp_nrem',5)), axis xy
ylim([0 15])
title('NREM'), %xlim([.65 .658])
subplot(233)
imagesc(linspace(0,1,length(Ctemp_rem)) , f , runmean(Ctemp_rem',5)), axis xy
ylim([0 15]), %xlim([.65 .68])
title('REM')


subplot(234)
imagesc(linspace(0,1,length(Ctemp_nrem)) , f , runmean(phi_wake',5)), axis xy
ylim([0 15]), %xlim([.65 .658])
ylabel('Frequency (Hz)')
subplot(235)
imagesc(linspace(0,1,length(Ctemp_nrem)) , f , runmean(phi_nrem',5)), axis xy
ylim([0 15]), %xlim([.65 .658])
subplot(236)
imagesc(linspace(0,1,length(Ctemp_nrem)) , f , runmean(phi_rem',5)), axis xy
ylim([0 15]), %xlim([.65 .68])


figure
subplot(231)
plot(Spectro{3} , nanmean(Data(OB_Wake)),'b')
hold on
plot(Spectro{3} , nanmean(Data(PFC_Wake)),'r')
plot(f , nanmean(Ctemp_wake))
xlim([0 15])
title('Wake'), %xlim([.65 .658])

subplot(232)
clear D m, D=Data(OB_NREM); m=max(nanmean(D(:,13:end)));
plot(Spectro{3} , nanmean(Data(OB_NREM))./m,'b')
hold on
clear D m, D=Data(PFC_NREM); m=max(nanmean(D(:,13:end)));
plot(Spectro{3} , nanmean(Data(PFC_NREM))./m,'r')
plot(f , (nanmean(Ctemp_nrem)-min(nanmean(Ctemp_nrem)))./max(nanmean(Ctemp_nrem)-min(nanmean(Ctemp_nrem))))
xlim([0 15])
title('NREM'), %xlim([.65 .658])

subplot(233)
clear D m, D=Data(OB_REM); m=max(nanmean(D(:,13:end)));
plot(Spectro{3} , nanmean(Data(OB_REM))./m,'b')
hold on
clear D m, D=Data(PFC_REM); m=max(nanmean(D(:,13:end)));
plot(f , (nanmean(Ctemp_rem)-min(nanmean(Ctemp_rem)))./max(nanmean(Ctemp_rem)-min(nanmean(Ctemp_rem))))
plot(f , nanmean(Ctemp_rem))
xlim([0 15])
title('REM'), %xlim([.65 .658])


subplot(234)
imagesc(linspace(0,1,length(Ctemp_nrem)) , f , runmean(phi_wake',5)), axis xy
ylim([0 15]), %xlim([.65 .658])
ylabel('Frequency (Hz)')
subplot(235)
imagesc(linspace(0,1,length(Ctemp_nrem)) , f , runmean(phi_nrem',5)), axis xy
ylim([0 15]), %xlim([.65 .658])
subplot(236)
imagesc(linspace(0,1,length(Ctemp_nrem)) , f , runmean(phi_rem',5)), axis xy
ylim([0 15]), %xlim([.65 .68])

