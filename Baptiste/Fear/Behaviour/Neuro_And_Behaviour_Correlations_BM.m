
clear all

GetEmbReactMiceFolderList_BM
Voltage_UMaze_Drugs_BM
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long'};
Side_ind=[3 5 6];
X = [1:8];
Cols = {[0, 0, 1],[1, 0, 0],[1, 0.5, 0.5],[0, 0.5, 0],[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83],[0.75, 0.225, 0]};
Legends_Drugs ={'SalineSB' 'Chronic Flx' 'Acute Flx' 'Midazolam','Saline_Short','DZP_Short','Saline_Long','DZP_Long'};
NoLegends_Drugs ={'', '', '', '','','','',''};

Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};
for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'respi_freq_BM');
end

Create_Behav_Drugs_BM

for mouse=1:length(Mouse)
    for sess=1:length(Session_type)
        
        RespiFreq.Fz_All.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Data(TSD_DATA.(Session_type{sess}).respi_freq_BM.tsd{mouse,3}));
        RespiFreq.Fz_Shock.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Data(TSD_DATA.(Session_type{sess}).respi_freq_BM.tsd{mouse,5}));
        RespiFreq.Fz_Safe.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Data(TSD_DATA.(Session_type{sess}).respi_freq_BM.tsd{mouse,6}));
        
        Mouse_names{mouse}
    end
end


for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            RespiFreq.Fz.(Drug_Group{group}).(Session_type{sess})(mouse,:) = RespiFreq.Fz_All.(Session_type{sess}).(Mouse_names{mouse});
            RespiFreq.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = RespiFreq.Fz_Shock.(Session_type{sess}).(Mouse_names{mouse});
            RespiFreq.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = RespiFreq.Fz_Safe.(Session_type{sess}).(Mouse_names{mouse});

        end
    end
end

for sess=1:length(Session_type)
    for group=1:length(Drug_Group)
        
        RespiFreq.All.Figure.(Session_type{sess}){group} = RespiFreq.Fz.(Drug_Group{group}).(Session_type{sess});
        RespiFreq.Shock.Figure.(Session_type{sess}){group} = RespiFreq.Shock.(Drug_Group{group}).(Session_type{sess});
        RespiFreq.Safe.Figure.(Session_type{sess}){group} = RespiFreq.Safe.(Drug_Group{group}).(Session_type{sess});

    end
end

for sess=1:length(Session_type)
    All.RespiFreq.All.Figure.(Session_type{sess})=[];     All.RespiFreq.Shock.Figure.(Session_type{sess})=[];     All.RespiFreq.Safe.Figure.(Session_type{sess})=[];
    for group=[1 3 4 5]
        All.RespiFreq.All.Figure.(Session_type{sess}) = [All.RespiFreq.All.Figure.(Session_type{sess}) ; RespiFreq.All.Figure.(Session_type{sess}){group}];
        All.RespiFreq.Shock.Figure.(Session_type{sess}) = [All.RespiFreq.Shock.Figure.(Session_type{sess}) ; RespiFreq.Shock.Figure.(Session_type{sess}){group}];
        All.RespiFreq.Safe.Figure.(Session_type{sess}) = [All.RespiFreq.Safe.Figure.(Session_type{sess}) ; RespiFreq.Safe.Figure.(Session_type{sess}){group}];
    end
end


% OB frequency with TestPost variables
figure; n=1;
for sess=[2 4 5 3]
    subplot(3,4,n)
    [R,P]=PlotCorrelations_BM(All.RespiFreq.All.Figure.(Session_type{sess}) , All.ZoneOccupancy.FigureShock.TestPost);
    title(Session_type{sess});
    if sess==2; ylabel('SZ occupancy Test Post'); end
    xlim([2 7]); ylim([0 .15]);
    
    subplot(3,4,n+4)
    [R,P]=PlotCorrelations_BM(All.RespiFreq.All.Figure.(Session_type{sess}) , All.ShockZoneEntries.Figure.TestPost);
    if sess==2; ylabel('SZ entries TestPost (#/min)'); end
    xlim([2 7]); ylim([0 1.5]);
    
    subplot(3,4,n+8)
    [R,P]=PlotCorrelations_BM(All.RespiFreq.All.Figure.(Session_type{sess}) , All.Latency_SZ.Figure.TestPost);
    if sess==2; ylabel('Latency SZ TestPost (s)'); end
    xlim([2 7]); ylim([0 150]);
    xlabel('OB freq during freezing (Hz)');

    n=n+1;
end
a=suptitle('Correlations of OB freq during freezing with TestPost variables, n=34'); a.FontSize=20;


figure; n=1;
for sess=[2 4 5 3]
    subplot(3,4,n)
    [R,P]=PlotCorrelations_BM(All.RespiFreq.Safe.Figure.(Session_type{sess}) , All.ZoneOccupancy.FigureShock.TestPost);
    title(Session_type{sess});
    if sess==2; ylabel('SZ occupancy Test Post'); end
    xlim([2 7]); ylim([0 .15]);
    
    subplot(3,4,n+4)
    [R,P]=PlotCorrelations_BM(All.RespiFreq.Safe.Figure.(Session_type{sess}) , All.ShockZoneEntries.Figure.TestPost);
    if sess==2; ylabel('SZ entries TestPost (#/min)'); end
    xlim([2 7]); ylim([0 1.5]);
    
    subplot(3,4,n+8)
    [R,P]=PlotCorrelations_BM(All.RespiFreq.Safe.Figure.(Session_type{sess}) , All.Latency_SZ.Figure.TestPost);
    if sess==2; ylabel('Latency SZ TestPost (s)'); end
    xlim([2 7]); ylim([0 150]);
    xlabel('OB safe freq during freezing (Hz)');

    n=n+1;
end
a=suptitle('Correlations of OB freq during safe freezing with TestPost variables, n=34'); a.FontSize=20;


figure; n=1;
for sess=[2 4 5 3]
    subplot(3,4,n)
    [R,P]=PlotCorrelations_BM(All.RespiFreq.Shock.Figure.(Session_type{sess})-All.RespiFreq.Safe.Figure.(Session_type{sess}) , All.ZoneOccupancy.FigureShock.TestPost);
    title(Session_type{sess});
    if sess==2; ylabel('SZ occupancy Test Post'); end
    %xlim([2 7]); ylim([0 .15]);
    
    subplot(3,4,n+4)
    [R,P]=PlotCorrelations_BM(All.RespiFreq.Shock.Figure.(Session_type{sess})-All.RespiFreq.Safe.Figure.(Session_type{sess}) , All.ShockZoneEntries.Figure.TestPost);
    if sess==2; ylabel('SZ entries TestPost (#/min)'); end
    %xlim([2 7]); ylim([0 1.5]);
    
    subplot(3,4,n+8)
    [R,P]=PlotCorrelations_BM(All.RespiFreq.Shock.Figure.(Session_type{sess})-All.RespiFreq.Safe.Figure.(Session_type{sess}) , All.Latency_SZ.Figure.TestPost);
    if sess==2; ylabel('Latency SZ TestPost (s)'); end
    %xlim([2 7]); ylim([0 150]);
    xlabel('OB freq diff during freezing (Hz)');

    n=n+1;
end
a=suptitle('Correlations of OB freq shock-safe during safe freezing with TestPost variables, n=34'); a.FontSize=20;

%% time proportion
thr=1; % threshold for noise
Freq_Limit=3.66;
Type={'All','Shock','Safe'};

for sess=1:length(Session_type)
    for mouse = 1:length(Mouse)
        for type=1:length(Type)
            if type==1; FzEpoch = Epoch1.(Session_type{sess}){mouse, 3}; Respi = TSD_DATA.(Session_type{sess}).respi_freq_BM.tsd{mouse, 3}; end
            if type==2; FzEpoch = Epoch1.(Session_type{sess}){mouse, 5}; Respi = TSD_DATA.(Session_type{sess}).respi_freq_BM.tsd{mouse, 5}; end
            if type==3; FzEpoch = Epoch1.(Session_type{sess}){mouse, 6}; Respi = TSD_DATA.(Session_type{sess}).respi_freq_BM.tsd{mouse, 6}; end
            
            [All_Freq.(Session_type{sess}).(Mouse_names{mouse}).(Type{type}) , EpLength.(Session_type{sess}).(Mouse_names{mouse}).(Type{type}) , EpProp_2_4.(Session_type{sess}).(Mouse_names{mouse}).(Type{type}) , TimeProp_2_4.(Session_type{sess}).(Mouse_names{mouse}).(Type{type}) , AbsoluteTime_2_4.(Session_type{sess}).(Mouse_names{mouse}).(Type{type})] = FreezingSpectrumEpisodesAnalysis_BM(FzEpoch , Respi , Freq_Limit);
            PropOfEp_2_4.(Session_type{sess}).(Mouse_names{mouse}).(Type{type})=length(find(EpProp_2_4.(Session_type{sess}).(Mouse_names{mouse}).(Type{type})>0.5))/length(EpLength.(Session_type{sess}).(Mouse_names{mouse}).(Type{type})); %
            TimeProp_norm_2_4.(Session_type{sess}).(Mouse_names{mouse}).(Type{type})=nanmean(EpProp_2_4.(Session_type{sess}).(Mouse_names{mouse}).(Type{type}));
            
            disp(Mouse_names{mouse})
        end
    end
end


for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            TimeProp_2_4.All.(Drug_Group{group}).(Session_type{sess})(mouse,:) = TimeProp_2_4.(Session_type{sess}).(Mouse_names{mouse}).All;
            TimeProp_2_4.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = TimeProp_2_4.(Session_type{sess}).(Mouse_names{mouse}).Shock;
            TimeProp_2_4.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = TimeProp_2_4.(Session_type{sess}).(Mouse_names{mouse}).Safe;

        end
    end
end

for sess=1:length(Session_type)
    for group=1:length(Drug_Group)
        
        TimeProp_2_4.All.Figure.(Session_type{sess}){group} = TimeProp_2_4.All.(Drug_Group{group}).(Session_type{sess});
        TimeProp_2_4.Shock.Figure.(Session_type{sess}){group} = TimeProp_2_4.Shock.(Drug_Group{group}).(Session_type{sess});
        TimeProp_2_4.Safe.Figure.(Session_type{sess}){group} = TimeProp_2_4.Safe.(Drug_Group{group}).(Session_type{sess});

    end
end


for sess=1:length(Session_type)
    All.TimeProp_2_4.All.Figure.(Session_type{sess})=[]; All.TimeProp_2_4.Shock.Figure.(Session_type{sess})=[]; All.TimeProp_2_4.Safe.Figure.(Session_type{sess})=[];
    for group=[1 3 4 5]
        All.TimeProp_2_4.All.Figure.(Session_type{sess}) = [All.TimeProp_2_4.All.Figure.(Session_type{sess}) ; TimeProp_2_4.All.Figure.(Session_type{sess}){group}];
        All.TimeProp_2_4.Shock.Figure.(Session_type{sess}) = [All.TimeProp_2_4.Shock.Figure.(Session_type{sess}) ; TimeProp_2_4.Shock.Figure.(Session_type{sess}){group}];
        All.TimeProp_2_4.Safe.Figure.(Session_type{sess}) = [All.TimeProp_2_4.Safe.Figure.(Session_type{sess}) ; TimeProp_2_4.Safe.Figure.(Session_type{sess}){group}];
    end
end
All.TimeProp_2_4.Safe.Figure.CondPre(23) = NaN;

figure; n=1;
for sess=[2 4 5 3]
    subplot(3,4,n)
    [R,P]=PlotCorrelations_BM(All.TimeProp_2_4.All.Figure.(Session_type{sess}) , All.ZoneOccupancy.FigureShock.TestPost);
    title(Session_type{sess});
    if sess==2; ylabel('SZ occupancy Test Post'); end
    xlim([0 1]); ylim([0 .15]);
    
    subplot(3,4,n+4)
    [R,P]=PlotCorrelations_BM(All.TimeProp_2_4.All.Figure.(Session_type{sess}) , All.ShockZoneEntries.Figure.TestPost);
    if sess==2; ylabel('SZ entries TestPost (#/min)'); end
    xlim([0 1]); ylim([0 1.5]);
    
    subplot(3,4,n+8)
    [R,P]=PlotCorrelations_BM(All.TimeProp_2_4.All.Figure.(Session_type{sess}) , All.Latency_SZ.Figure.TestPost);
    if sess==2; ylabel('Latency SZ TestPost (s)'); end
    xlim([0 1]); ylim([0 150]);
    xlabel('time proportion');

    n=n+1;
end
a=suptitle('Correlations of time proportion freezing at a low frequency with TestPost variables, n=34'); a.FontSize=20;


figure; n=1;
for sess=[2 4 5 3]
    subplot(3,4,n)
    [R,P]=PlotCorrelations_BM(All.TimeProp_2_4.Safe.Figure.(Session_type{sess}) , All.ZoneOccupancy.FigureShock.TestPost);
    title(Session_type{sess});
    if sess==2; ylabel('SZ occupancy Test Post'); end
    xlim([0 1]); ylim([0 .15]);
    
    subplot(3,4,n+4)
    [R,P]=PlotCorrelations_BM(All.TimeProp_2_4.Safe.Figure.(Session_type{sess}) , All.ShockZoneEntries.Figure.TestPost);
    if sess==2; ylabel('SZ entries TestPost (#/min)'); end
    xlim([0 1]); ylim([0 1.5]);
    
    subplot(3,4,n+8)
    [R,P]=PlotCorrelations_BM(All.TimeProp_2_4.Safe.Figure.(Session_type{sess}) , All.Latency_SZ.Figure.TestPost);
    if sess==2; ylabel('Latency SZ TestPost (s)'); end
    xlim([0 1]); ylim([0 150]);
    xlabel('time proportion');

    n=n+1;
end
a=suptitle('Correlations of OB freq during safe side freezing with TestPost variables, n=34'); a.FontSize=20;


%% normalized time per episode

for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            TimeProp_norm_2_4.All.(Drug_Group{group}).(Session_type{sess})(mouse,:) = TimeProp_norm_2_4.(Session_type{sess}).(Mouse_names{mouse}).All;
            TimeProp_norm_2_4.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = TimeProp_norm_2_4.(Session_type{sess}).(Mouse_names{mouse}).Shock;
            TimeProp_norm_2_4.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = TimeProp_norm_2_4.(Session_type{sess}).(Mouse_names{mouse}).Safe;

        end
    end
end

for sess=1:length(Session_type)
    for group=1:length(Drug_Group)
        
        TimeProp_norm_2_4.All.Figure.(Session_type{sess}){group} = TimeProp_norm_2_4.All.(Drug_Group{group}).(Session_type{sess});
        TimeProp_norm_2_4.Shock.Figure.(Session_type{sess}){group} = TimeProp_norm_2_4.Shock.(Drug_Group{group}).(Session_type{sess});
        TimeProp_norm_2_4.Safe.Figure.(Session_type{sess}){group} = TimeProp_norm_2_4.Safe.(Drug_Group{group}).(Session_type{sess});

    end
end


for sess=1:length(Session_type)
    All.TimeProp_norm_2_4.All.Figure.(Session_type{sess})=[]; All.TimeProp_norm_2_4.Shock.Figure.(Session_type{sess})=[]; All.TimeProp_norm_2_4.Safe.Figure.(Session_type{sess})=[];
    for group=[1 3 4 5]
        All.TimeProp_norm_2_4.All.Figure.(Session_type{sess}) = [All.TimeProp_norm_2_4.All.Figure.(Session_type{sess}) ; TimeProp_norm_2_4.All.Figure.(Session_type{sess}){group}];
        All.TimeProp_norm_2_4.Shock.Figure.(Session_type{sess}) = [All.TimeProp_norm_2_4.Shock.Figure.(Session_type{sess}) ; TimeProp_norm_2_4.Shock.Figure.(Session_type{sess}){group}];
        All.TimeProp_norm_2_4.Safe.Figure.(Session_type{sess}) = [All.TimeProp_norm_2_4.Safe.Figure.(Session_type{sess}) ; TimeProp_norm_2_4.Safe.Figure.(Session_type{sess}){group}];
    end
end


figure; n=1;
for sess=[2 4 5 3]
    subplot(3,4,n)
    [R,P]=PlotCorrelations_BM(All.TimeProp_norm_2_4.All.Figure.(Session_type{sess}) , All.ZoneOccupancy.FigureShock.TestPost);
    title(Session_type{sess});
    if sess==2; ylabel('SZ occupancy Test Post'); end
    xlim([0 1]); ylim([0 .15]);
    
    subplot(3,4,n+4)
    [R,P]=PlotCorrelations_BM(All.TimeProp_norm_2_4.All.Figure.(Session_type{sess}) , All.ShockZoneEntries.Figure.TestPost);
    if sess==2; ylabel('SZ entries TestPost (#/min)'); end
    xlim([0 1]); ylim([0 1.5]);
    
    subplot(3,4,n+8)
    [R,P]=PlotCorrelations_BM(All.TimeProp_norm_2_4.All.Figure.(Session_type{sess}) , All.Latency_SZ.Figure.TestPost);
    if sess==2; ylabel('Latency SZ TestPost (s)'); end
    xlim([0 1]); ylim([0 150]);
    xlabel('time proportion');

    n=n+1;
end
a=suptitle('Correlations of time proportion freezing at a low frequency with TestPost variables, n=34'); a.FontSize=20;


figure; n=1;
for sess=[2 4 5 3]
    subplot(3,4,n)
    [R,P]=PlotCorrelations_BM(All.TimeProp_norm_2_4.Safe.Figure.(Session_type{sess}) , All.ZoneOccupancy.FigureShock.TestPost);
    title(Session_type{sess});
    if sess==2; ylabel('SZ occupancy Test Post'); end
    xlim([0 1]); ylim([0 .15]);
    
    subplot(3,4,n+4)
    [R,P]=PlotCorrelations_BM(All.TimeProp_norm_2_4.Safe.Figure.(Session_type{sess}) , All.ShockZoneEntries.Figure.TestPost);
    if sess==2; ylabel('SZ entries TestPost (#/min)'); end
    xlim([0 1]); ylim([0 1.5]);
    
    subplot(3,4,n+8)
    [R,P]=PlotCorrelations_BM(All.TimeProp_norm_2_4.Safe.Figure.(Session_type{sess}) , All.Latency_SZ.Figure.TestPost);
    if sess==2; ylabel('Latency SZ TestPost (s)'); end
    xlim([0 1]); ylim([0 150]);
    xlabel('time proportion');

    n=n+1;
end
a=suptitle('Correlations of OB freq during safe side freezing with TestPost variables, n=34'); a.FontSize=20;

figure; n=1;
for sess=[2 4 5 3]
    subplot(3,4,n)
    [R,P]=PlotCorrelations_BM(All.TimeProp_norm_2_4.Shock.Figure.(Session_type{sess}) , All.ZoneOccupancy.FigureShock.TestPost);
    title(Session_type{sess});
    if sess==2; ylabel('SZ occupancy Test Post'); end
    %xlim([2 7]); ylim([0 .15]);
    
    subplot(3,4,n+4)
    [R,P]=PlotCorrelations_BM(All.TimeProp_norm_2_4.Shock.Figure.(Session_type{sess}) , All.ShockZoneEntries.Figure.TestPost);
    if sess==2; ylabel('SZ entries TestPost (#/min)'); end
    %xlim([2 7]); ylim([0 1.5]);
    
    subplot(3,4,n+8)
    [R,P]=PlotCorrelations_BM(All.TimeProp_norm_2_4.Shock.Figure.(Session_type{sess}) , All.Latency_SZ.Figure.TestPost);
    if sess==2; ylabel('Latency SZ TestPost (s)'); end
    %xlim([2 7]); ylim([0 150]);
    xlabel('time proportion');

    n=n+1;
end
a=suptitle('Correlations of OB freq during safe side freezing with TestPost variables, n=34'); a.FontSize=20;



%% absolute time

for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            AbsoluteTime_2_4.All.(Drug_Group{group}).(Session_type{sess})(mouse,:) = AbsoluteTime_2_4.(Session_type{sess}).(Mouse_names{mouse}).All;
            AbsoluteTime_2_4.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = AbsoluteTime_2_4.(Session_type{sess}).(Mouse_names{mouse}).Shock;
            AbsoluteTime_2_4.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = AbsoluteTime_2_4.(Session_type{sess}).(Mouse_names{mouse}).Safe;

        end
    end
end

for sess=1:length(Session_type)
    for group=1:length(Drug_Group)
        
        AbsoluteTime_2_4.All.Figure.(Session_type{sess}){group} = AbsoluteTime_2_4.All.(Drug_Group{group}).(Session_type{sess});
        AbsoluteTime_2_4.Shock.Figure.(Session_type{sess}){group} = AbsoluteTime_2_4.Shock.(Drug_Group{group}).(Session_type{sess});
        AbsoluteTime_2_4.Safe.Figure.(Session_type{sess}){group} = AbsoluteTime_2_4.Safe.(Drug_Group{group}).(Session_type{sess});

    end
end


for sess=1:length(Session_type)
    All.AbsoluteTime_2_4.All.Figure.(Session_type{sess})=[]; All.AbsoluteTime_2_4.Shock.Figure.(Session_type{sess})=[]; All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess})=[];
    for group=[1 3 4 5]
        All.AbsoluteTime_2_4.All.Figure.(Session_type{sess}) = [All.AbsoluteTime_2_4.All.Figure.(Session_type{sess}) ; AbsoluteTime_2_4.All.Figure.(Session_type{sess}){group}];
        All.AbsoluteTime_2_4.Shock.Figure.(Session_type{sess}) = [All.AbsoluteTime_2_4.Shock.Figure.(Session_type{sess}) ; AbsoluteTime_2_4.Shock.Figure.(Session_type{sess}){group}];
        All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess}) = [All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess}) ; AbsoluteTime_2_4.Safe.Figure.(Session_type{sess}){group}];
    end
end



figure; n=1;
for sess=[2 4 5 3]
    subplot(3,4,n)
    [R,P]=PlotCorrelations_BM(All.AbsoluteTime_2_4.All.Figure.(Session_type{sess}) , All.ZoneOccupancy.FigureShock.TestPost);
    title(Session_type{sess});
    if sess==2; ylabel('SZ occupancy Test Post'); end
    %xlim([0 1]); ylim([0 .15]);
    
    subplot(3,4,n+4)
    [R,P]=PlotCorrelations_BM(All.AbsoluteTime_2_4.All.Figure.(Session_type{sess}) , All.ShockZoneEntries.Figure.TestPost);
    if sess==2; ylabel('SZ entries TestPost (#/min)'); end
    %xlim([0 1]); ylim([0 1.5]);
    
    subplot(3,4,n+8)
    [R,P]=PlotCorrelations_BM(All.AbsoluteTime_2_4.All.Figure.(Session_type{sess}) , All.Latency_SZ.Figure.TestPost);
    if sess==2; ylabel('Latency SZ TestPost (s)'); end
    %xlim([0 1]); ylim([0 150]);
    xlabel('time proportion');

    n=n+1;
end
a=suptitle('Correlations of time proportion freezing at a low frequency with TestPost variables, n=34'); a.FontSize=20;


figure; n=1;
for sess=[2 4 5 3]
    subplot(3,4,n)
    [R,P]=PlotCorrelations_BM(All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess}) , All.ZoneOccupancy.FigureShock.TestPost);
    title(Session_type{sess});
    if sess==2; ylabel('SZ occupancy Test Post'); end
    %xlim([2 7]); ylim([0 .15]);
    
    subplot(3,4,n+4)
    [R,P]=PlotCorrelations_BM(All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess}) , All.ShockZoneEntries.Figure.TestPost);
    if sess==2; ylabel('SZ entries TestPost (#/min)'); end
    %xlim([2 7]); ylim([0 1.5]);
    
    subplot(3,4,n+8)
    [R,P]=PlotCorrelations_BM(All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess}) , All.Latency_SZ.Figure.TestPost);
    if sess==2; ylabel('Latency SZ TestPost (s)'); end
    %xlim([2 7]); ylim([0 150]);
    xlabel('time proportion');

    n=n+1;
end
a=suptitle('Correlations of OB freq during safe side freezing with TestPost variables, n=34'); a.FontSize=20;


figure; n=1;
for sess=[2 4 5 3]
    subplot(3,4,n)
    [R,P]=PlotCorrelations_BM(All.AbsoluteTime_2_4.Shock.Figure.(Session_type{sess}) , All.ZoneOccupancy.FigureShock.TestPost);
    title(Session_type{sess});
    if sess==2; ylabel('SZ occupancy Test Post'); end
    %xlim([2 7]); ylim([0 .15]);
    
    subplot(3,4,n+4)
    [R,P]=PlotCorrelations_BM(All.AbsoluteTime_2_4.Shock.Figure.(Session_type{sess}) , All.ShockZoneEntries.Figure.TestPost);
    if sess==2; ylabel('SZ entries TestPost (#/min)'); end
    %xlim([2 7]); ylim([0 1.5]);
    
    subplot(3,4,n+8)
    [R,P]=PlotCorrelations_BM(All.AbsoluteTime_2_4.Shock.Figure.(Session_type{sess}) , All.Latency_SZ.Figure.TestPost);
    if sess==2; ylabel('Latency SZ TestPost (s)'); end
    %xlim([2 7]); ylim([0 150]);
    xlabel('time proportion');

    n=n+1;
end
a=suptitle('Correlations of OB freq during safe side freezing with TestPost variables, n=34'); a.FontSize=20;


%% Restrict for mice freezing more than 5s and less than 100s

figure; n=1;
for sess=[2 4 5 3]
    subplot(3,4,n)
    [R,P]=PlotCorrelations_BM(All.AbsoluteTime_2_4.All.Figure.(Session_type{sess})(and(All.AbsoluteTime_2_4.All.Figure.(Session_type{sess})>5 , All.AbsoluteTime_2_4.All.Figure.(Session_type{sess})<100)) , All.ZoneOccupancy.FigureShock.TestPost(and(All.AbsoluteTime_2_4.All.Figure.(Session_type{sess})>5 , All.AbsoluteTime_2_4.All.Figure.(Session_type{sess})<100)));
    title(Session_type{sess});
    if sess==2; ylabel('SZ occupancy Test Post'); end
    %xlim([0 1]); ylim([0 .15]);
    
    subplot(3,4,n+4)
    [R,P]=PlotCorrelations_BM(All.AbsoluteTime_2_4.All.Figure.(Session_type{sess})(and(All.AbsoluteTime_2_4.All.Figure.(Session_type{sess})>5 , All.AbsoluteTime_2_4.All.Figure.(Session_type{sess})<100)) , All.ShockZoneEntries.Figure.TestPost(and(All.AbsoluteTime_2_4.All.Figure.(Session_type{sess})>5 , All.AbsoluteTime_2_4.All.Figure.(Session_type{sess})<100)));
    if sess==2; ylabel('SZ entries TestPost (#/min)'); end
    %xlim([0 1]); ylim([0 1.5]);
    
    subplot(3,4,n+8)
    [R,P]=PlotCorrelations_BM(All.AbsoluteTime_2_4.All.Figure.(Session_type{sess})(and(All.AbsoluteTime_2_4.All.Figure.(Session_type{sess})>5 , All.AbsoluteTime_2_4.All.Figure.(Session_type{sess})<100)) , All.Latency_SZ.Figure.TestPost(and(All.AbsoluteTime_2_4.All.Figure.(Session_type{sess})>5 , All.AbsoluteTime_2_4.All.Figure.(Session_type{sess})<100)));
    if sess==2; ylabel('Latency SZ TestPost (s)'); end
    %xlim([0 1]); ylim([0 150]);
    xlabel('time proportion');

    n=n+1;
end
a=suptitle('Correlations of time proportion freezing at a low frequency with TestPost variables, n=34'); a.FontSize=20;


figure; n=1;
for sess=[2 4 5 3]
    subplot(3,4,n)
    [R,P]=PlotCorrelations_BM(All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess})(and(All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess})>5 , All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess})<100)) , All.ZoneOccupancy.FigureShock.TestPost(and(All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess})>5 , All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess})<100)));
    title(Session_type{sess});
    if sess==2; ylabel('SZ occupancy Test Post'); end
    %xlim([2 7]); ylim([0 .15]);
    
    subplot(3,4,n+4)
    [R,P]=PlotCorrelations_BM(All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess})(and(All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess})>5 , All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess})<100)) , All.ShockZoneEntries.Figure.TestPost(and(All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess})>5 , All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess})<100)));
    if sess==2; ylabel('SZ entries TestPost (#/min)'); end
    %xlim([2 7]); ylim([0 1.5]);
    
    subplot(3,4,n+8)
    [R,P]=PlotCorrelations_BM(All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess})(and(All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess})>5 , All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess})<100)) , All.Latency_SZ.Figure.TestPost(and(All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess})>5 , All.AbsoluteTime_2_4.Safe.Figure.(Session_type{sess})<100)));
    if sess==2; ylabel('Latency SZ TestPost (s)'); end
    %xlim([2 7]); ylim([0 150]);
    xlabel('time proportion');

    n=n+1;
end
a=suptitle('Correlations of OB freq during safe side freezing with TestPost variables, n=34'); a.FontSize=20;



%% Ripples
for mouse=1:length(Mouse)
    for sess=1:length(Session_type)
        
        Ripples.Fz_All.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).wake_ripples.mean(mouse,3);
        Ripples.Fz_Shock.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).wake_ripples.mean(mouse,5);
        Ripples.Fz_Safe.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).wake_ripples.mean(mouse,6);
        
        Mouse_names{mouse}
    end
end


for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Ripples.Fz.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Ripples.Fz_All.(Session_type{sess}).(Mouse_names{mouse});
            Ripples.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Ripples.Fz_Shock.(Session_type{sess}).(Mouse_names{mouse});
            Ripples.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Ripples.Fz_Safe.(Session_type{sess}).(Mouse_names{mouse});

        end
    end
end

for sess=1:length(Session_type)
    for group=1:length(Drug_Group)
        
        Ripples.All.Figure.(Session_type{sess}){group} = Ripples.Fz.(Drug_Group{group}).(Session_type{sess});
        Ripples.Shock.Figure.(Session_type{sess}){group} = Ripples.Shock.(Drug_Group{group}).(Session_type{sess});
        Ripples.Safe.Figure.(Session_type{sess}){group} = Ripples.Safe.(Drug_Group{group}).(Session_type{sess});

    end
end

for sess=1:length(Session_type)
    All.Ripples.All.Figure.(Session_type{sess})=[];     All.Ripples.Shock.Figure.(Session_type{sess})=[];     All.Ripples.Safe.Figure.(Session_type{sess})=[];
    for group=[1 3 4 5]
        All.Ripples.All.Figure.(Session_type{sess}) = [All.Ripples.All.Figure.(Session_type{sess}) ; Ripples.All.Figure.(Session_type{sess}){group}];
        All.Ripples.Shock.Figure.(Session_type{sess}) = [All.Ripples.Shock.Figure.(Session_type{sess}) ; Ripples.Shock.Figure.(Session_type{sess}){group}];
        All.Ripples.Safe.Figure.(Session_type{sess}) = [All.Ripples.Safe.Figure.(Session_type{sess}) ; Ripples.Safe.Figure.(Session_type{sess}){group}];
        All.Ripples.All.Figure.(Session_type{sess})(All.Ripples.All.Figure.(Session_type{sess})==0)=NaN;
        All.Ripples.Shock.Figure.(Session_type{sess})(All.Ripples.Shock.Figure.(Session_type{sess})==0)=NaN;
        All.Ripples.Safe.Figure.(Session_type{sess})(All.Ripples.Safe.Figure.(Session_type{sess})==0)=NaN;
    end
end



figure; n=1;
for sess=[2 4 5 3]
    subplot(3,4,n)
    [R,P]=PlotCorrelations_BM(All.Ripples.All.Figure.(Session_type{sess}) , All.ZoneOccupancy.FigureShock.TestPost);
    title(Session_type{sess});
    if sess==2; ylabel('SZ occupancy Test Post'); end
    %xlim([2 7]); ylim([0 .15]);
    
    subplot(3,4,n+4)
    [R,P]=PlotCorrelations_BM(All.Ripples.All.Figure.(Session_type{sess}) , All.ShockZoneEntries.Figure.TestPost);
    if sess==2; ylabel('SZ entries TestPost (#/min)'); end
    %xlim([2 7]); ylim([0 1.5]);
    
    subplot(3,4,n+8)
    [R,P]=PlotCorrelations_BM(All.Ripples.All.Figure.(Session_type{sess}) , All.Latency_SZ.Figure.TestPost);
    if sess==2; ylabel('Latency SZ TestPost (s)'); end
    %xlim([2 7]); ylim([0 150]);
    xlabel('OB freq during freezing (Hz)');

    n=n+1;
end
a=suptitle('Correlations of OB freq during freezing with TestPost variables, n=34'); a.FontSize=20;







