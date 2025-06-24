
%% data
clear all
GetEmbReactMiceFolderList_BM
Group=22;

Mouse=Drugs_Groups_UMaze_BM(Group);
Session_type={'Cond','sleep_pre'};
for sess=1:length(Session_type) % generate all data required for analyses
        [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
            'accelero','ob_high');
end


for mouse=1:length(Mouse)
    try
        clear D, D = Data(OutPutData.Cond.ob_high.spectrogram{mouse,5});
        MeanSp_OB_High_Shock(mouse,:) = nanmean(D(round(size(D,1)*.9):end,:));
    end
    try
        clear D, D = Data(OutPutData.Cond.ob_high.spectrogram{mouse,6});
        MeanSp_OB_High_Safe(mouse,:) = nanmean(D(round(size(D,1)*.9):end,:));
    end
end
MeanSp_OB_High_Shock(MeanSp_OB_High_Shock==0) = NaN;
MeanSp_OB_High_Safe(MeanSp_OB_High_Safe==0) = NaN;


smoofact_Acc = 30;
thtps_immob=2;
for mouse = 1:length(Mouse)
    if mouse<14
        th_immob_Acc = 1e7;
    else
        th_immob_Acc = 1.7e7;
    end
    try
        NewMovAcctsd=tsd(Range(OutPutData.sleep_pre.accelero.tsd{mouse,1}),runmean(Data(OutPutData.sleep_pre.accelero.tsd{mouse,1}),smoofact_Acc));
        FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
        FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
        FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
        
        Sleep1 = Epoch1.sleep_pre{mouse,3};
        Sleep1 = dropShortIntervals(Sleep1,30e4);
        
        Sleep_Beginning = Start(Sleep1) ;
        Wake_Before_Sleep_Epoch = intervalSet(0 , Sleep_Beginning(1));
        QuietWake{mouse} = and(Wake_Before_Sleep_Epoch , FreezeAccEpoch);
    end
    try
        Epoch1.sleep_pre{mouse,3} = mergeCloseIntervals(Epoch1.sleep_pre{mouse,3} , 2e4);
        Epoch1.sleep_pre{mouse,3} = dropShortIntervals(Epoch1.sleep_pre{mouse,3} , 10e4);
    end
end

for mouse=1:length(Mouse)
    clear D, D = nanmean(Data(OutPutData.Cond.ob_high.spectrogram{mouse,5}));
    OB_gamma_shock(mouse) = nanmean(D(9:end));
    clear D, D = nanmean(Data(OutPutData.Cond.ob_high.spectrogram{mouse,6}));
    OB_gamma_safe(mouse) = nanmean(D(9:end));
    try
        clear D, D = nanmean(Data(OutPutData.sleep_pre.ob_high.spectrogram{mouse,3}));
        OB_gamma_sleep(mouse) = nanmean(D(9:end));
    end
    try
        clear D, D = nanmean(Data(Restrict(OutPutData.sleep_pre.ob_high.spectrogram{mouse,1} , QuietWake{mouse})));
        OB_gamma_QW(mouse) = nanmean(D(9:end));
    end
end
OB_gamma_sleep(OB_gamma_sleep==0) = NaN;
OB_gamma_QW(OB_gamma_QW==0) = NaN;


%% figure
figure
[~,Pow_ob_high_shock,Freq_ob_high_shock] = Plot_MeanSpectrumForMice_BM(runmean(MeanSp_OB_High_Shock',2)' , 'color' , [1 .5 .5] , 'dashed_line' , 0);
Pow_ob_high_shock([21 22]) = Pow_ob_high_shock([21 22])*2;
[~,Pow_ob_high_safe,Freq_ob_high_safe] = Plot_MeanSpectrumForMice_BM(runmean(MeanSp_OB_High_Safe',2)' , 'color' , [.5 .5 1] , 'power_norm_value' , Pow_ob_high_shock , 'dashed_line' , 0);
makepretty, xlim([30 100]), ylim([.3 1.1]), axis square




Cols = {[1 .5 .5],[.5 .5 1]};
X = [1:2];
Legends = {'Shock','Safe'};

figure
MakeSpreadAndBoxPlot3_SB({OB_gamma_shock OB_gamma_safe},Cols,X,Legends,'showpoints',0,'paired',1);
makepretty_BM2


Cols = {[.3 .3 .3],[.5 .5 1],[1 .5 .5]};
X = [1:3];
Legends = {'QW','Safe','Shock'};

figure
MakeSpreadAndBoxPlot3_SB({OB_gamma_QW OB_gamma_safe OB_gamma_shock},Cols,X,Legends,'showpoints',0,'paired',1);
makepretty_BM2
ylabel('OB gamma power (a.u.)')



Cols = {[.3 .3 .3],[.5 .5 1],[1 .5 .5]};
X = [1:3];
Legends = {'Sleep','Safe','Shock'};

figure
MakeSpreadAndBoxPlot3_SB({OB_gamma_sleep OB_gamma_safe OB_gamma_shock},Cols,X,Legends,'showpoints',0,'paired',1);
makepretty_BM2
ylabel('OB gamma power (a.u.)')






