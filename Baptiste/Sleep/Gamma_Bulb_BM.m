
%% Generate new spectrogramm

clear channel
load('ChannelsToAnalyse/Bulb_deep.mat')
channel;
MiddleSpectrum_BM([cd filesep],channel,'B')


%% An example
% Epochs to use
cd('/media/DataMOBsRAIDN/ProjetSlSc/C3H&DBA/M730')
load('B_Middle_Spectrum.mat')
load('SleepScoring_OBGamma.mat')
load('SleepSubstages.mat')

Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
Sptsd_Wake=Restrict(Sptsd,Wake);
Sptsd_NREM=Restrict(Sptsd,SWSEpoch);
Sptsd_REM=Restrict(Sptsd,REMEpoch);

Sp_Wake=Data(Sptsd_Wake); Rg_Wake=Range(Sptsd_Wake,'s');
Sp_NREM=Data(Sptsd_NREM); Rg_NREM=Range(Sptsd_NREM,'s');
Sp_REM=Data(Sptsd_REM); Rg_REM=Range(Sptsd_REM,'s');

Sptsd_N1=Restrict(Sptsd,Epoch{1});
Sptsd_N2=Restrict(Sptsd,Epoch{2});
Sptsd_N3=Restrict(Sptsd,Epoch{3});

% Spectrograms
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
a=suptitle('OB Spectrogram, baseline sleep, M730, DBA mouse'); a.FontSize=20;

% Mean spectrum
figure
subplot(131)
plot(Spectro{3} , nanmean(Data(Sptsd_Wake)),'b')
hold on
plot(Spectro{3} , nanmean(Data(Sptsd_NREM)),'r')
plot(Spectro{3} , nanmean(Data(Sptsd_REM)),'g')
legend('Wake','NREM','REM')
makepretty
ylim([0 2e4]); xlim([10 100])
vline(47,'--b'); vline(80,'--b'); 
vline(22,'--r'); vline(32,'--r'); 
vline(24,'--g'); vline(47,'--g'); 
ylabel('Power (A.U.)')
xlabel('Frequency (Hz)')
title('linear scale')

subplot(132)
plot(Spectro{3} , nanmean(Data(Sptsd_Wake)),'b')
hold on
plot(Spectro{3} , nanmean(Data(Sptsd_NREM)),'r')
plot(Spectro{3} , nanmean(Data(Sptsd_REM)),'g')
set(gca,'yscale','log')
makepretty
ylim([0 2e4]); xlim([10 100])
xlabel('Frequency (Hz)')
title('log scale')

subplot(133)
plot(Spectro{3} , Spectro{3}.*nanmean(Data(Sptsd_Wake)),'b')
hold on
plot(Spectro{3} , Spectro{3}.*nanmean(Data(Sptsd_NREM)),'r')
plot(Spectro{3} , Spectro{3}.*nanmean(Data(Sptsd_REM)),'g')
makepretty
ylim([0 6e5]); xlim([10 100])
xlabel('Frequency (Hz)')
title('Mean spectrum x f, log scale')
set(gca,'yscale','log')

a=suptitle('OB mean spectrum, baseline sleep, M730'); a.FontSize=20;

% Power evolution along time
figure
plot(Rg_Wake(1:30:end) , runmean(nanmean(Sp_Wake(1:30:end,13:33)'),30),'b')
hold on
plot(Rg_NREM(1:30:end) , runmean(nanmean(Sp_NREM(1:30:end,13:33)'),30),'r')
plot(Rg_REM(1:30:end) , runmean(nanmean(Sp_REM(1:30:end,13:33)'),30),'g')
legend('Wake','NREM','REM')
makepretty
ylim([0 3e4])
ylabel('Power (A.U.)')
xlabel('time (s)')
title('OB gamma power [20-50 Hz], as a function of time')

figure
plot(runmean(nanmean(Sp_REM(1:30:end,13:33)'),30),'g')
ylabel('Power (A.U.)')
xlabel('time (a.u.)')
makepretty
title('OB gamma power [20-50 Hz], during REM concatenated')

% Mean spectrum for NREM sleep substages
figure
plot(Spectro{3} , nanmean(Data(Sptsd_N1)),'b')
hold on
plot(Spectro{3} , nanmean(Data(Sptsd_N2)),'r')
plot(Spectro{3} , nanmean(Data(Sptsd_N3)),'g')
legend('Wake','NREM','REM')
makepretty
ylim([0 1e4])
vline(47,'--b'); vline(80,'--b'); 
vline(22,'--r'); vline(32,'--r'); 
vline(24,'--g'); vline(47,'--g'); 
ylabel('Power (A.U.)')
xlabel('Frequency (Hz)')
title('OB oscillations during baseline sleep')


% Look gamma oscillations during REM episodes, evolution of Gamma power / frequencies
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
    if Stop_REM(i)-Start_REM(i)>2e5 % consider only episodes longer than 20s
        subplot(5,5,t)
        SmallEpoch=intervalSet(Start_REM(i),Stop_REM(i));
        Spectro_Small=Restrict(Sptsd,SmallEpoch);
        
        Data_Spectro=Data(Spectro_Small);
        
         [P,F]=max(Data_Spectro(:,13:62)');  % Gamma low
         plot(runmean(Spectro{3}(F+12),10))
         ylim([20 80])
%         plot(runmean(P,10))

        
%        [P,F]=max(Data_Spectro(:,35:62)'); % High gamma
        %plot(runmean(Spectro{3}(F+34),10))
%        plot(runmean(P,10))

        %imagesc(Data(Spectro_Small)'); axis xy; caxis([0 4e5])
        t=t+1;
    end
end

figure; hist(Stop(REMEpoch)-Start(REMEpoch)) % distribution of REM episodes


%% Dissecting wake gamma: quiet/active, before/after sleep


load('behavResources.mat', 'MovAcctsd')

Acc_Wake=Restrict(MovAcctsd,Wake);
Acc_NREM=Restrict(MovAcctsd,SWSEpoch);
Acc_REM=Restrict(MovAcctsd,REMEpoch);

% defining quiet epoch, <4e7 accelero & >10s
New_Acc_Wake=tsd(Range(Acc_Wake),runmean(Data(Acc_Wake),30));
Quiet_Wake=thresholdIntervals(New_Acc_Wake,4e7,'Direction','Below');
Quiet_Wake=dropShortIntervals(Quiet_Wake,10*1e4);
Quiet_Wake=mergeCloseIntervals(Quiet_Wake,5*1e4);
Active_Wake = Wake-Quiet_Wake;

sum(Stop(Quiet_Wake)-Start(Quiet_Wake))/sum(Stop(Wake)-Start(Wake)) % proportion of quiet wake
New_Acc_Wake_Quiet = Restrict(New_Acc_Wake , Quiet_Wake);
Sptsd_Wake_Quiet=Restrict(Sptsd_Wake , Quiet_Wake);
Sptsd_Wake_Active=Restrict(Sptsd_Wake , Active_Wake);


Wake_before_sleep = intervalSet(0,1e7);
Wake_after_sleep = intervalSet(5e7,3e8);
New_Acc_Wake_Before = Restrict(New_Acc_Wake , Wake_before_sleep);
New_Acc_Wake_After = Restrict(New_Acc_Wake , Wake_after_sleep);
Sptsd_Wake_Before = Restrict(Sptsd_Wake , Wake_before_sleep);
Sptsd_Wake_After = Restrict(Sptsd_Wake , Wake_after_sleep);

% figures
figure
subplot(221)
plot(Range(New_Acc_Wake),Data(New_Acc_Wake),'c')
hold on
plot(Range(New_Acc_Wake_Quiet),Data(New_Acc_Wake_Quiet),'m')
legend('Active Wake','Quiet Wake')
makepretty

subplot(223)
plot(Spectro{3} , nanmean(Data(Sptsd_Wake)),'b')
hold on
plot(Spectro{3} , nanmean(Data(Sptsd_Wake_Quiet)),'m')
plot(Spectro{3} , nanmean(Data(Sptsd_Wake_Active)),'c')
legend('Wake','Quiet Wake','Active Wake')
makepretty
ylim([0 1.3e4])
ylabel('Power (A.U.)')
xlabel('Frequency (Hz)')
title('OB oscillations during baseline sleep')

subplot(222)
plot(Range(New_Acc_Wake_After),Data(New_Acc_Wake_After),'c')
hold on
plot(Range(New_Acc_Wake_Before),Data(New_Acc_Wake_Before),'m')
legend('Wake after sleep','Wake before sleep')
makepretty

subplot(224)
plot(Spectro{3} , nanmean(Data(Sptsd_Wake)),'b')
hold on
plot(Spectro{3} , nanmean(Data(Sptsd_Wake_Before)),'m')
plot(Spectro{3} , nanmean(Data(Sptsd_Wake_Active)),'c')
legend('Wake','Wake before sleep','Wake after sleep')
makepretty
ylim([0 1.3e4])
ylabel('Power (A.U.)')
xlabel('Frequency (Hz)')
title('OB oscillations during baseline sleep')



%% Summing data for mice
% strange strains
GetSleepSession_DiffMiceStrains
for mouse=1:length(filename)
    
    cd(filename{mouse})
    
    clear Epoch Spectro
    load('B_Middle_Spectrum.mat')
    
    load('SleepScoring_OBGamma.mat')
    
    Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
    
    Sptsd_Wake = Restrict(Sptsd , Wake);
    Sptsd_NREM = Restrict(Sptsd , SWSEpoch);
    Sptsd_REM = Restrict(Sptsd , REMEpoch);
    
    MeanSpec_All_Wake(mouse,:) = nanmean(Data(Sptsd_Wake));
    MeanSpec_All_NREM(mouse,:) = nanmean(Data(Sptsd_NREM));
    MeanSpec_All_REM(mouse,:) = nanmean(Data(Sptsd_REM));
    
end

figure
for mouse=1:length(filename)
    
    subplot(3,3,mouse)
    plot(Spectro{3} , MeanSpec_All_Wake(mouse,:),'b')
    hold on
    plot(Spectro{3} , MeanSpec_All_NREM(mouse,:),'r')
    plot(Spectro{3} , MeanSpec_All_REM(mouse,:),'g')
    makepretty
    ylim([0 3e4])
    
    if mouse==1
        legend('Wake','NREM','REM')
        ylabel('Power (A.U.)')
    elseif mouse==4
        ylabel('Power (A.U.)')
    end
    
end

xlabel('Frequency (Hz)')
title('OB oscillations during baseline sleep')

a=suptitle('OB High mean spectrum for different mice strains'); a.FontSize=20;


% C57Bl6
Mouse=[739 740 750 775 849 829 851 856 857];
for mouse = 1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    BaselineSleepSess.(Mouse_names{mouse}) = GetBaselineSleepSessions_BM(Mouse(mouse));
    BaselineSleepSess.(Mouse_names{mouse}) = [{BaselineSleepSess.(Mouse_names{mouse}){1}}];
end
cd(BaselineSleepSess.(Mouse_names{mouse}){1})

for mouse=1:length(Mouse)
    
    cd(BaselineSleepSess.(Mouse_names{mouse}){1})
    clear Epoch Spectro Sptsd
    load('B_Middle_Spectrum.mat')
    load('SleepScoring_OBGamma.mat')
    load('SleepSubstages.mat')
    
    Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
    
    Sptsd_Wake = Restrict(Sptsd , Wake);
    Sptsd_NREM = Restrict(Sptsd , SWSEpoch);
    Sptsd_REM = Restrict(Sptsd , REMEpoch);
    
    MeanSpec_All_Wake2(mouse,:) = nanmean(Data(Sptsd_Wake));
    MeanSpec_All_NREM2(mouse,:) = nanmean(Data(Sptsd_NREM));
    MeanSpec_All_REM2(mouse,:) = nanmean(Data(Sptsd_REM));
    
    Sptsd_N1=Restrict(Sptsd,Epoch{1});
    Sptsd_N2=Restrict(Sptsd,Epoch{2});
    Sptsd_N3=Restrict(Sptsd,Epoch{3});
    
    MeanSpec_All_N1(mouse,:) = nanmean(Data(Sptsd_N1));
    MeanSpec_All_N2(mouse,:) = nanmean(Data(Sptsd_N2));
    MeanSpec_All_N3(mouse,:) = nanmean(Data(Sptsd_N3));
    
end


figure
for mouse=1:length(Mouse)
    
    subplot(3,3,mouse)
    plot(Spectro{3} , MeanSpec_All_Wake2(mouse,:),'b')
    hold on
    plot(Spectro{3} , MeanSpec_All_NREM2(mouse,:),'r')
    plot(Spectro{3} , MeanSpec_All_REM2(mouse,:),'g')
    makepretty
    ylim([0 2e4])
    
    if mouse==1
        legend('Wake','NREM','REM')
        ylabel('Power (A.U.)')
    elseif or(mouse==4,mouse==7)
        ylabel('Power (A.U.)')
    elseif or(mouse==7,or(mouse==8,mouse==9))
        xlabel('Frequency (Hz)')
    end
    
    title(num2str(Mouse(mouse)))
end

a=suptitle('OB High mean spectrum for C57Bl6 mice'); a.FontSize=20;

% mean spectrum for few mice
figure
subplot(131)
 Conf_Inter=nanstd(MeanSpec_All_Wake2)/sqrt(size(MeanSpec_All_Wake2,1));
shadedErrorBar(Spectro{3},nanmean(MeanSpec_All_Wake2),Conf_Inter,{'Color','b','Linewidth',2},1); hold on
 Conf_Inter=nanstd(MeanSpec_All_NREM2)/sqrt(size(MeanSpec_All_NREM2,1));
shadedErrorBar(Spectro{3},nanmean(MeanSpec_All_NREM2),Conf_Inter,{'Color','r','Linewidth',2},1); hold on
 Conf_Inter=nanstd(MeanSpec_All_REM2)/sqrt(size(MeanSpec_All_REM2,1));
shadedErrorBar(Spectro{3},nanmean(MeanSpec_All_REM2),Conf_Inter,{'Color','g','Linewidth',2},1); hold on
f=get(gca,'Children');
a=legend([f(12),f(8),f(4)],'Wake','NREM','REM'); 
makepretty
ylim([0 2e4]); xlim([10 100])
ylabel('Power (A.U.)')
xlabel('Frequency (Hz)')
title('linear scale')

subplot(132)
 Conf_Inter=nanstd(MeanSpec_All_Wake2)/sqrt(size(MeanSpec_All_Wake2,1));
shadedErrorBar(Spectro{3},nanmean(MeanSpec_All_Wake2),Conf_Inter,{'Color','b','Linewidth',2},1); hold on
 Conf_Inter=nanstd(MeanSpec_All_NREM2)/sqrt(size(MeanSpec_All_NREM2,1));
shadedErrorBar(Spectro{3},nanmean(MeanSpec_All_NREM2),Conf_Inter,{'Color','r','Linewidth',2},1); hold on
 Conf_Inter=nanstd(MeanSpec_All_REM2)/sqrt(size(MeanSpec_All_REM2,1));
shadedErrorBar(Spectro{3},nanmean(MeanSpec_All_REM2),Conf_Inter,{'Color','g','Linewidth',2},1); hold on
set(gca,'yscale','log')
makepretty
ylim([0 2e4]); xlim([10 100])
xlabel('Frequency (Hz)')
title('log scale')

subplot(133)
 Conf_Inter=nanstd(Spectro{3}.*MeanSpec_All_Wake2)/sqrt(size(MeanSpec_All_Wake2,1));
shadedErrorBar(Spectro{3},Spectro{3}.*nanmean(MeanSpec_All_Wake2),Conf_Inter,{'Color','b','Linewidth',2},1); hold on
 Conf_Inter=nanstd(Spectro{3}.*MeanSpec_All_NREM2)/sqrt(size(MeanSpec_All_NREM2,1));
shadedErrorBar(Spectro{3},Spectro{3}.*nanmean(MeanSpec_All_NREM2),Conf_Inter,{'Color','r','Linewidth',2},1); hold on
 Conf_Inter=nanstd(Spectro{3}.*MeanSpec_All_REM2)/sqrt(size(MeanSpec_All_REM2,1));
shadedErrorBar(Spectro{3},Spectro{3}.*nanmean(MeanSpec_All_REM2),Conf_Inter,{'Color','g','Linewidth',2},1); hold on
makepretty
ylim([0 7e5]); xlim([10 100])
xlabel('Frequency (Hz)')
title('Mean spectrum x f, log scale')
set(gca,'yscale','log')

a=suptitle('OB mean spectrum, baseline sleep, C57Bl6 mice'); a.FontSize=20;


% NREM substages
figure
 Conf_Inter=nanstd(MeanSpec_All_N1([3 5 6 7],:))/sqrt(4);
shadedErrorBar(Spectro{3},nanmean(MeanSpec_All_N1([3 5 6 7],:)),Conf_Inter,{'Color','m','Linewidth',2},1); hold on
 Conf_Inter=nanstd(MeanSpec_All_N2([3 5 6 7],:))/sqrt(4);
shadedErrorBar(Spectro{3},nanmean(MeanSpec_All_N2([3 5 6 7],:)),Conf_Inter,{'Color','r','Linewidth',2},1); hold on
 Conf_Inter=nanstd(MeanSpec_All_N3([3 5 6 7],:))/sqrt(4);
shadedErrorBar(Spectro{3},nanmean(MeanSpec_All_N3([3 5 6 7],:)),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
f=get(gca,'Children');
a=legend([f(12),f(8),f(4)],'N1','N2','N3'); 
makepretty
ylim([0 1e4]); xlim([10 100])
ylabel('Power (A.U.)')
xlabel('Frequency (Hz)')
title('linear scale')

title('OB gamma, NREM substages, baseline sleep')


plot(Spectro{3} , nanmean(Data(Sptsd_N1)),'b')
hold on
plot(Spectro{3} , nanmean(Data(Sptsd_N2)),'r')
plot(Spectro{3} , nanmean(Data(Sptsd_N3)),'g')
legend('Wake','NREM','REM')
makepretty
ylim([0 1e4])
vline(47,'--b'); vline(80,'--b'); 
vline(22,'--r'); vline(32,'--r'); 
vline(24,'--g'); vline(47,'--g'); 
ylabel('Power (A.U.)')
xlabel('Frequency (Hz)')
title('OB oscillations during baseline sleep')






%% Looking at gamma characteristics

[Power_Wake,Freq_Wake] = max(Sp_Wake(:,13:end)');
[Power_NREM,Freq_NREM] = max(Sp_NREM(:,13:end)');
[Power_REM,Freq_REM] = max(Sp_REM(:,13:end)');

Freq_Wake=Spectro{3}(Freq_Wake+12); Freq_NREM=Spectro{3}(Freq_NREM+12); Freq_REM=Spectro{3}(Freq_REM+12);
Freq_Wake(Freq_Wake==Spectro{3}(13))=NaN; Freq_NREM(Freq_NREM==Spectro{3}(13))=NaN; Freq_REM(Freq_REM==Spectro{3}(13))=NaN;

figure
[theText, rawN, x] = nhist({Freq_Wake , Freq_NREM , Freq_REM} , 'minbins', 64 , 'maxbins', 64);
legend('Wake','NREM','REM')

a=set(gca, 'Xtick', x{1, 1}(1:8:end) ,'Xticklabel', num2cell(round(Spectro{3}(13:8:end),-1)));
xtickangle(45)
xlabel('Frequency (Hz)')
title('Frequency distribution, baseline sleep')


MeanPower_20_45_band_Wake = nanmean(Sp_Wake(:,13:33)');
MeanPower_20_45_band_NREM = nanmean(Sp_NREM(:,13:33)');
MeanPower_20_45_band_REM = nanmean(Sp_REM(:,13:33)');

figure
nhist({log10(MeanPower_20_45_band_Wake) , log10(MeanPower_20_45_band_NREM) , log10(MeanPower_20_45_band_REM)} , 'samebins')
makepretty
title('Mean power [20-50 Hz] distribution')
xlabel('Power (log scale)')
legend('Wake','NREM','REM')




MeanPower_20_45_band_REM_tsd = tsd(Range(Sptsd_REM) , log(MeanPower_20_45_band_REM)');
Epoch_With_REMGamma_High = thresholdIntervals(MeanPower_20_45_band_REM_tsd , 9.5 , 'Direction','Above');

REM_With_REMGamma_High_tsd=Restrict(MeanPower_20_45_band_REM_tsd , Epoch_With_REMGamma_High);

histogram(Range(MeanPower_20_45_band_REM_tsd),100)
hold on
histogram(Range(REM_With_REMGamma_High_tsd),100)






