

% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/OB_Spec.mat')
% or after 
% edit Freezing_FarFromStims_Maze_BM.m

Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};

%% Cond and Ext
% Cond
figure
[h , MaxPowerValues1 , Freq_Max1] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock.Cond, 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0);
[h , MaxPowerValues2 , Freq_Max2] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe.Cond , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0);
close

figure
subplot(3,6,1:2)
Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock.Cond, 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0 , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']'));
Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe.Cond , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0 , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']'));

f=get(gca,'Children'); l=legend([f(5),f(1)],'Shock','Safe'); l.Box='off';
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 15]); ylim([0 1])
makepretty_BM
v1=vline(nanmean(4.73)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(3.053)); set(v2,'LineStyle','--','Color',[.5 .5 1])
xticks([0:2:14])
title('Conditionning')

figure
[h , MaxPowerValues1 , Freq_Max1] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_NoClean_Shock.Cond, 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0);
[h , MaxPowerValues2 , Freq_Max2] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_NoClean_Safe.Cond , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0);
close

subplot(363)
MakeSpreadAndBoxPlot3_SB({Freq_Max1 Freq_Max2},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)')
ylim([0 8])

% Ext
figure
[h , MaxPowerValues1 , Freq_Max1] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock.Ext, 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0);
[h , MaxPowerValues2 , Freq_Max2] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe.Ext , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0);
close

subplot(3,6,4:5)
Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock.Ext, 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0 , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']'));
Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe.Ext , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0 , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']'));

xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 15]); ylim([0 1])
makepretty_BM
v1=vline(nanmean(4.73)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(3.053)); set(v2,'LineStyle','--','Color',[.5 .5 1])
xticks([0:2:14])
title('After conditionning')


figure
[h , MaxPowerValues1 , Freq_Max1] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_NoClean_Shock.Ext, 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0);
[h , MaxPowerValues2 , Freq_Max2] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_NoClean_Safe.Ext , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0);
close
Freq_Max1(7)=NaN;

subplot(366)
MakeSpreadAndBoxPlot3_SB({Freq_Max1 Freq_Max2},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)')
ylim([0 8])



%% Eyelid and PAG
% PAG
figure
[h , MaxPowerValues1 , Freq_Max1] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock.Fear(1:25,:), 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0);
[h , MaxPowerValues2 , Freq_Max2] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe.Fear(1:25,:) , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0);
close

subplot(3,6,7:8)
Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock.Fear(1:25,:), 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0 , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']'));
Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe.Fear(1:25,:) , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0 , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']'));

xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 15]); ylim([0 1])
makepretty_BM
v1=vline(nanmean(4.73)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(3.053)); set(v2,'LineStyle','--','Color',[.5 .5 1])
xticks([0:2:14])
title('PAG')

figure
[h , MaxPowerValues1 , Freq_Max1] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_NoClean_Shock.Fear(1:25,:), 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0);
[h , MaxPowerValues2 , Freq_Max2] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_NoClean_Safe.Fear(1:25,:) , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0);
close
Freq_Max1(7)=NaN;

subplot(369)
MakeSpreadAndBoxPlot3_SB({Freq_Max1 Freq_Max2},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)')
ylim([0 8])

% Eyelid
figure
[h , MaxPowerValues1 , Freq_Max1] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock.Fear(26:end,:), 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0);
[h , MaxPowerValues2 , Freq_Max2] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe.Fear(26:end,:) , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0);
close

subplot(3,6,10:11)
Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock.Fear(26:end,:), 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0 , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']'));
Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe.Fear(26:end,:) , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0 , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']'));

xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 15]); ylim([0 1])
makepretty_BM
v1=vline(nanmean(4.73)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(3.053)); set(v2,'LineStyle','--','Color',[.5 .5 1])
xticks([0:2:14])
title('Eyelid')


figure
[h , MaxPowerValues1 , Freq_Max1] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_NoClean_Shock.Fear(26:end,:), 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0);
[h , MaxPowerValues2 , Freq_Max2] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_NoClean_Safe.Fear(26:end,:) , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0);
close

subplot(3,6,12)
MakeSpreadAndBoxPlot3_SB({Freq_Max1 Freq_Max2},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)')
ylim([0 8])



%% Blocked or not
% Blocked
figure
[h , MaxPowerValues1 , Freq_Max1] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock_Blocked.Fear, 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0);
[h , MaxPowerValues2 , Freq_Max2] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe_Blocked.Fear , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0);
close

subplot(3,6,13:14)
Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock_Blocked.Fear, 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0 , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']'));
Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe_Blocked.Fear , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0 , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']'));

xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 15]); ylim([0 1])
makepretty_BM
v1=vline(nanmean(4.73)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(3.053)); set(v2,'LineStyle','--','Color',[.5 .5 1])
xticks([0:2:14])
title('Blocked')


figure
[h , MaxPowerValues1 , Freq_Max1] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock_Blocked.Fear, 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0);
[h , MaxPowerValues2 , Freq_Max2] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe_Blocked.Fear , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0);
close
Freq_Max1(7)=NaN;

subplot(3,6,15)
MakeSpreadAndBoxPlot3_SB({Freq_Max1 Freq_Max2},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)')
ylim([0 8])


% Free
figure
[h , MaxPowerValues1 , Freq_Max1] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock_Unblocked.Fear, 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0);
[h , MaxPowerValues2 , Freq_Max2] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe_Unblocked.Fear , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0);
close

subplot(3,6,16:17)
Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock_Unblocked.Fear, 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0 , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']'));
Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe_Unblocked.Fear , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0 , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']'));

xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 15]); ylim([0 1])
makepretty_BM
v1=vline(nanmean(4.73)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(3.053)); set(v2,'LineStyle','--','Color',[.5 .5 1])
xticks([0:2:14])
title('Free')


figure
[h , MaxPowerValues1 , Freq_Max1] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock_Unblocked.Fear, 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0);
[h , MaxPowerValues2 , Freq_Max2] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe_Unblocked.Fear , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0);
close
Freq_Max1([7 10 23 25])=[NaN 6.866 NaN NaN];

subplot(3,6,18)
MakeSpreadAndBoxPlot3_SB({Freq_Max1 Freq_Max2},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)')
ylim([0 8])



saveFigure_BM(3,'Paper_SBM_FigSup1_1','/home/ratatouille/Desktop/Figures_Baptiste/Paper_Figures/')



% for Spider map : edit GetSpiderMapData_BM.m or load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/SpiderMap.mat')


















