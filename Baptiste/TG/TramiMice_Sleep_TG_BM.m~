
%% path true NAS6
P{1} = '/media/nas6/Projet TramiPV/TG1_TG2_BaselineSleep_240531_095224/M2';
P{2} = '/media/nas6/Projet TramiPV/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M3';
P{3} = '/media/nas6/Projet TramiPV/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M4';
P{4} = '/media/nas6/Projet TramiPV/Trami_TG5_BaselineSleep_240718_093343';

P{5} = '/media/nas6/Projet TramiPV/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M1';
P{6} = '/media/nas6/Projet TramiPV/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M8';
P{7} = '/media/nas6/Projet TramiPV/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M7';
P{8} = '/media/nas6/Projet TramiPV/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M9';


P{1} = '/media/nas6/Projet TramiPV/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M7';
P{3} = '/media/nas6/Projet TramiPV/Trami_TG3_TG7_BaselineSleep_240627_092728/M7'

%% path true GALLOPIN extDrive
% P{1} = '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M2_240531_095224';
% P{2} = '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M3_240709_093745';
% P{3} = '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M4_240705_100948';
% P{4} = '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M5_240718_093343';
% 
% P{5} = '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M1_240628_091858';
% P{6} = '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M7_240711_090852';
% P{7} = '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M8_240704_093657';
% P{8} = '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M9_240711_090852';

% %% path other

P{1} = '/media/nas6/Projet TramiPV/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M2';
P{2} = '/media/nas6/Projet TramiPV/TG1_TG2_BaselineSleep_240531_095224/M2';
P{3} = '/media/nas6/Projet TramiPV/Trami_TG3_TG7_BaselineSleep_240627_092728/M3';
P{4} = '/media/nas6/Projet TramiPV/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M3';
P{5} = '/media/nas6/Projet TramiPV/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M4';
P{6} = '/media/nas6/Projet TramiPV/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M4';
P{7} = '/media/nas6/Projet TramiPV/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M4';
P{8} = '/media/nas6/Projet TramiPV/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M5';
P{9} = '/media/nas6/Projet TramiPV/Trami_TG5_BaselineSleep_240718_093343';

P{10} = '/media/nas6/Projet TramiPV/TG1_TG2_BaselineSleep_240531_095224/M1';
P{11} = '/media/nas6/Projet TramiPV/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M1';
P{12} = '/media/nas6/Projet TramiPV/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M1';
P{13} = '/media/nas6/Projet TramiPV/Trami_TG3_TG7_BaselineSleep_240627_092728/M7';
P{14} = '/media/nas6/Projet TramiPV/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M7';
P{15} = '/media/nas6/Projet TramiPV/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M8';
P{16} = '/media/nas6/Projet TramiPV/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M8';
P{17} = '/media/nas6/Projet TramiPV/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M8';
P{18} = '/media/nas6/Projet TramiPV/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M9';
P{19} = '/media/nas6/Projet TramiPV/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M9';
P{20} = '/media/nas6/Projet TramiPV/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M9';



% % make data, generate new spectrogram for high frquencies for OB and Somato cortex
% for i=9:23
%     cd(P{i})
% %     load('ChannelsToAnalyse/Bulb_deep.mat')
% %     MiddleSpectrum_BM(pwd,channel,'B')
%     load('ChannelsToAnalyse/SomCx_deep.mat')
%     MiddleSpectrum_BM(pwd,channel,'Somato')
%     %CreateRipplesSleep('scoring','accelero','non_rip_chan',0)
% end

%% generate data
for i=1:20
    clear Wake SWSEpoch REMEpoch MovAcctsd
    load([P{i} filesep 'SleepScoring_Accelero.mat'],'Wake','SWSEpoch','REMEpoch')
    %load([P{i} filesep 'behavResources.mat'], 'MovAcctsd')
    %load([P{i} filesep 'SWR.mat'])
    
%     % OB
%     load([P{i} filesep 'B_Middle_Spectrum.mat'])
%     Range_Middle = Spectro{3};
%     OB_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
%     
%     OB_Wake = Restrict(OB_Sptsd , Wake);
%     OB_NREM = Restrict(OB_Sptsd , SWSEpoch);
%     OB_REM = Restrict(OB_Sptsd , REMEpoch);
%     
%     OB_MeanSp_Wake(i,:) = nanmean(Data(OB_Wake)); % mean spectrum
%     OB_MeanSp_NREM(i,:) = nanmean(Data(OB_NREM));
%     OB_MeanSp_REM(i,:) = nanmean(Data(OB_REM));
    
    % Somato
    load([P{i} filesep 'Somato_Middle_Spectrum.mat'])
    Range_Middle = Spectro{3};
    Somato_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
    
    Somato_Wake = Restrict(Somato_Sptsd , Wake);
    Somato_NREM = Restrict(Somato_Sptsd , SWSEpoch);
    Somato_REM = Restrict(Somato_Sptsd , REMEpoch);
    
    Somato_MeanSp_Wake(i,:) = nanmean(Data(Somato_Wake));
    Somato_MeanSp_NREM(i,:) = nanmean(Data(Somato_NREM));
    Somato_MeanSp_REM(i,:) = nanmean(Data(Somato_REM));
    
%         % H_VHigh
%     load([P{i} filesep 'H_VHigh_Spectrum.mat'])
%     Range_VHigh = Spectro{3};
%     H_VHigh_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
%     
%     H_VHigh_Wake = Restrict(H_VHigh_Sptsd , Wake);
%     H_VHigh_NREM = Restrict(H_VHigh_Sptsd , SWSEpoch);
%     H_VHigh_REM = Restrict(H_VHigh_Sptsd , REMEpoch);
%     
%     H_VHigh_MeanSp_Wake(i,:) = nanmean(Data(H_VHigh_Wake)); % mean spectrum
%     H_VHigh_MeanSp_NREM(i,:) = nanmean(Data(H_VHigh_NREM));
%     H_VHigh_MeanSp_REM(i,:) = nanmean(Data(H_VHigh_REM));
    
%     % Accelero
%     Mean_Acc_Wake(i,:) = nanmean(Data(Restrict(MovAcctsd , Wake))); % mean spectrum
%     Mean_Acc_NREM(i,:) = nanmean(Data(Restrict(MovAcctsd , SWSEpoch)));
%     Mean_Acc_REM(i,:) = nanmean(Data(Restrict(MovAcctsd , REMEpoch)));
%     
%     % Ripples
%     Ripples_Density(i) = length(Restrict(tRipples , SWSEpoch))./(sum(DurationEpoch(SWSEpoch))./1e4);
    
    disp(i)
end

%% figures OB
figure
subplot(331)
plot(Range_Middle , OB_MeanSp_Wake(1:4,:)' , 'k'), hold on
plot(Range_Middle , OB_MeanSp_Wake(5:8,:)' , 'r')
xlim([20 100]), box off, %ylim([0 2])
f=get(gca,'Children'); l=legend([f([8 4])],'Control','Mutant');
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')
title('Wake')

subplot(334)
plot(Range_Middle , OB_MeanSp_Wake(1:4,:)'./max(OB_MeanSp_Wake(1:4,37:end)') , 'k'), hold on
plot(Range_Middle , OB_MeanSp_Wake(5:8,:)'./max(OB_MeanSp_Wake(5:8,37:end)') , 'r')
xlim([20 100]), box off, %ylim([0 2])
f=get(gca,'Children'); l=legend([f([8 4])],'Control','Mutant');
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')

subplot(337)
[h , MaxPowerValues_Sal , Freq_Max] = Plot_MeanSpectrumForMice_BM(OB_MeanSp_Wake(1:4,:) , 'threshold', 37 , 'color' , 'k')
[h , MaxPowerValues_Trami , Freq_Max] = Plot_MeanSpectrumForMice_BM(OB_MeanSp_Wake(5:8,:) , 'threshold', 37 , 'color' , 'r')
xlim([20 100]), ylim([0 1.3]), box off
f=get(gca,'Children'); l=legend([f([8 4])],'Control','Mutant');

subplot(332)
plot(Range_Middle , OB_MeanSp_NREM(1:4,:)' , 'k'), hold on
plot(Range_Middle , OB_MeanSp_NREM(5:8,:)' , 'r')
xlim([20 100]), box off, %ylim([0 2])
xlabel('Frequency (Hz)')
title('NREM')

subplot(335)
plot(Range_Middle , OB_MeanSp_NREM(1:4,:)'./max(OB_MeanSp_NREM(1:4,37:end)') , 'k'), hold on
plot(Range_Middle , OB_MeanSp_NREM(5:8,:)'./max(OB_MeanSp_NREM(5:8,37:end)') , 'r')
xlim([20 100]), box off, %ylim([0 2])
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')

subplot(338)
Plot_MeanSpectrumForMice_BM(OB_MeanSp_NREM(1:4,:) , 'threshold', 37 , 'color' , 'k')
Plot_MeanSpectrumForMice_BM(OB_MeanSp_NREM(5:8,:) , 'threshold', 37 , 'color' , 'r')
ylim([0 2]), box off
f=get(gca,'Children'); l=legend([f([8 4])],'Control','Mutant');

subplot(333)
plot(Range_Middle , OB_MeanSp_REM(1:4,:)' , 'k'), hold on
plot(Range_Middle , OB_MeanSp_REM(5:8,:)' , 'r')
xlim([20 100]), %ylim([0 2])
xlabel('Frequency (Hz)'), box off
title('REM')

subplot(336)
plot(Range_Middle , OB_MeanSp_REM(1:4,:)'./max(OB_MeanSp_REM(1:4,37:end)') , 'k'), hold on
plot(Range_Middle , OB_MeanSp_REM(5:8,:)'./max(OB_MeanSp_REM(5:8,37:end)') , 'r')
xlim([20 100]), box off, %ylim([0 2])
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')

subplot(339)
Plot_MeanSpectrumForMice_BM(OB_MeanSp_REM(1:4,:) , 'threshold', 37 , 'color' , 'k')
Plot_MeanSpectrumForMice_BM(OB_MeanSp_REM(5:8,:) , 'threshold', 37 , 'color' , 'r')
ylim([0 2.5]), box off
f=get(gca,'Children'); l=legend([f([8 4])],'Control','Mutant');

a=suptitle('OB High during arousal states'); a.FontSize=20;


for i=1:8
    MeanPower_OB_Wake(i) = nanmean(OB_MeanSp_Wake(i,37:end));
    MeanPower_OB_NREM(i) = nanmean(OB_MeanSp_NREM(i,37:end));
    MeanPower_OB_REM(i) = nanmean(OB_MeanSp_REM(i,37:end));
end 

Cols = {[.3 .3 .3],[.7 .3 .3]};
X = [1:2];
Legends = {'Control','Mutant'};


figure
subplot(231)
MakeSpreadAndBoxPlot3_SB({log10(MeanPower_OB_Wake(1:4)) log10(MeanPower_OB_Wake(5:8))},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('OB power, Wake (log scale)')

subplot(232)
MakeSpreadAndBoxPlot3_SB({log10(MeanPower_OB_NREM(1:4)) log10(MeanPower_OB_NREM(5:8))},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('OB power, NREM (log scale)')

subplot(233)
MakeSpreadAndBoxPlot3_SB({log10(MeanPower_OB_REM(1:4)) log10(MeanPower_OB_REM(5:8))},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('OB power, REM (log scale)')


subplot(235)
MakeSpreadAndBoxPlot3_SB({MeanPower_OB_NREM(1:4)./MeanPower_OB_Wake(1:4) MeanPower_OB_NREM(5:8)./MeanPower_OB_Wake(5:8)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('OB power, NREM (Wake norm))')

subplot(236)
MakeSpreadAndBoxPlot3_SB({MeanPower_OB_REM(1:4)./MeanPower_OB_Wake(1:4) MeanPower_OB_REM(5:8)./MeanPower_OB_Wake(5:8)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('OB power, REM (Wake norm)')


%% figures Somato
FreqLim = max(find(Range_Middle<50))+1;

figure
subplot(331)
plot(Range_Middle , Range_Middle'.*Somato_MeanSp_Wake(1:4,:)' , 'k'), hold on
plot(Range_Middle , Range_Middle'.*Somato_MeanSp_Wake(5:8,:)' , 'r')
xlim([20 100]), box off, %ylim([0 2])
f=get(gca,'Children'); l=legend([f([8 4])],'Control','Mutant');
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)'), set(gca,'YScale','log')
title('Wake')

subplot(334)
plot(Range_Middle , Range_Middle'.*Somato_MeanSp_Wake(1:4,:)'./max(Range_Middle(FreqLim:end)'.*Somato_MeanSp_Wake(1:4,FreqLim:end)') , 'k'), hold on
plot(Range_Middle , Range_Middle'.*Somato_MeanSp_Wake(5:8,:)'./max(Range_Middle(FreqLim:end)'.*Somato_MeanSp_Wake(5:8,FreqLim:end)') , 'r')
xlim([20 100]), ylim([1e-1 2]), box off, %ylim([0 2])
f=get(gca,'Children'); l=legend([f([8 4])],'Control','Mutant');
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)'), set(gca,'YScale','log')

subplot(337)
Plot_MeanSpectrumForMice_BM(Range_Middle.*Somato_MeanSp_Wake(1:4,:) , 'threshold', FreqLim , 'color' , 'k')
Plot_MeanSpectrumForMice_BM(Range_Middle.*Somato_MeanSp_Wake(5:8,:) , 'threshold', FreqLim , 'color' , 'r')
xlim([20 100]), ylim([0 1.3]), box off
f=get(gca,'Children'); l=legend([f([8 4])],'Control','Mutant');

subplot(332)
plot(Range_Middle , Range_Middle'.*Somato_MeanSp_NREM(1:4,:)' , 'k'), hold on
plot(Range_Middle , Range_Middle'.*Somato_MeanSp_NREM(5:8,:)' , 'r')
xlim([20 100]), box off, %ylim([0 2])
xlabel('Frequency (Hz)'), set(gca,'YScale','log')
title('NREM')

subplot(335)
plot(Range_Middle , Range_Middle'.*Somato_MeanSp_NREM(1:4,:)'./max(Range_Middle(FreqLim:end)'.*Somato_MeanSp_NREM(1:4,FreqLim:end)') , 'k'), hold on
plot(Range_Middle , Range_Middle'.*Somato_MeanSp_NREM(5:8,:)'./max(Range_Middle(FreqLim:end)'.*Somato_MeanSp_NREM(5:8,FreqLim:end)') , 'r')
xlim([20 100]), box off, ylim([1e-1 2])
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)'), set(gca,'YScale','log')

subplot(338)
Plot_MeanSpectrumForMice_BM(Range_Middle.*Somato_MeanSp_NREM(1:4,:) , 'threshold', FreqLim , 'color' , 'k')
Plot_MeanSpectrumForMice_BM(Range_Middle.*Somato_MeanSp_NREM(5:8,:) , 'threshold', FreqLim , 'color' , 'r')
ylim([0 2]), box off
f=get(gca,'Children'); l=legend([f([8 4])],'Control','Mutant');

subplot(333)
plot(Range_Middle , Range_Middle'.*Somato_MeanSp_REM(1:4,:)' , 'k'), hold on
plot(Range_Middle , Range_Middle'.*Somato_MeanSp_REM(5:8,:)' , 'r')
xlim([20 100]), %ylim([0 2])
xlabel('Frequency (Hz)'), set(gca,'YScale','log'), box off
title('REM')

subplot(336)
plot(Range_Middle , Range_Middle'.*Somato_MeanSp_REM(1:4,:)'./max(Range_Middle(FreqLim:end)'.*Somato_MeanSp_REM(1:4,FreqLim:end)') , 'k'), hold on
plot(Range_Middle , Range_Middle'.*Somato_MeanSp_REM(5:8,:)'./max(Range_Middle(FreqLim:end)'.*Somato_MeanSp_REM(5:8,FreqLim:end)') , 'r')
xlim([20 100]), box off, ylim([1e-1 2])
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)'), set(gca,'YScale','log')

subplot(339)
Plot_MeanSpectrumForMice_BM(Range_Middle.*Somato_MeanSp_REM(1:4,:) , 'threshold', FreqLim , 'color' , 'k')
Plot_MeanSpectrumForMice_BM(Range_Middle.*Somato_MeanSp_REM(5:8,:) , 'threshold', FreqLim , 'color' , 'r')
ylim([0 2.5]), box off
f=get(gca,'Children'); l=legend([f([8 4])],'Control','Mutant');

a=suptitle('Somato Cx High during arousal states'); a.FontSize=20;


for i=1:8
%     MeanPower_Somato_Wake(i) = nanmean(Range_Middle(62:end).*Somato_MeanSp_Wake(i,62:end));
%     MeanPower_Somato_NREM(i) = nanmean(Range_Middle(62:end).*Somato_MeanSp_NREM(i,62:end));
%     MeanPower_Somato_REM(i) = nanmean(Range_Middle(62:end).*Somato_MeanSp_REM(i,62:end));
%      
    MeanPower_Somato_Wake(i) = nanmean(Somato_MeanSp_Wake(i,37:end));
    MeanPower_Somato_NREM(i) = nanmean(Somato_MeanSp_NREM(i,37:end));
    MeanPower_Somato_REM(i) = nanmean(Somato_MeanSp_REM(i,37:end));
end 

Cols = {[.3 .3 .3],[.7 .3 .3]};
X = [1:2];
Legends = {'Control','Mutant'};

figure
subplot(231)
MakeSpreadAndBoxPlot3_SB({log10(MeanPower_Somato_Wake(1:4)) log10(MeanPower_Somato_Wake(5:8))},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Somato power, Wake (log scale)')

subplot(232)
MakeSpreadAndBoxPlot3_SB({log10(MeanPower_Somato_NREM(1:4)) log10(MeanPower_Somato_NREM(5:8))},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Somato power, NREM (log scale)')

subplot(233)
MakeSpreadAndBoxPlot3_SB({log10(MeanPower_Somato_REM(1:4)) log10(MeanPower_Somato_REM(5:8))},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Somato power, REM (log scale)')


subplot(235)
MakeSpreadAndBoxPlot3_SB({MeanPower_Somato_NREM(1:4)./MeanPower_Somato_Wake(1:4) MeanPower_Somato_NREM(5:8)./MeanPower_Somato_Wake(5:8)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Somato power, NREM (Wake norm))')

subplot(236)
MakeSpreadAndBoxPlot3_SB({MeanPower_Somato_REM(1:4)./MeanPower_Somato_Wake(1:4) MeanPower_Somato_REM(5:8)./MeanPower_Somato_Wake(5:8)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Somato power, REM (Wake norm)')


%% Ripples
figure
MakeSpreadAndBoxPlot3_SB({Ripples_Density(1:4) Ripples_Density(5:8)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('SWR occurence, NREM (#/s)')



%% Acc
figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({Mean_Acc_Wake(1:4) Mean_Acc_Wake(5:8)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('OB power, Wake (log scale)')

subplot(132)
MakeSpreadAndBoxPlot3_SB({Mean_Acc_NREM(1:4) Mean_Acc_NREM(5:8)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('OB power, NREM (log scale)')

subplot(133)
MakeSpreadAndBoxPlot3_SB({Mean_Acc_REM(1:4) Mean_Acc_REM(5:8)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('OB power, REM (log scale)')



%% figures HPC VHigh

figure
subplot(331)
plot(Range_VHigh , Range_VHigh'.*H_VHigh_MeanSp_Wake(1:4,:)' , 'k'), hold on
plot(Range_VHigh , Range_VHigh'.*H_VHigh_MeanSp_Wake(5:8,:)' , 'r')
xlim([20 250]), box off, %ylim([0 2])
f=get(gca,'Children'); l=legend([f([8 4])],'Control','Mutant');
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)'), set(gca,'YScale','log')
title('Wake')

subplot(334)
plot(Range_VHigh , Range_VHigh'.*H_VHigh_MeanSp_Wake(1:4,:)'./max(Range_VHigh(37:end)'.*H_VHigh_MeanSp_Wake(1:4,37:end)') , 'k'), hold on
plot(Range_VHigh , Range_VHigh'.*H_VHigh_MeanSp_Wake(5:8,:)'./max(Range_VHigh(37:end)'.*H_VHigh_MeanSp_Wake(5:8,37:end)') , 'r')
xlim([20 250]), ylim([1e-1 15]), box off, %ylim([0 2])
f=get(gca,'Children'); l=legend([f([8 4])],'Control','Mutant');
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)'), set(gca,'YScale','log')

subplot(337)
Plot_MeanSpectrumForMice_BM(Range_VHigh.*H_VHigh_MeanSp_Wake(1:4,:) , 'threshold', 37 , 'color' , 'k')
Plot_MeanSpectrumForMice_BM(Range_VHigh.*H_VHigh_MeanSp_Wake(5:8,:) , 'threshold', 37 , 'color' , 'r')
xlim([20 250]), ylim([0 5]), box off
f=get(gca,'Children'); l=legend([f([8 4])],'Control','Mutant');

subplot(332)
plot(Range_VHigh , Range_VHigh'.*H_VHigh_MeanSp_NREM(1:4,:)' , 'k'), hold on
plot(Range_VHigh , Range_VHigh'.*H_VHigh_MeanSp_NREM(5:8,:)' , 'r')
xlim([20 250]), box off, %ylim([0 2])
xlabel('Frequency (Hz)'), set(gca,'YScale','log')
title('NREM')

subplot(335)
plot(Range_VHigh , Range_VHigh'.*H_VHigh_MeanSp_NREM(1:4,:)'./max(Range_VHigh(37:end)'.*H_VHigh_MeanSp_NREM(1:4,37:end)') , 'k'), hold on
plot(Range_VHigh , Range_VHigh'.*H_VHigh_MeanSp_NREM(5:8,:)'./max(Range_VHigh(37:end)'.*H_VHigh_MeanSp_NREM(5:8,37:end)') , 'r')
xlim([20 250]), box off,  ylim([1e-1 15])
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)'), set(gca,'YScale','log')

subplot(338)
Plot_MeanSpectrumForMice_BM(Range_VHigh.*H_VHigh_MeanSp_NREM(1:4,:) , 'threshold', 37 , 'color' , 'k')
Plot_MeanSpectrumForMice_BM(Range_VHigh.*H_VHigh_MeanSp_NREM(5:8,:) , 'threshold', 37 , 'color' , 'r')
ylim([0 2]), box off
f=get(gca,'Children'); l=legend([f([8 4])],'Control','Mutant');

subplot(333)
plot(Range_VHigh , Range_VHigh'.*H_VHigh_MeanSp_REM(1:4,:)' , 'k'), hold on
plot(Range_VHigh , Range_VHigh'.*H_VHigh_MeanSp_REM(5:8,:)' , 'r')
xlim([20 250]), %ylim([0 2])
xlabel('Frequency (Hz)'), set(gca,'YScale','log'), box off
title('REM')

subplot(336)
plot(Range_VHigh , Range_VHigh'.*H_VHigh_MeanSp_REM(1:4,:)'./max(Range_VHigh(37:end)'.*H_VHigh_MeanSp_REM(1:4,37:end)') , 'k'), hold on
plot(Range_VHigh , Range_VHigh'.*H_VHigh_MeanSp_REM(5:8,:)'./max(Range_VHigh(37:end)'.*H_VHigh_MeanSp_REM(5:8,37:end)') , 'r')
xlim([20 250]), box off, ylim([1e-1 15])
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)'), set(gca,'YScale','log')

subplot(339)
Plot_MeanSpectrumForMice_BM(Range_VHigh.*H_VHigh_MeanSp_REM(1:4,:) , 'threshold', 37 , 'color' , 'k')
Plot_MeanSpectrumForMice_BM(Range_VHigh.*H_VHigh_MeanSp_REM(5:8,:) , 'threshold', 37 , 'color' , 'r')
xlim([20 250]), ylim([0 5]), box off
f=get(gca,'Children'); l=legend([f([8 4])],'Control','Mutant');

a=suptitle('HPC High during arousal states'); a.FontSize=20;


for i=1:8
    MeanPower_H_VHigh_Wake(i) = nanmean(Range_VHigh(37:end).*H_VHigh_MeanSp_Wake(i,37:end));
    MeanPower_H_VHigh_NREM(i) = nanmean(Range_VHigh(37:end).*H_VHigh_MeanSp_NREM(i,37:end));
    MeanPower_H_VHigh_REM(i) = nanmean(Range_VHigh(37:end).*H_VHigh_MeanSp_REM(i,37:end));
end 

for i=1:8
    MeanPower_H_Gamma_Wake(i) = nanmean(Range_VHigh(1:33).*H_VHigh_MeanSp_Wake(i,1:33));
    MeanPower_H_Gamma_NREM(i) = nanmean(Range_VHigh(1:33).*H_VHigh_MeanSp_NREM(i,1:33));
    MeanPower_H_Gamma_REM(i) = nanmean(Range_VHigh(1:33).*H_VHigh_MeanSp_REM(i,1:33));
end 

Cols = {[.3 .3 .3],[.7 .3 .3]};
X = [1:2];
Legends = {'Control','Mutant'};


figure
subplot(231)
MakeSpreadAndBoxPlot3_SB({log10(MeanPower_H_VHigh_Wake(1:4)) log10(MeanPower_H_VHigh_Wake(5:8))},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('H_VHigh power, Wake (log scale)')

subplot(232)
MakeSpreadAndBoxPlot3_SB({log10(MeanPower_H_VHigh_NREM(1:4)) log10(MeanPower_H_VHigh_NREM(5:8))},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('H_VHigh power, NREM (log scale)')

subplot(233)
MakeSpreadAndBoxPlot3_SB({log10(MeanPower_H_VHigh_REM(1:4)) log10(MeanPower_H_VHigh_REM(5:8))},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('H_VHigh power, REM (log scale)')


subplot(235)
MakeSpreadAndBoxPlot3_SB({MeanPower_H_VHigh_NREM(1:4)./MeanPower_H_VHigh_Wake(1:4) MeanPower_H_VHigh_NREM(5:8)./MeanPower_H_VHigh_Wake(5:8)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('H_VHigh power, NREM (Wake norm))')

subplot(236)
MakeSpreadAndBoxPlot3_SB({MeanPower_H_VHigh_REM(1:4)./MeanPower_H_VHigh_Wake(1:4) MeanPower_H_VHigh_REM(5:8)./MeanPower_H_VHigh_Wake(5:8)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('H_VHigh power, REM (Wake norm)')






figure
subplot(231)
MakeSpreadAndBoxPlot3_SB({log10(MeanPower_H_Gamma_Wake(1:4)) log10(MeanPower_H_Gamma_Wake(5:8))},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('H_Gamma power, Wake (log scale)')

subplot(232)
MakeSpreadAndBoxPlot3_SB({log10(MeanPower_H_Gamma_NREM(1:4)) log10(MeanPower_H_Gamma_NREM(5:8))},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('H_Gamma power, NREM (log scale)')

subplot(233)
MakeSpreadAndBoxPlot3_SB({log10(MeanPower_H_Gamma_REM(1:4)) log10(MeanPower_H_Gamma_REM(5:8))},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('H_Gamma power, REM (log scale)')


subplot(235)
MakeSpreadAndBoxPlot3_SB({MeanPower_H_Gamma_NREM(1:4)./MeanPower_H_Gamma_Wake(1:4) MeanPower_H_Gamma_NREM(5:8)./MeanPower_H_Gamma_Wake(5:8)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('H_Gamma power, NREM (Wake norm))')

subplot(236)
MakeSpreadAndBoxPlot3_SB({MeanPower_H_Gamma_REM(1:4)./MeanPower_H_Gamma_Wake(1:4) MeanPower_H_Gamma_REM(5:8)./MeanPower_H_Gamma_Wake(5:8)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('H_Gamma power, REM (Wake norm)')




%% Ripples mean waveform

load('SWR.mat', 'tRipples')
load('SleepScoring_OBGamma.mat', 'SWSEpoch')
ripples_time = Range(Restrict(tRipples,SWSEpoch),'s');
load('ChannelsToAnalyse/dHPC_rip.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
[M,T] = PlotRipRaw(LFP, ripples_time, 200, 0, 0);
Mean_Ripples(1,:) = M(:,2);


figure
plot(linspace(-200,200,501) , Mean_Ripples(1,:)), vline(0,'--r')
xlabel('time (ms)')





