
%% generate data and epoch
edit Imane_Project_Sleep_Fear_UMaze_BM.m



%% All REM
group=5;

% All freezing
for type=1:4
    figure
    subplot(221)
    ind_to_use = and(REM_prop.(Drug_Group{group}).sleep_pre>0.05 , and(REM_prop.(Drug_Group{group}).sleep_post>0.03 , and(REM_prop.(Drug_Group{group}).sleep_pre<0.2 ,FreezingProportion.All.(Drug_Group{group}).Cond'<.4)));
    [u1,v1]=PlotCorrelations_BM(REM_prop.(Drug_Group{group}).sleep_pre(ind_to_use)*100 , FreezingProportion.(Type{type}).(Drug_Group{group}).Fear(ind_to_use)*100,30,0,'k')
    axis square
    title('Sleep Pre')
    ylabel('Freezing (%)')
    xlim([0 18]); if type==4; ylim([0 100]); else; ylim([0 35]); end
    u=text(-5,10,'Cond + Ext'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)
    
    subplot(222)
    [u1,v1]=PlotCorrelations_BM(REM_prop.(Drug_Group{group}).sleep_post(ind_to_use)*100 , FreezingProportion.(Type{type}).(Drug_Group{group}).Fear(ind_to_use)*100,30,0,'k')
    axis square
    xlim([0 18]); if type==4; ylim([0 100]); else; ylim([0 35]); end
    title('Sleep Post')
    
    subplot(223)
    [u1,v1]=PlotCorrelations_BM(REM_prop.(Drug_Group{group}).sleep_pre(ind_to_use)*100 , FreezingProportion.(Type{type}).(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
    axis square
    ylabel('Freezing (%)')
    xlabel('REM (%)')
    xlim([0 18]); if type==4; ylim([0 100]); else; ylim([0 35]); end
    u=text(-5,13,'Cond'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)
    
    subplot(224)
    [u1,v1]=PlotCorrelations_BM(REM_prop.(Drug_Group{group}).sleep_post(ind_to_use)*100 , FreezingProportion.(Type{type}).(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
    axis square
    xlabel('REM (%)')
    xlim([0 18]); if type==4; ylim([0 100]); else; ylim([0 35]); end
    
    
    a=suptitle(['% ' num2str(Type{type}) ' = f(% REM)']); a.FontSize=20;
end



%% Learning
% SZ entries
figure
subplot(221)
ind_to_use = and(REM_prop.(Drug_Group{group}).sleep_pre>0.05 , and(REM_prop.(Drug_Group{group}).sleep_post>0.03 , ZoneEntries.Shock.(Drug_Group{group}).Cond'<3));
[u1,v1]=PlotCorrelations_BM(REM_prop.(Drug_Group{group}).sleep_pre(ind_to_use)*100 , ZoneEntries.Shock.(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
axis square
title('Sleep Pre')
xlim([0 18]); ylim([0 260])
ylabel('Zone entries density (#/min)')
u=text(-5,75,'Cond'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)

subplot(222)
[u1,v1]=PlotCorrelations_BM(REM_prop.(Drug_Group{group}).sleep_post(ind_to_use)*100 , ZoneEntries.Shock.(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
axis square
xlim([0 18]); ylim([0 260])
title('Sleep Post')

subplot(223)
[u1,v1]=PlotCorrelations_BM(REM_prop.(Drug_Group{group}).sleep_pre(ind_to_use)*100 , ZoneEntries.Shock.(Drug_Group{group}).TestPost(ind_to_use)*100,30,0,'k')
axis square
ylabel('Zone entries density (#/min)')
xlim([0 18]); ylim([0 260]);  xlabel('REM (%)')
u=text(-5,75,'Test Post'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)

subplot(224)
[u1,v1]=PlotCorrelations_BM(REM_prop.(Drug_Group{group}).sleep_post(ind_to_use)*100 , ZoneEntries.Shock.(Drug_Group{group}).TestPost(ind_to_use)*100,30,0,'k')
axis square
xlim([0 18]); ylim([0 260]);  xlabel('REM (%)')

a=suptitle('Shock zone entries = f(% REM)'); a.FontSize=20;


% SZ occupancy
figure
subplot(221)
ind_to_use = and(REM_prop.(Drug_Group{group}).sleep_pre>0.05 , and(REM_prop.(Drug_Group{group}).sleep_post>0.03 , ZoneEntries.Shock.(Drug_Group{group}).Cond'<3));
[u1,v1]=PlotCorrelations_BM(REM_prop.(Drug_Group{group}).sleep_pre(ind_to_use)*100 , ZoneOccupancy.Shock.(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
axis square
title('Sleep Pre')
xlim([0 18]); ylim([0 25])
ylabel('Occupancy (%)')
u=text(-5,10,'Cond'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)

subplot(222)
[u1,v1]=PlotCorrelations_BM(REM_prop.(Drug_Group{group}).sleep_post(ind_to_use)*100 , ZoneOccupancy.Shock.(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
axis square
xlim([0 18]); ylim([0 25])
title('Sleep Post')

subplot(223)
[u1,v1]=PlotCorrelations_BM(REM_prop.(Drug_Group{group}).sleep_pre(ind_to_use)*100 , ZoneOccupancy.Shock.(Drug_Group{group}).TestPost(ind_to_use)*100,30,0,'k')
axis square
ylabel('Occupancy (%)')
xlim([0 18]); ylim([0 60]);  xlabel('REM (%)')
u=text(-5,10,'Test Post'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)

subplot(224)
[u1,v1]=PlotCorrelations_BM(REM_prop.(Drug_Group{group}).sleep_post(ind_to_use)*100 , ZoneOccupancy.Shock.(Drug_Group{group}).TestPost(ind_to_use)*100,30,0,'k')
axis square
xlim([0 18]); ylim([0 60]);  xlabel('REM (%)')

a=suptitle('Shock zone occupancy = f(% REM)'); a.FontSize=20;



% REM diff
group=6;
figure
ind_to_use = and(REM_diff.(Drug_Group{group})<.3 , FreezingProportion.All.(Drug_Group{group}).Cond'<.4);
for type=1:4
    subplot(2,4,type)
    [u1,v1]=PlotCorrelations_BM(REM_diff.(Drug_Group{group})(ind_to_use)*100 , FreezingProportion.(Type{type}).(Drug_Group{group}).Fear(ind_to_use)*100,30,0,'k')
    axis square
    xlim([-10 10]); if type==4; ylim([0 100]); else; ylim([0 35]); end
    if type==1; ylabel('Freezing (%)'); end
    title(Type{type})
    
    subplot(2,4,type+4)
    [u1,v1]=PlotCorrelations_BM(REM_diff.(Drug_Group{group})(ind_to_use)*100 , FreezingProportion.(Type{type}).(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
    axis square
    xlim([-10 10]); if type==4; ylim([0 100]); else; ylim([0 35]); end
    xlabel('REM pre - REM post (%)')
    if type==1; ylabel('Freezing (%)'); end
end
a=suptitle('Freezing = f(% REM pre - % REM post)'); a.FontSize=20;



% REM diff & learning
figure
subplot(221)
ind_to_use = and(REM_diff.(Drug_Group{group})<.3 , FreezingProportion.All.(Drug_Group{group}).Cond'<.4);
[u1,v1]=PlotCorrelations_BM(REM_diff.(Drug_Group{group})(ind_to_use)*100 , ZoneEntries.Shock.(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
axis square
xlim([-10 10]); ylim([0 400])
ylabel('Zone entries density (#/min)')
title('Cond')

subplot(222)
[u1,v1]=PlotCorrelations_BM(REM_diff.(Drug_Group{group})(ind_to_use)*100 , ZoneEntries.Shock.(Drug_Group{group}).TestPost(ind_to_use)*100,30,0,'k')
axis square
xlim([-10 10]); ylim([0 400])
title('Test Post')

subplot(223)
[u1,v1]=PlotCorrelations_BM(REM_diff.(Drug_Group{group})(ind_to_use)*100 , ZoneOccupancy.Shock.(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
axis square
xlim([-10 10]); ylim([0 60]); xlabel('REM (%)')
ylabel('Occupancy (%)')
title('Cond')

subplot(224)
[u1,v1]=PlotCorrelations_BM(REM_diff.(Drug_Group{group})(ind_to_use)*100 , ZoneOccupancy.Shock.(Drug_Group{group}).TestPost(ind_to_use)*100,30,0,'k')
axis square
xlim([-10 10]); ylim([0 60]); xlabel('REM (%)')
title('Test Post')

a=suptitle('Learning = f(% REM pre - % REM post)'); a.FontSize=20;



%% Sequential REM
% All freezing
for type=1:4
    figure
    subplot(221)
    ind_to_use = and(REM_prop.(Drug_Group{group}).sleep_pre>0.05 , and(REM_prop.(Drug_Group{group}).sleep_post>0.03 , and(REM_prop.(Drug_Group{group}).sleep_pre<0.2 ,FreezingProportion.All.(Drug_Group{group}).Cond'<.4)));
    [u1,v1]=PlotCorrelations_BM(Sequential_REM_Proportion.(Drug_Group{group}).sleep_pre(ind_to_use)*100 , FreezingProportion.(Type{type}).(Drug_Group{group}).Fear(ind_to_use)*100,30,0,'k')
    axis square
    title('Sleep Pre')
    ylabel('Freezing (%)')
    xlim([0 18]); if type==4; ylim([0 100]); else; ylim([0 35]); end
    u=text(-5,10,'Cond + Ext'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)
    
    subplot(222)
    [u1,v1]=PlotCorrelations_BM(Sequential_REM_Proportion.(Drug_Group{group}).sleep_post(ind_to_use)*100 , FreezingProportion.(Type{type}).(Drug_Group{group}).Fear(ind_to_use)*100,30,0,'k')
    axis square
    xlim([0 18]); if type==4; ylim([0 100]); else; ylim([0 35]); end
    title('Sleep Post')
    
    subplot(223)
    [u1,v1]=PlotCorrelations_BM(Sequential_REM_Proportion.(Drug_Group{group}).sleep_pre(ind_to_use)*100 , FreezingProportion.(Type{type}).(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
    axis square
    ylabel('Freezing (%)')
    xlabel('REM (%)')
    xlim([0 18]); if type==4; ylim([0 100]); else; ylim([0 35]); end
    u=text(-5,13,'Cond'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)
    
    subplot(224)
    [u1,v1]=PlotCorrelations_BM(Sequential_REM_Proportion.(Drug_Group{group}).sleep_post(ind_to_use)*100 , FreezingProportion.(Type{type}).(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
    axis square
    xlabel('REM (%)')
    xlim([0 18]); if type==4; ylim([0 100]); else; ylim([0 35]); end
    
    a=suptitle(['% ' num2str(Type{type}) ' = f(% Sequential REM)']); a.FontSize=20;
end


% Sequential REM & learning
figure
subplot(221)
ind_to_use = and(REM_prop.(Drug_Group{group}).sleep_pre>0.05 , and(REM_prop.(Drug_Group{group}).sleep_post>0.03 , ZoneEntries.Shock.(Drug_Group{group}).Cond'<3));
[u1,v1]=PlotCorrelations_BM(Sequential_REM_Proportion.(Drug_Group{group}).sleep_pre(ind_to_use)*100 , ZoneEntries.Shock.(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
axis square
title('Sleep Pre')
xlim([0 18]); ylim([0 260])
ylabel('Zone entries density (#/min)')
u=text(-5,75,'Cond'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)

subplot(222)
[u1,v1]=PlotCorrelations_BM(Sequential_REM_Proportion.(Drug_Group{group}).sleep_post(ind_to_use)*100 , ZoneEntries.Shock.(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
axis square
xlim([0 18]); ylim([0 260])
title('Sleep Post')

subplot(223)
[u1,v1]=PlotCorrelations_BM(Sequential_REM_Proportion.(Drug_Group{group}).sleep_pre(ind_to_use)*100 , ZoneEntries.Shock.(Drug_Group{group}).TestPost(ind_to_use)*100,30,0,'k')
axis square
ylabel('Zone entries density (#/min)')
xlim([0 18]); ylim([0 260]); xlabel('REM (%)')
u=text(-5,75,'Test Post'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)

subplot(224)
[u1,v1]=PlotCorrelations_BM(Sequential_REM_Proportion.(Drug_Group{group}).sleep_post(ind_to_use)*100 , ZoneEntries.Shock.(Drug_Group{group}).TestPost(ind_to_use)*100,30,0,'k')
axis square
xlim([0 18]); ylim([0 260]);  xlabel('REM (%)')

a=suptitle('Shock zone entries = f(% Sequential REM)'); a.FontSize=20;


% SZ occupancy
figure
subplot(221)
ind_to_use = and(REM_prop.(Drug_Group{group}).sleep_pre>0.05 , and(REM_prop.(Drug_Group{group}).sleep_post>0.03 , ZoneEntries.Shock.(Drug_Group{group}).Cond'<3));
[u1,v1]=PlotCorrelations_BM(Sequential_REM_Proportion.(Drug_Group{group}).sleep_pre(ind_to_use)*100 , ZoneOccupancy.Shock.(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
axis square
title('Sleep Pre')
xlim([0 18]); ylim([0 25])
ylabel('Occupancy (%)')
u=text(-5,10,'Cond'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)

subplot(222)
[u1,v1]=PlotCorrelations_BM(Sequential_REM_Proportion.(Drug_Group{group}).sleep_post(ind_to_use)*100 , ZoneOccupancy.Shock.(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
axis square
xlim([0 18]); ylim([0 25])
title('Sleep Post')

subplot(223)
[u1,v1]=PlotCorrelations_BM(Sequential_REM_Proportion.(Drug_Group{group}).sleep_pre(ind_to_use)*100 , ZoneOccupancy.Shock.(Drug_Group{group}).TestPost(ind_to_use)*100,30,0,'k')
axis square
ylabel('Occupancy (%)')
xlim([0 18]); ylim([0 60]); xlabel('REM (%)')
u=text(-5,10,'Test Post'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)

subplot(224)
[u1,v1]=PlotCorrelations_BM(Sequential_REM_Proportion.(Drug_Group{group}).sleep_post(ind_to_use)*100 , ZoneOccupancy.Shock.(Drug_Group{group}).TestPost(ind_to_use)*100,30,0,'k')
axis square
xlim([0 18]); ylim([0 60]); xlabel('REM (%)')

a=suptitle('Shock zone occupancy = f(% Sequential REM)'); a.FontSize=20;


group=6;
% REM diff & freezing
figure
ind_to_use = and(REM_diff.(Drug_Group{group})<.3 , FreezingProportion.All.(Drug_Group{group}).Cond'<.4);
for type=1:4
    subplot(2,4,type)
    [u1,v1]=PlotCorrelations_BM(Sequential_REM_diff.(Drug_Group{group})(ind_to_use)*100 , FreezingProportion.(Type{type}).(Drug_Group{group}).Fear(ind_to_use)*100,30,0,'k')
    axis square
    xlim([-10 10]); if type==4; ylim([0 100]); else; ylim([0 35]); end
    if type==1; ylabel('Freezing (%)'); end
    title(Type{type})
    
    subplot(2,4,type+4)
    [u1,v1]=PlotCorrelations_BM(Sequential_REM_diff.(Drug_Group{group})(ind_to_use)*100 , FreezingProportion.(Type{type}).(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
    axis square
    xlim([-10 10]); if type==4; ylim([0 100]); else; ylim([0 35]); end
    xlabel('REM pre - REM post (%)')
    if type==1; ylabel('Freezing (%)'); end
end
a=suptitle('Freezing = f(% Sequential REM pre - % Sequential REM post)'); a.FontSize=20;



% REM diff & learning
figure
subplot(221)
ind_to_use = and(REM_diff.(Drug_Group{group})<.3 , FreezingProportion.All.(Drug_Group{group}).Cond'<.4);
[u1,v1]=PlotCorrelations_BM(Sequential_REM_diff.(Drug_Group{group})(ind_to_use)*100 , ZoneEntries.Shock.(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
axis square
xlim([-10 10]); ylim([0 400])
ylabel('Zone entries density (#/min)')
title('Cond')

subplot(222)
[u1,v1]=PlotCorrelations_BM(Sequential_REM_diff.(Drug_Group{group})(ind_to_use)*100 , ZoneEntries.Shock.(Drug_Group{group}).TestPost(ind_to_use)*100,30,0,'k')
axis square
xlim([-10 10]); ylim([0 400])
title('Test Post')

subplot(223)
[u1,v1]=PlotCorrelations_BM(Sequential_REM_diff.(Drug_Group{group})(ind_to_use)*100 , ZoneOccupancy.Shock.(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
axis square
xlim([-10 10]); ylim([0 60]); xlabel('REM (%)')
ylabel('Occupancy (%)')
title('Cond')

subplot(224)
[u1,v1]=PlotCorrelations_BM(Sequential_REM_diff.(Drug_Group{group})(ind_to_use)*100 , ZoneOccupancy.Shock.(Drug_Group{group}).TestPost(ind_to_use)*100,30,0,'k')
axis square
xlim([-10 10]); ylim([0 60]); xlabel('REM (%)')
title('Test Post')

a=suptitle('Learning = f(% Sequential REM pre - % Sequential REM post)'); a.FontSize=20;


%% Single REM
% All freezing
for type=1:4
    figure
    subplot(221)
    ind_to_use = and(REM_prop.(Drug_Group{group}).sleep_pre>0.05 , and(REM_prop.(Drug_Group{group}).sleep_post>0.03 , and(REM_prop.(Drug_Group{group}).sleep_pre<0.2 ,FreezingProportion.All.(Drug_Group{group}).Cond'<.4)));
    [u1,v1]=PlotCorrelations_BM(Single_REM_Proportion.(Drug_Group{group}).sleep_pre(ind_to_use)*100 , FreezingProportion.(Type{type}).(Drug_Group{group}).Fear(ind_to_use)*100,30,0,'k')
    axis square
    title('Sleep Pre')
    ylabel('Freezing (%)')
    xlim([0 18]); if type==4; ylim([0 100]); else; ylim([0 35]); end
    u=text(-5,10,'Cond + Ext'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)
    
    subplot(222)
    [u1,v1]=PlotCorrelations_BM(Single_REM_Proportion.(Drug_Group{group}).sleep_post(ind_to_use)*100 , FreezingProportion.(Type{type}).(Drug_Group{group}).Fear(ind_to_use)*100,30,0,'k')
    axis square
    xlim([0 18]); if type==4; ylim([0 100]); else; ylim([0 35]); end
    title('Sleep Post')
    
    subplot(223)
    [u1,v1]=PlotCorrelations_BM(Single_REM_Proportion.(Drug_Group{group}).sleep_pre(ind_to_use)*100 , FreezingProportion.(Type{type}).(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
    axis square
    ylabel('Freezing (%)')
    xlabel('REM (%)')
    xlim([0 18]); if type==4; ylim([0 100]); else; ylim([0 35]); end
    u=text(-5,13,'Cond'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)
    
    subplot(224)
    [u1,v1]=PlotCorrelations_BM(Single_REM_Proportion.(Drug_Group{group}).sleep_post(ind_to_use)*100 , FreezingProportion.(Type{type}).(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
    axis square
    xlabel('REM (%)')
    xlim([0 18]); if type==4; ylim([0 100]); else; ylim([0 35]); end
    
    a=suptitle(['% ' num2str(Type{type}) ' = f(% Single REM)']); a.FontSize=20;
end


% Single REM & learning
figure
subplot(221)
ind_to_use = and(REM_prop.(Drug_Group{group}).sleep_pre>0.05 , and(REM_prop.(Drug_Group{group}).sleep_post>0.03 , ZoneEntries.Shock.(Drug_Group{group}).Cond'<3));
[u1,v1]=PlotCorrelations_BM(Single_REM_Proportion.(Drug_Group{group}).sleep_pre(ind_to_use)*100 , ZoneEntries.Shock.(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
axis square
title('Sleep Pre')
xlim([0 18]); ylim([0 260]); xlabel('REM (%)')
ylabel('Zone entries density (#/min)')
u=text(-5,75,'Cond'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)

subplot(222)
[u1,v1]=PlotCorrelations_BM(Single_REM_Proportion.(Drug_Group{group}).sleep_post(ind_to_use)*100 , ZoneEntries.Shock.(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
axis square
xlim([0 18]); ylim([0 260]); xlabel('REM (%)')
title('Sleep Post')

subplot(223)
[u1,v1]=PlotCorrelations_BM(Single_REM_Proportion.(Drug_Group{group}).sleep_pre(ind_to_use)*100 , ZoneEntries.Shock.(Drug_Group{group}).TestPost(ind_to_use)*100,30,0,'k')
axis square
ylabel('Zone entries density (#/min)')
xlim([0 18]); ylim([0 260]); xlabel('REM (%)')
u=text(-5,75,'Test Post'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)

subplot(224)
[u1,v1]=PlotCorrelations_BM(Single_REM_Proportion.(Drug_Group{group}).sleep_post(ind_to_use)*100 , ZoneEntries.Shock.(Drug_Group{group}).TestPost(ind_to_use)*100,30,0,'k')
axis square
xlim([0 18]); ylim([0 260]); xlabel('REM (%)')

a=suptitle('Shock zone entries = f(% Single REM)'); a.FontSize=20;


% SZ occupancy
figure
subplot(221)
ind_to_use = and(REM_prop.(Drug_Group{group}).sleep_pre>0.05 , and(REM_prop.(Drug_Group{group}).sleep_post>0.03 , ZoneEntries.Shock.(Drug_Group{group}).Cond'<3));
[u1,v1]=PlotCorrelations_BM(Single_REM_Proportion.(Drug_Group{group}).sleep_pre(ind_to_use)*100 , ZoneOccupancy.Shock.(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
axis square
title('Sleep Pre')
xlim([0 18]); ylim([0 25]); xlabel('REM (%)')
ylabel('Occupancy (%)')
u=text(-5,10,'Cond'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)

subplot(222)
[u1,v1]=PlotCorrelations_BM(Single_REM_Proportion.(Drug_Group{group}).sleep_post(ind_to_use)*100 , ZoneOccupancy.Shock.(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
axis square
xlim([0 18]); ylim([0 25]); xlabel('REM (%)')
title('Sleep Post')

subplot(223)
[u1,v1]=PlotCorrelations_BM(Single_REM_Proportion.(Drug_Group{group}).sleep_pre(ind_to_use)*100 , ZoneOccupancy.Shock.(Drug_Group{group}).TestPost(ind_to_use)*100,30,0,'k')
axis square
ylabel('Occupancy (%)')
xlim([0 18]); ylim([0 60]); xlabel('REM (%)')
u=text(-5,10,'Test Post'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)

subplot(224)
[u1,v1]=PlotCorrelations_BM(Single_REM_Proportion.(Drug_Group{group}).sleep_post(ind_to_use)*100 , ZoneOccupancy.Shock.(Drug_Group{group}).TestPost(ind_to_use)*100,30,0,'k')
axis square
xlim([0 18]); ylim([0 60]); xlabel('REM (%)')

a=suptitle('Shock zone occupancy = f(% Single REM)'); a.FontSize=20;



% REM diff
group=6;
figure
ind_to_use = and(REM_diff.(Drug_Group{group})<.3 , FreezingProportion.All.(Drug_Group{group}).Cond'<.4);
for type=1:4
    subplot(2,4,type)
    [u1,v1]=PlotCorrelations_BM(Single_REM_diff.(Drug_Group{group})(ind_to_use)*100 , FreezingProportion.(Type{type}).(Drug_Group{group}).Fear(ind_to_use)*100,30,0,'k')
    axis square
    xlim([-10 10]); if type==4; ylim([0 100]); else; ylim([0 35]); end
    if type==1; ylabel('Freezing (%)'); end
    title(Type{type})
    
    subplot(2,4,type+4)
    [u1,v1]=PlotCorrelations_BM(Single_REM_diff.(Drug_Group{group})(ind_to_use)*100 , FreezingProportion.(Type{type}).(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
    axis square
    xlim([-10 10]); if type==4; ylim([0 100]); else; ylim([0 35]); end
    xlabel('REM pre - REM post (%)')
    if type==1; ylabel('Freezing (%)'); end
end
a=suptitle('Freezing = f(% Single REM pre - % Single REM post)'); a.FontSize=20;


% REM diff & learning
figure
subplot(221)
ind_to_use = and(REM_diff.(Drug_Group{group})<.3 , FreezingProportion.All.(Drug_Group{group}).Cond'<.4);
[u1,v1]=PlotCorrelations_BM(Single_REM_diff.(Drug_Group{group})(ind_to_use)*100 , ZoneEntries.Shock.(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
axis square
xlim([-10 10]); ylim([0 400])
ylabel('Zone entries density (#/min)')
title('Cond')

subplot(222)
[u1,v1]=PlotCorrelations_BM(Single_REM_diff.(Drug_Group{group})(ind_to_use)*100 , ZoneEntries.Shock.(Drug_Group{group}).TestPost(ind_to_use)*100,30,0,'k')
axis square
xlim([-10 10]); ylim([0 400])
title('Test Post')

subplot(223)
[u1,v1]=PlotCorrelations_BM(Single_REM_diff.(Drug_Group{group})(ind_to_use)*100 , ZoneOccupancy.Shock.(Drug_Group{group}).Cond(ind_to_use)*100,30,0,'k')
axis square
xlim([-10 10]); ylim([0 60])
ylabel('Occupancy (%)')
title('Cond')

subplot(224)
[u1,v1]=PlotCorrelations_BM(Single_REM_diff.(Drug_Group{group})(ind_to_use)*100 , ZoneOccupancy.Shock.(Drug_Group{group}).TestPost(ind_to_use)*100,30,0,'k')
axis square
xlim([-10 10]); ylim([0 60])
title('Test Post')

a=suptitle('Learning = f(% Single REM pre - % Single REM post)'); a.FontSize=20;

