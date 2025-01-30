


Cols1 = {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098]};
X1 = [1:2];
Legends1 = {'Saline','DZP'};
NoLegends = {'','','',''};
Cols2 = {[0.6350, 0.0780, 0.1840],[0.75, 0.75, 0]};
Legends2 = {'RipControl','RipInhib'};


%% All freezing & ratio
FreezingProportion.Figure.All.(Session_type{2}){5}(6)=NaN;
figure; n=1;
for sess=[2 3]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.All.(Session_type{sess})([5 6]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Freezing proportion'); end
    title(Session_type{sess})
    ylim([-0.01 0.75]); u=text(1,.7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.All.(Session_type{sess})([16 13]),Cols2,X1,NoLegends,'showpoints',1,'paired',0); 
    title(Session_type{sess})
    ylim([-0.01 0.75]); u=text(1,.7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Ratio.(Session_type{sess})([5 6]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock/Safe ratio'); end
    ylim([-0.01 1.1]); u=text(1,1.05,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Ratio.(Session_type{sess})([16 13]),Cols2,X1,Legends2,'showpoints',1,'paired',0); 
    ylim([-0.01 1.1]); u=text(1,1.05,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments'); a.FontSize=20;


FreezingProportion.Figure.All.(Session_type{2}){9}(6)=NaN;
figure; n=1;
for sess=[2 3]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.All.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Freezing proportion'); end
    title(Session_type{sess})
    ylim([-0.01 0.75]); u=text(1,.7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.All.(Session_type{sess})([18 17]),Cols2,X1,NoLegends,'showpoints',1,'paired',0); 
    title(Session_type{sess})
    ylim([-0.01 0.75]); u=text(1,.7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Ratio.(Session_type{sess})([9 11]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock/Safe ratio'); end
    ylim([-0.01 1.1]); u=text(1,1.05,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Ratio.(Session_type{sess})([18 17]),Cols2,X1,Legends2,'showpoints',1,'paired',0); 
    ylim([-0.01 1.1]); u=text(1,1.05,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments'); a.FontSize=20;



figure; n=1;
for sess=[2 3]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.All.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Freezing proportion'); end
    title(Session_type{sess})
    ylim([-0.01 0.75]); u=text(1,.7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.All.(Session_type{sess})([20 19]),Cols2,X1,NoLegends,'showpoints',0,'paired',1); 
    title(Session_type{sess})
    ylim([-0.01 0.75]); u=text(1,.7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Ratio.(Session_type{sess})([9 11]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock/Safe ratio'); end
    ylim([-0.01 1.1]); u=text(1,1.05,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Ratio.(Session_type{sess})([20 19]),Cols2,X1,Legends2,'showpoints',0,'paired',1); 
    ylim([-0.01 1.1]); u=text(1,1.05,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments'); a.FontSize=20;


%% Shock & safe freezing
FreezingProportion.Figure.Shock.(Session_type{2}){5}(6)=NaN;
FreezingProportion.Figure.Safe.(Session_type{2}){5}(6)=NaN;
figure; n=1;
for sess=[2 3]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Shock.(Session_type{sess})([5 6]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock freezing proportion'); end
    title(Session_type{sess})
    ylim([-0.01 0.75]); u=text(1,.7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Shock.(Session_type{sess})([16 13]),Cols2,X1,NoLegends,'showpoints',1,'paired',0); 
    title(Session_type{sess})
    ylim([-0.01 0.75]); u=text(1,.7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Safe.(Session_type{sess})([5 6]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Safe freezing proportion'); end
    ylim([-0.01 .75]); u=text(1,.7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Safe.(Session_type{sess})([16 13]),Cols2,X1,Legends2,'showpoints',1,'paired',0); 
    ylim([-0.01 .75]); u=text(1,.7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments'); a.FontSize=20;


FreezingProportion.Figure.Shock.(Session_type{2}){9}(6)=NaN;
FreezingProportion.Figure.Safe.(Session_type{2}){9}(6)=NaN;
figure; n=1;
for sess=[2 3]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Shock.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock freezing proportion'); end
    title(Session_type{sess})
    ylim([-0.01 0.75]); u=text(1,.7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Shock.(Session_type{sess})([18 17]),Cols2,X1,NoLegends,'showpoints',1,'paired',0); 
    title(Session_type{sess})
    ylim([-0.01 0.75]); u=text(1,.7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Safe.(Session_type{sess})([9 11]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Safe freezing proportion'); end
    ylim([-0.01 .75]); u=text(1,.7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Safe.(Session_type{sess})([18 17]),Cols2,X1,Legends2,'showpoints',1,'paired',0); 
    ylim([-0.01 .75]); u=text(1,.7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments'); a.FontSize=20;



figure; n=1;
for sess=[2 3]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Shock.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock freezing proportion'); end
    title(Session_type{sess})
    ylim([-0.01 0.75]); u=text(1,.7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Shock.(Session_type{sess})([20 19]),Cols2,X1,NoLegends,'showpoints',0,'paired',1); 
    title(Session_type{sess})
    ylim([-0.01 0.75]); u=text(1,.7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Safe.(Session_type{sess})([9 11]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Safe freezing proportion'); end
    ylim([-0.01 1.1]); u=text(1,1.05,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Safe.(Session_type{sess})([20 19]),Cols2,X1,Legends2,'showpoints',0,'paired',1); 
    ylim([-0.01 1.1]); u=text(1,1.05,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments'); a.FontSize=20;



%% Freezing episodes number
Episode_Number.Shock.(Session_type{2}){5}(6)=NaN;
Episode_Number.Safe.(Session_type{2}){5}(6)=NaN;
figure; n=1;
for sess=[2 3]
    subplot(3,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_Number.All.(Session_type{sess})([5 6]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Freezing episodes #'); end
    title(Session_type{sess})
    ylim([-0.01 300]); u=text(1,295,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_Number.All.(Session_type{sess})([16 13]),Cols2,X1,NoLegends,'showpoints',1,'paired',0); 
    title(Session_type{sess})
    ylim([-0.01 300]); u=text(1,295,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
 
    subplot(3,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_Number.Shock.(Session_type{sess})([5 6]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock freezing episodes #'); end
    title(Session_type{sess})
    ylim([-0.01 120]); u=text(1,115,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_Number.Shock.(Session_type{sess})([16 13]),Cols2,X1,NoLegends,'showpoints',1,'paired',0); 
    title(Session_type{sess})
    ylim([-0.01 120]); u=text(1,115,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+9)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_Number.Safe.(Session_type{sess})([5 6]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Safe freezing episodes #'); end
    ylim([-0.01 200]); u=text(1,195,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+10)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_Number.Safe.(Session_type{sess})([16 13]),Cols2,X1,Legends2,'showpoints',1,'paired',0); 
    ylim([-0.01 200]); u=text(1,195,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments'); a.FontSize=20;


Episode_Number.Shock.(Session_type{2}){9}(6)=NaN;
Episode_Number.Safe.(Session_type{2}){9}(6)=NaN;
figure; n=1;
for sess=[2 3]
    subplot(3,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_Number.All.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Freezing episodes #'); end
    title(Session_type{sess})
    ylim([-0.01 300]); u=text(1,295,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_Number.All.(Session_type{sess})([18 17]),Cols2,X1,NoLegends,'showpoints',1,'paired',0); 
    title(Session_type{sess})
    ylim([-0.01 300]); u=text(1,295,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
 
    subplot(3,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_Number.Shock.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock freezing episodes #'); end
    title(Session_type{sess})
    ylim([-0.01 120]); u=text(1,115,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_Number.Shock.(Session_type{sess})([18 17]),Cols2,X1,NoLegends,'showpoints',1,'paired',0); 
    title(Session_type{sess})
    ylim([-0.01 120]); u=text(1,115,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+9)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_Number.Safe.(Session_type{sess})([9 11]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Safe freezing episodes #'); end
    ylim([-0.01 200]); u=text(1,195,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+10)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_Number.Safe.(Session_type{sess})([18 17]),Cols2,X1,Legends2,'showpoints',1,'paired',0); 
    ylim([-0.01 200]); u=text(1,195,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments'); a.FontSize=20;



figure;  n=1;
for sess=[2 3]
    subplot(3,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_Number.All.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Freezing episodes #'); end
    title(Session_type{sess})
    ylim([-0.01 300]); u=text(1,295,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_Number.All.(Session_type{sess})([20 19]),Cols2,X1,NoLegends,'showpoints',0,'paired',1); 
    title(Session_type{sess})
    ylim([-0.01 300]); u=text(1,295,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
 
    subplot(3,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_Number.Shock.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock freezing episodes #'); end
    title(Session_type{sess})
    ylim([-0.01 120]); u=text(1,115,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_Number.Shock.(Session_type{sess})([20 19]),Cols2,X1,NoLegends,'showpoints',0,'paired',1); 
    title(Session_type{sess})
    ylim([-0.01 120]); u=text(1,115,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+9)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_Number.Safe.(Session_type{sess})([9 11]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Safe freezing episodes #'); end
    ylim([-0.01 200]); u=text(1,195,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+10)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_Number.Safe.(Session_type{sess})([20 19]),Cols2,X1,Legends2,'showpoints',0,'paired',1); 
    ylim([-0.01 200]); u=text(1,195,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments, episodes number'); a.FontSize=20;


%% Freezing episodes mean duration
Episode_MedianDuration.Shock.(Session_type{2}){5}(6)=NaN;
Episode_MedianDuration.Safe.(Session_type{2}){5}(6)=NaN;
figure; n=1;
for sess=[2 3]
    subplot(3,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.All.(Session_type{sess})([5 6]),Cols1,X1,NoLegends,'showpoints',1,'paired',0);
    if sess==2; ylabel('Freezing episodes #'); end
    title(Session_type{sess})
    ylim([0 7.5 ]); u=text(1,7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.All.(Session_type{sess})([16 13]),Cols2,X1,NoLegends,'showpoints',1,'paired',0);
    title(Session_type{sess})
    ylim([0 7.5 ]); u=text(1,7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.Shock.(Session_type{sess})([5 6]),Cols1,X1,NoLegends,'showpoints',1,'paired',0);
    if sess==2; ylabel('Shock freezing episodes #'); end
    title(Session_type{sess})
    ylim([0 7.5 ]); u=text(1,7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.Shock.(Session_type{sess})([16 13]),Cols2,X1,NoLegends,'showpoints',1,'paired',0);
    title(Session_type{sess})
    ylim([0 7.5 ]); u=text(1,7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+9)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.Safe.(Session_type{sess})([5 6]),Cols1,X1,Legends1,'showpoints',1,'paired',0);
    if sess==2; ylabel('Safe freezing episodes #'); end
    ylim([0 7.5 ]); u=text(1,7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+10)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.Safe.(Session_type{sess})([16 13]),Cols2,X1,Legends2,'showpoints',1,'paired',0);
    ylim([0 7.5 ]); u=text(1,7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments, episodes mean duration'); a.FontSize=20;


Episode_MedianDuration.Shock.(Session_type{2}){9}(6)=NaN;
Episode_MedianDuration.Safe.(Session_type{2}){9}(6)=NaN;
figure; n=1;
for sess=[2 3]
    subplot(3,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.All.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0);
    if sess==2; ylabel('Freezing episodes #'); end
    title(Session_type{sess})
    ylim([0 7.5 ]); u=text(1,7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.All.(Session_type{sess})([18 17]),Cols2,X1,NoLegends,'showpoints',1,'paired',0);
    title(Session_type{sess})
    ylim([0 7.5 ]); u=text(1,7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.Shock.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0);
    if sess==2; ylabel('Shock freezing episodes #'); end
    title(Session_type{sess})
    ylim([0 7.5 ]); u=text(1,7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.Shock.(Session_type{sess})([18 17]),Cols2,X1,NoLegends,'showpoints',1,'paired',0);
    title(Session_type{sess})
    ylim([0 7.5 ]); u=text(1,7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+9)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.Safe.(Session_type{sess})([9 11]),Cols1,X1,Legends1,'showpoints',1,'paired',0);
    if sess==2; ylabel('Safe freezing episodes #'); end
    ylim([0 7.5 ]); u=text(1,7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+10)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.Safe.(Session_type{sess})([18 17]),Cols2,X1,Legends2,'showpoints',1,'paired',0);
    ylim([0 7.5 ]); u=text(1,7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments, episodes mean duration'); a.FontSize=20;



figure;  n=1;
for sess=[2 3]
    subplot(3,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.All.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0);
    if sess==2; ylabel('Freezing episodes #'); end
    title(Session_type{sess})
    ylim([0 7.5 ]); u=text(1,7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.All.(Session_type{sess})([20 19]),Cols2,X1,NoLegends,'showpoints',0,'paired',1);
    title(Session_type{sess})
    ylim([0 7.5 ]); u=text(1,7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.Shock.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0);
    if sess==2; ylabel('Shock freezing episodes #'); end
    title(Session_type{sess})
    ylim([0 7.5 ]); u=text(1,7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.Shock.(Session_type{sess})([20 19]),Cols2,X1,NoLegends,'showpoints',0,'paired',1);
    title(Session_type{sess})
    ylim([0 7.5 ]); u=text(1,7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+9)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.Safe.(Session_type{sess})([9 11]),Cols1,X1,Legends1,'showpoints',1,'paired',0);
    if sess==2; ylabel('Safe freezing episodes #'); end
    ylim([0 7.5 ]); u=text(1,7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(3,4,(n-1)*2+10)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.Safe.(Session_type{sess})([20 19]),Cols2,X1,Legends2,'showpoints',0,'paired',1);
    ylim([0 7.5 ]); u=text(1,7,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments, episodes mean duration'); a.FontSize=20;


%% Zone entries
figure; n=1;
for sess=[2 7]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntries.Figure.Shock.(Session_type{sess})([5 6]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock freezing proportion'); end
    title(Session_type{sess})
    ylim([0 5]); u=text(1,4.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntries.Figure.Shock.(Session_type{sess})([16 13]),Cols2,X1,NoLegends,'showpoints',1,'paired',0); 
    title(Session_type{sess})
    ylim([0 5]); u=text(1,4.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntries.Figure.Safe.(Session_type{sess})([5 6]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Safe freezing proportion'); end
    ylim([0 5]); u=text(1,4.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntries.Figure.Safe.(Session_type{sess})([16 13]),Cols2,X1,Legends2,'showpoints',1,'paired',0); 
    ylim([0 5]); u=text(1,4.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments, zone entries'); a.FontSize=20;


figure; n=1;
for sess=[2 7]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntries.Figure.Shock.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock freezing proportion'); end
    title(Session_type{sess})
    ylim([0 5]); u=text(1,4.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntries.Figure.Shock.(Session_type{sess})([18 17]),Cols2,X1,NoLegends,'showpoints',1,'paired',0); 
    title(Session_type{sess})
    ylim([0 5]); u=text(1,4.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15)
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntries.Figure.Safe.(Session_type{sess})([9 11]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Safe freezing proportion'); end
    ylim([0 5]); u=text(1,4.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntries.Figure.Safe.(Session_type{sess})([18 17]),Cols2,X1,Legends2,'showpoints',1,'paired',0); 
    ylim([0 5]); u=text(1,4.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments, zone entries'); a.FontSize=20;



figure; n=1;
for sess=[2 7]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntries.Figure.Shock.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock freezing proportion'); end
    title(Session_type{sess})
    ylim([0 5]); u=text(1,4.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntries.Figure.Shock.(Session_type{sess})([20 19]),Cols2,X1,NoLegends,'showpoints',0,'paired',1); 
    title(Session_type{sess})
    ylim([0 5]); u=text(1,4.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntries.Figure.Safe.(Session_type{sess})([9 11]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Safe freezing proportion'); end
    ylim([0 5]); u=text(1,4.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntries.Figure.Safe.(Session_type{sess})([20 19]),Cols2,X1,Legends2,'showpoints',0,'paired',1); 
    ylim([0 5]); u=text(1,4.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments, zone entries'); a.FontSize=20;


%% Zone entries when active
figure; n=1;
for sess=[2 7]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntriesActive.Figure.Shock.(Session_type{sess})([5 6]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock freezing proportion'); end
    title(Session_type{sess})
    ylim([0 7]); u=text(1,6.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntriesActive.Figure.Shock.(Session_type{sess})([16 13]),Cols2,X1,NoLegends,'showpoints',1,'paired',0); 
    title(Session_type{sess})
    ylim([0 7]); u=text(1,6.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntriesActive.Figure.Safe.(Session_type{sess})([5 6]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Safe freezing proportion'); end
    ylim([0 7]); u=text(1,6.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntriesActive.Figure.Safe.(Session_type{sess})([16 13]),Cols2,X1,Legends2,'showpoints',1,'paired',0); 
    ylim([0 7]); u=text(1,6.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments, zone entries normalized by time active'); a.FontSize=20;


figure; n=1;
for sess=[2 7]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntriesActive.Figure.Shock.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock freezing proportion'); end
    title(Session_type{sess})
    ylim([0 7]); u=text(1,6.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntriesActive.Figure.Shock.(Session_type{sess})([18 17]),Cols2,X1,NoLegends,'showpoints',1,'paired',0); 
    title(Session_type{sess})
    ylim([0 7]); u=text(1,6.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntriesActive.Figure.Safe.(Session_type{sess})([9 11]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Safe freezing proportion'); end
    ylim([0 7]); u=text(1,6.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntriesActive.Figure.Safe.(Session_type{sess})([18 17]),Cols2,X1,Legends2,'showpoints',1,'paired',0); 
    ylim([0 7]); u=text(1,6.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments, zone entries normalized by time active'); a.FontSize=20;



figure; n=1;
for sess=[2 7]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntriesActive.Figure.Shock.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock freezing proportion'); end
    title(Session_type{sess})
    ylim([0 7]); u=text(1,6.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntriesActive.Figure.Shock.(Session_type{sess})([20 19]),Cols2,X1,NoLegends,'showpoints',0,'paired',1); 
    title(Session_type{sess})
    ylim([0 7]); u=text(1,6.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntriesActive.Figure.Safe.(Session_type{sess})([9 11]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Safe freezing proportion'); end
    ylim([0 7]); u=text(1,6.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneEntriesActive.Figure.Safe.(Session_type{sess})([20 19]),Cols2,X1,Legends2,'showpoints',0,'paired',1); 
    ylim([0 7]); u=text(1,6.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments, zone entries normalized by time active'); a.FontSize=20;


%% Zone occupancy
figure; n=1;
for sess=[2 7]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.Figure.Shock.(Session_type{sess})([5 6]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock freezing proportion'); end
    title(Session_type{sess})
    ylim([0 1.1]); u=text(1,1,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.Figure.Shock.(Session_type{sess})([16 13]),Cols2,X1,NoLegends,'showpoints',1,'paired',0); 
    title(Session_type{sess})
    ylim([0 1.1]); u=text(1,1,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.Figure.Safe.(Session_type{sess})([5 6]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Safe freezing proportion'); end
    ylim([0 1.1]); u=text(1,1,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.Figure.Safe.(Session_type{sess})([16 13]),Cols2,X1,Legends2,'showpoints',1,'paired',0); 
    ylim([0 1.1]); u=text(1,1,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments, zone occupancy'); a.FontSize=20;


figure; n=1;
for sess=[2 7]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.Figure.Shock.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock freezing proportion'); end
    title(Session_type{sess})
    ylim([0 1.1]); u=text(1,1,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.Figure.Shock.(Session_type{sess})([18 17]),Cols2,X1,NoLegends,'showpoints',1,'paired',0); 
    title(Session_type{sess})
    ylim([0 1.1]); u=text(1,1,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.Figure.Safe.(Session_type{sess})([9 11]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Safe freezing proportion'); end
    ylim([0 1.1]); u=text(1,1,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.Figure.Safe.(Session_type{sess})([18 17]),Cols2,X1,Legends2,'showpoints',1,'paired',0); 
    ylim([0 1.1]); u=text(1,1,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments, zone occupancy'); a.FontSize=20;



figure; n=1;
for sess=[2 7]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.Figure.Shock.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock freezing proportion'); end
    title(Session_type{sess})
    ylim([0 1.1]); u=text(1,1,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.Figure.Shock.(Session_type{sess})([20 19]),Cols2,X1,NoLegends,'showpoints',0,'paired',1); 
    title(Session_type{sess})
    ylim([0 1.1]); u=text(1,1,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.Figure.Safe.(Session_type{sess})([9 11]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Safe freezing proportion'); end
    ylim([0 1.1]); u=text(1,1,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.Figure.Safe.(Session_type{sess})([20 19]),Cols2,X1,Legends2,'showpoints',0,'paired',1); 
    ylim([0 1.1]); u=text(1,1,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments, zone occupancy'); a.FontSize=20;



%% Stims
figure; n=1;
for sess=[4 5]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ExtraStim.Figure.(Session_type{sess})([5 6]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Stims / min'); end
    title(Session_type{sess})
    ylim([0 4]); u=text(1,3.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ExtraStim.Figure.(Session_type{sess})([16 13]),Cols2,X1,NoLegends,'showpoints',1,'paired',0); 
    title(Session_type{sess})
    ylim([0 4]); u=text(1,3.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Stim_By_SZ_entries.Figure.(Session_type{sess})([5 6]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Shock zone entries / stims'); end
    ylim([0 22]); u=text(1,21,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Stim_By_SZ_entries.Figure.(Session_type{sess})([16 13]),Cols2,X1,Legends2,'showpoints',1,'paired',0); 
    ylim([0 22]); u=text(1,21,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    n=n+1;
end
a=suptitle('Stims analysis, UMaze drugs experiments'); a.FontSize=20;


figure; n=1;
for sess=[4 5]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ExtraStim.Figure.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Stims / min'); end
    title(Session_type{sess})
    ylim([0 4]); u=text(1,3.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ExtraStim.Figure.(Session_type{sess})([18 17]),Cols2,X1,NoLegends,'showpoints',1,'paired',0); 
    title(Session_type{sess})
    ylim([0 4]); u=text(1,3.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Stim_By_SZ_entries.Figure.(Session_type{sess})([9 11]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Shock zone entries / stims'); end
    ylim([0 22]); u=text(1,21,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Stim_By_SZ_entries.Figure.(Session_type{sess})([18 17]),Cols2,X1,Legends2,'showpoints',1,'paired',0); 
    ylim([0 22]); u=text(1,21,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    n=n+1;
end
a=suptitle('Stims analysis, UMaze drugs experiments'); a.FontSize=20;



figure; n=1;
for sess=[4 5]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ExtraStim.Figure.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Stims / min'); end
    title(Session_type{sess})
    ylim([0 4]); u=text(1,3.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(ExtraStim.Figure.(Session_type{sess})([20 19]),Cols2,X1,NoLegends,'showpoints',0,'paired',1); 
    title(Session_type{sess})
    ylim([0 4]); u=text(1,3.8,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Stim_By_SZ_entries.Figure.(Session_type{sess})([9 11]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Shock zone entries / stims'); end
    ylim([0 22]); u=text(1,21,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Stim_By_SZ_entries.Figure.(Session_type{sess})([20 19]),Cols2,X1,Legends2,'showpoints',0,'paired',1); 
    ylim([0 22]); u=text(1,21,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    n=n+1;
end
a=suptitle('Stims analysis, UMaze drugs experiments'); a.FontSize=20;


%% Occupancy mean time
figure; n=1;
for sess=[2 7]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(OccupancyMeanTime.Figure.Shock.(Session_type{sess})([5 6]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock mean time (s)'); end
    title(Session_type{sess})
    ylim([0 20]); u=text(1,19,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(OccupancyMeanTime.Figure.Shock.(Session_type{sess})([16 13]),Cols2,X1,NoLegends,'showpoints',1,'paired',0); 
    title(Session_type{sess})
    ylim([0 20]); u=text(1,19,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(OccupancyMeanTime.Figure.Safe.(Session_type{sess})([5 6]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Safe mean time (s)'); end
    ylim([0 60]); u=text(1,55,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(OccupancyMeanTime.Figure.Safe.(Session_type{sess})([16 13]),Cols2,X1,Legends2,'showpoints',1,'paired',0); 
    ylim([0 60]); u=text(1,55,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    n=n+1;
end
a=suptitle('Occupancy mean time, UMaze drugs experiments'); a.FontSize=20;


figure; n=1;
for sess=[2 7]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(OccupancyMeanTime.Figure.Shock.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock mean time (s)'); end
    title(Session_type{sess})
    ylim([0 20]); u=text(1,19,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(OccupancyMeanTime.Figure.Shock.(Session_type{sess})([18 17]),Cols2,X1,NoLegends,'showpoints',1,'paired',0); 
    title(Session_type{sess})
    ylim([0 20]); u=text(1,19,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(OccupancyMeanTime.Figure.Safe.(Session_type{sess})([9 11]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Safe mean time (s)'); end
    ylim([0 60]); u=text(1,55,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(OccupancyMeanTime.Figure.Safe.(Session_type{sess})([18 17]),Cols2,X1,Legends2,'showpoints',1,'paired',0); 
    ylim([0 60]); u=text(1,55,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    n=n+1;
end
a=suptitle('Occupancy mean time, UMaze drugs experiments'); a.FontSize=20;



figure; n=1;
for sess=[2 7]
    subplot(2,4,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(OccupancyMeanTime.Figure.Shock.(Session_type{sess})([9 11]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock mean time (s)'); end
    title(Session_type{sess})
    ylim([0 20]); u=text(1,19,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(OccupancyMeanTime.Figure.Shock.(Session_type{sess})([20 19]),Cols2,X1,NoLegends,'showpoints',0,'paired',1); 
    title(Session_type{sess})
    ylim([0 20]); u=text(1,19,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+5)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(OccupancyMeanTime.Figure.Safe.(Session_type{sess})([9 11]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Safe mean time (s)'); end
    ylim([0 60]); u=text(1,55,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(2,4,(n-1)*2+6)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(OccupancyMeanTime.Figure.Safe.(Session_type{sess})([20 19]),Cols2,X1,Legends2,'showpoints',0,'paired',1); 
    ylim([0 60]); u=text(1,55,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    n=n+1;
end
a=suptitle('Occupancy mean time, UMaze drugs experiments'); a.FontSize=20;




%% Middle zone
figure; n=1;
for sess=[4 5 7]
    subplot(3,6,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Occupancy_MiddleZone.Figure.(Session_type{sess})([5 6]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Occupancy middle zone (proportion)'); end
    title(Session_type{sess})
    ylim([0 .7]); u=text(1,.65,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(3,6,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Occupancy_MiddleZone.Figure.(Session_type{sess})([16 13]),Cols2,X1,NoLegends,'showpoints',1,'paired',0); 
    title(Session_type{sess})
    ylim([0 .7]); u=text(1,.65,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(3,6,(n-1)*2+7)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProp_MiddleZone.Figure.(Session_type{sess})([5 6]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Middle zone freezing proportion'); end
    ylim([0 .7]); u=text(1,.65,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(3,6,(n-1)*2+8)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProp_MiddleZone.Figure.(Session_type{sess})([16 13]),Cols2,X1,Legends2,'showpoints',1,'paired',0); 
    ylim([0 .7]); u=text(1,.65,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
      
    subplot(3,6,(n-1)*2+13)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingTime_MiddleZone.Figure.(Session_type{sess})([5 6]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Middle freezing time (s)'); end
    ylim([0 205]); u=text(1,200,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(3,6,(n-1)*2+14)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingTime_MiddleZone.Figure.(Session_type{sess})([16 13]),Cols2,X1,Legends2,'showpoints',1,'paired',0); 
    ylim([0 205]); u=text(1,200,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    n=n+1;
end
a=suptitle('Middle zone analysis, UMaze drugs experiments'); a.FontSize=20;


figure; n=1;
for sess=[4 5 7]
    subplot(3,6,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Occupancy_MiddleZone.Figure.(Session_type{sess})([9 10]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Occupancy middle zone (proportion)'); end
    title(Session_type{sess})
    ylim([0 .7]); u=text(1,.65,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(3,6,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Occupancy_MiddleZone.Figure.(Session_type{sess})([18 17]),Cols2,X1,NoLegends,'showpoints',1,'paired',0); 
    title(Session_type{sess})
    ylim([0 .7]); u=text(1,.65,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(3,6,(n-1)*2+7)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProp_MiddleZone.Figure.(Session_type{sess})([9 10]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Middle zone freezing proportion'); end
    ylim([0 .7]); u=text(1,.65,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(3,6,(n-1)*2+8)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProp_MiddleZone.Figure.(Session_type{sess})([18 17]),Cols2,X1,Legends2,'showpoints',1,'paired',0); 
    ylim([0 .7]); u=text(1,.65,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
      
    subplot(3,6,(n-1)*2+13)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingTime_MiddleZone.Figure.(Session_type{sess})([9 10]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Middle freezing time (s)'); end
    ylim([0 205]); u=text(1,200,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(3,6,(n-1)*2+14)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingTime_MiddleZone.Figure.(Session_type{sess})([16 13]),Cols2,X1,Legends2,'showpoints',1,'paired',0); 
    ylim([0 205]); u=text(1,200,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    n=n+1;
end
a=suptitle('Middle zone analysis, UMaze drugs experiments'); a.FontSize=20;




figure; n=1;
for sess=[4 5 7]
    subplot(3,6,(n-1)*2+1)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Occupancy_MiddleZone.Figure.(Session_type{sess})([9 10]),Cols1,X1,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Occupancy middle zone (proportion)'); end
    title(Session_type{sess})
    ylim([0 .7]); u=text(1,.65,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(3,6,(n-1)*2+2)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(Occupancy_MiddleZone.Figure.(Session_type{sess})([20 19]),Cols2,X1,NoLegends,'showpoints',0,'paired',1); 
    title(Session_type{sess})
    ylim([0 .7]); u=text(1,.65,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(3,6,(n-1)*2+7)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProp_MiddleZone.Figure.(Session_type{sess})([9 10]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Middle zone freezing proportion'); end
    ylim([0 .7]); u=text(1,.65,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(3,6,(n-1)*2+8)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingProp_MiddleZone.Figure.(Session_type{sess})([20 19]),Cols2,X1,Legends2,'showpoints',0,'paired',1); 
    ylim([0 .7]); u=text(1,.65,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
      
    subplot(3,6,(n-1)*2+13)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingTime_MiddleZone.Figure.(Session_type{sess})([9 10]),Cols1,X1,Legends1,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Middle freezing time (s)'); end
    ylim([0 205]); u=text(1,200,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    subplot(3,6,(n-1)*2+14)
    [pval , ~] = MakeSpreadAndBoxPlot2_SB(FreezingTime_MiddleZone.Figure.(Session_type{sess})([20 19]),Cols2,X1,Legends2,'showpoints',0,'paired',1); 
    ylim([0 205]); u=text(1,200,['p = ' num2str(pval(1,2))]); set(u,'FontSize',15) 
    
    n=n+1;
end
a=suptitle('Middle zone analysis, UMaze drugs experiments'); a.FontSize=20;















