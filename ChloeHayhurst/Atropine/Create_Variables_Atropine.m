clear all; cl

GetAtropineMice_CH

Session_type = {'Sleep_Pre','Sleep_Post','OF_Pre','OF_Post'};
States={'Sleep','NREM','REM','Wake'};

cd('/media/nas7/Atropine/Mouse1500/30012024/OF_Pre/')

load('H_Low_Spectrum.mat'); range_Low=Spectro{3};
load('B_High_Spectrum.mat'); range_High=Spectro{3};
load('H_VHigh_Spectrum.mat'); range_VHigh=Spectro{3};


%% For each mouse

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    disp(Mouse_names{mouse})
    
    for sess = 1:2
        cd(AtropineSess.(Mouse_names{mouse}){sess});
        clear Wake SWSEpoch REMEpoch Sleep Epoch tRipples
        load('SleepScoring_Accelero.mat', 'Wake' , 'SWSEpoch' , 'REMEpoch' , 'Sleep' , 'Epoch');
        try; load('SWR.mat','tRipples'); end
        
        Wake_Epoch.(Mouse_names{mouse}){sess} = Wake;
        Sleep_Epoch.(Mouse_names{mouse}){sess} = Sleep;
        SWS_Epoch.(Mouse_names{mouse}){sess} = SWSEpoch;
        REM_Epoch.(Mouse_names{mouse}){sess} = REMEpoch;
        
        Wake_prop.(Mouse_names{mouse}){sess} = sum(Stop(Wake)-Start(Wake))/sum(Stop(Epoch)-Start(Epoch));
        Wake_MeanDur.(Mouse_names{mouse}){sess} = nanmean(DurationEpoch(Wake))/1e4;
        Wake_EpNumb.(Mouse_names{mouse}){sess} = length(Start(Wake));
        
        Sleep_prop.(Mouse_names{mouse}){sess} = sum(Stop(Sleep)-Start(Sleep))/sum(Stop(Epoch)-Start(Epoch));
        Sleep_MeanDur.(Mouse_names{mouse}){sess} = nanmean(DurationEpoch(Sleep))/1e4;
        Sleep_EpNumb.(Mouse_names{mouse}){sess} = length(Start(Sleep));
        
        NREM_prop.(Mouse_names{mouse}){sess} = sum(Stop(SWSEpoch)-Start(SWSEpoch))/sum(Stop(Sleep)-Start(Sleep));
        NREM_MeanDur.(Mouse_names{mouse}){sess} = nanmean(DurationEpoch(SWSEpoch))/1e4;
        NREM_EpNumb.(Mouse_names{mouse}){sess} = length(Start(SWSEpoch));
        
        REM_prop.(Mouse_names{mouse}){sess} = sum(Stop(REMEpoch)-Start(REMEpoch))/sum(Stop(Sleep)-Start(Sleep));
        REM_MeanDur.(Mouse_names{mouse}){sess} = nanmean(DurationEpoch(REMEpoch))/1e4;
        REM_EpNumb.(Mouse_names{mouse}){sess} = length(Start(REMEpoch));
        
    end
    
    for sess = 1:length(Session_type)
        if sess == 1 | sess==2
            cd(AtropineSess.(Mouse_names{mouse}){sess})
            clear Wake SWSEpoch REMEpoch Sleep Epoch tRipples MovAcctsd
            load('SleepScoring_Accelero.mat', 'Wake' , 'SWSEpoch' , 'REMEpoch' , 'Sleep' , 'Epoch');
            load('SleepScoring_OBGamma.mat', 'SmoothGamma')
            try; load('SWR.mat','tRipples'); end
            
        else
            cd(AtropineSess.(Mouse_names{mouse}){sess})
            clear FreezeAccEpoch MovingEpoch Epoch tRipples MovAcctsd
            load('behavResources_SB.mat', 'Behav');
            load('StateEpochSB.mat', 'Epoch')
                    load('StateEpochSB.mat', 'smooth_ghi')
            try; load('SWR.mat','tRipples'); end
        end
        
        load('ExpeInfo.mat');
        
        ExpeInfo.SleepSession = {ExpeInfo.SleepSession};
        
        IsSleep.(Mouse_names{mouse})(sess) = ExpeInfo.SleepSession;
        
        clear 'ExpeInfo.mat';
        
        load('behavResources.mat', 'MovAcctsd');
        
        SpectroHLow.(Mouse_names{mouse}){sess} = load('H_Low_Spectrum.mat');
        SpectroBHigh.(Mouse_names{mouse}){sess} = load('B_High_Spectrum.mat');
        SpectroBLow.(Mouse_names{mouse}){sess} = load('B_Low_Spectrum.mat');
        
        
        FreqHLow.(Mouse_names{mouse}){sess} = SpectroHLow.(Mouse_names{mouse}){sess}.Spectro{3};
        FreqBHigh.(Mouse_names{mouse}){sess} = SpectroBHigh.(Mouse_names{mouse}){sess}.Spectro{3};
        FreqBLow.(Mouse_names{mouse}){sess} = SpectroBLow.(Mouse_names{mouse}){sess}.Spectro{3};
        
        
        Sp_tsd_HLow.(Mouse_names{mouse}){sess} = tsd(SpectroHLow.(Mouse_names{mouse}){sess}.Spectro{2}*1e4 , SpectroHLow.(Mouse_names{mouse}){sess}.Spectro{1});
        Sp_tsd_BHigh.(Mouse_names{mouse}){sess} = tsd(SpectroBHigh.(Mouse_names{mouse}){sess}.Spectro{2}*1e4 , SpectroBHigh.(Mouse_names{mouse}){sess}.Spectro{1});
        Sp_tsd_BLow.(Mouse_names{mouse}){sess} = tsd(SpectroBLow.(Mouse_names{mouse}){sess}.Spectro{2}*1e4 , SpectroBLow.(Mouse_names{mouse}){sess}.Spectro{1});
        
        if sess == 1 | sess==2
            Sp_tsd_HLow_Sleep.(Mouse_names{mouse}){sess} = Restrict(Sp_tsd_HLow.(Mouse_names{mouse}){sess},Sleep_Epoch.(Mouse_names{mouse}){sess});
            Sp_tsd_BHigh_Sleep.(Mouse_names{mouse}){sess} = Restrict(Sp_tsd_BHigh.(Mouse_names{mouse}){sess},Sleep_Epoch.(Mouse_names{mouse}){sess});
            Sp_tsd_BLow_Sleep.(Mouse_names{mouse}){sess} = Restrict(Sp_tsd_BLow.(Mouse_names{mouse}){sess},Sleep_Epoch.(Mouse_names{mouse}){sess});
            
            Mean_HLow_Sleep.(Mouse_names{mouse}){sess} = nanmean(Data(Sp_tsd_HLow_Sleep.(Mouse_names{mouse}){sess}));
            Mean_HLow_Sleep_corr.(Mouse_names{mouse}){sess} = nanmean(Data(Sp_tsd_HLow_Sleep.(Mouse_names{mouse}){sess})) .* FreqHLow.(Mouse_names{mouse}){sess};
            Mean_BHigh_Sleep.(Mouse_names{mouse}){sess} = nanmean(Data(Sp_tsd_BHigh_Sleep.(Mouse_names{mouse}){sess}));
            Mean_BHigh_Sleep_corr.(Mouse_names{mouse}){sess} = nanmean(Data(Sp_tsd_BHigh_Sleep.(Mouse_names{mouse}){sess})) .* FreqBHigh.(Mouse_names{mouse}){sess};
            Mean_BLow_Sleep.(Mouse_names{mouse}){sess} = nanmean(Data(Sp_tsd_BLow_Sleep.(Mouse_names{mouse}){sess}));
            Mean_BLow_Sleep_corr.(Mouse_names{mouse}){sess} = nanmean(Data(Sp_tsd_BLow_Sleep.(Mouse_names{mouse}){sess})) .* FreqBLow.(Mouse_names{mouse}){sess};
        else

        end
        
        
        Mean_HLow.(Mouse_names{mouse}){sess} = nanmean(Data(Sp_tsd_HLow.(Mouse_names{mouse}){sess}));
        Mean_BHigh.(Mouse_names{mouse}){sess} = nanmean(Data(Sp_tsd_BHigh.(Mouse_names{mouse}){sess}));
        Mean_BLow.(Mouse_names{mouse}){sess} = nanmean(Data(Sp_tsd_BLow.(Mouse_names{mouse}){sess}));
        
        Mean_BLow_corr.(Mouse_names{mouse}){sess} = nanmean(Data(Sp_tsd_BLow.(Mouse_names{mouse}){sess})) .* FreqBLow.(Mouse_names{mouse}){sess};
        Mean_HLow_corr.(Mouse_names{mouse}){sess} = nanmean(Data(Sp_tsd_HLow.(Mouse_names{mouse}){sess})) .* FreqHLow.(Mouse_names{mouse}){sess};
        Mean_BHigh_corr.(Mouse_names{mouse}){sess} = nanmean(Data(Sp_tsd_BHigh.(Mouse_names{mouse}){sess})) .* FreqBHigh.(Mouse_names{mouse}){sess};
        
        smootime = 1;
        NewMovAcctsd.(Mouse_names{mouse}){sess} = tsd(Range(MovAcctsd),runmean(Data(MovAcctsd) , ceil(smootime/median(diff(Range(MovAcctsd,'s'))))));
        MeanAcc.(Mouse_names{mouse}){sess} = nanmean(Data(NewMovAcctsd.(Mouse_names{mouse}){sess}));
        
        if IsSleep.(Mouse_names{mouse}){sess} == 0
            NewSmoothGamma.(Mouse_names{mouse}){sess} = tsd(Range(smooth_ghi),runmean(Data(smooth_ghi), ceil(smootime/median(diff(Range(smooth_ghi,'s'))))));
        else
            NewSmoothGamma.(Mouse_names{mouse}){sess} = tsd(Range(SmoothGamma),runmean(Data(SmoothGamma), ceil(smootime/median(diff(Range(SmoothGamma,'s'))))));
            Acc_SWS.(Mouse_names{mouse}){sess} = Restrict(NewMovAcctsd.(Mouse_names{mouse}){sess},SWS_Epoch.(Mouse_names{mouse}){sess});
            Acc_REM.(Mouse_names{mouse}){sess} = Restrict(NewMovAcctsd.(Mouse_names{mouse}){sess},REM_Epoch.(Mouse_names{mouse}){sess});
        end
        
        MeanSmoothGamma.(Mouse_names{mouse}){sess} = nanmean(Data(NewSmoothGamma.(Mouse_names{mouse}){sess}));
        
        
        try
            Ripples_density.(Mouse_names{mouse}){sess} = length(Range(Restrict(tRipples,Epoch)))/(sum(Stop(Epoch)-Start(Epoch))/1e4);
        catch
            Ripples_density.(Mouse_names{mouse}){sess} = NaN;
        end
        try
            Ripples_density_SWS.(Mouse_names{mouse}){sess} = length(Range(Restrict(tRipples,SWSEpoch)))/(sum(Stop(SWSEpoch)-Start(SWSEpoch))/1e4);
        catch
            Ripples_density_SWS.(Mouse_names{mouse}){sess} = NaN;
        end
        try
            Ripples_density_Wake.(Mouse_names{mouse}){sess} = length(Range(Restrict(tRipples,Wake)))/(sum(Stop(Wake)-Start(Wake))/1e4);
        catch
            Ripples_density_Wake.(Mouse_names{mouse}){sess} = NaN;
        end
        try
            Ripples_density_REM.(Mouse_names{mouse}){sess} = length(Range(Restrict(tRipples,REMEpoch)))/(sum(Stop(REMEpoch)-Start(REMEpoch))/1e4);
        catch
            Ripples_density_REM.(Mouse_names{mouse}){sess} = NaN;
        end
        if IsSleep.(Mouse_names{mouse}){sess} == 0
            try
                Ripples_density_Slow.(Mouse_names{mouse}){sess} = length(Range(Restrict(tRipples,Behav.SlowAccEpoch)))/(sum(Stop(Behav.SlowAccEpoch)-Start(Behav.SlowAccEpoch))/1e4);
            catch
                Ripples_density_Slow.(Mouse_names{mouse}){sess} = NaN;
            end
            try
                Ripples_density_Active.(Mouse_names{mouse}){sess} = length(Range(Restrict(tRipples,Behav.ActiveEpoch)))/(sum(Stop(Behav.ActiveEpoch)-Start(Behav.ActiveEpoch))/1e4);
            catch
                Ripples_density_Active.(Mouse_names{mouse}){sess} = NaN;
            end
        end 
    end
    disp(Mouse_names{mouse})
end



for mouse=2
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    for sess = 1:length(Session_type)
        cd(AtropineSess.(Mouse_names{mouse}){sess});
        load('HeartBeatInfo.mat', 'EKG')
        HR{sess} = EKG.HBRate;
        HR_good{sess}=Restrict(HR{sess},EKG.GoodEpoch);
    end
    
    for sess = 1:2
        HR_Wake{sess} = Restrict(HR{sess},Wake_Epoch.(Mouse_names{mouse}){sess});
        HR_Sleep{sess} = Restrict(HR{sess},Sleep_Epoch.(Mouse_names{mouse}){sess});
        HR_SWS{sess} = Restrict(HR{sess},SWS_Epoch.(Mouse_names{mouse}){sess});
        HR_REM{sess} = Restrict(HR{sess},REM_Epoch.(Mouse_names{mouse}){sess});
        HR_Wake_mean{sess} = nanmean(Data(HR_Wake{sess}));
        Data_HR_REM{sess} = Data(HR_REM{sess})
        Data_HR_SWS{sess} = Data(HR_SWS{sess})
    end
    for sess = 3:4
        cd(AtropineSess.(Mouse_names{mouse}){sess})
        load('StateEpochSB.mat')
        HR_Wake{sess} = Restrict(HR{sess},Epoch);
        HR_Wake_mean{sess} = nanmean(Data(HR_Wake{sess}));
    end
end
%     
% figure
% plot(Data(HR_Wake{1}))
% hold on
% plot(Data(HR_Wake{2}))
% figure
% plot(Range(HR_Wake{3}),Data(HR_Wake{3}))
% hold on
% plot(Range(HR_Wake{4}),Data(HR_Wake{4}))
% 
% 
% figure
% plot(Data(NewMovAcctsd.M1531{3}))
% hold on
% plot(Data(NewMovAcctsd.M1531{4}))
% 
% 
% plot(length(HR_REM{1}))
% Data_HR_REM = Data(HR_REM)

%% Mean for all mice


for sess = 1:length(Session_type)
    for mouse = 1:length(Mouse)
        MeanAcc_All{sess}(mouse) = MeanAcc.(Mouse_names{mouse}){sess};
    end
end

for sess = 1:2
    for mouse = 1:length(Mouse)
        Sleep_Prop_All{sess}(mouse) = Sleep_prop.(Mouse_names{mouse}){sess};
        REM_Prop_All{sess}(mouse) = REM_prop.(Mouse_names{mouse}){sess};
        NREM_Prop_All{sess}(mouse) = NREM_prop.(Mouse_names{mouse}){sess};
        Wake_Prop_All{sess}(mouse) = Wake_prop.(Mouse_names{mouse}){sess};
        Mean_OB_Low_Sleep{sess}(mouse,:) = Mean_BLow_Sleep.(Mouse_names{mouse}){sess};
        Mean_H_Low_Sleep{sess}(mouse,:) = Mean_HLow_Sleep.(Mouse_names{mouse}){sess};
        Mean_B_High_Sleep{sess}(mouse,:) = Mean_BHigh_Sleep.(Mouse_names{mouse}){sess};
        Mean_H_Low_Sleep_corr{sess}(mouse,:) = Mean_HLow_Sleep_corr.(Mouse_names{mouse}){sess};
        Mean_B_Low_Sleep_corr{sess}(mouse,:) = Mean_BLow_Sleep_corr.(Mouse_names{mouse}){sess};
        Mean_B_High_Sleep_corr{sess}(mouse,:) = Mean_BHigh_Sleep_corr.(Mouse_names{mouse}){sess};
        
        clear A, A = Data(Restrict(NewMovAcctsd.(Mouse_names{mouse}){sess},SWS_Epoch.(Mouse_names{mouse}){sess}));
        Mean_Acc_SWS{sess}(mouse,:) = A;
        clear B, B = Data(Acc_REM.(Mouse_names{mouse}){sess});
        Mean_Acc_REM{sess}(mouse,:) = B;
        
    end
end

for mouse = 1:length(Mouse)
    for sess = 1:2
        clear A, A = Data(Acc_SWS.(Mouse_names{mouse}){sess});
        Mean_Acc_SWS{sess}(mouse,:) = A;
        clear B, B = Data(Acc_REM.(Mouse_names{mouse}){sess});
        Mean_Acc_REM{sess}(mouse,:) = B;
        
    end
end

% Ripples only for mouse 1500 and 1531

for sess = 1:length(Session_type)
    for mouse = 1:2
        
        Ripples_density_All{sess}(mouse) = Ripples_density.(Mouse_names{mouse}){sess};
        
        if IsSleep.(Mouse_names{mouse}){sess} == 1
            Ripples_density_SWS_All{sess}(mouse) = Ripples_density_SWS.(Mouse_names{mouse}){sess};
            Ripples_density_Wake_All{sess}(mouse) = Ripples_density_Wake.(Mouse_names{mouse}){sess};
            Ripples_density_REM_All{sess}(mouse) = Ripples_density_REM.(Mouse_names{mouse}){sess};
        end
        
        if IsSleep.(Mouse_names{mouse}){sess} == 0
            Ripples_density_Slow_All{sess}(mouse) = Ripples_density_Slow.(Mouse_names{mouse}){sess};
            Ripples_density_Active_All{sess}(mouse) = Ripples_density_Active.(Mouse_names{mouse}){sess};
        end
        %         Ripples_density_Slow_All{1,1} = NaN;
        %         Ripples_density_Slow_All{1,2} = NaN;
        %         Ripples_density_Active_All{1,1} = NaN;
        %         Ripples_density_Active_All{1,2} = NaN;
        %
    end
end

for sess = 1:length(Session_type)
    for mouse = 1:length(Mouse)
        Accelero_All{sess}(mouse) = NewMovAcctsd.(Mouse_names{mouse}){sess};
        %         Accelero_All{sess}(mouse) = log10(nanmedian(Data(NewMovAcctsd.(Mouse_names{mouse}){sess})));
        MeanAcc_All{sess}(mouse) = MeanAcc.(Mouse_names{mouse}){sess};
        clear A, A = Data(Restrict(NewMovAcctsd.(Mouse_names{mouse}){sess} , NewMovAcctsd.(Mouse_names{1}){sess}));
        Mean_Acc_All{sess}(mouse,:) = A;
        SmoothGamma_All{sess}(mouse) = NewSmoothGamma.(Mouse_names{mouse}){sess};
        MeanG_All{sess}(mouse) = MeanSmoothGamma.(Mouse_names{mouse}){sess};
        clear B, B = Data(Restrict(NewSmoothGamma.(Mouse_names{mouse}){sess} , NewSmoothGamma.(Mouse_names{1}){sess}));
        Mean_SmoothGamma_All{sess}(mouse,:) = B;
        Sp_tsd_BLow_All{sess}(mouse) = Sp_tsd_BLow.(Mouse_names{mouse}){sess};
        clear C, C =  Data(Restrict(Sp_tsd_BLow.(Mouse_names{mouse}){sess} , Sp_tsd_BLow.(Mouse_names{1}){sess}));
        Mean_OB_Low{sess}(mouse,:) = Mean_BLow.(Mouse_names{mouse}){sess};
        Mean_H_Low{sess}(mouse,:) = Mean_HLow.(Mouse_names{mouse}){sess};
        Mean_B_High{sess}(mouse,:) = Mean_BHigh.(Mouse_names{mouse}){sess};
        Mean_H_Low_corr{sess}(mouse,:) = Mean_HLow_corr.(Mouse_names{mouse}){sess};
        Mean_B_Low_corr{sess}(mouse,:) = Mean_BLow_corr.(Mouse_names{mouse}){sess};
        Mean_B_High_corr{sess}(mouse,:) = Mean_BHigh_corr.(Mouse_names{mouse}){sess};
  
    end
end




%% Figures

% Sleep Architecture

Cols = {[.3 .4 1],[1 .4 .3]};
X = [1:2];
Legends = {'Sleep Pre','Sleep Post'};
NoLegends = {'',''};

figure;

subplot(2,3,1)
MakeSpreadAndBoxPlot3_SB(Wake_Prop_All,Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('%')
title('Wake Proportion')

subplot(232)
MakeSpreadAndBoxPlot3_SB(NREM_Prop_All,Cols,X,Legends,'showpoints',0,'paired',1);
title('NREM Proportion')

subplot(233)
MakeSpreadAndBoxPlot3_SB(REM_Prop_All,Cols,X,Legends,'showpoints',0,'paired',1);
title('REM Proportion')
A=mtitle(['Sleep Stages']); A.FontSize=20; A.FontWeight='bold';

subplot(234)
MakeSpreadAndBoxPlot3_SB(Ripples_density_Wake_All,Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 .6])
ylabel('Ripples/second')
title('Wake Ripples')

subplot(235)
MakeSpreadAndBoxPlot3_SB(Ripples_density_SWS_All,Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 .6])
title('NREM Ripples')

subplot(236)
MakeSpreadAndBoxPlot3_SB(Ripples_density_REM_All,Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 .6])
title('REM Ripples')

a = mtitle('Atropine, sleep sessions (50 mg/kg)')

saveFigure_BM(1,'SleepArchitecture','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/Atropine/')


%% Heart Rate and detecting REM without theta

figure


%% OF sessions

Cols = {[.3 .4 1],[1 .4 .3]};
X = [1:2];
Legends = {'OF Pre','OF Post'};
NoLegends = {'',''};

figure
subplot(231)
MakeSpreadAndBoxPlot3_SB(Ripples_density_All(3:4),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Ripples/second')
title('All ripples')

subplot(232)
MakeSpreadAndBoxPlot3_SB(Ripples_density_Slow_All(3:4),Cols,X,Legends,'showpoints',0,'paired',1);
title('Ripples slow')

subplot(233)
MakeSpreadAndBoxPlot3_SB(Ripples_density_Active_All(3:4),Cols,X,Legends,'showpoints',0,'paired',1);
title('Ripples active')

subplot(234)
MakeSpreadAndBoxPlot3_SB(MeanAcc_All(3:4),Cols,X,Legends,'showpoints',0,'paired',1);
title('Mean Accelero Value')

subplot(2, 3, [5:6])
Data_to_use = Mean_Acc_All{3};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
S = shadedErrorBar(linspace(0,15,length(Data_to_use)) , runmean(Mean_All_Sp,1000) , runmean(Conf_Inter,1000) ,'-b',1); hold on;
hold on
Data_to_use = Mean_Acc_All{4};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,30,length(Data_to_use)) , runmean(Mean_All_Sp,1000) , runmean(Conf_Inter,1000) ,'-r',1); hold on;
xlim([0 15])
xlabel('time (minutes)')
title('Mean Accelero across time')

a = mtitle('Atropine, open field sessions (50 mg/kg)')

saveFigure_BM(2,'RipAccelero_OF','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/Atropine/')


%% OF sessions, OB

Cols = {[.3 .4 1],[1 .4 .3]};
X = [1:2];
Legends = {'OF Pre','OF Post'};
NoLegends = {'',''};

% Mean Spectrums

figure

subplot(231)
Data_to_use = Mean_H_Low{1,3};
plot(linspace(0,20,length(Data_to_use)),log(nanmean(Data_to_use)))
hold on
Data_to_use = Mean_H_Low{1,4};
plot(linspace(0,20,length(Data_to_use)),log(nanmean(Data_to_use)))
legend('Pre','Post')
makepretty
title('H Low')
ylabel('Non-corrected')

subplot(234)
Data_to_use = Mean_H_Low_corr{1,3};
plot(linspace(0,20,length(Data_to_use)),log(nanmean(Data_to_use)))
hold on
Data_to_use = Mean_H_Low_corr{1,4};
plot(linspace(0,20,length(Data_to_use)),log(nanmean(Data_to_use)))
legend('Pre','Post')
makepretty
ylabel('Corrected')
xlabel('Frequency (Hz)')

subplot(232)
Data_to_use = Mean_OB_Low{1,3};
plot(linspace(0,20,length(Data_to_use)),log(nanmean(Data_to_use)))
hold on
Data_to_use = Mean_OB_Low{1,4};
plot(linspace(0,20,length(Data_to_use)),log(nanmean(Data_to_use)))
legend('Pre','Post')
makepretty
title('B Low')

subplot(235)
Data_to_use = Mean_B_Low_corr{1,3};
plot(linspace(0,20,length(Data_to_use)),log(nanmean(Data_to_use)))
hold on
Data_to_use = Mean_B_Low_corr{1,4};
plot(linspace(0,20,length(Data_to_use)),log(nanmean(Data_to_use)))
legend('Pre','Post')
makepretty
xlabel('Frequency (Hz)')


subplot(233)
Data_to_use = Mean_B_High{1,3};
plot(linspace(20,100,length(Data_to_use)),log(nanmean(Data_to_use)))
hold on
Data_to_use = Mean_B_High{1,4};
plot(linspace(20,100,length(Data_to_use)),log(nanmean(Data_to_use)))
legend('Pre','Post')
makepretty
title('B High')

subplot(236)
Data_to_use = Mean_B_High_corr{1,3};
plot(linspace(20,100,length(Data_to_use)),log(nanmean(Data_to_use)))
hold on
Data_to_use = Mean_B_High_corr{1,4};
plot(linspace(20,100,length(Data_to_use)),log(nanmean(Data_to_use)))
legend('Pre','Post')
makepretty
xlabel('Frequency (Hz)')

a = mtitle('Atropine, OF (log scale)')

saveFigure_BM(3,'Mean_Spectrums_OF','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/Atropine/')

% Same but for Sleep Sessions

figure

subplot(231)
Data_to_use = Mean_H_Low_Sleep{1,1};
plot(linspace(0,20,length(Data_to_use)),log(nanmean(Data_to_use)))
hold on
Data_to_use = Mean_H_Low_Sleep{1,2};
plot(linspace(0,20,length(Data_to_use)),log(nanmean(Data_to_use)))
legend('Pre','Post')
makepretty
title('H Low')
ylabel('Non-corrected')

subplot(234)
Data_to_use = Mean_H_Low_Sleep_corr{1,1};
plot(linspace(0,20,length(Data_to_use)),log(nanmean(Data_to_use)))
hold on
Data_to_use = Mean_H_Low_Sleep_corr{1,2};
plot(linspace(0,20,length(Data_to_use)),log(nanmean(Data_to_use)))
legend('Pre','Post')
makepretty
ylabel('Corrected')
xlabel('Frequency (Hz)')

subplot(232)
Data_to_use = Mean_OB_Low_Sleep{1,1};
plot(linspace(0,20,length(Data_to_use)),log(nanmean(Data_to_use)))
hold on
Data_to_use = Mean_OB_Low_Sleep{1,2};
plot(linspace(0,20,length(Data_to_use)),log(nanmean(Data_to_use)))
legend('Pre','Post')
makepretty
title('B Low')

subplot(235)
Data_to_use = Mean_B_Low_Sleep_corr{1,1};
plot(linspace(0,20,length(Data_to_use)),log(nanmean(Data_to_use)))
hold on
Data_to_use = Mean_B_Low_Sleep_corr{1,2};
plot(linspace(0,20,length(Data_to_use)),log(nanmean(Data_to_use)))
legend('Pre','Post')
makepretty
xlabel('Frequency (Hz)')


subplot(233)
Data_to_use = Mean_B_High_Sleep{1,1};
plot(linspace(20,100,length(Data_to_use)),log(nanmean(Data_to_use)))
hold on
Data_to_use = Mean_B_High_Sleep{1,2};
plot(linspace(20,100,length(Data_to_use)),log(nanmean(Data_to_use)))
legend('Pre','Post')
makepretty
title('B High')

subplot(236)
Data_to_use = Mean_B_High_Sleep_corr{1,1};
plot(linspace(20,100,length(Data_to_use)),log(nanmean(Data_to_use)))
hold on
Data_to_use = Mean_B_High_Sleep_corr{1,2};
plot(linspace(20,100,length(Data_to_use)),log(nanmean(Data_to_use)))
legend('Pre','Post')
makepretty
xlabel('Frequency (Hz)')

a = mtitle('Atropine, Sleep (log scale)')

saveFigure_BM(4,'MeanSpectrumSleep','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/Atropine/')


% Mean Accelero and Gamma Power

figure

subplot(131)
MakeSpreadAndBoxPlot3_SB(MeanG_All(3:4),Cols,X,Legends,'showpoints',0,'paired',1);
title('Mean Gamma Power Value')

subplot(1, 3, 2:3)
Data_to_use = Mean_SmoothGamma_All{3};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,15,length(Data_to_use)) , runmean(Mean_All_Sp,2000) , runmean(Conf_Inter,2000) ,'-b',1); hold on;
hold on
Data_to_use = Mean_SmoothGamma_All{4};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,30,length(Data_to_use)) , runmean(Mean_All_Sp,2000) , runmean(Conf_Inter,2000) ,'-r',1); hold on;
xlim([0 15])
xlabel('time (minutes)')
title('Mean Gamma power across time')

a = mtitle('Gamma Power, OF')

saveFigure_BM(5,'GammaPower_OF','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/Atropine/')






