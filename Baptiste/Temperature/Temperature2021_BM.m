
clear all
close all

cd('/home/mobsmorty/Dropbox/Kteam/PrgMatlab/Baptiste')

GetEmbReactMiceFolderList_BM

%% Mean OB Spectrum

Mouse=[666 668 688 739 777 779 849 893 1096 875 876 877 1001 1002 1095 1134 1135 1131 1130 1144 1146 1147 1161 1162 1170 1171 1172 1174 1184 1189 11184 11189 11200 829 851 856 857 858 859 1005 1006];

for mouse = 34:41%1:length(Mouse) % generate all sessions of interest
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    try 
        TestPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost')))));
    catch
         Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
    end
    TestPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost')))));
    TestSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Test')))));
    CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
    ExtSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Ext')))));
    FearSess.(Mouse_names{mouse}) =  [CondSess.(Mouse_names{mouse}) ExtSess.(Mouse_names{mouse})];
    TestPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre')))));
    HabituationBlocked.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'HabituationBlocked')))));
    AllSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
end


for mouse = 34:41%1:length(Mouse_names)
    
    MaskTemperature.Sess.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess.(Mouse_names{mouse}),'masktemperature');
    MaskTemperature.Fear.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'masktemperature');
    MaskTemperature.HabBlocked.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(HabituationBlocked.(Mouse_names{mouse}),'masktemperature');
    MaskTemperature.Sleep.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(AllSleepSess.(Mouse_names{mouse}),'masktemperature');
    
    Cardio.Sess.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess.(Mouse_names{mouse}),'heartrate');
    Cardio.Fear.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'heartrate');
    Cardio.HabBlocked.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(HabituationBlocked.(Mouse_names{mouse}),'heartrate');
    Cardio.Sleep.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(AllSleepSess.(Mouse_names{mouse}),'heartrate');

end
MaskTemperature.Sess.M1144 = Restrict(MaskTemperature.Sess.M1144,intervalSet(0,2.3e7));

%% Comparison chronic flx and saline & BM

Drug_Group={'Saline','ChronicFlx','BM','Not_Working','MDZ'};

for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        Mouse=[666 668 688 739 777 779 849 893];
    elseif group==2 % chronic flx mice
        Mouse=[875 876 877 1001 1002];
    elseif group==3 % BM
        Mouse=[1144 1146 1147 1171 1172 1174 1184 1189];
    elseif group==4 %
        Mouse=[1130 1131 1134 1135];
    elseif group==5 %
        Mouse=[829 851 856 857 858 859 1005 1006];
    end
    
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        MeanTemp.(Drug_Group{group}){1}(mouse)=nanmean(Data(MaskTemperature.Sess.(Mouse_names{mouse})));
        MeanTemp.(Drug_Group{group}){2}(mouse)=nanmean(Data(MaskTemperature.Fear.(Mouse_names{mouse})));
        MeanTemp.(Drug_Group{group}){3}(mouse)=nanmean(Data(MaskTemperature.HabBlocked.(Mouse_names{mouse})));
        MeanTemp.(Drug_Group{group}){4}(mouse)=nanmean(Data(MaskTemperature.Sleep.(Mouse_names{mouse})));
        
        MeanEKG.(Drug_Group{group}){1}(mouse)=nanmean(Data(Cardio.Sess.(Mouse_names{mouse})));
        MeanEKG.(Drug_Group{group}){2}(mouse)=nanmean(Data(Cardio.Fear.(Mouse_names{mouse})));
        MeanEKG.(Drug_Group{group}){3}(mouse)=nanmean(Data(Cardio.HabBlocked.(Mouse_names{mouse})));
        MeanEKG.(Drug_Group{group}){4}(mouse)=nanmean(Data(Cardio.Sleep.(Mouse_names{mouse})));
        
    end
end
MeanEKG.ChronicFlx{1,1}(2)=NaN; MeanEKG.ChronicFlx{1,2}(2)=NaN; MeanEKG.ChronicFlx{1,3}(2)=NaN; MeanEKG.ChronicFlx{1,4}(2)=NaN; 
MeanEKG.Saline{1,1}(8)=NaN; MeanEKG.Saline{1,2}(8)=NaN; MeanEKG.Saline{1,3}(8)=NaN; MeanEKG.Saline{1,4}(8)=NaN; 

Cols = {[0 0 1],[0 0 0.8],[0 0 0.6],[0 0 0.4],[1 0 0],[0.8 0 0],[0.6 0 0],[0.4 0 0],[0 1 1],[0 0.8 0.8],[0 0.6 0.6],[0 0.4 0.4]};
X = [1,2,3,4,5,6,7,8,9,10,11,12];
Legends = {'SB All sess','SB fear sess','SB Hab blocked sess','SB sleep sess','Chronic flx All sess','Chronic flx fear sess','Chronic flx Hab blocked sess','Chronic flx sleep sess','BM All sess','BM fear sess','BM Hab blocked sess','BM sleep sess'};


figure
MakeSpreadAndBoxPlot2_SB([MeanTemp.Saline  MeanTemp.ChronicFlx  MeanTemp.BM],Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Temperature (°C)')
title('SB & BM saline & chronic flx mice, temperature comparison')
ylim([28 32.2])



figure
MakeSpreadAndBoxPlot2_SB([MeanEKG.Saline  MeanEKG.ChronicFlx  MeanEKG.BM],Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Heart rate (Hz)')
title('SB & BM saline & chronic flx mice, heart rate comparison')
ylim([8 14])








