clear all

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_Eyelid_Cond_2sFullBins.mat', 'OutPutData')
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Sleep_UMaze_Eyelid.mat', 'Prop')
load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/Physio_BehavGroup.mat', 'DATA_SAL')
load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/Behav_BehavGroup.mat', 'FreezingShock_Dur', 'FreezingSafe_Dur',...
     'FreezingShock_DurProp', 'FreezingSafe_DurProp')

Prop.REM{2}([4 8 14 15])=NaN;
Prop.REM{2}(Prop.Wake{2}>.5)=NaN;

FreqLim = 4.5;
n=1;
for group=22
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse = 1:length(Mouse)
        
        clear D, D = Data(OutPutData.Cond.respi_freq_bm.tsd{mouse,3});
        Respi_Fz(mouse) = nanmean(D);
        Prop_shock(n,mouse) = nansum(D>FreqLim)/sum(~isnan(D));
        Prop_shock_log(n,mouse) = log10(nansum(D>FreqLim))/log10(sum(~isnan(D)));
        Length_shock(n,mouse) = nansum(D>FreqLim)*.2;
        Length_safe(n,mouse) = nansum(D<FreqLim)*.2;
        
        clear D_shock, D_shock = Data(OutPutData.Cond.respi_freq_bm.tsd{mouse,5});
        Respi_shock(mouse) = nanmean(D_shock);
        Prop_shockShock(n,mouse) = nansum(D_shock>FreqLim)/sum(~isnan(D));
        Prop_safeShock(n,mouse) = nansum(D_shock<FreqLim)/sum(~isnan(D));
        Length_shock_side(n,mouse) = length(D_shock)*.2;
        
        clear D_safe, D_safe = Data(OutPutData.Cond.respi_freq_bm.tsd{mouse,6});
        Respi_safe(mouse) = nanmean(D_safe);
        Prop_shockSafe(n,mouse) = nansum(D_safe>FreqLim)/sum(~isnan(D));
        Prop_safeSafe(n,mouse) = nansum(D_safe<FreqLim)/sum(~isnan(D));
        Length_safeSafe(n,mouse) = nansum(D_safe<FreqLim)*.2;
        Length_safe_side(n,mouse) = length(D_safe)*.2;
        
        clear D, D = Data(OutPutData.Cond.respi_freq_bm.tsd{mouse,6});
        Respi_end_Cond(n,mouse) = nanmean(D([round(length(D)*.9):end]));
        Respi_diff_Cond(n,mouse) = nanmean(D([1:round(length(D)*.1)]))-nanmean(D([round(length(D)*.8):end]));
    end
    n=n+1;
end

% duration, zone
figure
subplot(221)
PlotCorrelations_BM(log10(FreezingShock_Dur.Cond{1, 1}([1:22 24:30]))   , Prop.Wake{2});
axis square
xlabel('Fz shock, duration (log scale)'), ylabel('Wake prop, Sleep Post')

subplot(222)
PlotCorrelations_BM(log10(FreezingShock_Dur.Cond{1, 1}([1:22 24:30]))   , Prop.REM{2});
axis square
xlabel('Fz shock, duration (log scale)'), ylabel('REM prop, Sleep Post')

subplot(223)
PlotCorrelations_BM(log10(FreezingSafe_Dur.Cond{1, 1}([1:22 24:30]))   , Prop.Wake{2});
axis square
xlabel('Fz safe, duration (log scale)'), ylabel('Wake prop, Sleep Post')

subplot(224)
PlotCorrelations_BM(log10(FreezingSafe_Dur.Cond{1, 1}([1:22 24:30]))   , Prop.REM{2});
axis square
xlabel('Fz safe, duration (log scale)'), ylabel('REM prop, Sleep Post')


% duration, frequency
figure
subplot(221)
PlotCorrelations_BM(Length_shock/60 , Prop.Wake{2});
axis square
xlabel('Breathing>4.5Hz, time (min)'), ylabel('Wake prop, Sleep Post')

subplot(222)
PlotCorrelations_BM(Length_shock/60 , Prop.REM{2});
axis square
xlabel('Breathing>4.5Hz, time (min)'), ylabel('REM prop, Sleep Post')

subplot(223)
PlotCorrelations_BM(Length_safe/60 , Prop.Wake{2});
axis square
xlabel('Breathing<4.5Hz, time (min)'), ylabel('Wake prop, Sleep Post')

subplot(224)
PlotCorrelations_BM(Length_safe/60 , Prop.REM{2});
axis square
xlabel('Breathing<4.5Hz, time (min)'), ylabel('REM prop, Sleep Post')


% duration, time proportion of protocol
figure
subplot(221)
PlotCorrelations_BM(log10(FreezingShock_DurProp.Cond{1, 1}([1:22 24:30]))   , Prop.Wake{2});
axis square
xlabel('Fz shock, duration (log scale, prop of protocol time)'), ylabel('Wake prop, Sleep Post')

subplot(222)
PlotCorrelations_BM(log10(FreezingShock_DurProp.Cond{1, 1}([1:22 24:30]))   , Prop.REM{2});
axis square
xlabel('Fz shock, duration (log scale, prop of protocol time)'), ylabel('REM prop, Sleep Post')

subplot(223)
PlotCorrelations_BM(log10(FreezingSafe_DurProp.Cond{1, 1}([1:22 24:30]))   , Prop.Wake{2});
axis square
xlabel('Fz safe, duration (log scale, prop of protocol time)'), ylabel('Wake prop, Sleep Post')

subplot(224)
PlotCorrelations_BM(log10(FreezingSafe_DurProp.Cond{1, 1}([1:22 24:30]))   , Prop.REM{2});
axis square
xlabel('Fz safe, duration (log scale, prop of protocol time)'), ylabel('REM prop, Sleep Post')


% proportion of time freezing with a frequency / total freezing
figure
subplot(221)
PlotCorrelations_BM(Prop_shock , Prop.Wake{2});
axis square
xlabel('Fz time_B_r_e_a_t_h_i_n_g_>_4_._5_H_z / Fz time_t_o_t_a_l'), ylabel('Wake prop, Sleep Post')

subplot(222)
PlotCorrelations_BM(Prop_shock , Prop.REM{2});
axis square
xlabel('Fz time_B_r_e_a_t_h_i_n_g_>_4_._5_H_z / Fz time_t_o_t_a_l'), ylabel('REM prop, Sleep Post')

subplot(223)
PlotCorrelations_BM(Prop_safeSafe , Prop.Wake{2});
axis square
xlabel('Safe side Fz time_B_r_e_a_t_h_i_n_g_<_4_._5_H_z / Fz time_t_o_t_a_l'), ylabel('Wake prop, Sleep Post')

subplot(224)
PlotCorrelations_BM(Prop_safeSafe , Prop.REM{2} , 'method','spearman');
axis square
xlabel('Safe side Fz time_B_r_e_a_t_h_i_n_g_<_4_._5_H_z / Fz time_t_o_t_a_l'), ylabel('REM prop, Sleep Post')





figure
subplot(221)
PlotCorrelations_BM(DATA_SAL(1,1:29) , Prop.Wake{2});
axis square
xlabel('Breathing shock freezing (Hz)'), ylabel('Wake prop, Sleep Post')

subplot(222)
PlotCorrelations_BM(DATA_SAL(1,1:29) , Prop.REM{2});
axis square
xlabel('Breathing shock freezing (Hz)'), ylabel('REM prop, Sleep Post')

subplot(223)
PlotCorrelations_BM(DATA_SAL(1,30:58) , Prop.Wake{2});
axis square
xlabel('Breathing safe freezing (Hz)'), ylabel('Wake prop, Sleep Post')

subplot(224)
PlotCorrelations_BM(DATA_SAL(1,30:58) , Prop.REM{2});
axis square
xlabel('Breathing safe freezing (Hz)'), ylabel('REM prop, Sleep Post')



figure
subplot(121)
PlotCorrelations_BM(Respi_end_Cond , Prop.Wake{2});
axis square
xlabel('Breathing safe side, end Cond (Hz)'), ylabel('Wake prop, Sleep Post')

subplot(122)
PlotCorrelations_BM(Respi_end_Cond , Prop.REM{2} , '');
axis square
xlabel('Breathing safe side, end Cond (Hz)'), ylabel('REM prop, Sleep Post')




%% with SVM
load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/SVMScores_Eyelid.mat', 'SVM_score_FzSafe_Cond', 'SVM_score_FzShock_Cond')
SVM_score_FzShock_Cond = SVM_score_FzShock_Cond([1:22 24:end]);
SVM_score_FzSafe_Cond = SVM_score_FzSafe_Cond([1:22 24:end]);

figure
subplot(221)
PlotCorrelations_BM(SVM_score_FzShock_Cond , Prop.Wake{2},'method','spearman');
axis square
xlabel('SVM score, shock freezing, Cond (a.u.)'), ylabel('Wake prop, Sleep Post')

subplot(222)
PlotCorrelations_BM(SVM_score_FzShock_Cond , Prop.REM{2},'method','spearman');
axis square
xlabel('SVM score, shock freezing, Cond (a.u.)'), ylabel('REM prop, Sleep Post')


subplot(223)
PlotCorrelations_BM(SVM_score_FzSafe_Cond , Prop.Wake{2},'method','spearman');
axis square
xlabel('SVM score, safe freezing, Cond (a.u.)'), ylabel('Wake prop, Sleep Post')

subplot(224)
PlotCorrelations_BM(SVM_score_FzSafe_Cond , Prop.REM{2} ,'method','spearman');
axis square
xlabel('SVM score, safe freezing, Cond (a.u.)'), ylabel('REM prop, Sleep Post')


load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/SVMScores_Eyelid.mat', 'SVM_score_FzSafe_Cond_interp', 'SVM_score_FzShock_Cond_interp')
SVM_score_FzShock_Cond_end = nanmean(SVM_score_FzShock_Cond_interp(:,91:end)');
SVM_score_FzSafe_Cond_end = nanmean(SVM_score_FzSafe_Cond_interp(:,91:end)');


figure
subplot(221)
PlotCorrelations_BM(SVM_score_FzShock_Cond_end , Prop.Wake{2},'method','spearman');
axis square
xlabel('SVM score, shock freezing, Cond (a.u.)'), ylabel('Wake prop, Sleep Post')

subplot(222)
PlotCorrelations_BM(SVM_score_FzShock_Cond_end , Prop.REM{2},'method','spearman');
axis square
xlabel('SVM score, shock freezing, Cond (a.u.)'), ylabel('REM prop, Sleep Post')


subplot(223)
PlotCorrelations_BM(SVM_score_FzSafe_Cond , Prop.Wake{2},'method','spearman');
axis square
xlabel('SVM score, safe freezing, Cond (a.u.)'), ylabel('Wake prop, Sleep Post')

subplot(224)
PlotCorrelations_BM(SVM_score_FzSafe_Cond , Prop.REM{2} ,'method','spearman');
axis square
xlabel('SVM score, safe freezing, Cond (a.u.)'), ylabel('REM prop, Sleep Post')


%% Duration * frequency
figure
subplot(121)
PlotCorrelations_BM(log10(Respi_Fz)   , Prop.Wake{2});
axis square
xlabel('Respi freq * time (log scale)'), ylabel('Wake prop, Sleep Post')

subplot(122)
PlotCorrelations_BM(log10(Respi_Fz)   , Prop.REM{2});
axis square
xlabel('Respi freq * time (log scale)'), ylabel('REM prop, Sleep Post')




