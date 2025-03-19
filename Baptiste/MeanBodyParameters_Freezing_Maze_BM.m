

% Mouse=Drugs_Groups_UMaze_BM(22); Session_type={'Cond'}; sess=1;
% [OutPutData , Epoch1 , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
%     'respi_freq_bm','heartrate','heartratevar','accelero','emg_pect','speed');
% 
% 
% for mouse=1:length(Mouse)
%     Moving=thresholdIntervals(OutPutData.speed.tsd{mouse,1} , 2 , 'Direction' , 'Above');
%     Acc_Moving(mouse) = nanmean(Data(Restrict(OutPutData.accelero.tsd{mouse,1} , Moving)));
% end
% 
% OutPutData.accelero.mean([1:4 7],:) = NaN;

% Box plots
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/MeanBodyValues_Eyelid_Cond.mat')

Cols={[1 .5 .5],[.5 .5 1]};
X=[1 2.5];
Legends={'Shock','Safe'};


figure
subplot(151)
MakeSpreadAndBoxPlot3_SB({OutPutData.respi_freq_bm.mean(:,5) OutPutData.respi_freq_bm.mean(:,6)},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Breathing (Hz)')
makepretty_BM2

subplot(152)
MakeSpreadAndBoxPlot3_SB({OutPutData.heartrate.mean(:,5) OutPutData.heartrate.mean(:,6)},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Heart rate (Hz)')
makepretty_BM2

subplot(153)
MakeSpreadAndBoxPlot3_SB({OutPutData.heartratevar.mean(:,5) OutPutData.heartratevar.mean(:,6)},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Heart rate variability (a.u.)')
makepretty_BM2

subplot(154)
MakeSpreadAndBoxPlot3_SB({OutPutData.accelero.mean(:,5)./Acc_Moving' OutPutData.accelero.mean(:,6)./Acc_Moving'},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Motion (norm)')
makepretty_BM2

subplot(155)
MakeSpreadAndBoxPlot3_SB({log10(OutPutData.emg_pect.mean(:,5)) log10(OutPutData.emg_pect.mean(:,6))},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('EMG power (log scale)')
makepretty_BM2




%% mean spectrum
clear all
Session_type={'Cond'};
Mouse=Drugs_Groups_UMaze_BM(22);
for sess=1:length(Session_type)
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = ...
        MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'ob_low','ob_high','hpc_low','hpc_vhigh');
end


% display
figure
subplot(141)
[~,Pow_ob_low_shock,Freq_ob_low_shock] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Cond.ob_low.mean(:,5,:)) , 'color' , [1 .5 .5]);
[~,Pow_ob_low_safe,Freq_ob_low_safe] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Cond.ob_low.mean(:,6,:)) , 'color' , [.5 .5 1] , 'power_norm_value' , Pow_ob_low_shock);
makepretty, xlim([0 10])
f=get(gca,'Children'); legend([f(5),f(1)],'Shock','Safe');

subplot(142)
[~,MaxPowerValues1] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Cond.hpc_low.mean(:,5,:)) , 'color' , [1 .5 .5] , 'threshold' , 39 , 'dashed_line' , 0);
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Cond.hpc_low.mean(:,6,:)) , 'color' , [.5 .5 1] , 'threshold' , 39 , 'power_norm_value' , MaxPowerValues1 , 'dashed_line' , 0);
makepretty, xlim([1 20]), ylim([0 1.5])

subplot(143)
[~,Pow_ob_high_shock,Freq_ob_high_shock] = Plot_MeanSpectrumForMice_BM(runmean(squeeze(OutPutData.Cond.ob_high.mean(:,5,:))',2)' , 'color' , [1 .5 .5] , 'dashed_line' , 0);
[~,Pow_ob_high_safe,Freq_ob_high_safe] = Plot_MeanSpectrumForMice_BM(runmean(squeeze(OutPutData.Cond.ob_high.mean(:,6,:))',2)' , 'color' , [.5 .5 1] , 'power_norm_value' , Pow_ob_high_shock , 'dashed_line' , 0);
makepretty, xlim([30 100]), ylim([.3 1.1])

subplot(144)
load('H_VHigh_Spectrum.mat')
[~,MaxPowerValues1,f1] = Plot_MeanSpectrumForMice_BM(runmean((Spectro{3}.*squeeze(OutPutData.Cond.hpc_vhigh.mean(:,5,:)))',2)' , 'color' , [1 .5 .5]);
[~,MaxPowerValues,f2] = Plot_MeanSpectrumForMice_BM(runmean((Spectro{3}.*squeeze(OutPutData.Cond.hpc_vhigh.mean(:,6,:)))',2)' , 'color' , [.5 .5 1] , 'power_norm_value' , MaxPowerValues1);
makepretty, xlim([20 250])
set(gca,'YScale','log')


% mean values, box plot
figure
subplot(241)
MakeSpreadAndBoxPlot3_SB({Pow_ob_low_shock Pow_ob_low_safe},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('OB low power (a.u.)')
makepretty_BM2

subplot(245)
MakeSpreadAndBoxPlot3_SB({Freq_ob_low_shock Freq_ob_low_safe},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('OB low freq (Hz)')
makepretty_BM2

load('H_Low_Spectrum.mat')
fthe = [find(Spectro{3}<5,1,'last'):find(Spectro{3}<8,1,'last')];
fall = [find(Spectro{3}<1.5,1,'last'):find(Spectro{3}<5,1,'last')];

subplot(142)
MakeSpreadAndBoxPlot3_SB({squeeze(nanmean(OutPutData.Cond.hpc_low.mean(:,5,fthe),3))./squeeze(nanmean(OutPutData.Cond.hpc_low.mean(:,5,fall),3))...
    squeeze(nanmean(OutPutData.Cond.hpc_low.mean(:,6,fthe),3))./squeeze(nanmean(OutPutData.Cond.hpc_low.mean(:,6,fall),3))},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('HPC theta/delta'), axis square
makepretty_BM2

subplot(243)
MakeSpreadAndBoxPlot3_SB({Pow_ob_high_shock Pow_ob_high_safe},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('OB high power (a.u.)')
makepretty_BM2

subplot(247)
MakeSpreadAndBoxPlot3_SB({Freq_ob_high_shock Freq_ob_high_safe},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('OB high freq (Hz)')
makepretty_BM2

load('H_VHigh_Spectrum.mat')
fthe = [find(Spectro{3}<40,1,'last'):find(Spectro{3}<80,1,'last')];
fall = [find(Spectro{3}<23,1,'last'):find(Spectro{3}<40,1,'last')];
fthe2 = [find(Spectro{3}<150,1,'last'):find(Spectro{3}<250,1,'last')];
fall2 = [find(Spectro{3}<23,1,'last'):find(Spectro{3}<150,1,'last')];

subplot(244)
MakeSpreadAndBoxPlot3_SB({squeeze(nanmean(OutPutData.Cond.hpc_vhigh.mean(:,5,fthe),3))./squeeze(nanmean(OutPutData.Cond.hpc_vhigh.mean(:,5,fall),3))...
    squeeze(nanmean(OutPutData.Cond.hpc_vhigh.mean(:,6,fthe),3))./squeeze(nanmean(OutPutData.Cond.hpc_vhigh.mean(:,6,fall),3))},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('HPC 40-80Hz band power')
makepretty_BM2

subplot(248)
MakeSpreadAndBoxPlot3_SB({squeeze(nanmean(OutPutData.Cond.hpc_vhigh.mean(:,5,fthe2),3))...
    squeeze(nanmean(OutPutData.Cond.hpc_vhigh.mean(:,6,fthe2),3))},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('HPC 150-250Hz band power')
makepretty_BM2



%% ripples features

clear all
Session_type={'Cond'};
Mouse=Drugs_Groups_UMaze_BM(22);
for sess=1:length(Session_type)
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = ...
        MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'ripples_all');
end

for mouse=1:length(Mouse)
    
    Rip_shock(mouse,:) = nanmean(Data(OutPutData.Cond.ripples_all.tsd{mouse,5}));
    Rip_safe(mouse,:) = nanmean(Data(OutPutData.Cond.ripples_all.tsd{mouse,6}));
    
end

Cols = {[1 .5 .5],[.5 .5 1]};
X = 1:2;
Legends = {'Shock','Safe'};

figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({Rip_shock(:,4) Rip_safe(:,4)},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('duration (ms)')
makepretty_BM2

subplot(132)
MakeSpreadAndBoxPlot3_SB({Rip_shock(:,5) Rip_safe(:,5)},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)')
makepretty_BM2

subplot(133)
MakeSpreadAndBoxPlot3_SB({Rip_shock(:,6) Rip_safe(:,6)},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Power (log)'), set(gca,'YScale','log'), ylim([800 5e3])
makepretty_BM2





%% old
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/MeanBodyValues_Fz.mat')
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/SpiderMap.mat', 'DATA_TO_PLOT')

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Cond_2sFullBins.mat')
figure, [~ , ~ , Freq_Max_Shock] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,5,:))); close
figure, [~ , ~ , Freq_Max_Safe] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,6,:))); close

%% Saline, Fear
Session_type = {'Fear'};
Mouse=Drugs_Groups_UMaze_BM(11);

for sess=1:length(Session_type) % generate all data required for analyses
        [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
            'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','linearposition');
    
%     [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),...
%         'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','linearposition');
end

for sess=1:length(Session_type)
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
'ripples_meanwaveform');
end


%% Mean spectro OB freezing

clear all
GetAllSalineSessions_BM
Mouse=Drugs_Groups_UMaze_BM(22);
Session_type = {'Cond'};
load('B_Low_Spectrum.mat')

for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        OB_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
        Freeze.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
        Zone.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','zoneepoch');
        ShockZone.(Session_type{sess}).(Mouse_names{mouse}) = Zone.(Session_type{sess}).(Mouse_names{mouse}){1};
        SafeZone.(Session_type{sess}).(Mouse_names{mouse}) = or(Zone.(Session_type{sess}).(Mouse_names{mouse}){2} , Zone.(Session_type{sess}).(Mouse_names{mouse}){5});
        
        Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}) = and(Freeze.(Session_type{sess}).(Mouse_names{mouse}) , ShockZone.(Session_type{sess}).(Mouse_names{mouse}));
        Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}) = and(Freeze.(Session_type{sess}).(Mouse_names{mouse}) , SafeZone.(Session_type{sess}).(Mouse_names{mouse}));
        
    end
end


for mouse=1:length(Mouse)
    Fz_Shock = Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse});
    Fz_Safe = Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse});
    for ep=1:length(Start(Fz_Shock))
        try
            clear D
            D = Data(Restrict(OB_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}) , subset(Fz_Shock,ep)));
            for i=1:261
                OB_shock{mouse}(ep,:,i) = interp1(linspace(0,1,size(D(:,i),1)) , D(:,i) , linspace(0,1,100));
            end
            OB_shock{mouse}(ep,:,:) = OB_shock{mouse}(ep,:,:)./sum(sum(squeeze(OB_shock{mouse}(ep,:,13:130))));
        end
    end
    for ep=1:length(Start(Fz_Safe))
        try
            clear D
            D = Data(Restrict(OB_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}) , subset(Fz_Safe,ep)));
            for i=1:261
                OB_safe{mouse}(ep,:,i) = interp1(linspace(0,1,size(D(:,i),1)) , D(:,i) , linspace(0,1,100));
            end
            OB_safe{mouse}(ep,:,:) = OB_safe{mouse}(ep,:,:)./sum(sum(squeeze(OB_safe{mouse}(ep,:,13:130))));
        end
    end
    OB_shock{mouse}(OB_shock{mouse}==0) = NaN;
    OB_safe{mouse}(OB_safe{mouse}==0) = NaN;
    
    disp(mouse)
end



% for mouse=1:length(Mouse)
%     OB_shock_all(mouse,:,:) = squeeze(nanmean(log10(OB_shock{mouse})));
%     OB_shock_all(mouse,:,:) = OB_shock_all(mouse,:,:)./sum(sum(squeeze(OB_shock_all(mouse,:,13:130))));
%     OB_safe_all(mouse,:,:) = squeeze(nanmean(log10(OB_safe{mouse})));
%     OB_safe_all(mouse,:,:) = OB_safe_all(mouse,:,:)./sum(sum(squeeze(OB_safe_all(mouse,:,13:130))));
% end
for mouse=1:length(Mouse)
    OB_shock_all(mouse,:,:) = squeeze(nanmean(OB_shock{mouse}));
    OB_shock_all(mouse,:,:) = OB_shock_all(mouse,:,:)./sum(sum(squeeze(OB_shock_all(mouse,:,:))));
    OB_safe_all(mouse,:,:) = squeeze(nanmean(OB_safe{mouse}));
    OB_safe_all(mouse,:,:) = OB_safe_all(mouse,:,:)./sum(sum(squeeze(OB_safe_all(mouse,:,:))));
end



figure
subplot(121)
imagesc([1:100] , Spectro{3}(13:130) , squeeze(nanmean(OB_shock_all(:,:,13:130)))'), axis xy
ylabel('Frequency (Hz)'), xlabel('time in fz episode (a.u.)'), title('Shock'), hline(4,'-k')
makepretty_BM2

subplot(122)
imagesc([1:100] , Spectro{3}(13:130) , squeeze(nanmean(OB_safe_all(:,:,13:130)))'), axis xy
title('Safe'), hline(4,'-k')
makepretty_BM2
caxis([5e-5 1.3e-4])



%% with quiet wake in Test Pre

Cols = {[.5 .5 .5],[1 0.5 0.5],[0.5 0.5 1]};
X = [1:3];
Legends = {'Quiet wake','Shock','Safe'};

GetAllSalineSessions_BM
Session_type={'Habituation','sleep_pre'};

% Mouse=[688 739 777 779 849 893]; 
Mouse=Drugs_Groups_UMaze_BM(11); 

for sess=1%:length(Session_type)
    Sessions_List_ForLoop_BM
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        try
            clear OB_Sptsd OB_Sp_LowSpeed Speed
%             OB_Sptsd.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
%             Speed.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'speed');
%             Smooth_speed.(Session_type{sess}) = tsd(Range(Speed.(Session_type{sess})),runmean(Data(Speed.(Session_type{sess})),10));
%             
%             Low_Speed_Epoch.(Session_type{sess}){mouse} = thresholdIntervals(Smooth_speed.(Session_type{sess}),1,'Direction','Below');
%             Low_Speed_Epoch.(Session_type{sess}){mouse} = dropShortIntervals(Low_Speed_Epoch.(Session_type{sess}){mouse},3e4);
%             Low_Speed_Epoch.(Session_type{sess}){mouse} = mergeCloseIntervals(Low_Speed_Epoch.(Session_type{sess}){mouse},2e4);
%             if convertCharsToStrings(Session_type{sess}) == 'sleep_pre'
%                 SleepStates.(Session_type{sess}){mouse} = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','sleepstates');
%                 Wake_bef_first_sleep = subset(SleepStates.(Session_type{sess}){mouse}{1},1);
%                 Low_Speed_Epoch.(Session_type{sess}){mouse} = and(Low_Speed_Epoch.(Session_type{sess}){mouse} , Wake_bef_first_sleep);
%             end
%             
%             
%             OB_Sp_LowSpeed.(Session_type{sess}) = Restrict(OB_Sptsd.(Session_type{sess}) , Low_Speed_Epoch.(Session_type{sess}){mouse});
%             
%             OB_MeanSp_LowSpeed.(Session_type{sess})(mouse,:) = nanmean(Data(OB_Sp_LowSpeed.(Session_type{sess})));
%             Low_Speed_Epoch_prop.(Session_type{sess})(mouse) = sum(DurationEpoch(Low_Speed_Epoch.(Session_type{sess}){mouse}))/max(Range(Speed.(Session_type{sess})));
%             Spectrum_Frequency.(Session_type{sess}){mouse} = ConvertSpectrum_in_Frequencies_BM(linspace(.15,20,261) , Range(OB_Sp_LowSpeed.(Session_type{sess})) , Data(OB_Sp_LowSpeed.(Session_type{sess})));
%             Mean_Respi_LowSpeed.(Session_type{sess})(mouse) = nanmean(Data(Spectrum_Frequency.(Session_type{sess}){mouse}));
%             try
%                 Respi.(Session_type{sess}){mouse} = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'instfreq','method','WV','suffix_instfreq','B');
%                 Mean_Respi_LowSpeed.(Session_type{sess})(mouse) = nanmean(Data(Restrict(Respi.(Session_type{sess}){mouse} , Low_Speed_Epoch.(Session_type{sess}){mouse})));
%                 Mean_Respi_LowSpeed.(Session_type{sess})(Mean_Respi_LowSpeed.(Session_type{sess})==0)=NaN;
%             end
%             try
%                 HR.(Session_type{sess}){mouse} = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartrate');
%                 Mean_HR_LowSpeed.(Session_type{sess})(mouse) = nanmean(Data(Restrict(HR.(Session_type{sess}){mouse} , Low_Speed_Epoch.(Session_type{sess}){mouse})));
%                 Mean_HR_LowSpeed(Mean_HR_LowSpeed==0)=NaN;
%             end
%             try
%                 HRVar.(Session_type{sess}){mouse} = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartratevar');
%                 Mean_HRVar_LowSpeed.(Session_type{sess})(mouse) = nanmean(Data(Restrict(HRVar.(Session_type{sess}){mouse} , Low_Speed_Epoch.(Session_type{sess}){mouse})));
%                 Mean_HRVar_LowSpeed.(Session_type{sess})(Mean_HRVar_LowSpeed.(Session_type{sess})==0)=NaN;
%             end
            try
                TailTemperature.(Session_type{sess}){mouse} = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'tailtemperature');
                Mean_TailTemperature_LowSpeed.(Session_type{sess})(mouse) = nanmean(Data(Restrict(TailTemperature.(Session_type{sess}){mouse} , Low_Speed_Epoch.(Session_type{sess}){mouse})));
                Mean_TailTemperature_LowSpeed.(Session_type{sess})(Mean_TailTemperature_LowSpeed.(Session_type{sess})==0)=NaN;
            end
%             try
%                 EMG.(Session_type{sess}){mouse} = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'emg_pect');
%                 Mean_EMG_LowSpeed.(Session_type{sess})(mouse) = nanmean(Data(Restrict(EMG.(Session_type{sess}){mouse} , Low_Speed_Epoch.(Session_type{sess}){mouse})));
%                 Mean_EMG_LowSpeed.(Session_type{sess})(Mean_EMG_LowSpeed.(Session_type{sess})==0)=NaN;
%             end
%             try
%                 Accelero.(Session_type{sess}){mouse} = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'accelero');
%                 Mean_Accelero_LowSpeed.(Session_type{sess})(mouse) = nanmean(Data(Restrict(Accelero.(Session_type{sess}){mouse} , Low_Speed_Epoch.(Session_type{sess}){mouse})));
%                 Mean_Accelero_LowSpeed.(Session_type{sess})(Mean_Accelero_LowSpeed.(Session_type{sess})==0)=NaN;
%             end
            disp(Mouse_names{mouse})
        end
    end
end
Mean_HR_LowSpeed.Habituation(Mean_HR_LowSpeed.Habituation==0)=NaN;
Mean_HRVar_LowSpeed.Habituation(Mean_HRVar_LowSpeed.Habituation==0)=NaN;
Mean_TailTemperature_LowSpeed.Habituation(Mean_TailTemperature_LowSpeed.Habituation==0)=NaN;



% figures
figure
Plot_MeanSpectrumForMice_BM(OB_MeanSp_LowSpeed.(Session_type{sess}) , 'threshold',50);
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 15]); ylim([0 2])
v1=vline(nanmean(4.73)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(3.053)); set(v2,'LineStyle','--','Color',[.5 .5 1])
f=get(gca,'Children'); l=legend([f(1)],'Quiet wake'); l.Box='off';
makepretty_BM
xticks([0:2:14])


figure
subplot(141)
MakeSpreadAndBoxPlot3_SB({Mean_Respi_LowSpeed.(Session_type{sess}) Freq_Max_Shock Freq_Max_Safe},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)'); title('Respiratory rate')

subplot(142)
MakeSpreadAndBoxPlot3_SB({Mean_HR_LowSpeed.Habituation OutPutData.Fear.heartrate.mean(:,5) OutPutData.Fear.heartrate.mean(:,6)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)'); title('Heart rate')

subplot(143)
MakeSpreadAndBoxPlot3_SB({Mean_HRVar_LowSpeed.Habituation OutPutData.Fear.heartratevar.mean(:,5) OutPutData.Fear.heartratevar.mean(:,6)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)'); title('Heart rate variability')

subplot(144)
MakeSpreadAndBoxPlot3_SB({Mean_TailTemperature_LowSpeed.Habituation MeanTailTemperature(:,5) MeanTailTemperature(:,6)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Temperature (°C)'); title('Tail temperature')




clear P s
P=[nanmedian(DATA_TO_PLOT.Fear(:,1,:),3)' ; nanmedian(DATA_TO_PLOT.Fear(:,2,:),3)' ;...
    nanmedian([Mean_Respi_LowSpeed.Habituation' Mean_HR_LowSpeed.Habituation' Mean_HRVar_LowSpeed.Habituation' Mean_TailTemperature_LowSpeed.Habituation' Mean_EMG_LowSpeed.Habituation' Mean_Accelero_LowSpeed.Habituation'])];
P(:,5:6) =log10(P(:,5:6));

figure
s = spider_plot_class(P);
s.AxesLabels =  {'Breathing','HR','HR var','Tail T°','EMG','Motion'};
s.LegendLabels = {'Freezing shock', 'Freezing safe','Quiet wake'};
s.AxesInterval = 2;
s.FillOption = { 'on', 'on','on'};
s.Color = [1 .5 .5; .5 .5 1 ; .3 .3 .3];
s.LegendHandle.Location = 'northeastoutside';
s.AxesLabelsEdge = 'none';
% s.AxesLimits = [2.36 9.5 .10 27.6 4 7; 5.08 12 .23 30.05 5.4 7.5];


%% with Active in Fear
Cols = {[.5 .5 .5],[1 0.5 0.5],[0.5 0.5 1]};
X = [1:3];
Legends = {'Active','Shock','Safe'};

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    clear OB_Sptsd OB_Sp_HighSpeed Speed
    OB_Sptsd = ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
    Speed = ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'speed');
    High_Speed_Epoch{mouse} = thresholdIntervals(Speed,2,'Direction','Above');
    
    OB_Sp_HighSpeed = Restrict(OB_Sptsd , High_Speed_Epoch{mouse});
    
    OB_MeanSp_HighSpeed(mouse,:) = nanmean(Data(OB_Sp_HighSpeed));
    High_Speed_Epoch_prop(mouse) = sum(DurationEpoch(High_Speed_Epoch{mouse}))/max(Range(Speed));
    Spectrum_Frequency{mouse} = ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Range(OB_Sp_HighSpeed) , Data(OB_Sp_HighSpeed));
    Mean_Respi_HighSpeed_Fear(mouse) = nanmean(Data(Spectrum_Frequency{mouse}));
%     try
%         HR{mouse} = OutPutData.Fear.heartrate.tsd{mouse,1};
%         Mean_HR_HighSpeed_Fear(mouse) = nanmean(Data(Restrict(HR{mouse} , High_Speed_Epoch{mouse})));
%         Mean_HR_HighSpeed_Fear(Mean_HR_HighSpeed_Fear==0)=NaN;
%     end
%     try
%         HRVar{mouse} = OutPutData.Fear.heartratevar.tsd{mouse,1};
%         Mean_HRVar_HighSpeed_Fear(mouse) = nanmean(Data(Restrict(HRVar{mouse} , High_Speed_Epoch{mouse})));
%         Mean_HRVar_HighSpeed_Fear(Mean_HRVar_HighSpeed_Fear==0)=NaN;
%     end
%     try
%         TailTemperature{mouse} = OutPutData.Fear.tailtemperature.tsd{mouse,1};
%         Mean_TailTemperature_HighSpeed_Fear(mouse) = nanmean(Data(Restrict(TailTemperature{mouse} , High_Speed_Epoch{mouse})));
%         Mean_TailTemperature_HighSpeed_Fear(Mean_TailTemperature_HighSpeed_Fear==0)=NaN;
%     end
%     try
%         EMG{mouse} = OutPutData.Fear.emg_pect.tsd{mouse,1};
%         Mean_EMG_HighSpeed_Fear(mouse) = nanmean(Data(Restrict(EMG{mouse} , High_Speed_Epoch{mouse})));
%         Mean_EMG_HighSpeed_Fear(Mean_EMG_HighSpeed_Fear==0)=NaN;
%     end
%     try
%         Accelero{mouse} = OutPutData.Fear.accelero.tsd{mouse,1};
%         Mean_Accelero_HighSpeed_Fear(mouse) = nanmean(Data(Restrict(Accelero{mouse} , High_Speed_Epoch{mouse})));
%         Mean_Accelero_HighSpeed_Fear(Mean_Accelero_HighSpeed_Fear==0)=NaN;
%     end
    
    disp(Mouse_names{mouse})
end



% figures
figure
Plot_MeanSpectrumForMice_BM(OB_MeanSp_HighSpeed , 'threshold',50);
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 15]); ylim([0 2])
v1=vline(nanmean(4.73)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(3.053)); set(v2,'LineStyle','--','Color',[.5 .5 1])
f=get(gca,'Children'); l=legend([f(1)],'Active'); l.Box='off';
makepretty_BM
xticks([0:2:14])


figure
subplot(141)
MakeSpreadAndBoxPlot3_SB({Mean_Respi_HighSpeed_Fear OutPutData.Fear.respi_freq_bm.mean(:,5) OutPutData.Fear.respi_freq_bm.mean(:,6)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)'); title('Respiratory rate')

subplot(142)
MakeSpreadAndBoxPlot3_SB({Mean_HR_HighSpeed_Fear OutPutData.Fear.heartrate.mean(:,5) OutPutData.Fear.heartrate.mean(:,6)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)'); title('Heart rate')

subplot(143)
MakeSpreadAndBoxPlot3_SB({Mean_HRVar_HighSpeed_Fear OutPutData.Fear.heartratevar.mean(:,5) OutPutData.Fear.heartratevar.mean(:,6)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)'); title('Heart rate variability')

subplot(144)
MakeSpreadAndBoxPlot3_SB({Mean_TailTemperature_HighSpeed_Fear OutPutData.Fear.tailtemperature.mean(:,5) OutPutData.Fear.tailtemperature.mean(:,6)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Temperature (°C)'); title('Tail temperature')





clear P s
P=[nanmedian(DATA_TO_PLOT.Fear(:,1,:),3)' ; nanmedian(DATA_TO_PLOT.Fear(:,2,:),3)' ;...
    nanmedian([Mean_Respi_HighSpeed_Fear' Mean_HR_HighSpeed_Fear' Mean_HRVar_HighSpeed_Fear' Mean_TailTemperature_HighSpeed_Fear' Mean_EMG_HighSpeed_Fear' Mean_Accelero_HighSpeed_Fear'])];
P(:,5:6) =log10(P(:,5:6));

figure
s = spider_plot_class(P);
s.AxesLabels =  {'Breathing','HR','HR var','Tail T°','EMG','Motion'};
s.LegendLabels = {'Freezing shock', 'Freezing safe','Active'};
s.AxesInterval = 2;
s.FillOption = { 'on', 'on','on'};
s.Color = [1 .5 .5; .5 .5 1 ; .3 .3 .3];
s.LegendHandle.Location = 'northeastoutside';
s.AxesLabelsEdge = 'none';
% s.AxesLimits = [2.36 9.5 .10 27.6 4 7; 5.08 12 .23 30.05 5.4 7.5];



%% with Sleep
Session_type = {'sleep_pre'};
Mouse=Drugs_Groups_UMaze_BM(11);

for sess=1:length(Session_type)
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
'respi_freq_bm','heartrate','heartratevar','tailtemperature','emg_pect','accelero','ob_low');
end
OutPutData.SleepPre.ob_low.max_freq(OutPutData.SleepPre.ob_low.max_freq==0)=NaN;
OutPutData.SleepPre.tailtemperature.mean(OutPutData.SleepPre.tailtemperature.mean==0)=NaN;

Cols = {[.5 .5 .5],[1 0.5 0.5],[0.5 0.5 1]};
X = [1:3];
Legends = {'Sleep','Shock','Safe'};


% figures
figure
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.SleepPre.ob_low.mean(:,3,:)), 'threshold',13);
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 15]); ylim([0 2])
v1=vline(nanmean(4.73)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(3.053)); set(v2,'LineStyle','--','Color',[.5 .5 1])
f=get(gca,'Children'); l=legend([f(1)],'Sleep'); l.Box='off';
makepretty_BM
xticks([0:2:14])


figure
subplot(141)
MakeSpreadAndBoxPlot3_SB({OutPutData.SleepPre.ob_low.max_freq(:,3) OutPutData.Fear.respi_freq_bm.mean(:,5) OutPutData.Fear.respi_freq_bm.mean(:,6)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)'); title('Respiratory rate')

subplot(142)
MakeSpreadAndBoxPlot3_SB({OutPutData.SleepPre.heartrate.mean(:,3) OutPutData.Fear.heartrate.mean(:,5) OutPutData.Fear.heartrate.mean(:,6)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)'); title('Heart rate')

subplot(143)
MakeSpreadAndBoxPlot3_SB({OutPutData.SleepPre.heartratevar.mean(:,3) OutPutData.Fear.heartratevar.mean(:,5) OutPutData.Fear.heartratevar.mean(:,6)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)'); title('Heart rate variability')

subplot(144)
MakeSpreadAndBoxPlot3_SB({OutPutData.SleepPre.tailtemperature.mean(:,3) OutPutData.Fear.tailtemperature.mean(:,5) OutPutData.Fear.tailtemperature.mean(:,6)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Temperature (°C)'); title('Tail temperature')



clear P s
P=[nanmedian(DATA_TO_PLOT.Fear(:,1,:),3)' ; nanmedian(DATA_TO_PLOT.Fear(:,2,:),3)' ;...
    nanmedian([OutPutData.SleepPre.ob_low.max_freq(:,3) OutPutData.SleepPre.heartrate.mean(:,3) OutPutData.SleepPre.heartratevar.mean(:,3)...
NaN(length(Mouse),1) OutPutData.SleepPre.emg_pect.mean(:,3) OutPutData.SleepPre.accelero.mean(:,3)])];
P(:,5:6) =log10(P(:,5:6));

figure
s = spider_plot_class(P);
s.AxesLabels =  {'Breathing','HR','HR var','Tail T°','EMG','Motion'};
s.LegendLabels = {'Freezing shock', 'Freezing safe','Sleep'};
s.AxesInterval = 2;
s.FillOption = { 'on', 'on','on'};
s.Color = [1 .5 .5; .5 .5 1 ; .3 .3 .3];
s.LegendHandle.Location = 'northeastoutside';
s.AxesLabelsEdge = 'none';
% s.AxesLimits = [2.36 9.5 .10 27.6 4 7; 5.08 12 .23 30.05 5.4 7.5];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù
%% load data

load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepComparison_FzSafe.mat')


%% generate data
Mouse=Drugs_Groups_UMaze_BM(11);
Session_type={'Fear','sleep_pre'};
for sess=1:length(Session_type) % generate all data required for analyses
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
        'heartrate','ob_gamma_power');
end
OutPutData.sleep_pre.heartrate.mean(27,:)=NaN;




Session_type={'sleep_pre','Fear'};
for mouse=1:length(Mouse)
    for sess=1:2
        % heart rate
        clear D
        if sess==1
            D = Data(OutPutData.(Session_type{sess}).heartrate.tsd{mouse,3});
        else
            D = Data(OutPutData.(Session_type{sess}).heartrate.tsd{mouse,6});
        end
        if ~isempty(D)
            bin_size = round(length(D)/(sess*20));
            for bin=1:sess*20
                try, HR_Evol{sess}(mouse,bin) = nanmean(D((bin-1)*bin_size+1:bin*bin_size)); end
            end
        end
        
        % ob gamma power
        clear D
        if sess==1
            D = Data(OutPutData.(Session_type{sess}).ob_gamma_power.tsd{mouse,3});
        else
            D = Data(OutPutData.(Session_type{sess}).ob_gamma_power.tsd{mouse,6});
        end
        if ~isempty(D)
            bin_size = round(length(D)/(sess*20));
            for bin=1:sess*20
                try, Gamma_Evol{sess}(mouse,bin) = nanmean(D((bin-1)*bin_size+1:bin*bin_size))./nanmean(Data(OutPutData.sleep_pre.ob_gamma_power.tsd{mouse,3})); end
            end
        end
        
        % emg pect
        clear D
        if sess==1
            D = Data(OutPutData.(Session_type{sess}).emg_pect.tsd{mouse,3});
        else
            D = Data(OutPutData.(Session_type{sess}).emg_pect.tsd{mouse,6});
        end
        if ~isempty(D)
            bin_size = round(length(D)/(sess*20));
            for bin=1:sess*20
                try, EMG_Evol{sess}(mouse,bin) = nanmean(D((bin-1)*bin_size+1:bin*bin_size))./nanmean(Data(OutPutData.sleep_pre.emg_pect.tsd{mouse,3})); end
            end
        end
    end
end

HR_Evol_all=[];
for sess=1:2
    HR_Evol_all = [HR_Evol_all HR_Evol{sess}];
end
HR_Evol_all(HR_Evol_all==0)=NaN;
HR_Evol_all(:,[20 60])=NaN;

Gamma_Evol_all=[];
for sess=1:2
    Gamma_Evol_all = [Gamma_Evol_all Gamma_Evol{sess}];
end
Gamma_Evol_all(Gamma_Evol_all==0)=NaN;

EMG_Evol_all=[];
for sess=1:2
    EMG_Evol_all = [EMG_Evol_all EMG_Evol{sess}];
end
EMG_Evol_all(EMG_Evol_all==0)=NaN;


%% figures
Cols={[.5 .5 .5],[1 .5 .5],[.5 .5 1]};
X = [1:3];
Legends={'Sleep','Shock','Safe'};

ind = or(or(isnan(OutPutData.sleep_pre.heartrate.mean(:,3)) , isnan(OutPutData.Fear.heartrate.mean(:,5))) , isnan(OutPutData.Fear.heartrate.mean(:,6)));

figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({OutPutData.sleep_pre.heartrate.mean(~ind,3) OutPutData.Fear.heartrate.mean(~ind,5) OutPutData.Fear.heartrate.mean(~ind,6)} , Cols , X , Legends , 'showpoints',0,'paired',1);
ylabel('Heart rate (Hz)')
makepretty_BM2

subplot(132)
MakeSpreadAndBoxPlot3_SB({OutPutData.sleep_pre.ob_gamma_power.mean(~ind,3)./OutPutData.sleep_pre.ob_gamma_power.mean(~ind,3)...
    OutPutData.Fear.ob_gamma_power.mean(~ind,5)./OutPutData.sleep_pre.ob_gamma_power.mean(~ind,3) OutPutData.Fear.ob_gamma_power.mean(~ind,6)./OutPutData.sleep_pre.ob_gamma_power.mean(~ind,3)} , Cols , X , Legends , 'showpoints',0,'paired',1);
ylabel('Gamma power norm to sleep')
makepretty_BM2
ylim([.8 4])

subplot(133)
MakeSpreadAndBoxPlot3_SB({OutPutData.sleep_pre.emg_pect.mean(~ind,3)./OutPutData.sleep_pre.emg_pect.mean(~ind,3)...
    OutPutData.Fear.emg_pect.mean(~ind,5)./OutPutData.sleep_pre.emg_pect.mean(~ind,3) OutPutData.Fear.emg_pect.mean(~ind,6)./OutPutData.sleep_pre.emg_pect.mean(~ind,3)} , Cols , X , Legends , 'showpoints',0,'paired',1);
ylabel('EMG power norm to sleep')
makepretty_BM2
% ylim([.8 4])




figure
subplot(311)
Data_to_use = HR_Evol_all;
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
b=bar(Mean_All_Sp); b.FaceColor=[.5 .5 1]; hold on
errorbar([1:60],Mean_All_Sp,zeros(size(Conf_Inter)),Conf_Inter,'.','vertical','Color','k')
ylim([8 12])
box off
ylabel('Heart rate (Hz)')
makepretty_BM2
vline(20,'--k')

subplot(312)
Data_to_use = Gamma_Evol_all;
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
b=bar(Mean_All_Sp); b.FaceColor=[.5 .5 1]; hold on
errorbar([1:60],Mean_All_Sp,zeros(size(Conf_Inter)),Conf_Inter,'.','vertical','Color','k')
ylim([.9 2.5])
box off
ylabel('Gamma power norm to sleep')
makepretty_BM2
vline(20,'--k')

subplot(313)
Data_to_use = EMG_Evol_all;
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
b=bar(Mean_All_Sp); b.FaceColor=[.5 .5 1]; hold on
errorbar([1:60],Mean_All_Sp,zeros(size(Conf_Inter)),Conf_Inter,'.','vertical','Color','k')
ylim([.8 5])
box off
ylabel('EMG power norm to sleep')
makepretty_BM2
vline(20,'--k')
