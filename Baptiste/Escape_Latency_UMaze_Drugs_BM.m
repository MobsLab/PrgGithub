

GetEmbReactMiceFolderList_BM

Mouse=[688,739,777,779,849,893,1096,875,876,877,1001,1002,1095,1130,740,750,775,778,794];
Session_type={'CondShock','CondSafe','ExtShock','ExtSafe','CondPreShock','CondPreSafe','CondPostShock','CondPostSafe'};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long'};

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    CondPreShockSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'CondBlockedShock_Pre')))));
    CondPreSafeSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'CondBlockedSafe_Pre')))));
    CondPostShockSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'CondBlockedShock_Po')))));
    CondPostSafeSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'CondBlockedSafe_Post')))));
end

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        
        if convertCharsToStrings(Session_type{sess})=='CondShock'
            FolderList=CondShockSess;
        elseif convertCharsToStrings(Session_type{sess})=='CondSafe'
            FolderList=CondSafeSess;
        elseif convertCharsToStrings(Session_type{sess})=='ExtShock'
            FolderList=ExtShockSess;
        elseif convertCharsToStrings(Session_type{sess})=='ExtSafe'
            FolderList=ExtSafeSess;
        elseif convertCharsToStrings(Session_type{sess})=='CondPreShock'
            FolderList=CondPreShockSess;
        elseif convertCharsToStrings(Session_type{sess})=='CondPreSafe'
            FolderList=CondPreSafeSess;
        elseif convertCharsToStrings(Session_type{sess})=='CondPostShock'
            FolderList=CondPostShockSess;
        elseif convertCharsToStrings(Session_type{sess})=='CondPostSafe'
            FolderList=CondPostSafeSess;
        end
        
        EscapeLatency.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'escape_latency');
        
    end
    disp(Mouse_names{mouse})
end


for group=1:3
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            EscapeLatency.(Drug_Group{group}).(Session_type{sess})(mouse) = nanmean(EscapeLatency.(Session_type{sess}).(Mouse_names{mouse}));
            
        end
    end
end

Cols = {[0 0 1],[0 1 0],[1 0 0]};
Legends ={'SalineSB' 'Acute Flx' 'Chronic Flx'};
NoLegends ={'', '', ''};
X = [1:3];

Cols1 = {[1 .5 .5],[.5 .5 1]};
Legends1 ={'Shock' 'Safe'};
NoLegends1 ={'', ''};
X1 = [1:2];

% Latency
figure
subplot(161)
MakeSpreadAndBoxPlot2_SB({EscapeLatency.SalineSB.CondShock EscapeLatency.SalineSB.CondSafe},Cols1,X1,Legends1,'showpoints',0,'paired',1); 
ylabel('time (s)'); ylim([0 190])
title('Cond Saline')

subplot(162)
MakeSpreadAndBoxPlot2_SB({EscapeLatency.SalineSB.ExtShock EscapeLatency.SalineSB.ExtSafe},Cols1,X1,Legends1,'showpoints',0,'paired',1); 
title('Ext Saline'); ylim([0 190])

subplot(232); sess=1;
MakeSpreadAndBoxPlot2_SB({EscapeLatency.SalineSB.(Session_type{sess}) EscapeLatency.AcuteFlx.(Session_type{sess}) EscapeLatency.ChronicFlx.(Session_type{sess})},Cols,X,NoLegends,'showpoints',1,'paired',0); 
title('Cond')
ylabel('Shock'); ylim([0 200])

subplot(233); sess=3;
MakeSpreadAndBoxPlot2_SB({EscapeLatency.SalineSB.(Session_type{sess}) EscapeLatency.AcuteFlx.(Session_type{sess}) EscapeLatency.ChronicFlx.(Session_type{sess})},Cols,X,NoLegends,'showpoints',1,'paired',0); 
title('Ext')

subplot(235); sess=2;
MakeSpreadAndBoxPlot2_SB({EscapeLatency.SalineSB.(Session_type{sess}) EscapeLatency.AcuteFlx.(Session_type{sess}) EscapeLatency.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0); 
ylabel('Safe')

subplot(236); sess=4;
MakeSpreadAndBoxPlot2_SB({EscapeLatency.SalineSB.(Session_type{sess}) EscapeLatency.AcuteFlx.(Session_type{sess}) EscapeLatency.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0); 

% with CondPre & Post
figure
subplot(191)
MakeSpreadAndBoxPlot2_SB({EscapeLatency.SalineSB.CondPreShock EscapeLatency.SalineSB.CondPreSafe},Cols1,X1,Legends1,'showpoints',0,'paired',1); 
ylabel('time (s)');% ylim([0 190])
title('CondPre Saline')

subplot(192)
MakeSpreadAndBoxPlot2_SB({EscapeLatency.SalineSB.CondPostShock EscapeLatency.SalineSB.CondPostSafe},Cols1,X1,Legends1,'showpoints',0,'paired',1); 
%ylabel('time (s)'); ylim([0 190])
title('CondPost Saline')

subplot(232); sess=1;
MakeSpreadAndBoxPlot2_SB({EscapeLatency.SalineSB.(Session_type{sess}) EscapeLatency.AcuteFlx.(Session_type{sess}) EscapeLatency.ChronicFlx.(Session_type{sess})},Cols,X,NoLegends,'showpoints',1,'paired',0); 
title('Cond')
ylabel('Shock'); ylim([0 200])

subplot(233); sess=3;
MakeSpreadAndBoxPlot2_SB({EscapeLatency.SalineSB.(Session_type{sess}) EscapeLatency.AcuteFlx.(Session_type{sess}) EscapeLatency.ChronicFlx.(Session_type{sess})},Cols,X,NoLegends,'showpoints',1,'paired',0); 
title('Ext')

subplot(235); sess=2;
MakeSpreadAndBoxPlot2_SB({EscapeLatency.SalineSB.(Session_type{sess}) EscapeLatency.AcuteFlx.(Session_type{sess}) EscapeLatency.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0); 
ylabel('Safe')

subplot(236); sess=4;
MakeSpreadAndBoxPlot2_SB({EscapeLatency.SalineSB.(Session_type{sess}) EscapeLatency.AcuteFlx.(Session_type{sess}) EscapeLatency.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0); 






