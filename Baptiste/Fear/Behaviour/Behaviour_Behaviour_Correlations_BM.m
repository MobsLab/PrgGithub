%% Correlations for all the "saline-like"
All.Stim_By_SZ_entries.Cond([6 24 31]) = NaN;
All.Stim_By_SZ_entries.CondPre([6 24 31]) = NaN;
All.Stim_By_SZ_entries.CondPost([6 24 31]) = NaN;

All.FreezingProp.FigureAll.Cond([6 24 31]) = NaN;
All.FreezingProp.FigureAll.CondPre([6 24 31]) = NaN;
All.FreezingProp.FigureAll.CondPost([6 24 31 ]) = NaN;

All.ExtraStim.Figure.Cond([6 24 31 ]) = NaN;
All.ExtraStim.Figure.CondPre([6 24 31 ]) = NaN;
All.ExtraStim.Figure.CondPost([6 24 31 ]) = NaN;

All.ShockZoneEntries.Figure.Cond([6 24 31 ]) = NaN;
All.ShockZoneEntries.Figure.CondPre([6 24 31 ]) = NaN;
All.ShockZoneEntries.Figure.CondPost([6 24 31 ]) = NaN;

% Freezing prop with extra-stim density
figure; n=1;
for sess=[2 4 5]
    subplot(1,3,n)
    [R,P]=PlotCorrelations_BM(All.FreezingProp.FigureAll.(Session_type{sess}) , All.ExtraStim.Figure.(Session_type{sess}));
    n=n+1; 
    title(Session_type{sess}); 
    xlabel('Freezing proportion'); 
    if sess==2; ylabel('Extra-stim density (#/min)'); end
    axis square; xlim([0 0.25]); ylim([0 1]);
end
a=suptitle('Correlations of extra-stim density with freezing proportion, n=31'); a.FontSize=20;


% Freezing prop with SZ entries
figure; n=1;
for sess=[2 4 5]
    subplot(1,3,n)
    [R,P]=PlotCorrelations_BM(All.FreezingProp.FigureAll.(Session_type{sess}) , All.ShockZoneEntries.Figure.(Session_type{sess}));
    n=n+1; 
    title(Session_type{sess}); 
    xlabel('Freezing proportion'); 
    if sess==2; ylabel('Shock zone entries (#/min)'); end
    axis square; xlim([0 0.25]); ylim([0 4.5]);
end
a=suptitle('Correlations of shock zone entries with freezing proportion, n=31'); a.FontSize=20;

% Extra-stim with SZ entries
figure; n=1;
for sess=[2 4 5]
    subplot(1,3,n)
    [R,P]=PlotCorrelations_BM(All.ExtraStim.Figure.(Session_type{sess}) , All.ShockZoneEntries.Figure.(Session_type{sess}));
    n=n+1; 
    title(Session_type{sess}); 
    xlabel('Freezing proportion'); 
    if sess==2; ylabel('Shock zone entries (#/min)'); end
    axis square; %xlim([0 0.25]); ylim([0 4.5]);
end
a=suptitle('Correlations of shock zone entries with freezing proportion, n=31'); a.FontSize=20;


% Freezing prop with extra-stim density corrected by SZ entries
figure; n=1;
for sess=[2 4 5]
    subplot(1,3,n)
    [R,P]=PlotCorrelations_BM(All.FreezingProp.FigureAll.(Session_type{sess}) , All.Stim_By_SZ_entries.(Session_type{sess}));
    n=n+1; 
    title(Session_type{sess});
    xlabel('Freezing proportion'); 
    if sess==2; ylabel('SZ entries / Extra-stim'); end
    axis square; xlim([0 0.25]); ylim([0 100]);
end
a=suptitle('Correlations of extra-stim density corrected by shock zone entries with freezing proportion, n=31'); a.FontSize=20;


% SZ occupancy cond and SZ occupancy TestPost
figure; n=1;
for sess=[2 4 5]
    subplot(1,3,n)
    [R,P]=PlotCorrelations_BM(All.ZoneOccupancy.FigureShock.(Session_type{sess}) , All.ZoneOccupancy.FigureShock.TestPost);
    n=n+1;
    title(Session_type{sess}); 
    if sess==2; ylabel('Shock zone occupancy TestPost'); end
    xlabel(['Shock zone occupancy ' Session_type{sess}]); 
    axis square; xlim([0 0.2])
end
a=suptitle('Correlations of shock zone occupancy in conditionning sessions with zone occupancy in TestPost sessions, n=34'); a.FontSize=20;


% SZ entries cond and SZ entries TestPost
figure; n=1;
for sess=[2 4 5]
    subplot(1,3,n)
    [R,P]=PlotCorrelations_BM(All.ShockZoneEntries.Figure.(Session_type{sess}) , All.ShockZoneEntries.Figure.TestPost);
    n=n+1;
    title(Session_type{sess}); 
    if sess==2; ylabel('Shock zone entries TestPost'); end
    xlabel(['Shock zone entries ' Session_type{sess}]); 
    axis square; xlim([0 5])
end
a=suptitle('Correlations of shock zone entries in conditionning sessions with zone entries in TestPost sessions, n=34'); a.FontSize=20;

% Freezing prop with TestPost variables
figure; n=1;
for sess=[2 4 5]
    subplot(3,3,n)
    [R,P]=PlotCorrelations_BM(All.FreezingProp.FigureAll.(Session_type{sess}) , All.ZoneOccupancy.FigureShock.TestPost);
    title(Session_type{sess});
    if sess==2; ylabel('SZ occupancy Test Post'); end
    xlim([0 0.35]); ylim([0 .15]);
    
    subplot(3,3,n+3)
    [R,P]=PlotCorrelations_BM(All.FreezingProp.FigureAll.(Session_type{sess}) , All.ShockZoneEntries.Figure.TestPost);
    if sess==2; ylabel('SZ entries TestPost (#/min)'); end
    xlim([0 0.35]); ylim([0 1.5]);
    
    subplot(3,3,n+6)
    [R,P]=PlotCorrelations_BM(All.FreezingProp.FigureAll.(Session_type{sess}) , All.Latency_SZ.Figure.TestPost);
    if sess==2; ylabel('Latency SZ TestPost (s)'); end
    xlim([0 0.35]); ylim([0 150]);
    xlabel('Freezing proportion');

    n=n+1;
end
a=suptitle('Correlations of freezing proportion with TestPost variables, n=34'); a.FontSize=20;


% Safe freezing prop with TestPost variables
figure; n=1;
for sess=[2 4 5]
    subplot(3,3,n)
    [R,P]=PlotCorrelations_BM(1-All.FreezingProp.FigureShock.(Session_type{sess}) , All.ZoneOccupancy.FigureShock.TestPost);
    title(Session_type{sess});
    if sess==2; ylabel('SZ occupancy Test Post'); end
    xlim([0 1.1]); ylim([0 .15]);
    
    subplot(3,3,n+3)
    [R,P]=PlotCorrelations_BM(1-All.FreezingProp.FigureShock.(Session_type{sess}) , All.ShockZoneEntries.Figure.TestPost);
    if sess==2; ylabel('SZ entries TestPost (#/min)'); end
    xlim([0 1.1]); ylim([0 1.5]);
    
    subplot(3,3,n+6)
    [R,P]=PlotCorrelations_BM(1-All.FreezingProp.FigureShock.(Session_type{sess}) , All.Latency_SZ.Figure.TestPost);
    if sess==2; ylabel('Latency SZ TestPost (s)'); end
    xlim([0 1.1]); ylim([0 150]);
    xlabel('Safe freezing proportion');

    n=n+1;
end
a=suptitle('Correlations of shock freezing proportion with TestPost variables, n=34'); a.FontSize=20;


% Correcting those which didn't freeze on shock side
figure; n=1;
for sess=[2 4 5]
    subplot(3,3,n)
    [R,P]=PlotCorrelations_BM(1-All.FreezingProp.FigureShock.(Session_type{sess})(All.FreezingProp.FigureShock.(Session_type{sess})>.1) , All.ZoneOccupancy.FigureShock.TestPost(All.FreezingProp.FigureShock.(Session_type{sess})>.1));
    title(Session_type{sess});
    if sess==2; ylabel('SZ occupancy Test Post'); end
    xlim([0 0.35]); ylim([0 .15]);
    
    subplot(3,3,n+3)
    [R,P]=PlotCorrelations_BM(1-All.FreezingProp.FigureShock.(Session_type{sess})(All.FreezingProp.FigureShock.(Session_type{sess})>.1) , All.ShockZoneEntries.Figure.TestPost(All.FreezingProp.FigureShock.(Session_type{sess})>.1));
    if sess==2; ylabel('SZ entries TestPost (#/min)'); end
    xlim([0 0.35]); ylim([0 1.5]);
    
    subplot(3,3,n+6)
    [R,P]=PlotCorrelations_BM(1-All.FreezingProp.FigureShock.(Session_type{sess})(All.FreezingProp.FigureShock.(Session_type{sess})>.1) , All.Latency_SZ.Figure.TestPost(All.FreezingProp.FigureShock.(Session_type{sess})>.1));
    if sess==2; ylabel('Latency SZ TestPost (s)'); end
    xlim([0 0.35]); ylim([0 150]);
    xlabel('Safe freezing proportion');

    n=n+1;
end
a=suptitle('Correlations of shock freezing proportion (>0.1) with TestPost variables, n=34'); a.FontSize=20;


% Looking at freezing quantity
figure; n=1;
for sess=[2 4 5]
    subplot(3,3,n)
    [R,P]=PlotCorrelations_BM(All.FreezingTime.Figure.Safe.(Session_type{sess}) , All.ZoneOccupancy.FigureShock.TestPost);
    title(Session_type{sess});
    if sess==2; ylabel('SZ occupancy Test Post'); end
    %xlim([0 0.35]); ylim([0 .15]);
    
    subplot(3,3,n+3)
    [R,P]=PlotCorrelations_BM(All.FreezingTime.Figure.Safe.(Session_type{sess}) , All.ShockZoneEntries.Figure.TestPost);
    if sess==2; ylabel('SZ entries TestPost (#/min)'); end
    %xlim([0 0.35]); ylim([0 1.5]);
    
    subplot(3,3,n+6)
    [R,P]=PlotCorrelations_BM(All.FreezingTime.Figure.Safe.(Session_type{sess}) , All.Latency_SZ.Figure.TestPost);
    if sess==2; ylabel('Latency SZ TestPost (s)'); end
    %xlim([0 0.35]); ylim([0 150]);
    xlabel('Time spent freezing safe (min)');

    n=n+1;
end
a=suptitle('Correlations of time spent freezing on safe side with TestPost variables, n=34'); a.FontSize=20;


%% Correlations by drug group
% Correlations extra-stim / Shock zone occupancy Cond CondPost and TestPost
figure
for group=1:length(Drug_Group)
    for sess=[4 5 7]
        if sess==4; u=1; elseif sess==5; u=2; elseif sess==7; u=3; end
        subplot(3,length(Drug_Group),length(Drug_Group)*(u-1)+group)
        [R,P]=PlotCorrelations_BM(ExtraStim.(Drug_Group{group}).Cond , ZoneOccupancy.Shock.(Drug_Group{group}).(Session_type{sess}));
        if sess==4; xlim([0 0.6]); ylim([0 0.3]); end
        if sess==5; xlim([0 0.6]); ylim([0 0.3]); end
        if sess==7; xlim([0 0.6]); ylim([0 0.3]); end
        if and(sess==4,group==1); ylabel('Shock zone occupancy CondPre'); end
        if and(sess==5,group==1); ylabel('Shock zone occupancy CondPost'); end
        if and(sess==7,group==1); ylabel('Shock zone occupancy TestPost'); end
        if sess==7; xlabel('# extra-stims'); end
    end
end

% Correlations extra-stim / Shock zone entries CondPre CondPost and TestPost
figure
for group=1:length(Drug_Group)
    for sess=[4 5 7]
        if sess==4; u=1; elseif sess==5; u=2; elseif sess==7; u=3; end
        subplot(3,length(Drug_Group),length(Drug_Group)*(u-1)+group)
        [R,P]=PlotCorrelations_BM(ExtraStim.(Drug_Group{group}).Cond , ShockZoneEntries.(Drug_Group{group}).(Session_type{sess}));
        if sess==4; xlim([0 0.6]); ylim([0 2.5]); end
        if sess==5; xlim([0 0.6]); ylim([0 2.5]); end
        if sess==7; xlim([0 0.6]); ylim([0 2.5]); end
        if and(sess==4,group==1); ylabel('Shock zone entries CondPre'); end
        if and(sess==5,group==1); ylabel('Shock zone entries CondPost'); end
        if and(sess==7,group==1); ylabel('Shock zone entries TestPost'); end
        if sess==7; xlabel('# extra-stims'); end
    end
end

% Correlations extra-stim / Freezing proportion CondPre CondPost and Ext
figure
for group=1:length(Drug_Group)
    
    subplot(3,length(Drug_Group),group)
    [R,P]=PlotCorrelations_BM(ExtraStim.(Drug_Group{group}).CondPre , FreezingProp.All.(Drug_Group{group}).CondPre);
    xlim([0 0.6]); ylim([0 0.16]);
    if group==1; ylabel('Freezing proportion CondPre'); end
    
    subplot(3,length(Drug_Group),group+length(Drug_Group))
    [R,P]=PlotCorrelations_BM(ExtraStim.(Drug_Group{group}).CondPost , FreezingProp.All.(Drug_Group{group}).CondPost);
    xlim([0 0.6]); ylim([0 0.16]);
    if group==1; ylabel('Freezing proportion CondPost'); end
    
    subplot(3,length(Drug_Group),group+2*length(Drug_Group))
    [R,P]=PlotCorrelations_BM(ExtraStim.(Drug_Group{group}).Cond , FreezingProp.All.(Drug_Group{group}).Ext);
    xlim([0 0.6]); ylim([0 0.4]);
    if group==1; ylabel('Freezing proportion Ext'); end
    xlabel('# extra-stims');
end

% Correlations extra-stim / Shock freezing proportion CondPre CondPost and Ext
figure
for group=1:length(Drug_Group)
    subplot(3,length(Drug_Group),group)
    [R,P]=PlotCorrelations_BM(ExtraStim.(Drug_Group{group}).CondPre , FreezingProp.Shock.(Drug_Group{group}).CondPre);
    xlim([0 0.6]); ylim([0 0.7]);
    if group==1; ylabel('Shock freezing proportion CondPre'); end
    
    subplot(3,length(Drug_Group),group+length(Drug_Group))
    [R,P]=PlotCorrelations_BM(ExtraStim.(Drug_Group{group}).CondPost , FreezingProp.Shock.(Drug_Group{group}).CondPost);
    xlim([0 0.6]); ylim([0 0.7]);
    if group==1; ylabel('Shock freezing proportion CondPost'); end
    
    subplot(3,length(Drug_Group),group+2*length(Drug_Group))
    [R,P]=PlotCorrelations_BM(ExtraStim.(Drug_Group{group}).Cond , FreezingProp.Shock.(Drug_Group{group}).Ext);
    xlim([0 0.6]); ylim([0 1]);
    if group==1; ylabel('Shock freezing proportion Ext'); end
    xlabel('# extra-stims');
end

% Correlations freezing proportion CondPre CondPost / SZ occupancy TestPost
figure
for group=1:length(Drug_Group)
    subplot(3,length(Drug_Group),group)
    [R,P]=PlotCorrelations_BM(FreezingProp.All.(Drug_Group{group}).CondPre , ZoneOccupancy.Shock.(Drug_Group{group}).TestPost);
    xlim([0 0.2]); ylim([0 0.3]);
    if group==4; xlabel('Freezing proportion CondPre'); end
    if group==1; ylabel('Shock zone occupancy TestPost'); end
    
    subplot(3,length(Drug_Group),group+length(Drug_Group))
    [R,P]=PlotCorrelations_BM(FreezingProp.All.(Drug_Group{group}).CondPost , ZoneOccupancy.Shock.(Drug_Group{group}).TestPost);
    xlim([0 1]); ylim([0 0.35]);
    if group==4; xlabel('Freezing proportion CondPost'); end
    if group==1; ylabel('Shock zone occupancy TestPost'); end
    
    subplot(3,length(Drug_Group),group+2*length(Drug_Group))
    [R,P]=PlotCorrelations_BM((1-FreezingProp.Shock.(Drug_Group{group}).Cond).*FreezingProp.All.(Drug_Group{group}).Cond , ZoneOccupancy.Shock.(Drug_Group{group}).TestPost);
    xlim([0 0.1]); ylim([0 0.35]);
    if group==4; xlabel('Noramlized safe fz time'); end
    if group==1; ylabel('Shock zone occupancy TestPost'); end
end

% Correlations freezing proportion CondPre CondPost / SZ entries TestPost
figure
for group=1:length(Drug_Group)
    subplot(3,length(Drug_Group),group)
    [R,P]=PlotCorrelations_BM(FreezingProp.All.(Drug_Group{group}).CondPre , ShockZoneEntries.(Drug_Group{group}).TestPost);
    xlim([0 0.2]); ylim([0 0.3]);
    if group==4; xlabel('Freezing proportion CondPre'); end
    if group==1; ylabel('Shock zone occupancy TestPost'); end
    
    subplot(3,length(Drug_Group),group+length(Drug_Group))
    [R,P]=PlotCorrelations_BM(FreezingProp.All.(Drug_Group{group}).CondPost , ShockZoneEntries.(Drug_Group{group}).TestPost);
    xlim([0 1]); ylim([0 0.35]);
    if group==4; xlabel('Freezing proportion CondPost'); end
    if group==1; ylabel('Shock zone occupancy TestPost'); end
    
    subplot(3,length(Drug_Group),group+2*length(Drug_Group))
    [R,P]=PlotCorrelations_BM((1-FreezingProp.Shock.(Drug_Group{group}).Cond).*FreezingProp.All.(Drug_Group{group}).Cond , ShockZoneEntries.(Drug_Group{group}).TestPost);
    xlim([0 0.1]); ylim([0 0.35]);
    if group==4; xlabel('Noramlized safe fz time'); end
    if group==1; ylabel('Shock zone occupancy TestPost'); end
end

% Correlations shock freezing proportion CondPre Cond / SZ entries TestPost
figure
for group=1:length(Drug_Group)
    subplot(2,length(Drug_Group),group)
    [R,P]=PlotCorrelations_BM(1-FreezingProp.All.(Drug_Group{group}).Cond , ZoneOccupancy.Shock.(Drug_Group{group}).TestPost);
    xlim([0 0.2]); ylim([0 0.3]);
    if group==1; ylabel('Shock freezing proportion Cond'); end
    
    subplot(2,length(Drug_Group),group+length(Drug_Group))
    [R,P]=PlotCorrelations_BM(1-FreezingProp.Shock.(Drug_Group{group}).Cond , ZoneOccupancy.Shock.(Drug_Group{group}).TestPost);
    xlim([0 1]); ylim([0 0.35]);
    if group==1; ylabel('Shock freezing proportion Ext'); end
    xlabel('# extra-stims');
end


% is freezing proportion modifying learning (stim by SZ entries) ?
figure
for group=1:length(Drug_Group)
    for sess=[4 5]
        if sess==4; u=1; elseif sess==5; u=2; end
        subplot(2,length(Drug_Group),length(Drug_Group)*(u-1)+group)
        [R,P]=PlotCorrelations_BM(FreezingProp.All.(Drug_Group{group}).(Session_type{sess}) , Stim_By_SZ_entries.(Session_type{sess}){group});
        if sess==4; xlim([0 0.6]); ylim([0 50]); end
        if sess==5; xlim([0 0.6]); ylim([0 80]); end
        if and(sess==4,group==1); ylabel('Shock zone occupancy CondPre'); end
        if and(sess==5,group==1); ylabel('Shock zone occupancy CondPost'); end
        if sess==5; xlabel('# extra-stims'); end
    end
end


% is SZ occupancy in Cond / CondPost is correlated to the one in TestPost ?
figure
for group=1:length(Drug_Group)
    subplot(2,length(Drug_Group),group)
    [R,P]=PlotCorrelations_BM(ZoneOccupancy.Shock.(Drug_Group{group}).Cond , ZoneOccupancy.Shock.(Drug_Group{group}).TestPost);
    xlim([0 0.6]); ylim([0 0.3]);

    subplot(2,length(Drug_Group),group+8)
    [R,P]=PlotCorrelations_BM(ZoneOccupancy.Shock.(Drug_Group{group}).CondPost , ZoneOccupancy.Shock.(Drug_Group{group}).TestPost);
    xlim([0 0.6]); ylim([0 0.3]);
end


% is SZ entries in Cond / CondPost is correlated to the one in TestPost ?
figure
for group=1:length(Drug_Group)
    subplot(2,length(Drug_Group),group)
    [R,P]=PlotCorrelations_BM(ShockZoneEntries.(Drug_Group{group}).Cond , ShockZoneEntries.(Drug_Group{group}).TestPost);
    xlim([0 4]); ylim([0 2.5]);
    
     subplot(2,length(Drug_Group),group+8)
    [R,P]=PlotCorrelations_BM(ShockZoneEntries.(Drug_Group{group}).CondPost , ShockZoneEntries.(Drug_Group{group}).TestPost);
    xlim([0 4]); ylim([0 2.5]);
end



