

clear all
Mouse = [1230 1239 1240 1249 11230 11239 11240 11249];
Session_type={'TestPre','Cond','TestPost'};
for mouse = 1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions_MFB(Mouse(mouse));
    TestPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre')))));
    CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
    TestPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost')))));
    SleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
end


for mouse = 1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for f=1:8
        cd(TestPreSess.(Mouse_names{mouse}){f})
        load('behavResources.mat')
        for zones = 1:9
            TestPreExplo.(Mouse_names{mouse})(f,zones) = sum(Stop(ZoneEpoch{zones})-Start(ZoneEpoch{zones}))/1e4;
            TestPreProportion.(Mouse_names{mouse})(f,zones) = sum(Stop(ZoneEpoch{zones})-Start(ZoneEpoch{zones}))/120e4;
            try
                LatencyTestPre.(Mouse_names{mouse})(f,zones) = min(Start(ZoneEpoch{zones}))/1e4;
            catch
                LatencyTestPre.(Mouse_names{mouse})(f,zones) = 120;
            end
            TestPreMeanTime.(Mouse_names{mouse})(f,zones) = nanmean(Stop(ZoneEpoch{zones})-Start(ZoneEpoch{zones}))/1e4;
            [aft_cell,bef_cell] = transEpoch(ZoneEpoch{1} , ZoneEpoch{8});
            TestPreZonesEnter.(Mouse_names{mouse})(f,1) = length(Start(bef_cell{1,2}));
            [aft_cell,bef_cell] = transEpoch(ZoneEpoch{2} , ZoneEpoch{9});
            TestPreZonesEnter.(Mouse_names{mouse})(f,2) = length(Start(bef_cell{1,2}));
            TestPreSpeed.(Mouse_names{mouse})(f,zones) = nanmean(Data(Restrict(Vtsd , ZoneEpoch{zones})));
        end
        
        cd(CondSess.(Mouse_names{mouse}){f})
        load('behavResources.mat')
        for zones = 1:9
            CondExplo.(Mouse_names{mouse})(f,zones) = sum(Stop(ZoneEpoch{zones})-Start(ZoneEpoch{zones}))/1e4;
            CondProportion.(Mouse_names{mouse})(f,zones) = sum(Stop(ZoneEpoch{zones})-Start(ZoneEpoch{zones}))/240e4;
            try
                LatencyCond.(Mouse_names{mouse})(f,zones) = min(Start(ZoneEpoch{zones}))/1e4;
            catch
                LatencyCond.(Mouse_names{mouse})(f,zones) = 240;
            end
            CondMeanTime.(Mouse_names{mouse})(f,zones) = nanmean(Stop(ZoneEpoch{zones})-Start(ZoneEpoch{zones}))/1e4;
            [aft_cell,bef_cell] = transEpoch(ZoneEpoch{1} , ZoneEpoch{8});
            CondZonesEnter.(Mouse_names{mouse})(f,1) = length(Start(bef_cell{1,2}));
            [aft_cell,bef_cell] = transEpoch(ZoneEpoch{2} , ZoneEpoch{9});
            CondZonesEnter.(Mouse_names{mouse})(f,2) = length(Start(bef_cell{1,2}));
            CondSpeed.(Mouse_names{mouse})(f,zones) = nanmean(Data(Restrict(Vtsd , ZoneEpoch{zones})));
        end
        
        cd(TestPostSess.(Mouse_names{mouse}){f})
        load('behavResources.mat')
        for zones = 1:9
            TestPostExplo.(Mouse_names{mouse})(f,zones) = sum(Stop(ZoneEpoch{zones})-Start(ZoneEpoch{zones}))/1e4;
            TestPostProportion.(Mouse_names{mouse})(f,zones) = sum(Stop(ZoneEpoch{zones})-Start(ZoneEpoch{zones}))/120e4;
            try
                LatencyTestPost.(Mouse_names{mouse})(f,zones) = min(Start(ZoneEpoch{zones}))/1e4;
            catch
                LatencyTestPost.(Mouse_names{mouse})(f,zones) = 120;
            end
            TestPostMeanTime.(Mouse_names{mouse})(f,zones) = nanmean(Stop(ZoneEpoch{zones})-Start(ZoneEpoch{zones}))/1e4;
            [aft_cell,bef_cell] = transEpoch(ZoneEpoch{1} , ZoneEpoch{8});
            TestPostZonesEnter.(Mouse_names{mouse})(f,1) = length(Start(bef_cell{1,2}));
            [aft_cell,bef_cell] = transEpoch(ZoneEpoch{2} , ZoneEpoch{9});
            TestPostZonesEnter.(Mouse_names{mouse})(f,2) = length(Start(bef_cell{1,2}));
            TestPostSpeed.(Mouse_names{mouse})(f,zones) = nanmean(Data(Restrict(Vtsd , ZoneEpoch{zones})));
        end
    end
end


for mouse = 1:length(Mouse)
    AllTestPreTime(mouse,:) = nanmean(TestPreExplo.(Mouse_names{mouse}));
    AllCondTime(mouse,:) = nanmean(CondExplo.(Mouse_names{mouse}));
    AllTestPostTime(mouse,:) = nanmean(TestPostExplo.(Mouse_names{mouse}));
    
    AllTestPreProportion(mouse,:) = nanmean(TestPreProportion.(Mouse_names{mouse}));
    AllCondProportion(mouse,:) = nanmean(CondProportion.(Mouse_names{mouse}));
    AllTestPostProportion(mouse,:) = nanmean(TestPostProportion.(Mouse_names{mouse}));
    
    AllTestPreProportion_2(mouse,:) = nanmean(TestPreProportion.(Mouse_names{mouse})(1:4,:));
    AllCondProportion_2(mouse,:) = nanmean(CondProportion.(Mouse_names{mouse})(1:4,:));
    AllTestPostProportion_2(mouse,:) = nanmean(TestPostProportion.(Mouse_names{mouse})(1:4,:));
      
    AllLatencyTestPre(mouse,:) = nanmean(LatencyTestPre.(Mouse_names{mouse}));
    AllLatencyCond(mouse,:) = nanmean(LatencyCond.(Mouse_names{mouse}));
    AllLatencyTestPost(mouse,:) = nanmean(LatencyTestPost.(Mouse_names{mouse}));
    
    AllCondEvolutionExplo(:,mouse) = CondProportion.(Mouse_names{mouse})(:,1);
    AllCondEvolutionLatency(:,mouse) = LatencyCond.(Mouse_names{mouse})(:,1);
    
    AllTestPreEvolutionExploStim(:,mouse) = TestPreProportion.(Mouse_names{mouse})(:,1);
    AllTestPreEvolutionLatency(:,mouse) = LatencyTestPre.(Mouse_names{mouse})(:,1);
    AllTestPostEvolutionExploStim(:,mouse) = TestPostProportion.(Mouse_names{mouse})(:,1);
    AllTestPostEvolutionLatency(:,mouse) = LatencyTestPost.(Mouse_names{mouse})(:,1);
    
    AllTestPreZonesEnter(mouse,:) = nanmean(TestPreZonesEnter.(Mouse_names{mouse}));
    AllCondZonesEnter(mouse,:) = nanmean(CondZonesEnter.(Mouse_names{mouse}));
    AllTestPostZonesEnter(mouse,:) = nanmean(TestPostZonesEnter.(Mouse_names{mouse}));
    
    AllTestPreMeanTime(mouse,:) = nanmean(TestPreMeanTime.(Mouse_names{mouse}));
    AllCondMeanTime(mouse,:) = nanmean(CondMeanTime.(Mouse_names{mouse}));
    AllTestPostMeanTime(mouse,:) = nanmean(TestPostMeanTime.(Mouse_names{mouse}));

    AllTestPreSpeed(mouse,:) = nanmean(TestPreSpeed.(Mouse_names{mouse}));
    AllCondSpeed(mouse,:) = nanmean(CondSpeed.(Mouse_names{mouse}));
    AllTestPostSpeed(mouse,:) = nanmean(TestPostSpeed.(Mouse_names{mouse}));
end

Cols = {[0 1 0],[.9 .9 .9]};
X = [1:2];
Legends = {'Stim','NoStim'};

% Proportion
figure
subplot(231)
MakeSpreadAndBoxPlot2_SB([AllTestPreProportion(1:4,1) AllTestPreProportion(1:4,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1]); title('TestPre')
subplot(232)
MakeSpreadAndBoxPlot2_SB([AllCondProportion(1:4,1) AllCondProportion(1:4,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1]); title('Cond')
subplot(233)
MakeSpreadAndBoxPlot2_SB([AllTestPostProportion(1:4,1) AllTestPostProportion(1:4,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1]); title('TestPost')

subplot(234)
MakeSpreadAndBoxPlot2_SB([AllTestPreProportion(5:8,1) AllTestPreProportion(5:8,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1]);
subplot(235)
MakeSpreadAndBoxPlot2_SB([AllCondProportion(5:8,1) AllCondProportion(5:8,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1]);
subplot(236)
MakeSpreadAndBoxPlot2_SB([AllTestPostProportion(5:8,1) AllTestPostProportion(5:8,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1]);

% Proportion only on the bigger stim zone
figure
subplot(231)
MakeSpreadAndBoxPlot2_SB([sum(AllTestPreProportion(1:4,[1 8])') ; sum(AllTestPreProportion(1:4,[2 9])')]',Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1]); title('TestPre')
subplot(232)
MakeSpreadAndBoxPlot2_SB([sum(AllCondProportion(1:4,[1 8])') ; sum(AllCondProportion(1:4,[2 9])')]',Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1]); title('Cond')
subplot(233)
MakeSpreadAndBoxPlot2_SB([sum(AllTestPostProportion(1:4,[1 8])') ; sum(AllTestPostProportion(1:4,[2 9])')]',Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1]); title('TestPost')

subplot(234)
MakeSpreadAndBoxPlot2_SB([sum(AllTestPreProportion(5:8,[1 8])') ; sum(AllTestPreProportion(5:8,[2 9])')]',Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1]);
subplot(235)
MakeSpreadAndBoxPlot2_SB([sum(AllCondProportion(5:8,[1 8])') ; sum(AllCondProportion(5:8,[2 9])')]',Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1]);
subplot(236)
MakeSpreadAndBoxPlot2_SB([sum(AllTestPostProportion(5:8,[1 8])') ; sum(AllTestPostProportion(5:8,[2 9])')]',Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1]);

% Proportion only on the 4 first trials
figure
subplot(231)
MakeSpreadAndBoxPlot2_SB([AllTestPreProportion_2(1:4,1) AllTestPreProportion_2(1:4,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1]); ylabel('Proportion'); title('TestPre')
subplot(232)
MakeSpreadAndBoxPlot2_SB([AllCondProportion_2(1:4,1) AllCondProportion_2(1:4,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1]); title('Cond')
subplot(233)
MakeSpreadAndBoxPlot2_SB([AllTestPostProportion_2(1:4,1) AllTestPostProportion_2(1:4,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1]); title('TestPost')

subplot(234)
MakeSpreadAndBoxPlot2_SB([AllTestPreProportion_2(5:8,1) AllTestPreProportion_2(5:8,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1]); ylabel('Proportion')
subplot(235)
MakeSpreadAndBoxPlot2_SB([AllCondProportion_2(5:8,1) AllCondProportion_2(5:8,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1]);
subplot(236)
MakeSpreadAndBoxPlot2_SB([AllTestPostProportion_2(5:8,1) AllTestPostProportion_2(5:8,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1]);

a=suptitle('Explo, MFB, Maze, DZP, n=4'); a.FontSize=20;

% Latency
figure
subplot(231)
MakeSpreadAndBoxPlot2_SB([AllLatencyTestPre(1:4,1) AllLatencyTestPre(1:4,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 155]); ylabel('latency (s)'); title('TestPre')
subplot(232)
MakeSpreadAndBoxPlot2_SB([AllLatencyCond(1:4,1) AllLatencyCond(1:4,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 155]); title('Cond')
subplot(233)
MakeSpreadAndBoxPlot2_SB([AllLatencyTestPost(1:4,1) AllLatencyTestPost(1:4,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 155]); title('TestPost')

subplot(234)
MakeSpreadAndBoxPlot2_SB([AllLatencyTestPre(5:8,1) AllLatencyTestPre(5:8,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 155]); ylabel('latency (s)')
subplot(235)
MakeSpreadAndBoxPlot2_SB([AllLatencyCond(5:8,1) AllLatencyCond(5:8,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 155]);
subplot(236)
MakeSpreadAndBoxPlot2_SB([AllLatencyTestPost(5:8,1) AllLatencyTestPost(5:8,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 155]);

a=suptitle('Explo, MFB, Maze, DZP, n=4'); a.FontSize=20;

% mean speed
figure
subplot(231)
MakeSpreadAndBoxPlot2_SB([mean(AllTestPreSpeed(1:4,[1 8])')' mean(AllTestPreSpeed(1:4,[2 9])')'],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 15]); ylabel('speed (cm/s)'); title('TestPre')
subplot(232)
MakeSpreadAndBoxPlot2_SB([mean(AllCondSpeed(1:4,[1 8])')' mean(AllCondSpeed(1:4,[2 9])')'],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 15]); title('Cond')
subplot(233)
MakeSpreadAndBoxPlot2_SB([mean(AllTestPostSpeed(1:4,[1 8])')' mean(AllTestPostSpeed(1:4,[2 9])')'],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 15]); title('TestPost')

subplot(234)
MakeSpreadAndBoxPlot2_SB([mean(AllTestPreSpeed(5:8,[1 8])')' mean(AllTestPreSpeed(5:8,[2 9])')'],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 15]); ylabel('speed (cm/s)')
subplot(235)
MakeSpreadAndBoxPlot2_SB([mean(AllCondSpeed(5:8,[1 8])')' mean(AllCondSpeed(5:8,[2 9])')'],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 15]);
subplot(236)
MakeSpreadAndBoxPlot2_SB([mean(AllTestPostSpeed(5:8,[1 8])')' mean(AllTestPostSpeed(5:8,[2 9])')'],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 15]);

a=suptitle('Speed, MFB, Maze, DZP, n=4'); a.FontSize=20;



%% Learning during conditionning
% evolution along Cond for proportion & latencies
figure
subplot(121)
Conf_Inter=nanstd(AllCondEvolutionExplo(:,1:4)')/sqrt(size(AllCondEvolutionExplo(:,1:4),2));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllCondEvolutionExplo(:,1:4)');
shadedErrorBar([1:8] , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
Conf_Inter=nanstd(AllCondEvolutionExplo(:,5:8)')/sqrt(size(AllCondEvolutionExplo(:,5:8),2));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllCondEvolutionExplo(:,5:8)');
shadedErrorBar([1:8] , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
makepretty; ylabel('Proportion'); xlabel('sessions number')
f=get(gca,'Children'); legend([f(5),f(1)],'Saline','DZP');

subplot(122)
Conf_Inter=nanstd(AllCondEvolutionLatency(:,1:4)')/sqrt(size(AllCondEvolutionLatency(:,1:4),2));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllCondEvolutionLatency(:,1:4)');
shadedErrorBar([1:8] , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
Conf_Inter=nanstd(AllCondEvolutionLatency(:,5:8)')/sqrt(size(AllCondEvolutionLatency(:,5:8),2));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllCondEvolutionLatency(:,5:8)');
shadedErrorBar([1:8] , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
makepretty; ylabel('Latency (s'); xlabel('sessions number')

a=suptitle('Explo, MFB, Maze, DZP, n=4'); a.FontSize=20;

% mean time in zones
figure
subplot(231)
MakeSpreadAndBoxPlot2_SB([AllTestPreMeanTime(1:4,1) AllTestPreMeanTime(1:4,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 90]); ylabel('mean time (s)'); title('TestPre')
subplot(232)
MakeSpreadAndBoxPlot2_SB([AllCondMeanTime(1:4,1) AllCondMeanTime(1:4,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 90]); title('Cond')
subplot(233)
MakeSpreadAndBoxPlot2_SB([AllTestPostMeanTime(1:4,1) AllTestPostMeanTime(1:4,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 90]); title('TestPost')

subplot(234)
MakeSpreadAndBoxPlot2_SB([AllTestPreMeanTime(5:8,1) AllTestPreMeanTime(5:8,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 90]); ylabel('mean time (s)');
subplot(235)
MakeSpreadAndBoxPlot2_SB([AllCondMeanTime(5:8,1) AllCondMeanTime(5:8,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 90]);
subplot(236)
MakeSpreadAndBoxPlot2_SB([AllTestPostMeanTime(5:8,1) AllTestPostMeanTime(5:8,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 90]);

a=suptitle('Mean time in zones, MFB, Maze, DZP, n=4'); a.FontSize=20;


% entries/time spent
figure
subplot(231)
MakeSpreadAndBoxPlot2_SB([AllTestPreZonesEnter(1:4,1)./AllTestPreTime(1:4,1) AllTestPreZonesEnter(1:4,2)./AllTestPreTime(1:4,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 .8]); ylabel('entries / time in zone'); title('TestPre')
subplot(232)
MakeSpreadAndBoxPlot2_SB([AllCondZonesEnter(1:4,1)./AllCondTime(1:4,1) AllCondZonesEnter(1:4,2)./AllCondTime(1:4,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 .8]); title('Cond')
subplot(233)
MakeSpreadAndBoxPlot2_SB([AllTestPostZonesEnter(1:4,1)./AllTestPostTime(1:4,1) AllTestPostZonesEnter(1:4,2)./AllTestPostTime(1:4,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 .8]); title('TestPost')

subplot(234)
MakeSpreadAndBoxPlot2_SB([AllTestPreZonesEnter(5:8,1)./AllTestPreTime(5:8,1) AllTestPreZonesEnter(5:8,2)./AllTestPreTime(5:8,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 .8]); ylabel('entries / time in zone');
subplot(235)
MakeSpreadAndBoxPlot2_SB([AllCondZonesEnter(5:8,1)./AllCondTime(5:8,1) AllCondZonesEnter(5:8,2)./AllCondTime(5:8,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 .8]);
subplot(236)
MakeSpreadAndBoxPlot2_SB([AllTestPostZonesEnter(5:8,1)./AllTestPostTime(5:8,1) AllTestPostZonesEnter(5:8,2)./AllTestPostTime(5:8,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 .8]);

a=suptitle('Entries / time in zones, MFB, Maze, DZP, n=4'); a.FontSize=20;

% zone entries
figure
subplot(231)
MakeSpreadAndBoxPlot2_SB([AllTestPreZonesEnter(1:4,1) AllTestPreZonesEnter(1:4,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 33]); ylabel('entries in zone'); title('TestPre')
subplot(232)
MakeSpreadAndBoxPlot2_SB([AllCondZonesEnter(1:4,1) AllCondZonesEnter(1:4,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 33]); title('Cond')
subplot(233)
MakeSpreadAndBoxPlot2_SB([AllTestPostZonesEnter(1:4,1) AllTestPostZonesEnter(1:4,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 33]); title('TestPost')

subplot(234)
MakeSpreadAndBoxPlot2_SB([AllTestPreZonesEnter(5:8,1) AllTestPreZonesEnter(5:8,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 33]); ylabel('entries in zone');
subplot(235)
MakeSpreadAndBoxPlot2_SB([AllCondZonesEnter(5:8,1) AllCondZonesEnter(5:8,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 33]);
subplot(236)
MakeSpreadAndBoxPlot2_SB([AllTestPostZonesEnter(5:8,1) AllTestPostZonesEnter(5:8,2)],Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 33]);

a=suptitle('Entries in zones, MFB, Maze, DZP, n=4'); a.FontSize=20;

%% Test Post evolution
% evolution along Cond for proportion & latencies
figure
subplot(221)
Conf_Inter=nanstd(AllTestPreEvolutionExploStim(:,1:4)')/sqrt(size(AllTestPreEvolutionExploStim(:,1:4),2));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllTestPreEvolutionExploStim(:,1:4)');
shadedErrorBar([1:8] , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
Conf_Inter=nanstd(AllTestPreEvolutionExploStim(:,5:8)')/sqrt(size(AllTestPreEvolutionExploStim(:,5:8),2));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllTestPreEvolutionExploStim(:,5:8)');
shadedErrorBar([1:8] , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
makepretty; ylabel('Proportion'); ylim([0 .7])
f=get(gca,'Children'); legend([f(5),f(1)],'Saline','DZP');
hline(.22,'--r'); title('Test Pre')

subplot(223)
Conf_Inter=nanstd(AllTestPreEvolutionLatency(:,1:4)')/sqrt(size(AllTestPreEvolutionLatency(:,1:4),2));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllTestPreEvolutionLatency(:,1:4)');
shadedErrorBar([1:8] , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
Conf_Inter=nanstd(AllTestPreEvolutionLatency(:,5:8)')/sqrt(size(AllTestPreEvolutionLatency(:,5:8),2));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllTestPreEvolutionLatency(:,5:8)');
shadedErrorBar([1:8] , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
makepretty; ylabel('Latency (s)'); xlabel('sessions number')

subplot(222)
Conf_Inter=nanstd(AllTestPostEvolutionExploStim(:,1:4)')/sqrt(size(AllTestPostEvolutionExploStim(:,1:4),2));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllTestPostEvolutionExploStim(:,1:4)');
shadedErrorBar([1:8] , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
Conf_Inter=nanstd(AllTestPostEvolutionExploStim(:,5:8)')/sqrt(size(AllTestPostEvolutionExploStim(:,5:8),2));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllTestPostEvolutionExploStim(:,5:8)');
shadedErrorBar([1:8] , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
makepretty; hline(.22,'--r')
title('Test Post')

subplot(224)
Conf_Inter=nanstd(AllTestPostEvolutionLatency(:,1:4)')/sqrt(size(AllTestPostEvolutionLatency(:,1:4),2));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllTestPostEvolutionLatency(:,1:4)');
shadedErrorBar([1:8] , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
Conf_Inter=nanstd(AllTestPostEvolutionLatency(:,5:8)')/sqrt(size(AllTestPostEvolutionLatency(:,5:8),2));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllTestPostEvolutionLatency(:,5:8)');
shadedErrorBar([1:8] , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
makepretty; xlabel('sessions number')

a=suptitle('learning evolution, MFB, Maze, DZP, n=4'); a.FontSize=20;


%% Occupancy maps
Session_type={'TestPre','Cond','TestPost'};
sizeMap = 50;
sizeMap2 = 9;
Drug_Group={'Saline','DZP'};

for mouse=1:length(Mouse)
    for sess=1:length(Session_type)
        
        if sess==1; Sess_To_use=TestPreSess;
        elseif sess==2; Sess_To_use=CondSess;
        elseif sess==3 Sess_To_use=TestPostSess;
        end
        
        Speed_tsd.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(Sess_To_use.(Mouse_names{mouse}),'speed');
        Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(Sess_To_use.(Mouse_names{mouse}),'AlignedPosition');
        Position.(Mouse_names{mouse}).(Session_type{sess}) = Data(ConcatenateDataFromFolders_SB(Sess_To_use.(Mouse_names{mouse}),'AlignedPosition'));
        Position.(Mouse_names{mouse}).(Session_type{sess})(or(Position.(Mouse_names{mouse}).(Session_type{sess})<0 , Position.(Mouse_names{mouse}).(Session_type{sess})>1)) = NaN;
        
        if sess==2
            StimEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(Sess_To_use.(Mouse_names{mouse}),'epoch','epochname','stimepoch');
            BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(Sess_To_use.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
            StimEpochBlocked.(Mouse_names{mouse}).(Session_type{sess}) = and(StimEpoch.(Mouse_names{mouse}).(Session_type{sess}),BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            
            TotEpoch.(Mouse_names{mouse}).(Session_type{sess}) = intervalSet(0,max(Range(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}))));
            UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) = TotEpoch.(Mouse_names{mouse}).(Session_type{sess}) - BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess});
            
            Position_tsd_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Position_tsd_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Position_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Blocked.(Mouse_names{mouse}).(Session_type{sess}));
            Position_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Unblocked.(Mouse_names{mouse}).(Session_type{sess}));
            Speed_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Speed_tsd.(Mouse_names{mouse}).(Session_type{sess}) , UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Position_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(or(Position_Unblocked.(Mouse_names{mouse}).(Session_type{sess})<0 , Position_Unblocked.(Mouse_names{mouse}).(Session_type{sess})>1)) = NaN;
            
            clear Range_to_use Stim_times Stim_times_Blocked;
            Range_to_use = Range(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}));
            Stim_times = Start(StimEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Stim_times_Blocked = Start(StimEpochBlocked.(Mouse_names{mouse}).(Session_type{sess}));
            
            for stim=1:length(Stim_times)
                rank_to_useExplo.(Mouse_names{mouse}).(Session_type{sess})(stim) = sum(Range_to_use<Stim_times(stim));
            end
            try
                rank_to_useExplo.(Mouse_names{mouse}).(Session_type{sess})=rank_to_useExplo.(Mouse_names{mouse}).(Session_type{sess})(find(rank_to_useExplo.(Mouse_names{mouse}).(Session_type{sess})~=0));
            end
            for stim=1:length(Stim_times_Blocked)
                rank_to_use_blocked.(Mouse_names{mouse}).(Session_type{sess})(stim) = sum(Range_to_use<Stim_times_Blocked(stim));
            end
            try
                PositionStimExplo.(Mouse_names{mouse}).(Session_type{sess}) = Position.(Mouse_names{mouse}).(Session_type{sess})(rank_to_useExplo.(Mouse_names{mouse}).(Session_type{sess}),:);
                PositionStimBlocked.(Mouse_names{mouse}).(Session_type{sess}) = Position.(Mouse_names{mouse}).(Session_type{sess})(rank_to_use_blocked.(Mouse_names{mouse}).(Session_type{sess}),:);
            end
        end
        
    end
    disp(Mouse_names{mouse})
end


for mouse=1:length(Mouse_names)
    for sess=1:length(Session_type)
        try
            if sess==2
                [OccupMap.(Mouse_names{mouse}).(Session_type{sess}) , SpeedMap.(Mouse_names{mouse}).(Session_type{sess})] = hist3d_BM([Position_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1] , [Position_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1] , [Data(Speed_Unblocked.(Mouse_names{mouse}).(Session_type{sess}));0;1;0;1] , sizeMap , sizeMap);
            else
                [OccupMap.(Mouse_names{mouse}).(Session_type{sess}) , SpeedMap.(Mouse_names{mouse}).(Session_type{sess})] = hist3d_BM([Position.(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1] , [Position.(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1] , [Data(Speed_tsd.(Mouse_names{mouse}).(Session_type{sess}));0;1;0;1] , sizeMap , sizeMap);
            end
            OccupMap.(Mouse_names{mouse}).(Session_type{sess}) = OccupMap.(Mouse_names{mouse}).(Session_type{sess})/sum(OccupMap.(Mouse_names{mouse}).(Session_type{sess})(:));
            OccupMap.(Mouse_names{mouse}).(Session_type{sess}) = OccupMap.(Mouse_names{mouse}).(Session_type{sess})';
            
            OccupMap_binary.(Mouse_names{mouse}).(Session_type{sess}) = OccupMap.(Mouse_names{mouse}).(Session_type{sess});
            OccupMap_binary.(Mouse_names{mouse}).(Session_type{sess})(OccupMap_binary.(Mouse_names{mouse}).(Session_type{sess})>0) = 1;
            
            OccupMap_log.(Mouse_names{mouse}).(Session_type{sess}) = log(OccupMap.(Mouse_names{mouse}).(Session_type{sess}));
            OccupMap_log.(Mouse_names{mouse}).(Session_type{sess})(OccupMap_log.(Mouse_names{mouse}).(Session_type{sess})==-Inf) = -1e4;
            
            if sess==2
                StimOccupMap.(Mouse_names{mouse}).(Session_type{sess}) = hist2d([PositionStimExplo.(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1],[PositionStimExplo.(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1],sizeMap2,sizeMap2);
                StimOccupMap.(Mouse_names{mouse}).(Session_type{sess}) = StimOccupMap.(Mouse_names{mouse}).(Session_type{sess})/20;
                StimOccupMap.(Mouse_names{mouse}).(Session_type{sess}) = StimOccupMap.(Mouse_names{mouse}).(Session_type{sess})';
                StimOccupMap_binary.(Mouse_names{mouse}).(Session_type{sess}) = StimOccupMap.(Mouse_names{mouse}).(Session_type{sess});
                StimOccupMap_binary.(Mouse_names{mouse}).(Session_type{sess})(StimOccupMap_binary.(Mouse_names{mouse}).(Session_type{sess})>0) = 1;
                StimOccupMap_log.(Mouse_names{mouse}).(Session_type{sess}) = log(StimOccupMap.(Mouse_names{mouse}).(Session_type{sess}));
                StimOccupMap_log.(Mouse_names{mouse}).(Session_type{sess})(StimOccupMap_log.(Mouse_names{mouse}).(Session_type{sess})==-Inf) = -1e4;
                
                FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess}) = hist2d([PositionStimExplo.(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1],[PositionStimExplo.(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1],sizeMap2,sizeMap2)-hist2d([PositionStimBlocked.(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1],[PositionStimBlocked.(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1],sizeMap2,sizeMap2);
                FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess}) = FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess})/20;
                FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess}) = FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess})';
                FreeStimOccupMap_binary.(Mouse_names{mouse}).(Session_type{sess}) = FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess});
                FreeStimOccupMap_binary.(Mouse_names{mouse}).(Session_type{sess})(FreeStimOccupMap_binary.(Mouse_names{mouse}).(Session_type{sess})>0) = 1;
                FreeStimOccupMap_log.(Mouse_names{mouse}).(Session_type{sess}) = log(FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess}));
                FreeStimOccupMap_log.(Mouse_names{mouse}).(Session_type{sess})(FreeStimOccupMap_log.(Mouse_names{mouse}).(Session_type{sess})==-Inf) = -1e4;
            end
            disp(Mouse_names{mouse})
        end
    end
end


clear StimOccupMap_squeeze StimOccupMap_log_squeeze FreeStimOccupMap_squeeze FreeStimOccupMap_log_squeeze OccupMap_log_squeeze OccupMap_squeeze
for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        Mouse=[1230 1239 1240 1249];
    elseif group==2 % chronic flx mice
        Mouse=[11230 11239 11240 11249];
    end
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            try
                OccupMap.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = OccupMap.(Mouse_names{mouse}).(Session_type{sess});
                SpeedMap.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = SpeedMap.(Mouse_names{mouse}).(Session_type{sess});
                if sess==2
                    StimOccupMap.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = StimOccupMap.(Mouse_names{mouse}).(Session_type{sess});
                end
            catch
                OccupMap.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = NaN(sizeMap,sizeMap);
                SpeedMap.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = NaN(sizeMap,sizeMap);
                if sess==2
                    StimOccupMap.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = NaN(sizeMap2,sizeMap2);
                end
            end
        end
        try
            OccupMap_squeeze.(Drug_Group{group}).(Session_type{sess}) = squeeze(nanmean(OccupMap.(Drug_Group{group}).(Session_type{sess})));
            OccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess}) = log(OccupMap_squeeze.(Drug_Group{group}).(Session_type{sess}));
            OccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess})(OccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess})==-Inf) = -1e4;
            
            StimOccupMap_squeeze.(Drug_Group{group}).(Session_type{sess}) = squeeze(nanmean(StimOccupMap.(Drug_Group{group}).(Session_type{sess})));
            StimOccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess}) = log(StimOccupMap_squeeze.(Drug_Group{group}).(Session_type{sess}));
            StimOccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess})(StimOccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess})==-Inf) = -1e4;
            
            FreeStimOccupMap_squeeze.(Drug_Group{group}).(Session_type{sess}) = squeeze(nanmean(FreeStimOccupMap.(Drug_Group{group}).(Session_type{sess})));
            FreeStimOccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess}) = log(FreeStimOccupMap_squeeze.(Drug_Group{group}).(Session_type{sess}));
            FreeStimOccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess})(FreeStimOccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess})==-Inf) = -1e4;
        end
        SpeedMap_squeeze.(Drug_Group{group}).(Session_type{sess}) = squeeze(nanmean(SpeedMap.(Drug_Group{group}).(Session_type{sess})));
    end
end


for group=1:2
    figure; n=1;
    
    if group==1 % saline mice
        Mouse=[1230 1239 1240 1249];
    elseif group==2 % chronic flx mice
        Mouse=[11230 11239 11240 11249];
    end
    
    for mouse=1:length(Mouse)
        
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        subplot(length(Mouse),3,3*(mouse-1)+1);
        imagesc(OccupMap_log.(Mouse_names{mouse}).TestPre)
        axis xy; caxis([-10 -5])
        if mouse==1; title('Test Pre'); end
        ylabel(num2str(Mouse_names{mouse})); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        Maze_Frame_BM
        
        subplot(length(Mouse),3,3*(mouse-1)+2);
        imagesc(OccupMap_log.(Mouse_names{mouse}).Cond)
        axis xy; caxis([-10 -5]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if mouse==1; title('Cond'); end
        Maze_Frame_BM
        
        subplot(length(Mouse),3,3*(mouse-1)+3);
        imagesc(OccupMap_log.(Mouse_names{mouse}).TestPost)
        axis xy; caxis([-10 -5]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if mouse==1; title('Test Post'); end
        Maze_Frame_BM
        
        colormap bone
        a=suptitle(['Occupancy maps, ' Drug_Group{group}]); a.FontSize=20;
    end
end


figure;
for group=1:length(Drug_Group)
    
    subplot(length(Drug_Group),3,1+(group-1)*3);
    imagesc(OccupMap_squeeze.(Drug_Group{group}).TestPre)
    axis xy; caxis ([0 1e-3])
    if group==1; title('Test Pre'); end
    ylabel(Drug_Group{group}); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    Maze_Frame_BM
    
    subplot(length(Drug_Group),3,2+(group-1)*3);
    imagesc(OccupMap_squeeze.(Drug_Group{group}).Cond)
    axis xy; caxis([0 1e-3]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if group==1; title('Cond'); end
    Maze_Frame_BM
    
    subplot(length(Drug_Group),3,3+(group-1)*3);
    imagesc(OccupMap_squeeze.(Drug_Group{group}).TestPost)
    axis xy; caxis([0 1e-3]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if group==1; title('Test Post'); end
    Maze_Frame_BM
    
    colormap bone
end
a=suptitle('Occupancy maps for all drugs groups'); a.FontSize=20;




for group=1:2
    figure; n=1;
    
    if group==1 % saline mice
        Mouse=[1230 1239 1240 1249];
    elseif group==2 % chronic flx mice
        Mouse=[11230 11239 11240 11249];
    end
    
    for mouse=1:length(Mouse)
        
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        subplot(length(Mouse),3,3*(mouse-1)+1);
        imagesc(SpeedMap.(Mouse_names{mouse}).TestPre')
        axis xy; caxis([0 25])
        if mouse==1; title('Test Pre'); end
        ylabel(num2str(Mouse_names{mouse})); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        Maze_Frame_BM
        
        subplot(length(Mouse),3,3*(mouse-1)+2);
        imagesc(SpeedMap.(Mouse_names{mouse}).Cond')
        axis xy; caxis([0 25]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if mouse==1; title('Cond Pre'); end
        Maze_Frame_BM
        
        subplot(length(Mouse),3,3*(mouse-1)+3);
        imagesc(SpeedMap.(Mouse_names{mouse}).TestPost')
        axis xy; caxis([0 25]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if mouse==1; title('Test Post'); end
        Maze_Frame_BM
        
        colormap jet
        a=suptitle(['Speed maps, ' Drug_Group{group}]); a.FontSize=20;
    end
end


figure;
for group=1:length(Drug_Group)
    
    subplot(length(Drug_Group),3,1+(group-1)*3);
    imagesc(SpeedMap_squeeze.(Drug_Group{group}).TestPre')
    axis xy; caxis([2 20])
    if group==1; title('Test Pre'); end
    ylabel(Drug_Group{group}); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    Maze_Frame_BM
    
    subplot(length(Drug_Group),3,2+(group-1)*3);
    imagesc(SpeedMap_squeeze.(Drug_Group{group}).Cond')
    axis xy; caxis([2 20]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if group==1; title('Cond Pre'); end
    Maze_Frame_BM
    
    subplot(length(Drug_Group),3,3+(group-1)*3);
    imagesc(SpeedMap_squeeze.(Drug_Group{group}).TestPost')
    axis xy; caxis([2 20]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if group==1; title('Test Post'); end
    Maze_Frame_BM
    
    colormap jet
end
a=suptitle('Speed maps for all drugs groups'); a.FontSize=20;

for group=1:2
    figure; n=1;
    
        if group==1 % saline mice
        Mouse=[1230 1239 1240 1249];
    elseif group==2 % chronic flx mice
        Mouse=[11230 11239 11240 11249];
    end
    
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
         
        subplot(length(Mouse),3,3*n-2)
        plot(Position.(Mouse_names{mouse}).TestPre(:,1),Position.(Mouse_names{mouse}).TestPre(:,2));
        xlim([0 1]); ylim([0 1])
        if mouse==1; title('Test Pre'); end
        ylabel(Mouse_names{mouse}); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        end
        
        subplot(length(Mouse),3,3*n-1)
        plot(Position_Unblocked.(Mouse_names{mouse}).Cond(:,1),Position_Unblocked.(Mouse_names{mouse}).Cond(:,2));
        hold on
        plot(PositionStimExplo.(Mouse_names{mouse}).Cond(:,1) , PositionStimExplo.(Mouse_names{mouse}).Cond(:,2),'.r','MarkerSize',10);
        xlim([0 1]); ylim([0 1]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if mouse==1; title('Cond Pre'); end
        
        subplot(length(Mouse),3,3*n)
        try
            plot(Position.(Mouse_names{mouse}).TestPost(:,1),Position.(Mouse_names{mouse}).TestPost(:,2)); hold on
            plot(PositionStimExplo.(Mouse_names{mouse}).Cond(:,1) , PositionStimExplo.(Mouse_names{mouse}).Cond(:,2),'.r','MarkerSize',10);
        end
        xlim([0 1]); ylim([0 1]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if mouse==1; title('Test Post');
        f=get(gca,'Children'); l=legend([f(1)],'stim cond'); l.Position=[0.8 0.9 0.1 0.1]; end
        
        n=n+1;
    end
    a=suptitle(['Trajectories, ' Drug_Group{group}]); a.FontSize=20;
end


% Speed analysis



%% Sleep analysis
for mouse = 1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sleep_sess=1:2
        
%         SleepEpoch.(Mouse_names{mouse}){sleep_sess} = ConcatenateDataFromFolders_SB(SleepSess.(Mouse_names{mouse})(sleep_sess),'epoch','epochname','sleepstates');
%         NREM_and_REM.(Mouse_names{mouse}){sleep_sess} = or(SleepEpoch.(Mouse_names{mouse}){sleep_sess}{2},SleepEpoch.(Mouse_names{mouse}){sleep_sess}{3});
%         All_Epoch.(Mouse_names{mouse}){sleep_sess} = or(or(SleepEpoch.(Mouse_names{mouse}){sleep_sess}{2},SleepEpoch.(Mouse_names{mouse}){sleep_sess}{3}),SleepEpoch.(Mouse_names{mouse}){sleep_sess}{1});
%         
%         HPC_Low_tsd.(Mouse_names{mouse}){sleep_sess} = ConcatenateDataFromFolders_SB(SleepSess.(Mouse_names{mouse})(sleep_sess),'spectrum','prefix','H_Low');
%         OB_Low_tsd.(Mouse_names{mouse}){sleep_sess} = ConcatenateDataFromFolders_SB(SleepSess.(Mouse_names{mouse})(sleep_sess),'spectrum','prefix','B_Low');
%         HPC_VHigh_tsd.(Mouse_names{mouse}){sleep_sess} = ConcatenateDataFromFolders_SB(SleepSess.(Mouse_names{mouse})(sleep_sess),'spectrum','prefix','H_VHigh');
%         try
%             HPCSpec_REM.(Mouse_names{mouse})(sleep_sess,:) = nanmean(Data(Restrict(HPC_Low_tsd.(Mouse_names{mouse}){sleep_sess} , SleepEpoch.(Mouse_names{mouse}){sleep_sess}{3} )));
%             HPCSpec_Wake.(Mouse_names{mouse})(sleep_sess,:) = nanmean(Data(Restrict(HPC_Low_tsd.(Mouse_names{mouse}){sleep_sess} , SleepEpoch.(Mouse_names{mouse}){sleep_sess}{1} )));
%         end
%         try
%             OBSpec_Wake.(Mouse_names{mouse})(sleep_sess,:) = nanmean(Data(Restrict(OB_Low_tsd.(Mouse_names{mouse}){sleep_sess} , SleepEpoch.(Mouse_names{mouse}){sleep_sess}{1}  )));
%             OBSpec_NREM.(Mouse_names{mouse})(sleep_sess,:) = nanmean(Data(Restrict(OB_Low_tsd.(Mouse_names{mouse}){sleep_sess} , SleepEpoch.(Mouse_names{mouse}){sleep_sess}{2} )));
%             OBSpec_REM.(Mouse_names{mouse})(sleep_sess,:) = nanmean(Data(Restrict(OB_Low_tsd.(Mouse_names{mouse}){sleep_sess} , SleepEpoch.(Mouse_names{mouse}){sleep_sess}{3} )));
%         end
%         try
%             HPC_VHigh_Wake.(Mouse_names{mouse})(sleep_sess,:) = nanmean(Data(Restrict(HPC_VHigh_tsd.(Mouse_names{mouse}){sleep_sess} , SleepEpoch.(Mouse_names{mouse}){sleep_sess}{1} )));
%             HPC_VHigh_NREM.(Mouse_names{mouse})(sleep_sess,:) = nanmean(Data(Restrict(HPC_VHigh_tsd.(Mouse_names{mouse}){sleep_sess} , SleepEpoch.(Mouse_names{mouse}){sleep_sess}{2} )));
%         end
%         
%         REM_prop.(Mouse_names{mouse})(sleep_sess) = sum(Stop(SleepEpoch.(Mouse_names{mouse}){sleep_sess}{3})-Start(SleepEpoch.(Mouse_names{mouse}){sleep_sess}{3}))./(sum(Stop(NREM_and_REM.(Mouse_names{mouse}){sleep_sess})-Start(NREM_and_REM.(Mouse_names{mouse}){sleep_sess})))*100;
%         Sleep_prop.(Mouse_names{mouse})(sleep_sess) = sum(Stop(NREM_and_REM.(Mouse_names{mouse}){sleep_sess})-Start(NREM_and_REM.(Mouse_names{mouse}){sleep_sess}))./(sum(Stop(All_Epoch.(Mouse_names{mouse}){sleep_sess})-Start(All_Epoch.(Mouse_names{mouse}){sleep_sess})));
%         Sleep_prop.(Mouse_names{mouse})(sleep_sess) = Sleep_prop.(Mouse_names{mouse})(sleep_sess)*100;
%         
        % Ripples
        Ripples.(Mouse_names{mouse}){sleep_sess} = ConcatenateDataFromFolders_SB(SleepSess.(Mouse_names{mouse})(sleep_sess),'ripples');
        if isempty(Ripples.(Mouse_names{mouse}))
            RipplesDensity.(Mouse_names{mouse}){sleep_sess} = NaN;
        else
            RipplesDensity.(Mouse_names{mouse}){sleep_sess} = length(Restrict(Ripples.(Mouse_names{mouse}){sleep_sess} , SleepEpoch.(Mouse_names{mouse}){sleep_sess}{2}))/(sum(Stop(SleepEpoch.(Mouse_names{mouse}){sleep_sess}{2})-Start(SleepEpoch.(Mouse_names{mouse}){sleep_sess}{2}))/1e4); % ripples density on SWS
        end
    end
end

Drug_Group={'Saline','DZP'};
for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        Mouse=[1230 1239 1240 1249];
    elseif group==2 % chronic flx mice
        Mouse=[11230 11239 11240 11249];
    end
    
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sleep_sess=1:length(SleepSess.(Mouse_names{mouse}))
            
            REM_prop.(Drug_Group{group})(mouse,sleep_sess) = REM_prop.(Mouse_names{mouse})(sleep_sess);
            Sleep_prop.(Drug_Group{group})(mouse,sleep_sess) = Sleep_prop.(Mouse_names{mouse})(sleep_sess);
            RipplesDensityAll.(Drug_Group{group})(mouse,sleep_sess) = RipplesDensity.(Mouse_names{mouse}){sleep_sess};
            RipplesDensityAll.(Drug_Group{group})(RipplesDensityAll.(Drug_Group{group})==0) = NaN;
            
            HPC_Low_tsd.(Drug_Group{group})(mouse,:,sleep_sess) = nanmean(Data(HPC_Low_tsd.(Mouse_names{mouse}){sleep_sess}));
            OB_Low_tsd.(Drug_Group{group})(mouse,:,sleep_sess) = nanmean(Data(OB_Low_tsd.(Mouse_names{mouse}){sleep_sess}));
            HPC_VHigh_tsd.(Drug_Group{group})(mouse,:,sleep_sess) = nanmean(Data(HPC_VHigh_tsd.(Mouse_names{mouse}){sleep_sess}));
            
            try
                HPCSpec_REM.(Drug_Group{group})(mouse,:,sleep_sess) = HPCSpec_REM.(Mouse_names{mouse})(sleep_sess,:);
                HPCSpec_Wake.(Drug_Group{group})(mouse,:,sleep_sess) =  HPCSpec_Wake.(Mouse_names{mouse})(sleep_sess,:);
            end
            try
                OBSpec_Wake.(Drug_Group{group})(mouse,:,sleep_sess) =  OBSpec_Wake.(Mouse_names{mouse})(sleep_sess,:);
                OBSpec_NREM.(Drug_Group{group})(mouse,:,sleep_sess) =  OBSpec_NREM.(Mouse_names{mouse})(sleep_sess,:);
                OBSpec_REM.(Drug_Group{group})(mouse,:,sleep_sess) =  OBSpec_REM.(Mouse_names{mouse})(sleep_sess,:);
            end
            try
                HPC_VHigh_Wake.(Drug_Group{group})(mouse,:,sleep_sess) = HPC_VHigh_Wake.(Mouse_names{mouse})(sleep_sess,:);
                HPC_VHigh_NREM.(Drug_Group{group})(mouse,:,sleep_sess) = HPC_VHigh_NREM.(Mouse_names{mouse})(sleep_sess,:);
            end
        end
    end
end

cd('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre2')
load('H_Low_Spectrum.mat'); RangeLow=Spectro{3};
load('B_Middle_Spectrum.mat'); RangeMiddle=Spectro{3};
load('B_High_Spectrum.mat'); RangeHigh=Spectro{3};
load('H_VHigh_Spectrum.mat'); RangeVHigh=Spectro{3};

Cols = {[.2 .2 .2],[.5 .5 .5],[0 1 0],[0 .5 0]};
X = [1:4];
Legends ={'SleepPre Saline' 'SleepPost Saline' 'SleepPre DZP' 'SleepPost DZP'};
NoLegends ={'' '' '' ''};

% Sleep
a=figure; a.Position=[1e3 1e3 1e3 1e3];
subplot(131)
MakeSpreadAndBoxPlot2_SB([REM_prop.Saline REM_prop.DZP],Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 20]); ylabel('%')
title('REM proportion');

subplot(132)
MakeSpreadAndBoxPlot2_SB([Sleep_prop.Saline Sleep_prop.DZP],Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 110]); ylabel('%')
title('Sleep proportion'); 

subplot(133)
MakeSpreadAndBoxPlot2_SB([RipplesDensityAll.Saline RipplesDensityAll.DZP],Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .9]); ylabel('#/s');
title('Ripples density'); 

a=suptitle('Sleep characteristics, drugs experiments'); a.FontSize=20;

% Pre Post saline comparison
figure
subplot(331)
Data_to_use = HPCSpec_REM.Saline(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = HPCSpec_REM.Saline(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([0 15]); ylim([0 1e5]); ylabel('HPC low power'); %xlabel('Frequency (Hz)')
title('Wake')
f=get(gca,'Children'); legend([f(8),f(4)],'Sleep Pre','Sleep Post ');

subplot(332)
title('NREM'); makepretty

subplot(339)
xlabel('Frequency (Hz)'); makepretty

subplot(333)
Data_to_use = HPCSpec_Wake.Saline(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = HPCSpec_Wake.Saline(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([0 15]); ylim([0 1e5])
title('REM')

subplot(334)
Data_to_use = OBSpec_Wake.Saline(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = OBSpec_Wake.Saline(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([0 15]); ylim([0 1e6]); ylabel('OB power')

subplot(335)
Data_to_use = OBSpec_NREM.Saline(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = OBSpec_NREM.Saline(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([0 10]); ylim([0 1e6])

subplot(336)
Data_to_use = OBSpec_REM.Saline(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = OBSpec_REM.Saline(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([0 10]); ylim([0 1e6])

subplot(337)
Data_to_use = HPC_VHigh_Wake.Saline(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = HPC_VHigh_Wake.Saline(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([100 250]); ylim([0 1e3]); ylabel('HPC VHigh power')

subplot(338)
Data_to_use = HPC_VHigh_NREM.Saline(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = HPC_VHigh_NREM.Saline(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([50 250]); ylim([0 1e3]); set(gca, 'YScale', 'log');

a=suptitle('Mean spectrums, Saline, Sleep Pre/Post comparison'); a.FontSize=20;


% Pre saline/DZP comparison
figure
subplot(331)
Data_to_use = HPCSpec_REM.Saline(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = HPCSpec_REM.DZP(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([0 15]); ylim([0 1e5]); ylabel('HPC low power'); %xlabel('Frequency (Hz)')
title('Wake')
f=get(gca,'Children'); legend([f(8),f(4)],'Saline','DZP ');

subplot(332)
title('NREM'); makepretty

subplot(339)
xlabel('Frequency (Hz)'); makepretty

subplot(333)
Data_to_use = HPCSpec_Wake.Saline(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = HPCSpec_Wake.DZP(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([0 15]); ylim([0 1e5])
title('REM')

subplot(334)
Data_to_use = OBSpec_Wake.Saline(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = OBSpec_Wake.DZP(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([0 15]); ylim([0 1e6]); ylabel('OB power')

subplot(335)
Data_to_use = OBSpec_NREM.Saline(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = OBSpec_NREM.DZP(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([0 10]); ylim([0 1e6])

subplot(336)
Data_to_use = OBSpec_REM.Saline(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = OBSpec_REM.DZP(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([0 10]); ylim([0 1e6])

subplot(337)
Data_to_use = HPC_VHigh_Wake.Saline(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = HPC_VHigh_Wake.DZP(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([100 250]); ylim([0 1e3]); ylabel('HPC VHigh power'); xlabel('Frequency (Hz)');

subplot(338)
Data_to_use = HPC_VHigh_NREM.Saline(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = HPC_VHigh_NREM.DZP(:,:,1);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([50 250]); ylim([0 1e3]); set(gca, 'YScale', 'log'); xlabel('Frequency (Hz)');

a=suptitle('Mean spectrums, Sleep Pre, Saline/DZP comparison'); a.FontSize=20;

% Post Saline/DZP comparison
figure
subplot(331)
Data_to_use = HPCSpec_REM.Saline(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = HPCSpec_REM.DZP(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([0 15]); ylim([0 1e5]); ylabel('HPC low power'); %xlabel('Frequency (Hz)')
title('Wake')
f=get(gca,'Children'); legend([f(8),f(4)],'Saline','DZP ');

subplot(332)
title('NREM'); makepretty

subplot(339)
xlabel('Frequency (Hz)'); makepretty

subplot(333)
Data_to_use = HPCSpec_Wake.Saline(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = HPCSpec_Wake.DZP(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([0 15]); ylim([0 5e4])
title('REM')

subplot(334)
Data_to_use = OBSpec_Wake.Saline(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = OBSpec_Wake.DZP(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([0 15]); ylim([0 1e6]); ylabel('OB power')

subplot(335)
Data_to_use = OBSpec_NREM.Saline(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = OBSpec_NREM.DZP(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([0 10]); ylim([0 1e6])

subplot(336)
Data_to_use = OBSpec_REM.Saline(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = OBSpec_REM.DZP(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([0 10]); ylim([0 1e6])

subplot(337)
Data_to_use = HPC_VHigh_Wake.Saline(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = HPC_VHigh_Wake.DZP(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([100 250]); ylim([0 1e3]); ylabel('HPC VHigh power'); xlabel('Frequency (Hz)')

subplot(338)
Data_to_use = HPC_VHigh_NREM.Saline(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
Data_to_use = HPC_VHigh_NREM.DZP(:,:,2);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
makepretty
xlim([50 250]); ylim([0 1e3]); set(gca, 'YScale', 'log'); xlabel('Frequency (Hz)')

a=suptitle('Mean spectrums, Sleep Post, Saline/DZP comparison'); a.FontSize=20;









