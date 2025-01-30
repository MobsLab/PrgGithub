


Mouse_names={'M666','M667','M668','M669','M688','M739','M777','M779','M849','M893'};
Mouse=[666 667 668 669 688 739 777 779 849 893];
for mouse = 1:length(Mouse_names)
    Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
    TestPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost')))));
end



for mouse=1:length(Mouse_names)
    AccData.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}),'accelero');
    MTempData.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}),'masktemperature');
    TTempData.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}),'tailtemperature');
    FzEpoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
    ZoneEpoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}),'epoch','epochname','zoneepoch');
    TotalEpoch.(Mouse_names{mouse}) = intervalSet(0,max(Range(AccData.(Mouse_names{mouse}))));
    Non_FreezingEpoch.(Mouse_names{mouse})=TotalEpoch.(Mouse_names{mouse}) -FzEpoch.(Mouse_names{mouse});
    
    ShockZones.(Mouse_names{mouse})=or( ZoneEpoch.(Mouse_names{mouse}){1}, ZoneEpoch.(Mouse_names{mouse}){4});
    SafeZones.(Mouse_names{mouse})=or( ZoneEpoch.(Mouse_names{mouse}){2}, ZoneEpoch.(Mouse_names{mouse}){5});

    MeanMTempData.(Mouse_names{mouse})=nanmean(Data(MTempData.(Mouse_names{mouse})));
    MeanTTempData.(Mouse_names{mouse})=nanmean(Data(TTempData.(Mouse_names{mouse})));
    
    MTemp_TestPost_ShockSide(mouse)=nanmean(Data(Restrict(MTempData.(Mouse_names{mouse}),ShockZones.(Mouse_names{mouse}))))-MeanMTempData.(Mouse_names{mouse});
    MTemp_TestPost_SafeSide(mouse)=nanmean(Data(Restrict(MTempData.(Mouse_names{mouse}),SafeZones.(Mouse_names{mouse}))))-MeanMTempData.(Mouse_names{mouse});
    
    TTemp_TestPost_ShockSide(mouse)=nanmean(Data(Restrict(TTempData.(Mouse_names{mouse}),ShockZones.(Mouse_names{mouse}))))-MeanTTempData.(Mouse_names{mouse});
    TTemp_TestPost_SafeSide(mouse)=nanmean(Data(Restrict(TTempData.(Mouse_names{mouse}),SafeZones.(Mouse_names{mouse}))))-MeanTTempData.(Mouse_names{mouse});
end



% Plot Mean temperature in safe or shock zones during Test Post
figure
Figure=[MTemp_TestPost_ShockSide' MTemp_TestPost_SafeSide'];
[pval,hb,eb]=PlotErrorBoxPlotN_BM(Figure,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
ylabel('Frequency (Hz)')
xticklabels({'before shock','after shock'})
title('Heart Rate')
makepretty
set(gca,'FontSize',20)
xtickangle(45)

figure
Figure=[TTemp_TestPost_ShockSide' TTemp_TestPost_SafeSide'];
[pval,hb,eb]=PlotErrorBoxPlotN_BM(Figure,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
ylabel('Normalized Temperature (°C)')
xticklabels({'Shock Zones','Safe Zones'})
title('Tail Temperature during post sessions')
makepretty
set(gca,'FontSize',20)
xtickangle(45)



% Temperature evolution

for mouse=1:length(Mouse_names)
    
    RangeTTemp.(Mouse_names{mouse})=Range(TTempData.(Mouse_names{mouse}));
    DataTTemp.(Mouse_names{mouse})=Data(TTempData.(Mouse_names{mouse}))
    
    step=1.82e4; % time step corresponding to 1/100 of a Test Post sessions
    
    for n=1:400
        FindRank=RangeTTemp.(Mouse_names{mouse})<step*n & RangeTTemp.(Mouse_names{mouse})>step*(n-1);
        GatherData.(Mouse_names{mouse})(n)=nanmean(DataTTemp.(Mouse_names{mouse})(FindRank));
    end
    
    GatherData.(Mouse_names{mouse})(2,1:100)=GatherData.(Mouse_names{mouse})(1,1:100);
    GatherData.(Mouse_names{mouse})(3,1:100)=GatherData.(Mouse_names{mouse})(1,101:200);
    GatherData.(Mouse_names{mouse})(4,1:100)=GatherData.(Mouse_names{mouse})(1,201:300);
    GatherData.(Mouse_names{mouse})(5,1:100)=GatherData.(Mouse_names{mouse})(1,301:400);
    
    GatherData.(Mouse_names{mouse})(6,1:100)=nanmean(GatherData.(Mouse_names{mouse})(2:5,1:100));
    
end

figure
for mouse=1:length(Mouse_names)

subplot(2,5,mouse)

plot(GatherData.(Mouse_names{mouse})(6,1:100))

end

for mouse=1:length(Mouse_names)
    
    AllMiceGatherData(mouse,:) = GatherData.(Mouse_names{mouse})(6,1:100)-MeanTTempData.(Mouse_names{mouse});
    
end

% Tail Temperaure evolution during Post sessions
figure
Conf_Inter=nanstd( AllMiceGatherData)/sqrt(size( AllMiceGatherData,1));
shadedErrorBar([1:100],nanmean(AllMiceGatherData),Conf_Inter,'-r',1); hold on;
makepretty
ylabel('Normalized Temperature (°C)')
xlabel('proportional time for a session (%)')
title('Tail Temperature during post sessions (n=10 mice)')































