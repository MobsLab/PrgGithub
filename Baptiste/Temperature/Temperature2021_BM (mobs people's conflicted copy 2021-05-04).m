

clear all
close all

cd('/home/gruffalo/Dropbox/Kteam/PrgMatlab/Baptiste')
cd('/home/mobsmorty/Dropbox/Kteam/PrgMatlab/Baptiste')
load('Sess2.mat','Sess2')
Sess=Sess2;

%% Mean OB Spectrum

Mouse=[666 668 688 739 777 779 849 893 1096 875 876 877 1001 1002 1095 1130 1131 1134 1135 1144 1146 1147 1170 1171 1172 1174 1184 1189];

for mouse = [20:28]%1:length(Mouse) % generate all sessions of interest
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
    TestPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost')))));
    TestSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Test')))));
    CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
    ExtSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Ext')))));
    FearSess.(Mouse_names{mouse}) =  [CondSess.(Mouse_names{mouse}) ExtSess.(Mouse_names{mouse})];
    TestPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre')))));
    HabituationBlocked.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'HabituationBlocked')))));
end


for mouse = [24:28] %1:length(Mouse_names)
    
    MaskTemperature.Sess.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess.(Mouse_names{mouse}),'masktemperature');
     
    MaskTemperature.Fear.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'masktemperature');
    
    MaskTemperature.HabBlocked.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(HabituationBlocked.(Mouse_names{mouse}),'masktemperature');

end

%% Comparison chronic flx and saline
Mouse_names={'M666','M668','M688','M739','M777','M779','M849','M893','M1096'}; % add 1096
Mouse=[666 668 688 739 777 779 849 893 1096];
figure
for mouse=1:length(Mouse_names)
    subplot(4,3,mouse)
    plot(Range(MaskTemperature.Sess.(Mouse_names{mouse})),runmean(Data(MaskTemperature.Sess.(Mouse_names{mouse})),20))
    title(Mouse_names{mouse})
    
    MeanTempSalineAll(mouse)=nanmean(Data(MaskTemperature.Sess.(Mouse_names{mouse})));
    MeanTempSalineFear(mouse)=nanmean(Data(MaskTemperature.Fear.(Mouse_names{mouse})));
    MeanTempSalineHabBlocked(mouse)=nanmean(Data(MaskTemperature.HabBlocked.(Mouse_names{mouse})));
    
end

Mouse_names={'M875','M876','M877','M1001','M1002','M1095','M1131'};
Mouse=[875 876 877 1001 1002 1095 1131];
figure
for mouse=1:length(Mouse_names)
    subplot(4,2,mouse)
    plot(Range(MaskTemperature.Sess.(Mouse_names{mouse})),runmean(Data(MaskTemperature.Sess.(Mouse_names{mouse})),20))
    title(Mouse_names{mouse})
    
    MeanTempChronicFlxAll(mouse)=nanmean(Data(MaskTemperature.Sess.(Mouse_names{mouse})));
    MeanTempChronicFlxFear(mouse)=nanmean(Data(MaskTemperature.Fear.(Mouse_names{mouse})));
    MeanTempChronicFlxHabBlocked(mouse)=nanmean(Data(MaskTemperature.HabBlocked.(Mouse_names{mouse})));

end


figure
PlotErrorBarN_KJ({MeanTempSalineAll,MeanTempSalineFear,MeanTempSalineHabBlocked,MeanTempChronicFlxAll,MeanTempChronicFlxFear,MeanTempChronicFlxHabBlocked},'newfig',0,'paired',0)
ylim([25 35]); makepretty
xticks([1:6]); xticklabels({'All sess saline','Fear sess saline','Hab Blocked sess saline','All sess chronic flx','Fear sess chronic flx','Hab Blocked sess chronic flx'})
xtickangle(45)
ylabel('Temperature (°C)')

%% Comparison SB and BM mice
Mouse=[666 668 688 739 777 779 849 893];
figure
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    subplot(4,3,mouse)
    plot(Range(MaskTemperature.Sess.(Mouse_names{mouse})),runmean(Data(MaskTemperature.Sess.(Mouse_names{mouse})),20))
    title(Mouse_names{mouse})
    
    MeanTempSophieAll(mouse)=nanmean(Data(MaskTemperature.Sess.(Mouse_names{mouse})));
    MeanTempSophieFear(mouse)=nanmean(Data(MaskTemperature.Fear.(Mouse_names{mouse})));
    MeanTempSophieHabBlocked(mouse)=nanmean(Data(MaskTemperature.HabBlocked.(Mouse_names{mouse})));
    
end

Mouse=[1144 1146 1147 1170 1171 1172 1174 1184 1189];
figure
for mouse=1:length(Mouse)
   try
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    subplot(4,2,mouse)
    plot(Range(MaskTemperature.Sess.(Mouse_names{mouse})),runmean(Data(MaskTemperature.Sess.(Mouse_names{mouse})),20))
    title(Mouse_names{mouse})
    
    MeanTempBaptisteAll(mouse)=nanmean(Data(MaskTemperature.Sess.(Mouse_names{mouse})));
    MeanTempBaptisteFear(mouse)=nanmean(Data(MaskTemperature.Fear.(Mouse_names{mouse})));
    MeanTempBaptisteHabBlocked(mouse)=nanmean(Data(MaskTemperature.HabBlocked.(Mouse_names{mouse})));
   end
end


figure
PlotErrorBarN_KJ({MeanTempSophieAll,MeanTempSophieFear,MeanTempSophieHabBlocked,MeanTempBaptisteAll,MeanTempBaptisteFear,MeanTempBaptisteHabBlocked},'newfig',0,'paired',0)
ylim([25 35]); makepretty
xticks([1:6]); xticklabels({'All sess SB','Fear sess SB','Hab Blocked sess SB','All sess BM','Fear sess BM','Hab Blocked sess BM'})
xtickangle(45)
ylabel('Temperature (°C)')



