clear all
Dir = PathForExperimentFEAR('Sleep-OBX');

for dd = 1:length(Dir.path)
    cd(Dir.path{dd})
    disp(Dir.path{dd})
    %     SleepScoringAccelerometer('recompute',1)
    
    
    %% Sleep event
    disp('getting sleep signals')
    CreateSleepSignals('recompute',1,'scoring','accelero');
    
    %% Substages
    disp('getting sleep stages')
    [featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures('scoring','accelero');
    save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch', 'scoring')
    [Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch);
    save('SleepSubstages', 'Epoch', 'NameEpoch')
    
    %% Id figure 1
    disp('making ID fig1')
    MakeIDSleepData
    PlotIDSleepData('scoring','accelero')
    saveas(1,'IDFig1.png')
    close all
    
    %% Id figure 2
    disp('making ID fig2')
    MakeIDSleepData2('scoring','accelero')
    PlotIDSleepData2
    saveas(1,'IDFig2.png')
    close all
    
end

%%%%%%%
clear all
Dir = PathForExperimentFEAR('Sleep-OBX');

for dd = 1:length(Dir.path)
    cd(Dir.path{dd})
    disp(Dir.path{dd})
    load('SleepScoring_Accelero.mat','SWSEpoch','REMEpoch','Wake','TotalNoiseEpoch')
    Sleep = or(SWSEpoch,REMEpoch);
    Wake = or(Wake,TotalNoiseEpoch);
    SleepOnWake(dd) = sum(Stop(Sleep) - Start(Sleep))./(sum(Stop(Sleep) - Start(Sleep)) + sum(Stop(Wake) - Start(Wake)));
    REMonSleep(dd) = sum(Stop(REMEpoch) - Start(REMEpoch))./(sum(Stop(Sleep) - Start(Sleep)));
    TotDur(dd) = sum(Stop(Sleep) - Start(Sleep)) + (sum(Stop(Wake) - Start(Wake)));
    MouseNum(dd) = eval(Dir.name{dd}(end-2:end));
end

ylim([0 0.18])

LongSession = [2,4,6,13,16];

Dir = PathForExperimentsEmbReact('BaselineSleep');

mouse = 1;
clear DataPts
for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        if not(Dir.ExpeInfo{d}{dd}.nmouse ==439)
            try
                clear SWSEpoch REMEpoch Wake NewtsdZT
                load('SleepScoring_OBGamma.mat','SWSEpoch','REMEpoch','Wake','TotalNoiseEpoch')
                
                Sleep = or(SWSEpoch,REMEpoch);
                Wake = or(Wake,TotalNoiseEpoch);
                SleepOnWake_Ctrl(mouse) = sum(Stop(Sleep) - Start(Sleep))./(sum(Stop(Sleep) - Start(Sleep)) + sum(Stop(Wake) - Start(Wake)));
                REMonSleep_Ctrl(mouse) = sum(Stop(REMEpoch) - Start(REMEpoch))./(sum(Stop(Sleep) - Start(Sleep)));
%                 if  REMonSleep_Ctrl(mouse) <0.09
%                     keyboard
%                 end
                TotDurk_Ctrl(mouse) = sum(Stop(Sleep) - Start(Sleep)) + (sum(Stop(Wake) - Start(Wake)));
                MouseNum_Ctrl(mouse) = Dir.ExpeInfo{d}{dd}.nmouse;
                mouse=mouse+1;
            end
        end
    end
end
UniqueCTRLMice = unique(MouseNum_Ctrl);
SleepOnWake_Ctrl_temp = SleepOnWake_Ctrl;
REMonSleep_Ctrl_temp = REMonSleep_Ctrl;
TotDurk_Ctrl_temp = TotDurk_Ctrl;

clear TotDurk_Ctrl REMonSleep_Ctrl TotDurk_Ctrl
for ii = 1:length(UniqueCTRLMice)
    if length(find(MouseNum_Ctrl==UniqueCTRLMice(ii)))>1
        TotDurk_Ctrl(ii) = nanmean(TotDurk_Ctrl_temp(find(MouseNum_Ctrl==UniqueCTRLMice(ii))));
        REMonSleep_Ctrl(ii) = nanmean(REMonSleep_Ctrl_temp(find(MouseNum_Ctrl==UniqueCTRLMice(ii))));
        SleepOnWake_Ctrl(ii) = nanmean(SleepOnWake_Ctrl_temp(find(MouseNum_Ctrl==UniqueCTRLMice(ii))));
    else
        TotDurk_Ctrl(ii) = NaN;
        REMonSleep_Ctrl(ii) = NaN;
        SleepOnWake_Ctrl(ii) = NaN;
        
    end
end


Cols = {[0.4 0.4 0.4],[1 0.4 0.4],[0.8 0.6 0.6]};
figure
A = {REMonSleep_Ctrl(1:20),REMonSleep(LongSession(1:2)),REMonSleep(LongSession(3:end))};
Legends = {'CtrlDataSet','Small BBX','Big BBX'};
MakeSpreadAndBoxPlot_SB(A,Cols,1:3,Legends,1,0)
ylabel('Prop. REM in sleep')
ylim([0 0.18])


subplot(132)
A = {SleepOnWake_Ctrl,SleepOnWake(LongSession(1:2)),SleepOnWake(LongSession(3:end))};
MakeSpreadAndBoxPlot_SB(A,Cols)
set(gca,'XTick',[1:3],'XTickLabel',{'CtrlDataSet','Small BBX','Big BBX'})
ylabel('Prop. Sleep on total')

subplot(133)
A = {TotDurk_Ctrl/(3600*1e4),TotDur(LongSession(1:2))/(3600*1e4),TotDur(LongSession(3:end))/(3600*1e4)};
MakeSpreadAndBoxPlot_SB(A,Cols)
set(gca,'XTick',[1:3],'XTickLabel',{'CtrlDataSet','Small BBX','Big BBX'})
ylabel('Hours recorded')

figure
subplot(131)
plot(TotDurk_Ctrl/(3600*1e4),REMonSleep_Ctrl,'k.','MarkerSize',20)
hold on
plot(TotDur(LongSession(1:2))/(3600*1e4),REMonSleep(LongSession(1:2)),'r.','MarkerSize',20)
plot(TotDur(LongSession(3:end))/(3600*1e4),REMonSleep(LongSession(3:end)),'m.','MarkerSize',20)
xlabel('Hours recorded')
ylabel('Prop. REM in sleep')
legend('CtrlDataSet','Small BBX','Big BBX')
box off

subplot(132)
plot(SleepOnWake_Ctrl,REMonSleep_Ctrl,'k.','MarkerSize',20)
hold on
plot(SleepOnWake(LongSession(1:2)),REMonSleep(LongSession(1:2)),'r.','MarkerSize',20)
plot(SleepOnWake(LongSession(3:end)),REMonSleep(LongSession(3:end)),'m.','MarkerSize',20)
xlabel('Prop. Sleep on total')
ylabel('Prop. REM in sleep')
box off

subplot(133)
plot(TotDurk_Ctrl/(3600*1e4),SleepOnWake_Ctrl,'k.','MarkerSize',20)
hold on
plot(TotDur(LongSession(1:2))/(3600*1e4),SleepOnWake(LongSession(1:2)),'r.','MarkerSize',20)
plot(TotDur(LongSession(3:end))/(3600*1e4),SleepOnWake(LongSession(3:end)),'m.','MarkerSize',20)
xlabel('Hours recorded')
ylabel('Prop. Sleep on total')
box off

