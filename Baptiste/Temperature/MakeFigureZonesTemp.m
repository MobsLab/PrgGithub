%% Tail

Mouse_names={'M666','M667','M668','M669','M688','M739','M777','M779','M849','M893'};
Mouse=[666 667 668 669 688 739 777 779 849 893];
for mouse=1:length(Mouse)
    ZonesTemp = ZonesTemperature(Mouse(mouse),FolderList,'Tail');
    ZonesTemperatu.Tail.(Mouse_names{mouse})=ZonesTemp;
    clear ZonesTemp;
end

% put all the data in an array for the figure
Mouse_names={'M666','M667','M668','M669','M688','M739','M777','M779','M849','M893'};
for i=1:length(Mouse_names)
    ZonesTemperatu.Tail.Figure(i,1)=nanmean([Data(ZonesTemperatu.Tail.(Mouse_names{i}).FearExplo1) ; Data(ZonesTemperatu.Tail.(Mouse_names{i}).FearExplo4)]);
    ZonesTemperatu.Tail.Figure(i,2)=nanmean([Data(ZonesTemperatu.Tail.(Mouse_names{i}).FearFz1) ; Data(ZonesTemperatu.Tail.(Mouse_names{i}).FearFz4)]);
    ZonesTemperatu.Tail.Figure(i,3)=nanmean([Data(ZonesTemperatu.Tail.(Mouse_names{i}).FearExplo2) ; Data(ZonesTemperatu.Tail.(Mouse_names{i}).FearExplo5)]);
    ZonesTemperatu.Tail.Figure(i,4)=nanmean([Data(ZonesTemperatu.Tail.(Mouse_names{i}).FearFz2) ; Data(ZonesTemperatu.Tail.(Mouse_names{i}).FearFz5)]);
end

figure
[pval,hb,eb]=PlotErrorBoxPlotN_BM(ZonesTemperatu.Tail.Figure(:,[1 2 4 3]),'newfig',0,'colorpoints',1);
set(hb, 'linewidth' ,2)
set(gca,'XTickLabel', {'Active Shock'; 'Freezing Shock'; 'Freezing Safe'; 'Active Safe'})
set(gca,'linewidth', 2)
title('Tail Temperature (n=10) ')
ylabel('Temperature (°C)')

%% Body

Mouse_names={'M666','M667','M668','M669','M688','M739','M777','M779','M849','M893'};
Mouse=[666 667 668 669 688 739 777 779 849 893];
for mouse=1:length(Mouse)
    ZonesTemp = ZonesTemperature(Mouse(mouse),FolderList,'Body');
    ZonesTemperatu.Body.(Mouse_names{mouse})=ZonesTemp;
    clear ZonesTemp;
end

% put all the data in an array for the figure
Mouse_names={'M666','M667','M668','M669','M688','M739','M777','M779','M849','M893'};
for i=1:length(Mouse_names)
    ZonesTemperatu.Body.Figure(i,1)=nanmean([Data(ZonesTemperatu.Body.(Mouse_names{i}).FearExplo1) ; Data(ZonesTemperatu.Body.(Mouse_names{i}).FearExplo4)]);
    ZonesTemperatu.Body.Figure(i,2)=nanmean([Data(ZonesTemperatu.Body.(Mouse_names{i}).FearFz1) ; Data(ZonesTemperatu.Body.(Mouse_names{i}).FearFz4)]);
    ZonesTemperatu.Body.Figure(i,3)=nanmean([Data(ZonesTemperatu.Body.(Mouse_names{i}).FearExplo2) ; Data(ZonesTemperatu.Body.(Mouse_names{i}).FearExplo5)]);
    ZonesTemperatu.Body.Figure(i,4)=nanmean([Data(ZonesTemperatu.Body.(Mouse_names{i}).FearFz2) ; Data(ZonesTemperatu.Body.(Mouse_names{i}).FearFz5)]);
end

figure
[pval,hb,eb]=PlotErrorBoxPlotN_BM(ZonesTemperatu.Body.Figure(:,[1 2 4 3]),'newfig',0,'colorpoints',1);
set(hb, 'linewidth' ,2)
set(gca,'XTickLabel', {'Active Shock'; 'Freezing Shock'; 'Freezing Safe'; 'Active Safe'})
set(gca,'linewidth', 2)
title('Body Temperature (n=10) ')
ylabel('Temperature (°C)')

%% Mouse
Mouse_names={'M666','M667','M668','M669','M688','M739','M777','M779','M849','M893'};
Mouse=[666 667 668 669 688 739 777 779 849 893];
for mouse=1:length(Mouse)
    ZonesTemp = ZonesTemperature(Mouse(mouse),FolderList,'Mouse');
    ZonesTemperatu.Mouse.(Mouse_names{mouse})=ZonesTemp;
    clear ZonesTemp;
end

% put all the data in an array for the figure
Mouse_names={'M666','M667','M668','M669','M688','M739','M777','M779','M849','M893'};
for i=1:length(Mouse_names)
    ZonesTemperatu.Mouse.Figure(i,1)=nanmean([Data(ZonesTemperatu.Mouse.(Mouse_names{i}).FearExplo1) ; Data(ZonesTemperatu.Mouse.(Mouse_names{i}).FearExplo4)]);
    ZonesTemperatu.Mouse.Figure(i,2)=nanmean([Data(ZonesTemperatu.Mouse.(Mouse_names{i}).FearFz1) ; Data(ZonesTemperatu.Mouse.(Mouse_names{i}).FearFz4)]);
    ZonesTemperatu.Mouse.Figure(i,3)=nanmean([Data(ZonesTemperatu.Mouse.(Mouse_names{i}).FearExplo2) ; Data(ZonesTemperatu.Mouse.(Mouse_names{i}).FearExplo5)]);
    ZonesTemperatu.Mouse.Figure(i,4)=nanmean([Data(ZonesTemperatu.Mouse.(Mouse_names{i}).FearFz2) ; Data(ZonesTemperatu.Mouse.(Mouse_names{i}).FearFz5)]);
end

figure
[pval,hb,eb]=PlotErrorBoxPlotN_BM(ZonesTemperatu.Mouse.Figure(:,[1 2 4 3]),'newfig',0,'colorpoints',1);
set(hb, 'linewidth' ,2)
set(gca,'XTickLabel', {'Active Shock'; 'Freezing Shock'; 'Freezing Safe'; 'Active Safe'})
set(gca,'linewidth', 2)
title('Mouse Temperature (n=10) ')
ylabel('Temperature (°C)')

%% Tail - Room cor
Mouse_names={'M666','M667','M668','M669','M688','M739','M777','M779','M849','M893'};
Mouse=[666 667 668 669 688 739 777 779 849 893];
for mouse=1:length(Mouse)
    ZonesTemp = ZonesTemperature(Mouse(mouse),FolderList,'Tail-Room');
    ZonesTemperatu.Tail_Room.(Mouse_names{mouse})=ZonesTemp;
    clear ZonesTemp;
end

% put all the data in an array for the figure
for i=1:length(Mouse_names)
    ZonesTemperatu.Tail_Room.Figure(i,1)=nanmean([Data(ZonesTemperatu.Tail_Room.(Mouse_names{i}).FearExplo1) ; Data(ZonesTemperatu.Tail_Room.(Mouse_names{i}).FearExplo4)]);
    ZonesTemperatu.Tail_Room.Figure(i,2)=nanmean([Data(ZonesTemperatu.Tail_Room.(Mouse_names{i}).FearFz1) ; Data(ZonesTemperatu.Tail_Room.(Mouse_names{i}).FearFz4)]);
    ZonesTemperatu.Tail_Room.Figure(i,3)=nanmean([Data(ZonesTemperatu.Tail_Room.(Mouse_names{i}).FearExplo2) ; Data(ZonesTemperatu.Tail_Room.(Mouse_names{i}).FearExplo5)]);
    ZonesTemperatu.Tail_Room.Figure(i,4)=nanmean([Data(ZonesTemperatu.Tail_Room.(Mouse_names{i}).FearFz2) ; Data(ZonesTemperatu.Tail_Room.(Mouse_names{i}).FearFz5)]);
end

figure
[pval,hb,eb]=PlotErrorBoxPlotN_BM(ZonesTemperatu.Tail_Room.Figure(:,[1 2 4 3]),'newfig',0,'colorpoints',1);
set(hb, 'linewidth' ,2)
set(gca,'XTickLabel', {'Active Shock'; 'Freezing Shock'; 'Freezing Safe'; 'Active Safe'})
set(gca,'linewidth', 2)
title('Tail Temperature corrected (n=10) ')
ylabel('Temperature (°C)')

%% Body - Room cor
Mouse_names={'M666','M667','M668','M669','M688','M739','M777','M779','M849','M893'};
Mouse=[666 667 668 669 688 739 777 779 849 893];
for mouse=1:length(Mouse)
    ZonesTemp = ZonesTemperature(Mouse(mouse),FolderList,'Body-Room');
    ZonesTemperatu.Body_Room.(Mouse_names{mouse})=ZonesTemp;
    clear ZonesTemp;
end

% put all the data in an array for the figure
for i=1:length(Mouse_names)
    ZonesTemperatu.Body_Room.Figure(i,1)=nanmean([Data(ZonesTemperatu.Body_Room.(Mouse_names{i}).FearExplo1) ; Data(ZonesTemperatu.Body_Room.(Mouse_names{i}).FearExplo4)]);
    ZonesTemperatu.Body_Room.Figure(i,2)=nanmean([Data(ZonesTemperatu.Body_Room.(Mouse_names{i}).FearFz1) ; Data(ZonesTemperatu.Tail_Room.(Mouse_names{i}).FearFz4)]);
    ZonesTemperatu.Body_Room.Figure(i,3)=nanmean([Data(ZonesTemperatu.Body_Room.(Mouse_names{i}).FearExplo2) ; Data(ZonesTemperatu.Body_Room.(Mouse_names{i}).FearExplo5)]);
    ZonesTemperatu.Body_Room.Figure(i,4)=nanmean([Data(ZonesTemperatu.Body_Room.(Mouse_names{i}).FearFz2) ; Data(ZonesTemperatu.Body_Room.(Mouse_names{i}).FearFz5)]);
end

figure
[pval,hb,eb]=PlotErrorBoxPlotN_BM(ZonesTemperatu.Body_Room.Figure(:,[1 2 4 3]),'newfig',0,'colorpoints',1);
set(hb, 'linewidth' ,2)
set(gca,'XTickLabel', {'Active Shock'; 'Freezing Shock'; 'Freezing Safe'; 'Active Safe'})
set(gca,'linewidth', 2)
title('Body Temperature corrected (n=10) ')
ylabel('Temperature Difference (°C)')

%% Mouse - Room cor
Mouse_names={'M666','M667','M668','M669','M688','M739','M777','M779','M849','M893'};
Mouse=[666 667 668 669 688 739 777 779 849 893];
for mouse=1:length(Mouse)
    ZonesTemp = ZonesTemperature(Mouse(mouse),FolderList,'Mouse-Room');
    ZonesTemperatu.Mouse_Room.(Mouse_names{mouse})=ZonesTemp;
    clear ZonesTemp;
end

% put all the data in an array for the figure
for i=1:length(Mouse_names)
    ZonesTemperatu.Mouse_Room.Figure(i,1)=nanmean([Data(ZonesTemperatu.Mouse_Room.(Mouse_names{i}).FearExplo1) ; Data(ZonesTemperatu.Mouse_Room.(Mouse_names{i}).FearExplo4)]);
    ZonesTemperatu.Mouse_Room.Figure(i,2)=nanmean([Data(ZonesTemperatu.Mouse_Room.(Mouse_names{i}).FearFz1) ; Data(ZonesTemperatu.Mouse_Room.(Mouse_names{i}).FearFz4)]);
    ZonesTemperatu.Mouse_Room.Figure(i,3)=nanmean([Data(ZonesTemperatu.Mouse_Room.(Mouse_names{i}).FearExplo2) ; Data(ZonesTemperatu.Mouse_Room.(Mouse_names{i}).FearExplo5)]);
    ZonesTemperatu.Mouse_Room.Figure(i,4)=nanmean([Data(ZonesTemperatu.Mouse_Room.(Mouse_names{i}).FearFz2) ; Data(ZonesTemperatu.Mouse_Room.(Mouse_names{i}).FearFz5)]);
end

figure
[pval,hb,eb]=PlotErrorBoxPlotN_BM(ZonesTemperatu.Mouse_Room.Figure(:,[1 2 4 3]),'newfig',0,'colorpoints',1);
set(hb, 'linewidth' ,2)
set(gca,'XTickLabel', {'Active Shock'; 'Freezing Shock'; 'Freezing Safe'; 'Active Safe'})
set(gca,'linewidth', 2)
title('Mouse Temperature corrected (n=10) ')
ylabel('Temperature (°C)')
