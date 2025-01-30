

SessNames={'TestPost_PostDrug'};

Dir=PathForExperimentsEmbReact_Failures(SessNames{1});

for d=1:length(Dir.path)
    Mouse_names{d}= ['M' num2str(Dir.ExpeInfo{1, d}{1, 1}.nmouse)];
    Mouse(d)=Dir.ExpeInfo{1, d}{1, 1}.nmouse;
    DrugType{d} = Dir.ExpeInfo{1,d}{1,1}.DrugInjected; % addition SB
end


for mouse =1:length(Mouse)
    Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions_Failures(Mouse(mouse));
    HabSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Habituation')))));
    TestPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre')))));
    TestPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost')))));
    TestSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Test')))));
    SleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
    CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
    ExtSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Ext')))));
    CondSessCorrections
    FearSess.(Mouse_names{mouse}) =  [CondSess.(Mouse_names{mouse}) ExtSess.(Mouse_names{mouse})];
    TestPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre')))));
    CondExploSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'CondExplo')))));
    FirstExtSess.(Mouse_names{mouse}) = [ExtSess.(Mouse_names{mouse})(1) ExtSess.(Mouse_names{mouse})(ceil(length(ExtSess.(Mouse_names{mouse}))/2)+1)];
    
    if sum(mouse==[1:3])==1 % Short protocol
        CondPreSess.(Mouse_names{mouse}) = CondSess.(Mouse_names{mouse})(1:6);
        CondPostSess.(Mouse_names{mouse}) = CondSess.(Mouse_names{mouse})(7:end);
    else % Long protocol
        CondPreSess.(Mouse_names{mouse}) = CondSess.(Mouse_names{mouse})(1:6);
        CondPostSess.(Mouse_names{mouse}) = CondSess.(Mouse_names{mouse})(7:end);
        RealTimeSess1.(Mouse_names{mouse}) = CondPreSess.(Mouse_names{mouse})(1:3);
    end
end


Session_type={'Cond','TestPost'};
Mouse=[1131 1134 1135 1172, 1200, 1204, 1206 ];

for mouse = 1:length(Mouse_names)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        
        Sessions_List_ForLoop_BM
        
        TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'accelero'))));
        FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch');
        ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
        ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
        SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2} , ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
        Freeze_ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        Freeze_SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        Freezing_prop.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}))-Start(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/sum(Stop(TotEpoch.(Session_type{sess}).(Mouse_names{mouse}))-Start(TotEpoch.(Session_type{sess}).(Mouse_names{mouse})));
        ShockZone_prop.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}))-Start(ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})))/sum(Stop(TotEpoch.(Session_type{sess}).(Mouse_names{mouse}))-Start(TotEpoch.(Session_type{sess}).(Mouse_names{mouse})));
        SafeZone_prop.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}))-Start(SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})))/sum(Stop(TotEpoch.(Session_type{sess}).(Mouse_names{mouse}))-Start(TotEpoch.(Session_type{sess}).(Mouse_names{mouse})));
        
        Freezing_prop_all.(Session_type{sess})(mouse) = Freezing_prop.(Session_type{sess}).(Mouse_names{mouse});
        SafeZone_prop_all.(Session_type{sess})(mouse) = SafeZone_prop.(Session_type{sess}).(Mouse_names{mouse});
        ShockZone_prop_all.(Session_type{sess})(mouse) = ShockZone_prop.(Session_type{sess}).(Mouse_names{mouse});
    end
end

Cols = {[0.3, 0.745, 0.93],[0.3, 0.545, 0.3]};
X = [1:2];
Legends = {'No Fz','SalineSB'};
NoLegends = {'',''};
   
load('/media/nas6/ProjetEmbReact/DataEmbReact/Create_Behav_Drugs_BM.mat','ZoneOccupancy','ZoneOccupancy','FreezingProportion')

figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({Freezing_prop_all.Cond*100 FreezingProportion.All.SalineSB.Cond*100},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Freezing (%)'); title('Freezing percentage')
subplot(132)
MakeSpreadAndBoxPlot2_SB({ShockZone_prop_all.Cond*100 ZoneOccupancy.Shock.SalineSB.Cond*100},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Occupancy (%)'); title('Shock zone occupancy, Cond')
hline(50,'--r')
subplot(133)
MakeSpreadAndBoxPlot2_SB({ShockZone_prop_all.TestPost*100 ZoneOccupancy.Shock.SalineSB.TestPost*100},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Occupancy (%)'); title('Shock zone occupancy, TestPost')
hline(50,'--r')

sgtitle('Analysis of mice that did not freeze')



Mouse=[1131 1134 1135 1172 1200 1204 1206];
for mouse =1:length(Mouse) % generate all sessions of interest
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    AllSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
end

SleepSess={'SleepPre','SleepPost_Pre','SleepPost_Post'};
for mouse = 1:length(Mouse) % generate all sessions of interest
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sleep_sess=1:length(AllSleepSess.(Mouse_names{mouse}))
        
        SleepEpoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(AllSleepSess.(Mouse_names{mouse})(sleep_sess),'epoch','epochname','sleepstates');
        NREM_and_REM.(Mouse_names{mouse})=or(SleepEpoch.(Mouse_names{mouse}){2},SleepEpoch.(Mouse_names{mouse}){3});
        All_Epoch.(Mouse_names{mouse})=or(or(SleepEpoch.(Mouse_names{mouse}){2},SleepEpoch.(Mouse_names{mouse}){3}),SleepEpoch.(Mouse_names{mouse}){1});
        REM_prop.(Mouse_names{mouse})(sleep_sess) = sum(Stop(SleepEpoch.(Mouse_names{mouse}){3})-Start(SleepEpoch.(Mouse_names{mouse}){3}))./(sum(Stop(NREM_and_REM.(Mouse_names{mouse}))-Start(NREM_and_REM.(Mouse_names{mouse}))))*100;
        Sleep_prop.(Mouse_names{mouse})(sleep_sess) = sum(Stop(NREM_and_REM.(Mouse_names{mouse}))-Start(NREM_and_REM.(Mouse_names{mouse})))./(sum(Stop(All_Epoch.(Mouse_names{mouse}))-Start(All_Epoch.(Mouse_names{mouse})))); Sleep_prop.(Mouse_names{mouse})(sleep_sess) = Sleep_prop.(Mouse_names{mouse})(sleep_sess)*100;
        
    end
end



Drug_Group={'NoFzLong','NoFzShort'};

for group=1:2
    
    if group==1
        Mouse = [1131 1134 1135];
    else
        Mouse = [1200, 1204, 1206];
    end
    
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sleep_sess=1:length(AllSleepSess.(Mouse_names{mouse}))
            REM_prop.(Drug_Group{group})(mouse,sleep_sess)=REM_prop.(Mouse_names{mouse})(sleep_sess);
            Sleep_prop.(Drug_Group{group})(mouse,sleep_sess)=Sleep_prop.(Mouse_names{mouse})(sleep_sess);
        end
    end
end

Cols = {[0.66 0.66 1],[0 0 1],[0 0 0.33]};
X = [1:3];
Legends ={'SleepPre' 'SleepPost_Pre' 'SleepPost_Post'};
NoLegends ={'' '' ''};

Cols2 = {[0.66 0.66 1],[0 0 0.33]};
X2 = [1:2];
Legends2 ={'SleepPre' 'SleepPost'};


figure
group=1;
subplot(221)
MakeSpreadAndBoxPlot2_SB(Sleep_prop.(Drug_Group{group}),Cols,X,Legends,'showpoints',0);
ylim([0 100])
title('Sleep percentage')

subplot(222)
MakeSpreadAndBoxPlot2_SB(REM_prop.(Drug_Group{group}),Cols,X,Legends,'showpoints',0);
ylim([0 17])
title('REM percentage'); ylabel('%')

group=2;
subplot(223)
MakeSpreadAndBoxPlot2_SB(Sleep_prop.(Drug_Group{group}),Cols2,X2,Legends2,'showpoints',0);
ylim([0 100])
title('Sleep percentage')

subplot(224)
MakeSpreadAndBoxPlot2_SB(REM_prop.(Drug_Group{group}),Cols2,X2,Legends2,'showpoints',0);
ylim([0 17])
title('REM percentage'); ylabel('%')

sgtitle('Non-freezing mice sleep features')
