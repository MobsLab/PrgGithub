


load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/MeanBodyValues_Eyelid_Cond.mat')

Params = {'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_delta'};
       
% for par=1:length(Params)
%     for mouse=1:length(Mouse)
%         try
%             MeanVal_Shock.(Params{par})(mouse) = nanmean(Data(Restrict(OutPutData.(Params{par}).tsd{mouse,5} , intervalSet(48*60e4 , 100*60e4))));
%         end
%         try
%             MeanVal_Safe.(Params{par})(mouse) = nanmean(Data(Restrict(OutPutData.(Params{par}).tsd{mouse,6} , intervalSet(48*60e4 , 100*60e4))));
%         end
%     end
% end
for par=1:length(Params)
    for mouse=1:length(Mouse)
        try
            clear D, D = Data(OutPutData.(Params{par}).tsd{mouse,5});
            MeanVal_Shock.(Params{par})(mouse) = nanmean(D(round(size(D,1)*.9):end));
        end
        try
            clear D, D = Data(OutPutData.(Params{par}).tsd{mouse,6});
            MeanVal_Safe.(Params{par})(mouse) = nanmean(D(round(size(D,1)*.9):end));
        end
    end
    try, MeanVal_Shock.(Params{par})(MeanVal_Safe.(Params{par})==0) = NaN; end
    try, MeanVal_Safe.(Params{par})(MeanVal_Safe.(Params{par})==0) = NaN; end
end


Cols={[1 .5 .5],[.5 .5 1]};
X=[1 2.5];
Legends={'Shock','Safe'};


figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({MeanVal_Shock.respi_freq_bm MeanVal_Safe.respi_freq_bm},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Breathing (Hz)')
makepretty_BM2




%% mean spectrum
clear all
Session_type={'Cond'};
Mouse=Drugs_Groups_UMaze_BM(22);
for sess=1:length(Session_type)
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = ...
        MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'ob_low','ob_high','hpc_low','hpc_vhigh');
end


for mouse=1:length(Mouse)
    try
        clear D, D = Data(OutPutData.Cond.ob_low.spectrogram{mouse,5});
        MeanSp_OB_Low_Shock(mouse,:) = nanmean(D(round(size(D,1)*.9):end,:));
    end
    try
        clear D, D = Data(OutPutData.Cond.ob_low.spectrogram{mouse,6});
        MeanSp_OB_Low_Safe(mouse,:) = nanmean(D(round(size(D,1)*.9):end,:));
    end
    try
        clear D, D = Data(OutPutData.Cond.ob_high.spectrogram{mouse,5});
        MeanSp_OB_High_Shock(mouse,:) = nanmean(D(round(size(D,1)*.9):end,:));
    end
    try
        clear D, D = Data(OutPutData.Cond.ob_high.spectrogram{mouse,6});
        MeanSp_OB_High_Safe(mouse,:) = nanmean(D(round(size(D,1)*.9):end,:));
    end
    try
        clear D, D = Data(OutPutData.Cond.hpc_low.spectrogram{mouse,5});
        MeanSp_HPC_Low_Shock(mouse,:) = nanmean(D(round(size(D,1)*.9):end,:));
    end
    try
        clear D, D = Data(OutPutData.Cond.hpc_low.spectrogram{mouse,6});
        MeanSp_HPC_Low_Safe(mouse,:) = nanmean(D(round(size(D,1)*.9):end,:));
    end
    try
        clear D, D = Data(OutPutData.Cond.hpc_vhigh.spectrogram{mouse,5});
        MeanSp_HPC_VHigh_Shock(mouse,:) = nanmean(D(round(size(D,1)*.9):end,:));
    end
    try
        clear D, D = Data(OutPutData.Cond.hpc_vhigh.spectrogram{mouse,6});
        MeanSp_HPC_VHigh_Safe(mouse,:) = nanmean(D(round(size(D,1)*.9):end,:));
    end
end
MeanSp_OB_Low_Shock(MeanSp_OB_Low_Shock==0) = NaN;
MeanSp_OB_Low_Safe(MeanSp_OB_Low_Safe==0) = NaN;
MeanSp_OB_High_Shock(MeanSp_OB_High_Shock==0) = NaN;
MeanSp_OB_High_Safe(MeanSp_OB_High_Safe==0) = NaN;
MeanSp_HPC_Low_Shock(MeanSp_HPC_Low_Shock==0) = NaN;
MeanSp_HPC_Low_Safe(MeanSp_HPC_Low_Safe==0) = NaN;
MeanSp_HPC_VHigh_Shock(MeanSp_HPC_VHigh_Shock==0) = NaN;
MeanSp_HPC_VHigh_Safe(MeanSp_HPC_VHigh_Safe==0) = NaN;


figure
subplot(141)
[~,Pow_ob_low_shock,Freq_ob_low_shock] = Plot_MeanSpectrumForMice_BM(movmean(MeanSp_OB_Low_Shock',5)' , 'color' , [1 .5 .5]);
Pow_ob_low_shock([10 19]) = Pow_ob_low_shock([10 19])*10;
[~,Pow_ob_low_safe,Freq_ob_low_safe] = Plot_MeanSpectrumForMice_BM(movmean(MeanSp_OB_Low_Safe',10)' , 'color' , [.5 .5 1] , 'power_norm_value' , Pow_ob_low_shock);
makepretty, xlim([0 10]), xticks([0:2:10]), axis square
f=get(gca,'Children'); legend([f(5),f(1)],'Shock','Safe');

subplot(142)
MeanSp_HPC_Low_Shock([10 19],:) = NaN;
[~,MaxPowerValues1] = Plot_MeanSpectrumForMice_BM(movmean(MeanSp_HPC_Low_Shock',10)' , 'color' , [1 .5 .5] , 'threshold' , 39 , 'dashed_line' , 0);
Plot_MeanSpectrumForMice_BM(movmean(MeanSp_HPC_Low_Safe',10)' , 'color' , [.5 .5 1] , 'threshold' , 39 , 'power_norm_value' , MaxPowerValues1 , 'dashed_line' , 0);
makepretty, xlim([1 20]), ylim([0 1.5]), axis square

subplot(143)
[~,Pow_ob_high_shock,Freq_ob_high_shock] = Plot_MeanSpectrumForMice_BM(runmean(MeanSp_OB_High_Shock',2)' , 'color' , [1 .5 .5] , 'dashed_line' , 0);
Pow_ob_high_shock([21 22]) = Pow_ob_high_shock([21 22])*2;
[~,Pow_ob_high_safe,Freq_ob_high_safe] = Plot_MeanSpectrumForMice_BM(runmean(MeanSp_OB_High_Safe',2)' , 'color' , [.5 .5 1] , 'power_norm_value' , Pow_ob_high_shock , 'dashed_line' , 0);
makepretty, xlim([30 100]), ylim([.3 1.1]), axis square

subplot(144)
load('H_VHigh_Spectrum.mat')
[~,MaxPowerValues1,f1] = Plot_MeanSpectrumForMice_BM(runmean((Spectro{3}.*MeanSp_HPC_VHigh_Shock)',2)' , 'color' , [1 .5 .5]);
[~,MaxPowerValues,f2] = Plot_MeanSpectrumForMice_BM(runmean((Spectro{3}.*MeanSp_HPC_VHigh_Safe)',2)' , 'color' , [.5 .5 1] , 'power_norm_value' , MaxPowerValues1);
makepretty, xlim([20 250]), ylim([.4 11]), axis square
set(gca,'YScale','log')




%%
Cols={[1 .5 .5],[.5 .5 1]};
X=[1 2.5];
Legends={'Shock','Safe'};

Freq_ob_low_shock(12)=NaN;

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
MakeSpreadAndBoxPlot3_SB({nanmean(MeanSp_HPC_Low_Shock(:,fthe)')./nanmean(MeanSp_HPC_Low_Shock(:,fall)')...
    nanmean(MeanSp_HPC_Low_Safe(:,fthe)')./nanmean(MeanSp_HPC_Low_Safe(:,fall)')},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('HPC theta/delta')
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
MakeSpreadAndBoxPlot3_SB({nanmean(MeanSp_HPC_VHigh_Shock(:,fthe)')./nanmean(MeanSp_HPC_VHigh_Shock(:,fall)')...
  nanmean(MeanSp_HPC_VHigh_Safe(:,fthe)')./nanmean(MeanSp_HPC_VHigh_Safe(:,fall)')},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('HPC 40-80Hz band power')
makepretty_BM2

subplot(248)
MakeSpreadAndBoxPlot3_SB({nanmean(MeanSp_HPC_VHigh_Shock(:,fthe2)') nanmean(MeanSp_HPC_VHigh_Safe(:,fthe2)')},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('HPC 150-250Hz band power')
makepretty_BM2






%% ripples
clear all
Session_type={'Cond'};
Mouse=Drugs_Groups_UMaze_BM(22);
for sess=1:length(Session_type)
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = ...
        MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'ripples_all','ripples_density','respi_freq_bm','heartrate','heartratevar');
end


for mouse=1:length(Mouse)
    try
        clear D, D = Data(OutPutData.Cond.ripples_density.tsd{mouse,5});
        Mean_Rip_Shock(mouse,:) = nanmean(D(round(size(D,1)*.9):end));
    end
    try
        clear D, D = Data(OutPutData.Cond.ripples_density.tsd{mouse,6});
        Mean_Rip_Safe(mouse,:) = nanmean(D(round(size(D,1)*.9):end));
    end
    try
        clear D, D = Data(OutPutData.Cond.respi_freq_bm.tsd{mouse,5});
        Mean_Respi_Shock(mouse,:) = nanmean(D(round(size(D,1)*.9):end));
    end
    try
        clear D, D = Data(OutPutData.Cond.respi_freq_bm.tsd{mouse,6});
        Mean_Respi_Safe(mouse,:) = nanmean(D(round(size(D,1)*.9):end));
    end
    try
        clear D, D = Data(OutPutData.Cond.heartrate.tsd{mouse,5});
        Mean_HR_Shock(mouse,:) = nanmean(D(round(size(D,1)*.9):end));
    end
    try
        clear D, D = Data(OutPutData.Cond.heartrate.tsd{mouse,6});
        Mean_HR_Safe(mouse,:) = nanmean(D(round(size(D,1)*.9):end));
    end
    try
        clear D, D = Data(OutPutData.Cond.heartratevar.tsd{mouse,5});
        Mean_HRVar_Shock(mouse,:) = nanmean(D(round(size(D,1)*.9):end));
    end
    try
        clear D, D = Data(OutPutData.Cond.heartratevar.tsd{mouse,6});
        Mean_HRVar_Safe(mouse,:) = nanmean(D(round(size(D,1)*.9):end));
    end
end
Mean_Rip_Shock(Mean_Rip_Safe==0) = NaN;
Mean_Rip_Shock(Mean_Rip_Safe==0) = NaN;
Mean_Respi_Shock(Mean_Respi_Shock==0) = NaN;
Mean_Respi_Safe(Mean_Respi_Safe==0) = NaN;
Mean_HR_Shock(Mean_HR_Shock==0) = NaN;
Mean_HR_Safe(Mean_HR_Safe==0) = NaN;
Mean_HRVar_Shock(Mean_HRVar_Shock==0) = NaN;
Mean_HRVar_Safe(Mean_HRVar_Safe==0) = NaN;


Cols = {[1 .5 .5],[.5 .5 1]};
X = 1:2;
Legends = {'Shock','Safe'};

figure
subplot(141)
MakeSpreadAndBoxPlot3_SB({Mean_Rip_Shock Mean_Rip_Safe},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('SWR occurence (#/s)')
makepretty_BM2

subplot(142)
MakeSpreadAndBoxPlot3_SB({Mean_Respi_Shock Mean_Respi_Safe},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Breathing (Hz)')
makepretty_BM2

subplot(143)
MakeSpreadAndBoxPlot3_SB({Mean_HR_Shock Mean_HR_Safe},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('HR (Hz)')
makepretty_BM2

subplot(144)
MakeSpreadAndBoxPlot3_SB({Mean_HRVar_Shock Mean_HRVar_Safe},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('HR var (a.u.)')
makepretty_BM2


