clear all
Cols = {'k','r','k','r'};
enregistrements{1} = { ...
    '/media/nas7/ProjetPFCVLPO/M1423/20230320/BaselineSleep/CTRL_PFC_VLPO_1423_baselinesleep_230320_083012/';
    '/media/nas7/ProjetPFCVLPO/M1424/20230320/BaselineSleep/CTRL_PFC_VLPO_1424_baselinesleep_230320_083012/';
    '/media/nas7/ProjetPFCVLPO/M1425/20230320/BaselineSleep/CTRL_PFC_VLPO_1425_baselinesleep_230320_083012/';
    '/media/nas7/ProjetPFCVLPO/M1426/20230320/BaselineSleep/CTRL_PFC_VLPO_1426_baselinesleep_230320_083012/';
    '/media/nas7/ProjetPFCVLPO/M1433/20230419/BaselineSleep/CTRL_PFC_VLPO_1433_BaselineSleep_230419_091255/';
    % '/media/nas7/ProjetPFCVLPO/M1434/20230419/BaselineSleep/CTRL_PFC_VLPO_1434_BaselineSleep_230419_091255/';
    '/media/nas7/ProjetPFCVLPO/M1449/20230517/Sleep_SalineInjection_10h/CTRL_1449_saline_10h_230517_100502/';
    '/media/nas7/ProjetPFCVLPO/M1450/20230517/Sleep_SalineInjection_10h/CTRL_1450_saline_10h_230517_100502/';
    '/media/nas7/ProjetPFCVLPO/M1451/20230517/Sleep_SalineInjection_10h/CTRL_1451_saline_10h_230517_100502/';
    '/media/nas7/ProjetPFCVLPO/M1414/20230615/Sleep_SalineInjection_10h/BM_1414_Sleep_saline_10h_230615_100317/';
    '/media/nas7/ProjetPFCVLPO/M1439/20230601/Sleep_SalineInjection_10h/BM_1439_saline_10h_230601_095914/';
    '/media/nas7/ProjetPFCVLPO/M1440/20230601/Sleep_SalineInjection_10h/BM_1440_saline_10h_230601_095914/';
    '/media/nas7/ProjetPFCVLPO/M1437/20230615/Sleep_SalineInjection_10h/BM_1437_Sleep_saline_10h_230615_100317/';
    };


%Social defeat Saline mCherry
enregistrements{2} = { ...
'/media/nas6/ProjetPFCVLPO/M1148/20210520/SocialDefeat/SleepPostSD/DREADD_1148_SleepPostSD_210520_103704/'
'/media/nas6/ProjetPFCVLPO/M1149/20210520/SocialDefeat/SleepPostSD/DREADD_1149_SleepPostSD_210520_103704/'
'/media/nas6/ProjetPFCVLPO/M1150/20210520/SocialDefeat/SleepPostSD/DREADD_1150_SleepPostSD_210520_103704/'
'/media/nas6/ProjetPFCVLPO/M1217/20210804/SocialDefeat/SleepPostSD/DREADD_1217_SleepPostSD_210804_100450/'
'/media/nas6/ProjetPFCVLPO/M1218/20210804/SocialDefeat/SleepPostSD/DREADD_1218_SleepPostSD_210804_100450/'
'/media/nas6/ProjetPFCVLPO/M1219/20210818/SocialDefeat/SleepPostSD/DREADD_1219_SleepPostSD_210818_102638/'
'/media/nas7/ProjetPFCVLPO/M1449/20230525/SocialDefeat_SalineInjection/SleepPostSD_SalineInjection/CTRL_1449_sleepPostSD_230525_100459/'
'/media/nas7/ProjetPFCVLPO/M1450/20230525/SocialDefeat_SalineInjection/SleepPostSD_SalineInjection/CTRL_1450_sleepPostSD_230525_100459/'
'/media/nas7/ProjetPFCVLPO/M1416/20230616/SocialDefeat_SalineInjection/SleepPostSD_SalineInjecton/BM_1416_SleepPostSD_saline_230616_100541/'
'/media/nas7/ProjetPFCVLPO/M1437/20230616/SocialDefeat_SalineInjection/SleepPostSD_SalineInjecton/BM_1437_SleepPostSD_saline_230616_100541/'
'/media/nas7/ProjetPFCVLPO/M1415/20230707/SocialDefeat_SalineInjection/SleepPostSD_SlaineInjection/BM_1415_sleepPstSD_230707_100431/'
 };

%Social defeat CNO mCherry
enregistrements{3} = { ...
'/media/nas7/ProjetPFCVLPO/M1423/20230404/SocialDefeat/SleepPostSD_CNO/CTRL_PFC_VLPO_1423_Sleep_PostSD_230404_100429/'
'/media/nas7/ProjetPFCVLPO/M1424/20230404/SocialDefeat/SleepPostSD_CNO/CTRL_PFC_VLPO_1424_Sleep_PostSD_230404_100429/'
'/media/nas7/ProjetPFCVLPO/M1426/20230405/SocialDefeat/SleepPostSD_CNO/CTRL_PFC_VLPO_1426_sleepPostSD_230405_100108/'
'/media/nas7/ProjetPFCVLPO/M1433/20230513/SocialDefeat_CNOInjection/SleepPostSD_CNOInjection/CTRL_1433_sleepPostSD_230513_100916/'
'/media/nas7/ProjetPFCVLPO/M1434/20230513/SocialDefeat_CNOInjection/SleepPostSD_CNOInjection/CTRL_1434_sleepPostSD_230513_100916/'
'/media/nas7/ProjetPFCVLPO/M1435/20230513/SocialDefeat_CNOInjection/SleepPostSD_CNOInjection/CTRL_1435_sleepPostSD_230513_100916/'
'/media/nas7/ProjetPFCVLPO/M1439/20230602/SocialDefeat_CNOInjection/SleepPostSD_CNOInjection/BM_1439_sleepPostSD_230602_100213/'
'/media/nas7/ProjetPFCVLPO/M1440/20230602/SocialDefeat_CNOInjection/SleepPostSD_CNOInjection/BM_1440_sleepPostSD_230602_100213/'
'/media/nas7/ProjetPFCVLPO/M1417/20230609/SocialDefeat_CNOInjection/SleepPostSD_CNOInjection/BM_1417_sleepPostSD_230609_100843/'
'/media/nas7/ProjetPFCVLPO/M1418/20230609/SocialDefeat_CNOInjection/SleepPostSD_CNOInjection/BM_1418_sleepPostSD_230609_100843/'
'/media/nas7/ProjetPFCVLPO/M1448/20230609/SocialDefeat_CNOInjection/SleepPostSD_CNOInjection/BM_1448_sleepPostSD_230609_100843/'
 };

%Social defeat CNO DREADD- :
enregistrements{4} = { ...
'/media/nas6/ProjetPFCVLPO/M1247/20211216/SocialDefeat/SleepPostSD_CNO/DREADD_PFC_VLPO_1247_SleepPostSD_211216_100241/'
'/media/nas6/ProjetPFCVLPO/M1248/20211216/SocialDefeat/SleepPostSD_CNO/DREADD_PFC_VLPO_1248_SleepPostSD_211216_100241/'
'/media/nas7/ProjetPFCVLPO/M1300/20220610/SleepPostSD_CNOInjection/DREADD_PFC_VLPO_1300_sleepPostSD_220610_100538/'
'/media/nas7/ProjetPFCVLPO/M1301/20220617/SleepPostSD_CNOInjection/DREADD_PFC_VLPO_1301_sleepPostSD_220617_101046/'
'/media/nas7/ProjetPFCVLPO/M1302/20220610/SleepPostSD_CNOInjection/DREADD_PFC_VLPO_1302_sleepPostSD_220610_100538/'
'/media/nas7/ProjetPFCVLPO/M1303/20220617/SleepPostSD_CNOInjection/DREADD_PFC_VLPO_1303_sleepPostSD_220617_101046/'
 };


for grp = 1:4
    subplot(4,1,grp)
    for mm = 1:length(enregistrements{grp})
        cd(enregistrements{grp}{mm})
        mm
        % load SeepScoring
        load('SleepScoring_Accelero.mat','REMEpoch','Wake','SWSEpoch','tsdMovement')
        Hypnogram_LineColor_SB(Wake,SWSEpoch,REMEpoch,Range(tsdMovement,'h'),mm)
        ylim([0 12])
        xlim([4 6]*3600)
        timemx(grp,mm) = max(Range(tsdMovement,'s'));
        Epoch = intervalSet(0*3600*1e4,7*3600*1e4);
        Wake = and(Wake,Epoch);
        REMEpoch = and(REMEpoch,Epoch);
        SWSEpoch = and(SWSEpoch,Epoch);
        maxtime{grp}(mm) = max(Range(Restrict(tsdMovement,Epoch),'min'));
        StpREM = Stop(REMEpoch,'s');
        StrtREM = Start(REMEpoch,'s');

        % Basic REM characteristics
        TotRem{grp}(mm) = sum(StpREM- StrtREM);
        MnRemDur{grp}(mm) = nanmean(StpREM- StrtREM);
        NumRemEp{grp}(mm) = length(StpREM- StrtREM);
        
        RemDur{grp}{mm} = StpREM - StrtREM;
        RemDur{grp}{mm}(end) = [];
        RemInterval{grp}{mm} = StrtREM(2:end) - StpREM(1:end-1);
        for rr = 1:length(StrtREM)-1
            MiniEpoch = intervalSet(StpREM(rr)*1e4,StrtREM(rr+1)*1e4);
            MiniEpoch_NREM = and(MiniEpoch,SWSEpoch);
            RemInterval_SWS{grp}{mm}(rr) = sum(Stop(MiniEpoch_NREM) - Start(MiniEpoch_NREM))/1e4;
            MiniEpoch_Wake = and(MiniEpoch,Wake);
            RemInterval_Wake{grp}{mm}(rr) = sum(Stop(MiniEpoch_Wake) - Start(MiniEpoch_Wake))/1e4;
        end
        
                
        % Get REM followed by wake and sleep
        [aft_cell,bef_cell]=transEpoch(REMEpoch,Wake);
        WakeAfterREMDur{grp}{mm} = Stop(bef_cell{2,1}) - Start(bef_cell{2,1});
        REMBeforeWakeDur{grp}{mm} = Stop(aft_cell{1,2}) - Start(aft_cell{1,2});
        
        [aft_cell,bef_cell]=transEpoch(REMEpoch,SWSEpoch);
        SWSAfterREMDur{grp}{mm} = Stop(bef_cell{2,1}) - Start(bef_cell{2,1});
        REMBeforeSWSDur{grp}{mm} = Stop(aft_cell{1,2}) - Start(aft_cell{1,2});
    end
        
    
end
%% Basic sleep features
GroupNames = {'Ctrl','SDS','mCherry CNO','DREADD'};
figure
subplot(131)
MakeSpreadAndBoxPlot2_SB(TotRem,{},[1:4],GroupNames,'paired',0)
subplot(132)
MakeSpreadAndBoxPlot2_SB(MnRemDur,{},[1:4],GroupNames,'paired',0)
subplot(133)
MakeSpreadAndBoxPlot2_SB(NumRemEp,{},[1:4],GroupNames,'paired',0)

%% By mouse

for grp = 1:4
    AllSWSInter{grp} = [];
    AllREMDur{grp} = [];
    AllWakeInter{grp} = [];
    AllREMInterval{grp} = [];
    for mm = 1:length(enregistrements{grp})
        AllREMDur{grp} = [AllREMDur{grp};nanmean(RemDur{grp}{mm}')];
        AllSWSInter{grp} = [AllSWSInter{grp};nanmean(RemInterval_SWS{grp}{mm})'];
        AllWakeInter{grp} = [AllWakeInter{grp};nanmean(RemInterval_Wake{grp}{mm})'];
        AllREMInterval{grp} = [AllREMInterval{grp};nanmean(RemInterval{grp}{mm})'];
        
    end
end

figure
subplot(141)
MakeSpreadAndBoxPlot2_SB(AllSWSInter,{},[1:4],GroupNames,'paired',0)
ylabel('SWS duration between REM')
subplot(142)
MakeSpreadAndBoxPlot2_SB(AllWakeInter,{},[1:4],GroupNames,'paired',0)
ylabel('Wake duration between REM')
subplot(143)
MakeSpreadAndBoxPlot2_SB(AllREMInterval,{},[1:4],GroupNames,'paired',0)
ylabel('Interval between REM')
subplot(144)
MakeSpreadAndBoxPlot2_SB(AllREMDur,{},[1:4],GroupNames,'paired',0)
ylabel('Mean REM ep dur')

%% All events

for grp = 1:4
    AllSWSInter{grp} = [];
    AllREMDur{grp} = [];
    AllWakeInter{grp} = [];
    AllREMInterval{grp} = [];
    for mm = 1:length(enregistrements{grp})
        AllREMDur{grp} = [AllREMDur{grp};(RemDur{grp}{mm})];
        AllSWSInter{grp} = [AllSWSInter{grp};(RemInterval_SWS{grp}{mm})'];
        AllWakeInter{grp} = [AllWakeInter{grp};(RemInterval_Wake{grp}{mm})'];
        AllREMInterval{grp} = [AllREMInterval{grp};(RemInterval{grp}{mm})];
    end
end

figure
clear A
for grp = 1:4
    A{grp} = log(AllREMInterval{grp});
end
nhist(A)
legend(GroupNames)

%% Look at sequential vs single
for grp = 1:4
    figure
    for mm = 1:length(enregistrements{grp})
        subplot(2,2,1)
        plot(RemDur{grp}{mm},(RemInterval_Wake{grp}{mm}),'.','color',Cols{grp})
        hold on
        [R,P] = corr(RemDur{grp}{mm},(RemInterval_Wake{grp}{mm})');
        title(['R=' num2str(R) ' P=' num2str(P)])
        xlabel('REM duration')
        ylabel('InterREM Wake duration')
        subplot(2,2,2)
        plot(RemDur{grp}{mm},log(RemInterval_Wake{grp}{mm}+1),'.','color',Cols{grp})
        hold on
        [R,P] = corr(RemDur{grp}{mm},log(RemInterval_Wake{grp}{mm})');
        title(['R=' num2str(R) ' P=' num2str(P)])
        xlabel('REM duration')
        ylabel('InterREM Wake duration - log')
        subplot(2,2,3)
        
        plot(RemDur{grp}{mm},RemInterval_SWS{grp}{mm},'.','color',Cols{grp})
        [R,P] = corr(RemDur{grp}{mm},(RemInterval_SWS{grp}{mm})');
        title(['R=' num2str(R) ' P=' num2str(P)])
        hold on
        xlabel('REM duration')
        ylabel('InterREM SWS duration')
        subplot(2,2,4)
        plot(RemDur{grp}{mm},log(RemInterval_SWS{grp}{mm}),'.','color',Cols{grp})
        [R,P] = corr(RemDur{grp}{mm},log(RemInterval_SWS{grp}{mm})');
        title(['R=' num2str(R) ' P=' num2str(P)])
        hold on
        xlabel('REM duration')
        ylabel('InterREM SWS duration - log')
    end
end

% Look at time spent in sequential NREM vs sigle NREM
Lim = [1,1,1,1]*4.2;
clear A
for grp = 1:4
    for mm = 1:length(RemInterval_SWS{grp})
        A{grp}(mm) = sum(RemInterval_SWS{grp}{mm}(log(RemInterval_SWS{grp}{mm})<Lim(grp)))/sum(RemInterval_SWS{grp}{mm});
    end
end
figure
MakeSpreadAndBoxPlot2_SB(A,{},[1:5],GroupNames,'paired',0)
ylabel('Prop sequential NREM')

for grp = 1:2
    AllSWSInter{grp} = [];
    AllREMDur{grp} = [];
    AllWakeInter{grp} = [];
    for mm = 1:length(enregistrements{grp})
        AllREMDur{grp} = [AllREMDur{grp},RemDur{grp}{mm}'];
        AllSWSInter{grp} =  [AllSWSInter{grp};log(RemInterval_SWS{grp}{mm})'];
        AllWakeInter{grp} = [AllWakeInter{grp};log(RemInterval_Wake{grp}{mm})'];
        
    end
end


figure
clear A
subplot(121)
for grp = 1:4
    A{grp} = AllSWSInter{grp}(AllREMDur{grp}>20);
end
nhist(A)

subplot(122)
for grp = 1:2
    A{grp} = AllSWSInter{grp}(AllREMDur{grp}<20);
end
nhist(A)






figure
clear A
A{1} = cellfun(@length,RemDur{1});
A{2} = cellfun(@length,RemDur{2});
MakeSpreadAndBoxPlot2_SB(A,{},[1:2],GroupNames,'paired',0,'showsigstar','all')
ylabel('number of REM episodes')

figure
clear A
A{1} = cellfun(@length,RemDur{1})./maxtime{1};
A{2} = cellfun(@length,RemDur{2})./maxtime{2};
MakeSpreadAndBoxPlot2_SB(A,{},[1:2],GroupNames,'paired',0,'showsigstar','all')
ylabel('REM episodes per minute')


figure
MakeSpreadAndBoxPlot2_SB(maxtime,{},[1:2],GroupNames,'paired',0)
