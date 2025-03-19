


GetEmbReactMiceFolderList_BM

Mouse=[1189 1171 1170 11254 11200];
Session_type={'Habituation','TestPre','Cond','TestPost','Ext'};

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        
        Sessions_List_ForLoop_BM
        
        StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'stimepoch');
        Ripples.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'ripples');
        HeartRate.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'heartrate');
        Respi.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'respi_freq_bm');
        ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'zoneepoch');
        FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'freezeepoch');
        ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
        SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2} , ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
        BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'blockedepoch');
        LinPos.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'linearposition');
        Position.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'position');
        Speed.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'speed');
        
        clear chan_numb; chan_numb = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1} , 'bulb_deep');
        LFP_Bulb.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'lfp','channumber',chan_numb);
        clear chan_numb; chan_numb = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1} , 'rip');
        LFP_Rip.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'lfp','channumber',chan_numb);
        try
            clear chan_numb; chan_numb = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1} , 'pfc_deep');
            LFP_PFC.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'lfp','channumber',chan_numb);
        end
        disp(Session_type{sess})
    end
    disp(Mouse_names{mouse})
end


cd('~/Dropbox/Mobs_member/BaptisteMaheo/Data/Data_KB/')
save('DataMazeKarim2.mat','StimEpoch','Ripples','HeartRate','Respi','ZoneEpoch','FreezeEpoch','ShockZoneEpoch',...
    'SafeZoneEpoch','BlockedEpoch','LinPos','Mouse','Position','Speed','LFP_Bulb','LFP_Rip','LFP_PFC')






%% old script


%% Load necessary data
load('FinalFigures_UMaze_Drugs.mat')
GetEmbReactMiceFolderList_BM
Session_type={'Cond','Ext'};
cd('/media/nas6/ProjetEmbReact/DataEmbReact')
load('Create_Behav_Drugs_BM.mat')
Mice_Group = {'Saline SB','Chronic Flx','Acute Flx','Midazolam','Saline short BM','Diazepam short','Saline long BM','Diazepam long BM','Ripples inhibition','Chronic Buspirone','Acute Buspirone'};
indice = 26;

Columns_Names = {'Mice Group',...
    'Cond OB Low Shock','Cond OB Low Safe','Cond OB High Shock','Cond OB High Safe','Cond HR Shock','Cond HR Safe','Cond HRVar Shock','Cond HRVar Safe','Cond Ripples Shock','Cond Ripples Safe',...
    'Cond Shock freezing proportion','Cond Safe freezing proportion'...
    'Cond Shock zone occupancy','Cond Safe zone occupancy','Cond Shock mean occupancy','Cond Safe mean occupancy'...
    'Cond Shock zone entries','Cond Safe zone entries','Cond Shock freezing time','Cond Safe freezing time'...
    'Cond Freezing proportion ','Cond Ratio freezing proportion','Cond All freezing time'...
    'Cond Risk assessments','Cond Extra stim','Cond Stim by SZ entries'...
    'Ext OB Low Shock','Ext OB Low Safe','Ext OB High Shock','Ext OB High Safe','Ext HR Shock','Ext HR Safe','Ext HRVar Shock','Ext HRVar Safe','Ext Ripples Shock','Ext Ripples Safe'...
    'Ext Shock freezing proportion','Ext Safe freezing proportion',...
    'Ext Shock zone occupancy','Ext Safe zone occupancy','Ext Shock mean occupancy','Ext Safe mean occupancy'...
    'Ext Shock zone entries','Ext Safe zone entries','Ext Shock freezing time','Ext Safe freezing time'...
    'Ext Freezing proportion ','Ext Ratio freezing proportion','Ext All freezing time',...
    'Ext Risk assessments','Ext Extra stim','Ext Stim by SZ entries'};


%% Fill with mean data
GetEmbReactMiceFolderList_BM
for sess=1:length(Session_type)
    if sess==1
        ind=0;
    else
        ind=indice;
    end
    Sum_Up(:,2+ind) = OutPutData.(Session_type{sess}).ob_low.max_freq(:,5);
    Sum_Up(:,3+ind) = OutPutData.(Session_type{sess}).ob_low.max_freq(:,6);
    Sum_Up(:,4+ind) = OutPutData.(Session_type{sess}).ob_high.max_freq(:,5);
    Sum_Up(:,5+ind) = OutPutData.(Session_type{sess}).ob_high.max_freq(:,6);
    Sum_Up(:,6+ind) = OutPutData.(Session_type{sess}).heartrate.mean(:,5);
    Sum_Up(:,7+ind) = OutPutData.(Session_type{sess}).heartrate.mean(:,6);
    Sum_Up(:,8+ind) = OutPutData.(Session_type{sess}).heartratevar.mean(:,5);
    Sum_Up(:,9+ind) = OutPutData.(Session_type{sess}).heartratevar.mean(:,6);
    Sum_Up(:,10+ind) = OutPutData.(Session_type{sess}).ripples.mean(:,5);
    Sum_Up(:,11+ind) = OutPutData.(Session_type{sess}).ripples.mean(:,6);
    
    for mouse=1:length(Mouse)
        Sum_Up(mouse,14+ind) = ZoneOccupancy.Shock.(Session_type{sess}).(Mouse_names{mouse});
        Sum_Up(mouse,15+ind) = ZoneOccupancy.Safe.(Session_type{sess}).(Mouse_names{mouse});
        Sum_Up(mouse,16+ind) = OccupancyMeanTime.Shock.(Session_type{sess}).(Mouse_names{mouse});
        Sum_Up(mouse,17+ind) = OccupancyMeanTime.Safe.(Session_type{sess}).(Mouse_names{mouse});
        Sum_Up(mouse,18+ind) = ZoneEntries.Shock.(Session_type{sess}).(Mouse_names{mouse});
        Sum_Up(mouse,19+ind) = ZoneEntries.Safe.(Session_type{sess}).(Mouse_names{mouse});
        Sum_Up(mouse,25+ind) = ExtraStim.(Session_type{sess}).(Mouse_names{mouse});
        Sum_Up(mouse,26+ind) = RA.(Session_type{sess}).(Mouse_names{mouse});
        Sum_Up(mouse,27+ind) = Stim_By_SZ_entries.(Session_type{sess}).(Mouse_names{mouse});
    end
end

% Corrections for mice that didn't freeze in conditions
clear ind_to_use1 ind_to_use2 Logical_Array
for sess=1:length(Session_type)
    if sess==1
        ind=0;
    else
        ind=indice;
    end
    Logical_Array = isnan(OutPutData.(Session_type{sess}).respi_freq_bm.mean);
    ind_to_use1.(Session_type{sess}) = Logical_Array(:,5);
    ind_to_use2.(Session_type{sess}) = Logical_Array(:,6);
    
    Sum_Up(ind_to_use1.(Session_type{sess}) , [2+ind:2:10+ind]) = NaN;
    Sum_Up(ind_to_use2.(Session_type{sess}) , [3+ind:2:11+ind]) = NaN;
end

Sum_Up(Sum_Up==0) = NaN;
Sum_Up(Sum_Up==Inf) = NaN;

%% Defining drugs groups
GetEmbReactMiceFolderList_BM
for group=[1:8 13:15]
    
    Drugs_Groups_UMaze_BM
    
    clear Mouse_names2
    for mouse=1:length(Mouse)
        Mouse_names2{mouse}=['M' num2str(Mouse(mouse))];
        t(mouse,group)=find(not(cellfun(@isempty,strfind(Mouse_names , Mouse_names2{mouse}))));
    end
    Sum_Up(t(t(:,group)~=0,group),1) = group;
end
Sum_Up(isnan(Sum_Up(:,1)),1) = 0;

% Fill columns where 0 is needed
GetEmbReactMiceFolderList_BM
for sess=1:length(Session_type)
    if sess==1
        ind=0;
    else
        ind=indice;
    end
    
    for mouse=1:length(Mouse)
        Sum_Up(mouse,12+ind) = FreezingProportion.Shock.(Session_type{sess}).(Mouse_names{mouse});
        Sum_Up(mouse,13+ind) = FreezingProportion.Safe.(Session_type{sess}).(Mouse_names{mouse});
        Sum_Up(mouse,20+ind) = FreezingTime.Shock.(Session_type{sess}).(Mouse_names{mouse});
        Sum_Up(mouse,21+ind) = FreezingTime.Safe.(Session_type{sess}).(Mouse_names{mouse});
        Sum_Up(mouse,22+ind) = FreezingProportion.All.(Session_type{sess}).(Mouse_names{mouse});
        Sum_Up(mouse,23+ind) = FreezingProportion.Ratio.(Session_type{sess}).(Mouse_names{mouse});
        Sum_Up(mouse,24+ind) = FreezingTime.All.(Session_type{sess}).(Mouse_names{mouse});
    end
end

% save data
cd('/media/nas6/ProjetEmbReact/DataEmbReact')
save('DataForKarim_SumUpDrugsUMaze.mat','Sum_Up','Sum_Up2','Columns_Names','Mice_Group','-append')
cd('/home/gruffalo/Link to Dropbox/Mobs_member/BaptisteMaheo/Data_KB/')
save('DataForKarim_SumUpDrugsUMaze.mat','Sum_Up','Sum_Up2','Columns_Names','Mice_Group','-append')

% Sum_Up2 is without mice not in drugs groups
Sum_Up2 = Sum_Up(Sum_Up(:,1)~=0,:);

% Sum_Up3 is with mice sorted by drugs groups
[a,b] = sort(Sum_Up2(:,1));
Sum_Up3=Sum_Up2(b,:);

imagesc(zscore_nan_BM(Sum_Up3));
caxis([-2 2])

% legend the matrix
v=hline([7.5 14.5 19.5 26.5 38.5 50.5 55.5 61.5 65.5 70.5],'-r');
for i=1:10
    v(i).LineWidth=2;
end
u=vline([1.5 27.5],'-r'); u(1).LineWidth=4;  u(2).LineWidth=4;
caxis([-3 3]); colormap jet
xticks([.5:1:54.5]); xticklabels(Columns_Names); xtickangle(45)
yticks([4 11 17 23 33 45 53 59 63.5 68.5 71.5]); yticklabels(Mice_Group);

Sum_Up4 = zscore_nan_BM(Sum_Up3);
[R,P] = corrcoef(Sum_Up4)

imagesc(Sum_Up3);










%% trash ?
for mouse=1:length(Dir.ExpeInfo)
    try
        if and(or(convertCharsToStrings(Dir.ExpeInfo{mouse}{1}.DrugInjected)=='SALINE' , convertCharsToStrings(Dir.ExpeInfo{mouse}{1}.DrugInjected)=='SAL') , mouse<26)
            Sum_Up(mouse,1)=1;
        elseif or(convertCharsToStrings(Dir.ExpeInfo{mouse}{1}.DrugInjected)=='FLXCHRONIC' , convertCharsToStrings(Dir.ExpeInfo{mouse}{1}.DrugInjected)=='CHRONIC FLUOXETINE')
            Sum_Up(mouse,1)=2;
        elseif convertCharsToStrings(Dir.ExpeInfo{mouse}{1}.DrugInjected)=='FLX'
            Sum_Up(mouse,1)=3;
        elseif convertCharsToStrings(Dir.ExpeInfo{mouse}{1}.DrugInjected)=='MDZ'
            Sum_Up(mouse,1)=4;
        elseif  and(convertCharsToStrings(Dir.ExpeInfo{mouse}{1}.DrugInjected)=='SALINE' , mouse>26)
            Sum_Up(mouse,1)=5;
        elseif  convertCharsToStrings(Dir.ExpeInfo{mouse}{1}.DrugInjected)=='DIAZEPAM'
            Sum_Up(mouse,1)=6;
        end
    catch
        disp(Dir.ExpeInfo{mouse}{1}.DrugInjected)
        keyboard
    end
end
% little corrections
Sum_Up(28,1)=1; % 1096
Sum_Up(29,1)=2; % 1130
Sum_Up([15 37 46 47 54 ],1)=NaN; % 856
Sum_Up([40 49 55:57],1)=7; % Long Saline
Sum_Up([59:64],1)=8; % Long Diazepam
Sum_Up([76:78 81],1)=9; % Ripples inhibition
Sum_Up([72 73],1)=10; % Acute Buspirone
Sum_Up([74 75 80 82 83],1)=11; % Chronic Buspirone




