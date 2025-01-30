
clear all

GetEmbReactMiceFolderList_BM

Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long','Saline1','Saline2','DZP1','DZP2','RipInhib','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};
Group=[5:8];

Cols = {[.3, .745, .93],[.85, .325, .1],[.635, .078, .184],[.75, .75, 0]};
X = [1:4];
Legends = {'Saline','DZP','RipControl','RipInhib'};
NoLegends = {'','','',''};

% Cols = {[.3, .745, .93],[.85, .325, .1],[.635, .078, .184],[.75, .75, 0],[.735, .078, .284],[.95, .75, .2]};
% X = [1:6];
% Legends = {'Saline','DZP','RipControl','RipInhib','RipControl_old','RipInhib_old'};
% NoLegends = {'','','','','',''};

Zones_Lab={'Shock','Shock middle','Middle','Safe middle','Safe'};


for sess=1:length(Session_type)
    for group=Group
        Mouse=Drugs_Groups_UMaze_BM(group);
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Sessions_List_ForLoop_BM
            
%             Zones.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','zoneepoch_nosleep');
% %             Zones.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','zoneepoch');
%             TotalEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0 , max(Range(ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'accelero'))));
%             BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
%             EpochUnblocked.(Session_type{sess}).(Mouse_names{mouse}) = TotalEpoch.(Session_type{sess}).(Mouse_names{mouse})-BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
%             FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch_nosleep');
% %             FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
%             ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotalEpoch.(Session_type{sess}).(Mouse_names{mouse})-FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse});
%             Speed.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'speed');
%             
            TotalTime.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(TotalEpoch.(Session_type{sess}).(Mouse_names{mouse})));
            AbsoluteTime_Free.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(EpochUnblocked.(Session_type{sess}).(Mouse_names{mouse})));
            AbsoluteTime_Free_Active.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , EpochUnblocked.(Session_type{sess}).(Mouse_names{mouse}))));
            for zones=1:5
                Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} = and(Zones.(Session_type{sess}).(Mouse_names{mouse}){zones} , EpochUnblocked.(Session_type{sess}).(Mouse_names{mouse}));
                Zone_Free_Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones} = and(and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , Zones.(Session_type{sess}).(Mouse_names{mouse}){zones}) , EpochUnblocked.(Session_type{sess}).(Mouse_names{mouse}));
                Zone_Free_Active_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones} = and(and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , Zones.(Session_type{sess}).(Mouse_names{mouse}){zones}) , EpochUnblocked.(Session_type{sess}).(Mouse_names{mouse}));
                Absolute_Time_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones) = sum(Stop(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones})-Start(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones}))/1e4;
                Absolute_Time_Spent_Freezing_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones) = sum(Stop(and(Zones.(Session_type{sess}).(Mouse_names{mouse}){zones} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))-Start(and(Zones.(Session_type{sess}).(Mouse_names{mouse}){zones} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/1e4;
                Absolute_Time_Spent_Freezing_In_Zones_Free.(Session_type{sess}).(Mouse_names{mouse})(zones) = sum(Stop(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))-Start(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/1e4;
                Absolute_Time_Spent_Active_In_Zones_Free.(Session_type{sess}).(Mouse_names{mouse})(zones) = sum(Stop(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse})))-Start(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/1e4;
                
                Speed_Unblocked.(Session_type{sess}).(Mouse_names{mouse})(zones) = nanmean(Data(Restrict(Speed.(Session_type{sess}).(Mouse_names{mouse}) , Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones})));
                DistanceTraveled_Unblocked.(Session_type{sess}).(Mouse_names{mouse})(zones) = Speed_Unblocked.(Session_type{sess}).(Mouse_names{mouse})(zones)*(Absolute_Time_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones));
                Speed_Unblocked_Active.(Session_type{sess}).(Mouse_names{mouse})(zones) = nanmean(Data(Restrict(Speed.(Session_type{sess}).(Mouse_names{mouse}) , and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse})))));
           
                blocked epoch   
                Zone_Blocked_Freezing_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones} = and(and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , Zones.(Session_type{sess}).(Mouse_names{mouse}){zones}) , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            end
                        
            Proportion_Time_Spent_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones) = Absolute_Time_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones)/TotalTime.(Session_type{sess}).(Mouse_names{mouse});
            Proportion_Time_Spent_Freezing_In_Zones.(Session_type{sess}).(Mouse_names{mouse}) = Absolute_Time_Spent_Freezing_In_Zones_Free.(Session_type{sess}).(Mouse_names{mouse})./Absolute_Time_In_Zones.(Session_type{sess}).(Mouse_names{mouse});
            
            disp(Mouse_names{mouse})
        end
    end
end


n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            for zones=1:5
                
                DATA.Absolute_Time_In_Zones.(Session_type{sess}){zones}{n}(mouse) = Absolute_Time_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones)/60;
                DATA.Absolute_Time_Spent_Freezing_In_Zones.(Session_type{sess}){zones}{n}(mouse) = Absolute_Time_Spent_Freezing_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones)/60;
                DATA.Absolute_Time_Spent_Freezing_In_Zones_Free.(Session_type{sess}){zones}{n}(mouse) = Absolute_Time_Spent_Freezing_In_Zones_Free.(Session_type{sess}).(Mouse_names{mouse})(zones)/60;
                DATA.Absolute_Time_Spent_Active_In_Zones_Free.(Session_type{sess}){zones}{n}(mouse) = Absolute_Time_Spent_Active_In_Zones_Free.(Session_type{sess}).(Mouse_names{mouse})(zones)/60;
                DATA.Proportion_Time_Spent_Freezing_In_Zones.(Session_type{sess}){zones}{n}(mouse) = Proportion_Time_Spent_Freezing_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones);
                
                DATA.DistanceTraveled_Unblocked.(Session_type{sess}){zones}{n}(mouse) = DistanceTraveled_Unblocked.(Session_type{sess}).(Mouse_names{mouse})(zones);
                DATA.Speed_Unblocked_Active.(Session_type{sess}){zones}{n}(mouse) = Speed_Unblocked_Active.(Session_type{sess}).(Mouse_names{mouse})(zones);
                Zone_Entries_Numb.(Session_type{sess}){zones}{n}(mouse) = length(Start(Zone_Free_Active_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                Zone_Entries_Density.(Session_type{sess}){zones}{n}(mouse) = Zone_Entries_Numb.(Session_type{sess}){zones}{n}(mouse)/(AbsoluteTime_Free_Active.(Session_type{sess}).(Mouse_names{mouse})/60e4);
                Zones_MeanDuration.(Session_type{sess}){zones}{n}(mouse) = (sum(DurationEpoch(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones}))/1e4)/Zone_Entries_Numb.(Session_type{sess}){zones}{n}(mouse);
                
            end
        end
    end
    n=n+1;
end



figure; p=1; sess=2;
for zones=[1 4 3 5 2]
    
    subplot(3,5,p)
    MakeSpreadAndBoxPlot2_SB(DATA.Absolute_Time_In_Zones.(Session_type{sess}){zones} , Cols , X , NoLegends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('time (min)'); u=text(-1.,5,'Total time','FontSize',15,'FontWeight','bold','Rotation',90); end
    ylim([0 32])
    title(Zones_Lab{p})
    
    subplot(3,5,p+5)
    MakeSpreadAndBoxPlot2_SB(DATA.Absolute_Time_Spent_Active_In_Zones_Free.(Session_type{sess}){zones} , Cols , X , NoLegends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('time (min)'); u=text(-1.,5,'Time active','FontSize',15,'FontWeight','bold','Rotation',90); end
    ylim([0 30])
    
    subplot(3,5,p+10)
    MakeSpreadAndBoxPlot2_SB(DATA.Absolute_Time_Spent_Freezing_In_Zones.(Session_type{sess}){zones} , Cols , X , Legends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('time (min)'); u=text(-1.,1.5,'Time freezing','FontSize',15,'FontWeight','bold','Rotation',90); end
    ylim([0 8.5])
    
    p=p+1;
end
a=suptitle('Time spent in zones, Cond sessions'); a.FontSize=20;


figure; p=1; sess=2;
for zones=[1 4 3 5 2]
    
    subplot(1,5,p)
    MakeSpreadAndBoxPlot2_SB(DATA.Proportion_Time_Spent_Freezing_In_Zones.(Session_type{sess}){zones} , Cols , X , Legends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('time (min)'); end
    ylim([0 .5])
    title(Zones_Lab{p})
    
    p=p+1;
end
a=suptitle('Proportion time freezing when in zones, Cond session'); a.FontSize=20;


figure; p=1; sess=6;
for zones=[1 4 3 5 2]
    
    subplot(1,5,p)
    a=MakeSpreadAndBoxPlot2_SB(DATA.Absolute_Time_In_Zones.(Session_type{sess}){zones} , Cols , X , Legends , 'showpoints',1,'paired',0);
    ylim([0 6.5])
    if zones==1; ylabel('time (min)'); end
    title(Zones_Lab{p})
    
    p=p+1;
end
a=suptitle('Time spent in zones, TestPre sessions'); a.FontSize=20;


figure; p=1; sess=7;
for zones=[1 4 3 5 2]
    
    subplot(1,5,p)
    a=MakeSpreadAndBoxPlot2_SB(DATA.Absolute_Time_In_Zones.(Session_type{sess}){zones} , Cols , X , Legends , 'showpoints',1,'paired',0);
    ylim([0 12])
    if zones==1; ylabel('time (min)'); end
    title(Zones_Lab{p})
    
    p=p+1;
end
a=suptitle('Time spent in zones, TestPost sessions'); a.FontSize=20;



%% Zones entries 
figure; p=1; sess=2;
for zones=[1 4 3 5 2]
    
    subplot(2,5,p)
    MakeSpreadAndBoxPlot2_SB(DATA.DistanceTraveled_Unblocked.(Session_type{sess}){zones} , Cols , X , NoLegends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('dist. traveled (cm)'); end
    ylim([0 5.5e3]); title(Zones_Lab{p})
    
    subplot(2,5,p+5)
    MakeSpreadAndBoxPlot2_SB(DATA.Speed_Unblocked_Active.(Session_type{sess}){zones} , Cols , X , Legends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('speed when active (cm/s)');end
    ylim([0 10])
    
    p=p+1;
end
a=suptitle('Distance traveled & speed, Unblocked, Cond sessions'); a.FontSize=20;



figure; p=1; sess=2;
for zones=[1 4 3 5 2]
    
    subplot(3,5,p)
    MakeSpreadAndBoxPlot2_SB(Zone_Entries_Numb.(Session_type{sess}){zones} , Cols , X , NoLegends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('entries #');end
    ylim([0 260]); title(Zones_Lab{p})

        subplot(3,5,p+5)
    MakeSpreadAndBoxPlot2_SB(Zone_Entries_Density.(Session_type{sess}){zones} , Cols , X , NoLegends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('entries #/s active');end
%     ylim([0 260]); title(Zones_Lab{p})

    subplot(3,5,p+10)
    MakeSpreadAndBoxPlot2_SB(Zones_MeanDuration.(Session_type{sess}){zones} , Cols , X , Legends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('mean duration');end
    ylim([0 35])
    
    p=p+1;
end
a=suptitle('Zones entries analysis, Unblocked, Cond sessions'); a.FontSize=20;



%% Physio
for sess=1:length(Session_type)
    for group=Group
        Mouse=Drugs_Groups_UMaze_BM(group);
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Sessions_List_ForLoop_BM
            
            OBSpec.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
            try; HPCSpec.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','H_Low'); end
            try; PFCSpec.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','PFCx_Low'); end
            try; OBHighSpec.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','B_High'); end
            try; HPCVHighSpec.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','H_VHigh'); end
            Respi.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'respi_freq_bm');
            HeartRate.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartrate');
            Ripples.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ripples');
            
            for zones=1:5
                
                OBSpec_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(OBSpec.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Free_Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones});
                try; HPCSpec_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(HPCSpec.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Free_Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones}); end
                try;  PFCSpec_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(PFCSpec.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Free_Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones}); end
                try;  OBHighSpec_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(OBHighSpec.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Free_Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones}); end
                try;  HPCVHighSpec_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(HPCVHighSpec.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Free_Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones}); end
                Respi_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(Respi.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Free_Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones});
                HeartRate_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(HeartRate.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Free_Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones});
                Ripples_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones} = length(Restrict(Ripples.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Free_Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                if Ripples_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones}== 0
                    Ripples_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones}=NaN;
                end
                RipplesDensity_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones} = Ripples_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones}/(sum(DurationEpoch(Zone_Free_Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones}))/1e4);
                
                
                OBSpec_Active.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(OBSpec.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Free_Active_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones});
                try; HPCSpec_Active.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(HPCSpec.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Free_Active_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones}); end
                try; PFCSpec_Active.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(PFCSpec.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Free_Active_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones}); end
                try; OBHighSpec_Active.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(OBHighSpec.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Free_Active_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones}); end
                try; HPCVHighSpec_Active.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(HPCVHighSpec.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Free_Active_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones}); end
                Respi_Active.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(Respi.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Free_Active_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones});
                HeartRate_Active.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(HeartRate.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Free_Active_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones});
                Ripples_Active.(Session_type{sess}).(Mouse_names{mouse}){zones} = length(Restrict(Ripples.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Free_Active_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                if Ripples_Active.(Session_type{sess}).(Mouse_names{mouse}){zones} == 0
                    Ripples_Active.(Session_type{sess}).(Mouse_names{mouse}){zones}=NaN;
                end
                RipplesDensity_Active.(Session_type{sess}).(Mouse_names{mouse}){zones} = Ripples_Active.(Session_type{sess}).(Mouse_names{mouse}){zones}/(sum(DurationEpoch(Zone_Free_Active_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones}))/1e4);
                
                % blocked epoch
                OBSpec_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(OBSpec.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Blocked_Freezing_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones});
                try;  HPCSpec_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(HPCSpec.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Blocked_Freezing_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones}); end
                try; PFCSpec_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(PFCSpec.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Blocked_Freezing_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones}); end
                try; OBHighSpec_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(OBHighSpec.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Blocked_Freezing_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones}); end
                try; HPCVHighSpec_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(HPCVHighSpec.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Blocked_Freezing_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones}); end
                Respi_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(Respi.(Session_type{sess}).(Mouse_names{mouse}) , Zone_Blocked_Freezing_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones});
                
            end
            disp(Mouse_names{mouse})
        end
    end
end


n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=2%:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            for zones=1:5
                
                if size(Data(OBSpec_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones}),1)==1
                    DATA.OBSpec_Freeze.(Session_type{sess}){zones}{n}(mouse,:) = Data(OBSpec_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones});
                else
                    DATA.OBSpec_Freeze.(Session_type{sess}){zones}{n}(mouse,:) = nanmean(Data(OBSpec_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                end
                try; if size(Data(HPCSpec_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones}),1)==1
                        DATA.HPCSpec_Freeze.(Session_type{sess}){zones}{n}(mouse,:) = Data(HPCSpec_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones});
                    else
                        DATA.HPCSpec_Freeze.(Session_type{sess}){zones}{n}(mouse,:) = nanmean(Data(HPCSpec_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                    end; end
                try; if size(Data(PFCSpec_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones}),1)==1
                        DATA.PFCSpec_Freeze.(Session_type{sess}){zones}{n}(mouse,:) = Data(PFCSpec_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones});
                    else
                        DATA.PFCSpec_Freeze.(Session_type{sess}){zones}{n}(mouse,:) = nanmean(Data(PFCSpec_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                    end; end
                if size(Data(OBHighSpec_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones}),1)==1
                    DATA.OBHighSpec_Freeze.(Session_type{sess}){zones}{n}(mouse,:) = Data(OBHighSpec_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones});
                else
                    DATA.OBHighSpec_Freeze.(Session_type{sess}){zones}{n}(mouse,:) = nanmean(Data(OBHighSpec_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                end
                try; if size(Data(HPCVHighSpec_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones}),1)==1
                        DATA.HPCVHighSpec_Freeze.(Session_type{sess}){zones}{n}(mouse,:) = Data(HPCVHighSpec_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones});
                    else
                        DATA.HPCVHighSpec_Freeze.(Session_type{sess}){zones}{n}(mouse,:) = nanmean(Data(HPCVHighSpec_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                    end; end
                DATA.Respi_Freeze.(Session_type{sess}){zones}{n}(mouse) = nanmean(Data(Respi_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                DATA.HeartRate_Freeze.(Session_type{sess}){zones}{n}(mouse) = nanmean(Data(HeartRate_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                DATA.Ripples_Freeze.(Session_type{sess}){zones}{n}(mouse) = Ripples_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones}+1;
                DATA.RipplesDensity_Freeze.(Session_type{sess}){zones}{n}(mouse) = RipplesDensity_Freeze.(Session_type{sess}).(Mouse_names{mouse}){zones};
                
                DATA.OBSpec_Active.(Session_type{sess}){zones}{n}(mouse,:) = nanmean(Data(OBSpec_Active.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                try; DATA.HPCSpec_Active.(Session_type{sess}){zones}{n}(mouse,:) = nanmean(Data(HPCSpec_Active.(Session_type{sess}).(Mouse_names{mouse}){zones})); end
                try; DATA.PFCSpec_Active.(Session_type{sess}){zones}{n}(mouse,:) = nanmean(Data(PFCSpec_Active.(Session_type{sess}).(Mouse_names{mouse}){zones}));  end
                try; DATA.OBHighSpec_Active.(Session_type{sess}){zones}{n}(mouse,:) = nanmean(Data(OBHighSpec_Active.(Session_type{sess}).(Mouse_names{mouse}){zones}));  end
                try; DATA.HPCVHighSpec_Active.(Session_type{sess}){zones}{n}(mouse,:) = nanmean(Data(HPCVHighSpec_Active.(Session_type{sess}).(Mouse_names{mouse}){zones}));  end
                DATA.Respi_Active.(Session_type{sess}){zones}{n}(mouse) = nanmean(Data(Respi_Active.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                DATA.HeartRate_Active.(Session_type{sess}){zones}{n}(mouse) = nanmean(Data(HeartRate_Active.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                DATA.Ripples_Active.(Session_type{sess}){zones}{n}(mouse) = Ripples_Active.(Session_type{sess}).(Mouse_names{mouse}){zones}+1;
                DATA.RipplesDensity_Active.(Session_type{sess}){zones}{n}(mouse) = RipplesDensity_Active.(Session_type{sess}).(Mouse_names{mouse}){zones};
                
                % blocked epoch
                if size(Data(OBSpec_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones}),1)==1
                    DATA.OBSpec_Freeze_Blocked.(Session_type{sess}){zones}{n}(mouse,:) = Data(OBSpec_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones});
                else
                    DATA.OBSpec_Freeze_Blocked.(Session_type{sess}){zones}{n}(mouse,:) = nanmean(Data(OBSpec_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                end
                try; if size(Data(HPCSpec_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones}),1)==1
                        DATA.HPCSpec_Freeze_Blocked.(Session_type{sess}){zones}{n}(mouse,:) = Data(HPCSpec_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones});
                    else
                        DATA.HPCSpec_Freeze_Blocked.(Session_type{sess}){zones}{n}(mouse,:) = nanmean(Data(HPCSpec_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                    end; end
                try; if size(Data(PFCSpec_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones}),1)==1
                        DATA.PFCSpec_Freeze_Blocked.(Session_type{sess}){zones}{n}(mouse,:) = Data(PFCSpec_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones});
                    else
                        DATA.PFCSpec_Freeze_Blocked.(Session_type{sess}){zones}{n}(mouse,:) = nanmean(Data(PFCSpec_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                    end; end
                if size(Data(OBHighSpec_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones}),1)==1
                    DATA.OBHighSpec_Freeze_Blocked.(Session_type{sess}){zones}{n}(mouse,:) = Data(OBHighSpec_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones});
                else
                    DATA.OBHighSpec_Freeze_Blocked.(Session_type{sess}){zones}{n}(mouse,:) = nanmean(Data(OBHighSpec_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                end
                if size(Data(HPCVHighSpec_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones}),1)==1
                    DATA.HPCVHighSpec_Freeze_Blocked.(Session_type{sess}){zones}{n}(mouse,:) = Data(HPCVHighSpec_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones});
                else
                    DATA.HPCVHighSpec_Freeze_Blocked.(Session_type{sess}){zones}{n}(mouse,:) = nanmean(Data(HPCVHighSpec_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                end
                DATA.Respi_Freeze_Blocked.(Session_type{sess}){zones}{n}(mouse) = nanmean(Data(Respi_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                
                
                try
                    DATA.PFCSpec_Freeze.(Session_type{sess}){zones}{n}(DATA.PFCSpec_Freeze.(Session_type{sess}){zones}{n}==0) = NaN;
                    DATA.PFCSpec_Active.(Session_type{sess}){zones}{n}(DATA.PFCSpec_Active.(Session_type{sess}){zones}{n}==0) = NaN;
                    DATA.PFCSpec_Freeze_Blocked.(Session_type{sess}){zones}{n}(DATA.PFCSpec_Freeze_Blocked.(Session_type{sess}){zones}{n}==0) = NaN;
                end
            end
        end
    end
    n=n+1;
end


figure; p=1; sess=2;
for zones=[1 4 3 5 2]
    
    subplot(2,5,p)
    MakeSpreadAndBoxPlot2_SB(DATA.Respi_Freeze.(Session_type{sess}){zones} , Cols , X , NoLegends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('Frequency (Hz)'); u=text(-1,6,'Freezing','FontSize',15,'FontWeight','bold','Rotation',90); end
    ylim([3 12]); title(Zones_Lab{p})
   
    subplot(2,5,p+5)
    MakeSpreadAndBoxPlot2_SB(DATA.Respi_Active.(Session_type{sess}){zones} , Cols , X , Legends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('Frequency (Hz)');  u=text(-1,6,'Active','FontSize',15,'FontWeight','bold','Rotation',90); end
    ylim([3 12])
       
    p=p+1;
end
a=sgtitle('Respiratory rate, Unblocked, Cond sessions'); a.FontSize=20;


figure; p=1; sess=2;
for zones=[1 4 3 5 2]
    
    subplot(2,5,p)
    MakeSpreadAndBoxPlot2_SB(DATA.HeartRate_Freeze.(Session_type{sess}){zones} , Cols , X , NoLegends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('Frequency (Hz)'); u=text(-1.5,10.5,'Freezing','FontSize',15,'FontWeight','bold','Rotation',90); end
    ylim([9 14]); title(Zones_Lab{p})
    
    subplot(2,5,p+5)
    MakeSpreadAndBoxPlot2_SB(DATA.HeartRate_Active.(Session_type{sess}){zones} , Cols , X , Legends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('Frequency (Hz)');  u=text(-1.5,10.5,'Active','FontSize',15,'FontWeight','bold','Rotation',90); end
    ylim([9 14])
    
    p=p+1;
end
a=sgtitle('Heart rate, Unblocked, Cond sessions'); a.FontSize=20;


figure; p=1; sess=2;
for zones=[1 4 3 5 2]
    
    subplot(2,5,p)
    MakeSpreadAndBoxPlot2_SB(DATA.Ripples_Freeze.(Session_type{sess}){zones}, Cols , X , NoLegends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('#'); u=text(-1.,7,'Ripples total numb.','FontSize',15,'FontWeight','bold','Rotation',90); end
    ylim([0 220]); title(Zones_Lab{p})
    set(gca , 'Yscale', 'log')
    
    subplot(2,5,p+5)
    MakeSpreadAndBoxPlot2_SB(DATA.RipplesDensity_Freeze.(Session_type{sess}){zones} , Cols , X , Legends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('Frequency (Hz)'); u=text(-1.,.3,'Ripples density','FontSize',15,'FontWeight','bold','Rotation',90); end
    ylim([0 1.4])
    
    p=p+1;
end
a=sgtitle('Ripples, Freezing when unblocked, cond sessions'); a.FontSize=20;


%% mean spetrums
% OB
load('B_Low_Spectrum.mat'); RangeLow = Spectro{3};
figure; p=1; sess=2;
for zones=[1 4 3 5 2]
    
    subplot(2,5,p)
    Plot_MeanSpectrumForMice_BM(DATA.OBSpec_Freeze.(Session_type{sess}){zones}{1} , 'color' ,  [0.3, 0.745, 0.93]);
    Plot_MeanSpectrumForMice_BM(DATA.OBSpec_Freeze.(Session_type{sess}){zones}{2} , 'color' ,  [0.85, 0.325, 0.098]);
    ylim([0 1.2]), xlim([0 10]); makepretty; title(Zones_Lab{p})
    if zones==1; ylabel('Power (a.u.)'); u=text(-4.5,.4,'Freezing.','FontSize',15,'FontWeight','bold','Rotation',90);
    f=get(gca,'Children'); legend([f(8),f(4)],'Saline','DZP'); end
    
    subplot(2,5,p+5)
    Plot_MeanSpectrumForMice_BM(DATA.OBSpec_Active.(Session_type{sess}){zones}{1} , 'color' ,  [0.3, 0.745, 0.93]);
    Plot_MeanSpectrumForMice_BM(DATA.OBSpec_Active.(Session_type{sess}){zones}{2} , 'color' ,  [0.85, 0.325, 0.098]);
    ylim([0 .8]), xlim([0 20]); makepretty; xlabel('Frequency (Hz)')
    if zones==1; ylabel('Power (a.u.)'); u=text(-8.5,.4,'Active.','FontSize',15,'FontWeight','bold','Rotation',90); end
    
    p=p+1;
end
a=sgtitle('OB mean spectrum, unblocked, cond sessions'); a.FontSize=20;



figure; p=1; sess=2;
for zones=[1 4 3 5 2]
    
    try
        subplot(1,5,p)
        Plot_MeanSpectrumForMice_BM(DATA.OBSpec_Freeze_Blocked.(Session_type{sess}){zones}{1} , 'color' , [0.3, 0.745, 0.93]);
        Plot_MeanSpectrumForMice_BM(DATA.OBSpec_Freeze_Blocked.(Session_type{sess}){zones}{2} , 'color' ,  [0.85, 0.325, 0.098]);
        ylim([0 1.2]), xlim([0 10]); makepretty; xlabel('Frequency (Hz)')
        if zones==1; ylabel('Power (a.u.)'); u=text(-4.5,.4,'Blocked.','FontSize',15,'FontWeight','bold','Rotation',90); end
    end
    
    p=p+1;
end
a=sgtitle('OB mean spectrum, freezing, cond sessions'); a.FontSize=20;




% HPC
RangeLow = linspace(0.1526,20,261);
figure; p=1; sess=2;
for zones=[1 4 3 5 2]
    
    subplot(2,5,p)
    thr= 39;
    Data_to_use = DATA.HPCSpec_Freeze.(Session_type{sess}){zones}{1}./max(DATA.HPCSpec_Freeze.(Session_type{sess}){zones}{1}(:,thr:end)')';
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp = nanmean(Data_to_use);
    h=shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
    color= [0.3, 0.745, 0.93]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
    [~,d]=max(nanmean(Data_to_use(:,39:end)));
    a = vline(RangeLow(d+thr-1),'--'); set(a,'Color',color)
    
    Data_to_use = DATA.HPCSpec_Freeze.(Session_type{sess}){zones}{2}./max(DATA.HPCSpec_Freeze.(Session_type{sess}){zones}{2}(:,thr:end)')';
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp = nanmean(Data_to_use);
    h=shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
    color= [0.85, 0.325, 0.098]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
    [~,d]=max(nanmean(Data_to_use(:,39:end)));
    a = vline(RangeLow(d+thr-1),'--'); set(a,'Color',color)
    
    ylim([0 1.2]), xlim([0 15]); makepretty; title(Zones_Lab{p})
    if zones==1; ylabel('Power (a.u.)'); u=text(-4.5,.4,'Freezing.','FontSize',15,'FontWeight','bold','Rotation',90);
        f=get(gca,'Children'); legend([f(8),f(4)],'Saline','DZP'); end
    
    
    subplot(2,5,p+5)
    thr= 65;
    Data_to_use = DATA.HPCSpec_Active.(Session_type{sess}){zones}{1}./max(DATA.HPCSpec_Active.(Session_type{sess}){zones}{1}(:,thr:end)')';
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp = nanmean(Data_to_use);
    h=shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
    color= [0.3, 0.745, 0.93]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
    [~,d]=max(nanmean(Data_to_use(:,39:end)));
    a = vline(RangeLow(d+thr-1),'--'); set(a,'Color',color)
    
    Data_to_use = DATA.HPCSpec_Active.(Session_type{sess}){zones}{2}./max(DATA.HPCSpec_Active.(Session_type{sess}){zones}{2}(:,thr:end)')';
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp = nanmean(Data_to_use);
    h=shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
    color= [0.85, 0.325, 0.098]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
    [~,d]=max(nanmean(Data_to_use(:,39:end)));
    a = vline(RangeLow(d+thr-1),'--'); set(a,'Color',color)
    ylim([0 1]), xlim([0 15]); makepretty; xlabel('Frequency (Hz)')
    if zones==1; ylabel('Power (a.u.)'); u=text(-8.5,.4,'Active.','FontSize',15,'FontWeight','bold','Rotation',90); end
    
    p=p+1;
end
a=sgtitle('HPC mean spectrum, unblocked, cond sessions'); a.FontSize=20;


figure; p=1; sess=2;
for zones=[1 4 3 5 2]
    
    try
        subplot(1,5,p)
        
        thr= 39;
        Data_to_use = DATA.HPCSpec_Freeze_Blocked.(Session_type{sess}){zones}{1}./max(DATA.HPCSpec_Freeze_Blocked.(Session_type{sess}){zones}{1}(:,thr:end)')';
        Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
        clear Mean_All_Sp; Mean_All_Sp = nanmean(Data_to_use);
        h=shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
        color= [0.3, 0.745, 0.93]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
        [~,d]=max(nanmean(Data_to_use(:,39:end)));
        a = vline(RangeLow(d+thr-1),'--'); set(a,'Color',color)
        
        Data_to_use = DATA.HPCSpec_Freeze_Blocked.(Session_type{sess}){zones}{2}./max(DATA.HPCSpec_Freeze_Blocked.(Session_type{sess}){zones}{2}(:,thr:end)')';
        Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
        clear Mean_All_Sp; Mean_All_Sp = nanmean(Data_to_use);
        h=shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
        color= [0.85, 0.325, 0.098]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
        [~,d]=max(nanmean(Data_to_use(:,39:end)));
        a = vline(RangeLow(d+thr-1),'--'); set(a,'Color',color)
        
        ylim([0 1.2]), xlim([0 10]); makepretty; xlabel('Frequency (Hz)')
        if zones==1; ylabel('Power (a.u.)'); u=text(-4.5,.4,'Blocked.','FontSize',15,'FontWeight','bold','Rotation',90); end
    end
    
    p=p+1;
end
a=sgtitle('HPC mean spectrum, freezing, cond sessions'); a.FontSize=20;


% PFC
figure; p=1; sess=2;
for zones=[1 4 3 5 2]
    
    subplot(2,5,p)
    Plot_MeanSpectrumForMice_BM(RangeLow.*DATA.PFCSpec_Freeze.(Session_type{sess}){zones}{1} , 'color' , [0.3, 0.745, 0.93], 'threshold' , 26);
    Plot_MeanSpectrumForMice_BM(RangeLow.*DATA.PFCSpec_Freeze.(Session_type{sess}){zones}{2} , 'color' , [0.85, 0.325, 0.098], 'threshold' , 26);
    ylim([0 1.2]), xlim([0 10]); makepretty; title(Zones_Lab{p})
    if zones==1; ylabel('Power (a.u.)'); u=text(-4.5,.4,'Freezing.','FontSize',15,'FontWeight','bold','Rotation',90);
    f=get(gca,'Children'); legend([f(8),f(4)],'Saline','DZP'); end
    
    subplot(2,5,p+5)
    Plot_MeanSpectrumForMice_BM(RangeLow.*DATA.PFCSpec_Active.(Session_type{sess}){zones}{1} , 'color' ,   [0.3, 0.745, 0.93], 'threshold' , 26);
    Plot_MeanSpectrumForMice_BM(RangeLow.*DATA.PFCSpec_Active.(Session_type{sess}){zones}{2} , 'color' ,   [0.85, 0.325, 0.098], 'threshold' , 26);
    ylim([0 1]), xlim([0 20]); makepretty; xlabel('Frequency (Hz)')
    if zones==1; ylabel('Power (a.u.)'); u=text(-8.5,.4,'Active.','FontSize',15,'FontWeight','bold','Rotation',90); end
    
    p=p+1;
end
a=sgtitle('PFC mean spectrum, unblocked, cond sessions'); a.FontSize=20;



figure; p=1; sess=2;
for zones=[1 4 3 5 2]
    
    try
        subplot(1,5,p)
        Plot_MeanSpectrumForMice_BM(DATA.PFCSpec_Freeze_Blocked.(Session_type{sess}){zones}{1} , 'color' ,   [0.3, 0.745, 0.93], 'threshold' , 26);
        Plot_MeanSpectrumForMice_BM(DATA.PFCSpec_Freeze_Blocked.(Session_type{sess}){zones}{2} , 'color' ,   [0.85, 0.325, 0.098], 'threshold' , 26);
        ylim([0 1.2]), xlim([0 10]); makepretty; xlabel('Frequency (Hz)')
        if zones==1; ylabel('Power (a.u.)'); u=text(-4.5,.4,'Blocked.','FontSize',15,'FontWeight','bold','Rotation',90); end
    end
    
    p=p+1;
end
a=sgtitle('PFC mean spectrum, freezing, cond sessions'); a.FontSize=20;



% OB High
load('B_High_Spectrum.mat'); RangeHigh = Spectro{3};
figure; p=1; sess=2;
for zones=[1 4 3 5 2]
    
    subplot(2,5,p)
    Plot_MeanSpectrumForMice_BM(DATA.OBHighSpec_Freeze.(Session_type{sess}){zones}{1} , 'color' ,  [0.3, 0.745, 0.93]);
    Plot_MeanSpectrumForMice_BM(DATA.OBHighSpec_Freeze.(Session_type{sess}){zones}{2} , 'color' ,  [0.85, 0.325, 0.098]);
    ylim([0 1.2]), xlim([30 100]); makepretty; title(Zones_Lab{p})
    if zones==1; ylabel('Power (a.u.)'); u=text(-4.5,.4,'Freezing.','FontSize',15,'FontWeight','bold','Rotation',90);
    f=get(gca,'Children'); legend([f(8),f(4)],'Saline','DZP'); end
    
    subplot(2,5,p+5)
    Plot_MeanSpectrumForMice_BM(DATA.OBHighSpec_Active.(Session_type{sess}){zones}{1} , 'color' ,  [0.3, 0.745, 0.93]);
    Plot_MeanSpectrumForMice_BM(DATA.OBHighSpec_Active.(Session_type{sess}){zones}{2} , 'color' ,  [0.85, 0.325, 0.098]);
    ylim([0 1.2]), xlim([30 100]); makepretty; xlabel('Frequency (Hz)')
    if zones==1; ylabel('Power (a.u.)'); u=text(-8.5,.4,'Active.','FontSize',15,'FontWeight','bold','Rotation',90); end
    
    p=p+1;
end
a=sgtitle('OB mean spectrum, unblocked, cond sessions'); a.FontSize=20;



figure; p=1; sess=2;
for zones=[1 4 3 5 2]
    
    try
        subplot(1,5,p)
        Plot_MeanSpectrumForMice_BM(DATA.OBHighSpec_Freeze_Blocked.(Session_type{sess}){zones}{1} , 'color' , [0.3, 0.745, 0.93]);
        Plot_MeanSpectrumForMice_BM(DATA.OBHighSpec_Freeze_Blocked.(Session_type{sess}){zones}{2} , 'color' ,  [0.85, 0.325, 0.098]);
        ylim([0 1.2]), xlim([30 100]); makepretty; xlabel('Frequency (Hz)')
        if zones==1; ylabel('Power (a.u.)'); u=text(-4.5,.4,'Blocked.','FontSize',15,'FontWeight','bold','Rotation',90); end
    end
    
    p=p+1;
end
a=sgtitle('OB mean spectrum, freezing, cond sessions'); a.FontSize=20;




% HPC Vhigh
load('H_VHigh_Spectrum.mat'); RangeVHigh = Spectro{3};
figure; p=1; sess=2;
for zones=[1 4 3 5 2]
    
    subplot(2,5,p)
    Plot_MeanSpectrumForMice_BM(RangeVHigh.*DATA.HPCVHighSpec_Freeze.(Session_type{sess}){zones}{1} , 'color' ,  [0.3, 0.745, 0.93]);
    Plot_MeanSpectrumForMice_BM(RangeVHigh.*DATA.HPCVHighSpec_Freeze.(Session_type{sess}){zones}{2} , 'color' ,  [0.85, 0.325, 0.098]);
    ylim([0 5]), xlim([20 250]); makepretty; title(Zones_Lab{p})
    if zones==1; ylabel('Power (a.u.)'); u=text(-4.5,.4,'Freezing.','FontSize',15,'FontWeight','bold','Rotation',90);
    f=get(gca,'Children'); legend([f(8),f(4)],'Saline','DZP'); end
    
    subplot(2,5,p+5)
    Plot_MeanSpectrumForMice_BM(RangeVHigh.*DATA.HPCVHighSpec_Active.(Session_type{sess}){zones}{1} , 'color' ,  [0.3, 0.745, 0.93]);
    Plot_MeanSpectrumForMice_BM(RangeVHigh.*DATA.HPCVHighSpec_Active.(Session_type{sess}){zones}{2} , 'color' ,  [0.85, 0.325, 0.098]);
    ylim([0 5]), xlim([20 250]); makepretty; xlabel('Frequency (Hz)')
    if zones==1; ylabel('Power (a.u.)'); u=text(-8.5,.4,'Active.','FontSize',15,'FontWeight','bold','Rotation',90); end
    
    p=p+1;
end
a=sgtitle('HPC VHigh mean spectrum, unblocked, cond sessions'); a.FontSize=20;



figure; p=1; sess=2;
for zones=[1 4 3 5 2]
    
    try
        subplot(1,5,p)
        Plot_MeanSpectrumForMice_BM(RangeVHigh.*DATA.HPCVHighSpec_Freeze_Blocked.(Session_type{sess}){zones}{1} , 'color' , [0.3, 0.745, 0.93]);
        Plot_MeanSpectrumForMice_BM(RangeVHigh.*DATA.HPCVHighSpec_Freeze_Blocked.(Session_type{sess}){zones}{2} , 'color' ,  [0.85, 0.325, 0.098]);
        ylim([0 5]), xlim([20 250]); makepretty; xlabel('Frequency (Hz)')
        if zones==1; ylabel('Power (a.u.)'); u=text(-4.5,.4,'Blocked.','FontSize',15,'FontWeight','bold','Rotation',90); end
    end
    
    p=p+1;
end
a=sgtitle('HPC VHigh mean spectrum, freezing, cond sessions'); a.FontSize=20;










