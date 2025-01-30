

clear all

GetEmbReactMiceFolderList_BM

Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long','Saline1','Saline2','DZP1','DZP2','RipInhib','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired'};
Type={'All','Blocked','Unblocked'};

for group=[5 6 13 16]
    Drugs_Groups_UMaze_BM
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(Session_type)
            
            if sess==1; Sess_To_use=FearSess;
            elseif sess==2; Sess_To_use=CondSess;
            elseif sess==3; Sess_To_use=ExtSess;
            elseif sess==4; Sess_To_use=CondPreSess;
            elseif sess==5 Sess_To_use=CondPostSess;
            elseif sess==6 Sess_To_use=TestPreSess;
            elseif sess==7 Sess_To_use=TestPostSess;
            end
            
            Speed.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(Sess_To_use.(Mouse_names{mouse}),'speed');
            Ripples.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(Sess_To_use.(Mouse_names{mouse}),'ripples');
            
            BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(Sess_To_use.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
            TotEpoch.(Mouse_names{mouse}).(Session_type{sess}) = intervalSet(0,max(Range(Speed.(Mouse_names{mouse}).(Session_type{sess}))));
            UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) = TotEpoch.(Mouse_names{mouse}).(Session_type{sess}) - BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess});
            FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(Sess_To_use.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
            ActiveEpoch.(Mouse_names{mouse}).(Session_type{sess}) = TotEpoch.(Mouse_names{mouse}).(Session_type{sess}) - FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess});
            
            Speed_Active.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Speed.(Mouse_names{mouse}).(Session_type{sess}) , ActiveEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            
            ZoneEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(Sess_To_use.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
            ShockZoneEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ZoneEpoch.(Mouse_names{mouse}).(Session_type{sess}){1};
            SafeZoneEpoch.(Mouse_names{mouse}).(Session_type{sess}) = or(ZoneEpoch.(Mouse_names{mouse}).(Session_type{sess}){2},ZoneEpoch.(Mouse_names{mouse}).(Session_type{sess}){5});
            Blocked_Shock.(Mouse_names{mouse}).(Session_type{sess}) = and(ShockZoneEpoch.(Mouse_names{mouse}).(Session_type{sess}) , BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Blocked_Safe.(Mouse_names{mouse}).(Session_type{sess}) = and(SafeZoneEpoch.(Mouse_names{mouse}).(Session_type{sess}) , BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Unblocked_Shock.(Mouse_names{mouse}).(Session_type{sess}) = and(ShockZoneEpoch.(Mouse_names{mouse}).(Session_type{sess}) , UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Unblocked_Safe.(Mouse_names{mouse}).(Session_type{sess}) = and(SafeZoneEpoch.(Mouse_names{mouse}).(Session_type{sess}) , UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            
            Freeze_BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) = and(FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}) , BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Freeze_UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) = and(FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}) , UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Freeze_ShockEpoch.(Mouse_names{mouse}).(Session_type{sess}) = and(FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}) , ShockZoneEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Freeze_SafeEpoch.(Mouse_names{mouse}).(Session_type{sess}) = and(FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}) , SafeZoneEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Freeze_Blocked_ShockEpoch.(Mouse_names{mouse}).(Session_type{sess}) = and(Freeze_BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , ShockZoneEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Freeze_Blocked_SafeEpoch.(Mouse_names{mouse}).(Session_type{sess}) = and(Freeze_BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , SafeZoneEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Freeze_Unblocked_ShockEpoch.(Mouse_names{mouse}).(Session_type{sess}) = and(Freeze_UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , ShockZoneEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Freeze_Unblocked_SafeEpoch.(Mouse_names{mouse}).(Session_type{sess}) = and(Freeze_UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , SafeZoneEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            
            Speed_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Speed_Active.(Mouse_names{mouse}).(Session_type{sess}) , BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Speed_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Speed_Active.(Mouse_names{mouse}).(Session_type{sess}) , UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            
            Speed_Blocked_Shock.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Speed_Active.(Mouse_names{mouse}).(Session_type{sess}) , Blocked_Shock.(Mouse_names{mouse}).(Session_type{sess}));
            Speed_Blocked_Safe.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Speed_Active.(Mouse_names{mouse}).(Session_type{sess}) , Blocked_Safe.(Mouse_names{mouse}).(Session_type{sess}));
            Speed_Unblocked_Shock.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Speed_Active.(Mouse_names{mouse}).(Session_type{sess}) , Unblocked_Shock.(Mouse_names{mouse}).(Session_type{sess}));
            Speed_Unblocked_Safe.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Speed_Active.(Mouse_names{mouse}).(Session_type{sess}) , Unblocked_Safe.(Mouse_names{mouse}).(Session_type{sess}));
            
            Ripples_Freezing.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Ripples.(Mouse_names{mouse}).(Session_type{sess}) , FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Ripples_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Ripples.(Mouse_names{mouse}).(Session_type{sess}) , BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Ripples_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Ripples.(Mouse_names{mouse}).(Session_type{sess}) , UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Ripples_Freezing_Shock.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Ripples.(Mouse_names{mouse}).(Session_type{sess}) , Freeze_ShockEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Ripples_Freezing_Safe.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Ripples.(Mouse_names{mouse}).(Session_type{sess}) , Freeze_SafeEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            
            Ripples_Blocked_Freeze.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Ripples_Freezing.(Mouse_names{mouse}).(Session_type{sess}) , BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Ripples_Unblocked_Freeze.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Ripples_Freezing.(Mouse_names{mouse}).(Session_type{sess}) , UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Ripples_Blocked_Shock.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Ripples.(Mouse_names{mouse}).(Session_type{sess}) , Blocked_Shock.(Mouse_names{mouse}).(Session_type{sess}));
            Ripples_Blocked_Safe.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Ripples.(Mouse_names{mouse}).(Session_type{sess}) , Blocked_Safe.(Mouse_names{mouse}).(Session_type{sess}));
            Ripples_Unblocked_Shock.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Ripples.(Mouse_names{mouse}).(Session_type{sess}) , Unblocked_Shock.(Mouse_names{mouse}).(Session_type{sess}));
            Ripples_Unblocked_Safe.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Ripples.(Mouse_names{mouse}).(Session_type{sess}) , Unblocked_Safe.(Mouse_names{mouse}).(Session_type{sess}));
            
        end
        disp(Mouse_names{mouse})
    end
end


for sess=1:length(Session_type)
    n=1;
    for group=[5 6 16 13]
        Drugs_Groups_UMaze_BM
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            MeanSpeed.(Session_type{sess}){n}(mouse) = nanmean(Data(Speed_Active.(Mouse_names{mouse}).(Session_type{sess})));
            MeanSpeed_Blocked.(Session_type{sess}){n}(mouse) = nanmean(Data(Speed_Blocked.(Mouse_names{mouse}).(Session_type{sess})));
            MeanSpeed_Unblocked.(Session_type{sess}){n}(mouse) = nanmean(Data(Speed_Unblocked.(Mouse_names{mouse}).(Session_type{sess})));
            MeanSpeed_Blocked_Shock.(Session_type{sess}){n}(mouse) = nanmean(Data(Speed_Blocked_Shock.(Mouse_names{mouse}).(Session_type{sess})));
            MeanSpeed_Blocked_Safe.(Session_type{sess}){n}(mouse) = nanmean(Data(Speed_Blocked_Safe.(Mouse_names{mouse}).(Session_type{sess})));
            MeanSpeed_Unblocked_Shock.(Session_type{sess}){n}(mouse) = nanmean(Data(Speed_Unblocked_Shock.(Mouse_names{mouse}).(Session_type{sess})));
            MeanSpeed_Unblocked_Safe.(Session_type{sess}){n}(mouse) = nanmean(Data(Speed_Unblocked_Safe.(Mouse_names{mouse}).(Session_type{sess})));
            
            try
                TotalRipplesNumb.(Session_type{sess}){n}(mouse) = length(Range(Ripples.(Mouse_names{mouse}).(Session_type{sess})));
                TotalRipplesNumb_Freezing.(Session_type{sess}){n}(mouse)  = length(Range(Ripples_Freezing.(Mouse_names{mouse}).(Session_type{sess})));
                TotalRipplesNumb_Blocked.(Session_type{sess}){n}(mouse) = length(Range(Ripples_Blocked.(Mouse_names{mouse}).(Session_type{sess})));
                TotalRipplesNumb_Unblocked.(Session_type{sess}){n}(mouse) = length(Range(Ripples_Unblocked.(Mouse_names{mouse}).(Session_type{sess})));
                TotalRipplesNumb_Freeze_Shock.(Session_type{sess}){n}(mouse) = length(Range(Ripples_Freezing_Shock.(Mouse_names{mouse}).(Session_type{sess})));
                TotalRipplesNumb_Freeze_Safe.(Session_type{sess}){n}(mouse) = length(Range(Ripples_Freezing_Safe.(Mouse_names{mouse}).(Session_type{sess})));
                TotalRipplesNumb_Freeze_Blocked.(Session_type{sess}){n}(mouse) = length(Range(Ripples_Blocked_Freeze.(Mouse_names{mouse}).(Session_type{sess})));
                TotalRipplesNumb_Freeze_Unblocked.(Session_type{sess}){n}(mouse) = length(Range(Ripples_Unblocked_Freeze.(Mouse_names{mouse}).(Session_type{sess})));
            end
            TotalRipplesNumb.(Session_type{sess}){n}(TotalRipplesNumb.(Session_type{sess}){n}==0)=NaN;
            TotalRipplesNumb_Freezing.(Session_type{sess}){n}(TotalRipplesNumb_Freezing.(Session_type{sess}){n}==0)=NaN;
            TotalRipplesNumb_Blocked.(Session_type{sess}){n}(TotalRipplesNumb_Blocked.(Session_type{sess}){n}==0)=NaN;
            TotalRipplesNumb_Unblocked.(Session_type{sess}){n}(TotalRipplesNumb_Unblocked.(Session_type{sess}){n}==0)=NaN;
            TotalRipplesNumb_Freeze_Shock.(Session_type{sess}){n}(TotalRipplesNumb_Freeze_Shock.(Session_type{sess}){n}==0)=NaN;
            TotalRipplesNumb_Freeze_Safe.(Session_type{sess}){n}(TotalRipplesNumb_Freeze_Safe.(Session_type{sess}){n}==0)=NaN;
            TotalRipplesNumb_Freeze_Blocked.(Session_type{sess}){n}(TotalRipplesNumb_Freeze_Blocked.(Session_type{sess}){n}==0)=NaN;
            TotalRipplesNumb_Freeze_Unblocked.(Session_type{sess}){n}(TotalRipplesNumb_Freeze_Unblocked.(Session_type{sess}){n}==0)=NaN;
            
            FreezeDuration_All.(Session_type{sess}){n}(mouse) = sum(Stop(FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}))-Start(FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess})))/1e4;
            FreezeDuration_Blocked.(Session_type{sess}){n}(mouse) = sum(Stop(Freeze_BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}))-Start(Freeze_BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess})))/1e4;
            FreezeDuration_Unblocked.(Session_type{sess}){n}(mouse) = sum(Stop(Freeze_UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}))-Start(Freeze_UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess})))/1e4;
            FreezeDuration_Shock.(Session_type{sess}){n}(mouse) = sum(Stop(Freeze_ShockEpoch.(Mouse_names{mouse}).(Session_type{sess}))-Start(Freeze_ShockEpoch.(Mouse_names{mouse}).(Session_type{sess})))/1e4;
            FreezeDuration_Safe.(Session_type{sess}){n}(mouse) = sum(Stop(Freeze_SafeEpoch.(Mouse_names{mouse}).(Session_type{sess}))-Start(Freeze_SafeEpoch.(Mouse_names{mouse}).(Session_type{sess})))/1e4;

            FreezeDuration_Blocked_Shock.(Session_type{sess}){n}(mouse) = sum(Stop(Freeze_Blocked_ShockEpoch.(Mouse_names{mouse}).(Session_type{sess}))-Start(Freeze_Blocked_ShockEpoch.(Mouse_names{mouse}).(Session_type{sess})))/1e4;
            FreezeDuration_Blocked_Safe.(Session_type{sess}){n}(mouse) = sum(Stop(Freeze_Blocked_SafeEpoch.(Mouse_names{mouse}).(Session_type{sess}))-Start(Freeze_Blocked_SafeEpoch.(Mouse_names{mouse}).(Session_type{sess})))/1e4;
            FreezeDuration_Unblocked_Shock.(Session_type{sess}){n}(mouse) = sum(Stop(Freeze_Unblocked_ShockEpoch.(Mouse_names{mouse}).(Session_type{sess}))-Start(Freeze_Unblocked_ShockEpoch.(Mouse_names{mouse}).(Session_type{sess})))/1e4;
            FreezeDuration_Unblocked_Safe.(Session_type{sess}){n}(mouse) = sum(Stop(Freeze_Unblocked_SafeEpoch.(Mouse_names{mouse}).(Session_type{sess}))-Start(Freeze_Unblocked_SafeEpoch.(Mouse_names{mouse}).(Session_type{sess})))/1e4;
            
        end
        n=n+1;
    end
end

Cols = {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.6350, 0.0780, 0.1840],[0.75, 0.75, 0]};
X = [1:4];
Legends = {'Saline','DZP','RipControl','RipInhib'};
NoLegends = {'','','',''};

%% Speed figures
figure; n=1;
for sess=[6 4 5 7]
    subplot(3,4,n)
    MakeSpreadAndBoxPlot2_SB(MeanSpeed.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('speed (cm/s)'); end
    title(Session_type{sess})
    if n==1; u=text(-1,2,'Total'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 10])
    
    subplot(3,4,n+4)
    MakeSpreadAndBoxPlot2_SB(MeanSpeed_Blocked.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('speed (cm/s)'); end
    if n==1; u=text(-1,2,'Blocked'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 10])
    
    subplot(3,4,n+8)
    MakeSpreadAndBoxPlot2_SB(MeanSpeed_Unblocked.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('speed (cm/s)'); end
    if n==1; u=text(-1,2,'Free'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 10])
    
    n=n+1;
end
a=suptitle('Speed analysis, UMaze experiments'); a.FontSize=20;

figure; n=1;
for sess=[6 4 5 7]
    subplot(4,4,n)
    MakeSpreadAndBoxPlot2_SB(MeanSpeed_Blocked_Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('speed (cm/s)'); end
    title(Session_type{sess})
    if n==1; u=text(-1,2,'Blocked shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 10])
    
    subplot(4,4,n+4)
    MakeSpreadAndBoxPlot2_SB(MeanSpeed_Blocked_Safe.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('speed (cm/s)'); end
    if n==1; u=text(-1,2,'Blocked safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 10])
    
    subplot(4,4,n+8)
    MakeSpreadAndBoxPlot2_SB(MeanSpeed_Unblocked_Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('speed (cm/s)'); end
    if n==1; u=text(-1,2,'Free shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 15])
       
    subplot(4,4,n+12)
    MakeSpreadAndBoxPlot2_SB(MeanSpeed_Unblocked_Safe.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('speed (cm/s)'); end
    if n==1; u=text(-1,2,'Free safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 10])
    
    n=n+1;
end
a=suptitle('Speed analysis, UMaze experiments'); a.FontSize=20;


%% Ripples figures
figure; n=1;
for sess=[2 3]
    subplot(2,2,n)
    MakeSpreadAndBoxPlot2_SB(TotalRipplesNumb.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('ripples (#)'); end
    title(Session_type{sess})
    if n==1; u=text(-1,700,'Total'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 1500])
    
    subplot(2,2,n+2)
    MakeSpreadAndBoxPlot2_SB(TotalRipplesNumb_Freezing.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; u=text(-1,200,'Freezing'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    if n==1; ylabel('ripples (#)'); end
    ylim([0 600])
    
    n=n+1;
end
a=suptitle('Ripples analysis, UMaze experiments'); a.FontSize=20;



figure; n=1;
for sess=[2 3]
    subplot(2,2,n)
    MakeSpreadAndBoxPlot2_SB(TotalRipplesNumb_Freeze_Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('ripples (#)'); end
    title(Session_type{sess})
    if n==1; u=text(-1,100,'Freezing shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 300])
    
    subplot(2,2,n+2)
    MakeSpreadAndBoxPlot2_SB(TotalRipplesNumb_Freeze_Safe.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; u=text(-1,100,'Freezing safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    if n==1; ylabel('ripples (#)'); end
    ylim([0 300])
    
    n=n+1;
end
a=suptitle('Ripples analysis, UMaze experiments'); a.FontSize=20;


figure; n=1;
for sess=[2 3]
    subplot(2,2,n)
    MakeSpreadAndBoxPlot2_SB(TotalRipplesNumb_Freeze_Blocked.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('ripples (#)'); end
    title(Session_type{sess})
    if n==1; u=text(-1,100,'Blocked'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 400])
    
    subplot(2,2,n+2)
    MakeSpreadAndBoxPlot2_SB(TotalRipplesNumb_Freeze_Unblocked.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('ripples (#)'); end
    title(Session_type{sess})
    if n==1; u=text(-1,100,'Free'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 400])
    
    n=n+1;
end
a=suptitle('Ripples analysis, UMaze experiments'); a.FontSize=20;



%% Freezing duration
figure; n=1;
for sess=[2 3]
    subplot(3,2,n)
    MakeSpreadAndBoxPlot2_SB(FreezeDuration_All.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('time (s)'); end
    title(Session_type{sess})
    if n==1; u=text(-1,1000,'Total'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 3000])
    
    subplot(3,2,n+2)
    MakeSpreadAndBoxPlot2_SB(FreezeDuration_Blocked.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('time (s)'); end
    if n==1; u=text(-1,400,'Blocked'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 1400])
    
    subplot(3,2,n+4)
    MakeSpreadAndBoxPlot2_SB(FreezeDuration_Unblocked.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('time (s)'); end
    if n==1; u=text(-1,500,'Free'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 1700])
    
    n=n+1;
end
a=suptitle('Freezing duration'); a.FontSize=20;


figure; n=1;
for sess=[2 3]
    subplot(3,2,n)
    MakeSpreadAndBoxPlot2_SB(FreezeDuration_All.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('time (s)'); end
    title(Session_type{sess})
    if n==1; u=text(-1,1000,'Total'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 3000])
    
    subplot(3,2,n+2)
    MakeSpreadAndBoxPlot2_SB(FreezeDuration_Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('time (s)'); end
    if n==1; u=text(-1,400,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 1400])
    
    subplot(3,2,n+4)
    MakeSpreadAndBoxPlot2_SB(FreezeDuration_Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('time (s)'); end
    if n==1; u=text(-1,500,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 1700])
    
    n=n+1;
end
a=suptitle('Freezing duration'); a.FontSize=20;












