
function fig=Experimental_Conditions_Influences_ByGroup_BM(ind)


% Proportional time in middle
clear Saline_Plot 
Saline_Plot(:,1) = [Occupancy_MiddleZone_Cond_All(ind(Sum_Up_Array(2,ind) == 1))]; % Saline mice in Maze1
Saline_Plot(ind(Sum_Up_Array(2,ind) == 4),2) = Occupancy_MiddleZone_Cond_All(ind(Sum_Up_Array(2,ind) == 4)); % Saline mice in Maze4
Saline_Plot(Saline_Plot==0)=NaN;

figure
subplot(141)
MakeSpreadAndBoxPlot2_SB(Saline_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Proportional time spent in middle zone'); a.FontSize=20;


% Proportional time freezing in middle
clear Saline_Plot 
Saline_Plot(:,1) = FreezingProp_MiddleZone_Cond_All(ind(Sum_Up_Array(2,ind) == 1)); % Saline mice in Maze1
Saline_Plot(1:length(FreezingProp_MiddleZone_Cond_All(ind(Sum_Up_Array(2,ind) == 4))),2) = FreezingProp_MiddleZone_Cond_All(ind(Sum_Up_Array(2,ind) == 4)); % Saline mice in Maze4
Saline_Plot(Saline_Plot==0)=NaN;
Saline_Plot(1:3,1)=0;

subplot(142)
MakeSpreadAndBoxPlot2_SB(Saline_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Proportional time spent freezing in middle zone');


% Freezing proportion
clear Saline_Plot 
Saline_Plot(:,1) = FreezingProportion_Cond_All(ind(Sum_Up_Array(2,ind) == 1)); % Saline mice in Maze1
Saline_Plot(1:length(FreezingProportion_Cond_All(ind(Sum_Up_Array(2,ind) == 4))),2) = FreezingProportion_Cond_All(ind(Sum_Up_Array(2,ind) == 4)); % Saline mice in Maze4
Saline_Plot(Saline_Plot==0)=NaN;

subplot(143)
MakeSpreadAndBoxPlot2_SB(Saline_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Proportional time spent freezing');


% Shock zone occupancy cond sess
clear Saline_Plot 
Saline_Plot(:,1) = ZoneOccupancy_Shock_Cond_All(ind(Sum_Up_Array(2,ind) == 1)); % Saline mice in Maze1
Saline_Plot(1:length(ZoneOccupancy_Shock_Cond_All(ind(Sum_Up_Array(2,ind) == 4))),2) = ZoneOccupancy_Shock_Cond_All(ind(Sum_Up_Array(2,ind) == 4)); % Saline mice in Maze4
Saline_Plot(Saline_Plot==0)=NaN;

subplot(144)
MakeSpreadAndBoxPlot2_SB(Saline_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Shock zone occupancy, Cond sessions');
clear Saline_Plot 


% Shock zone occupancy test post sess
clear Saline_Plot 
Saline_Plot(:,1) = ZoneOccupancy_Shock_TestPost_All(ind(Sum_Up_Array(2,ind) == 1)); % Saline mice in Maze1
Saline_Plot(1:length(ZoneOccupancy_Shock_TestPost_All(ind(Sum_Up_Array(2,ind) == 4))),2) = ZoneOccupancy_Shock_TestPost_All(ind(Sum_Up_Array(2,ind) == 4)); % Saline mice in Maze4
Saline_Plot(Saline_Plot==0)=NaN;

subplot(145)
MakeSpreadAndBoxPlot2_SB(Saline_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Shock zone occupancy, Test Post sessions');


% Shock zone entries cond sess
clear Saline_Plot 
Saline_Plot(:,1) = ZoneEntries_Shock_Cond_All(ind(Sum_Up_Array(2,ind) == 1)); % Saline mice in Maze1
Saline_Plot(1:length(ZoneEntries_Shock_Cond_All(ind(Sum_Up_Array(2,ind) == 4))),2) = ZoneEntries_Shock_Cond_All(ind(Sum_Up_Array(2,ind) == 4)); % Saline mice in Maze4
Saline_Plot(Saline_Plot==0)=NaN;

subplot(146)
MakeSpreadAndBoxPlot2_SB(Saline_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Shock zone entries, Cond sessions');


% Shock zone entries test post sess
clear Saline_Plot 
Saline_Plot(:,1) = ZoneEntries_Shock_TestPost_All(ind(Sum_Up_Array(2,ind) == 1)); % Saline mice in Maze1
Saline_Plot(1:length(ZoneEntries_Shock_TestPost_All(ind(Sum_Up_Array(2,ind) == 4))),2) = ZoneEntries_Shock_TestPost_All(ind(Sum_Up_Array(2,ind) == 4)); % Saline mice in Maze4
Saline_Plot(Saline_Plot==0)=NaN;

subplot(147)
MakeSpreadAndBoxPlot2_SB(Saline_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Shock zone entries, TestPost sessions');








