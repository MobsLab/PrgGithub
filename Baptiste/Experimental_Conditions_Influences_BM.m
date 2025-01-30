
%% Check experimental conditions varitions
%% Maze type

SessNames={'TestPost_PostDrug'};
Dir=PathForExperimentsEmbReact(SessNames{1});
for d=1:length(Dir.path)
    Mouse_names{d}= ['M' num2str(Dir.ExpeInfo{1, d}{1, 1}.nmouse)];
    Mouse(d)=Dir.ExpeInfo{1, d}{1, 1}.nmouse;
    DrugType{d} = Dir.ExpeInfo{1,d}{1,1}.DrugInjected;
    MazeType{d} = Dir.ExpeInfo{1,d}{1,1}.RecordingBox;
    Experimenter{d} = Dir.ExpeInfo{1,d}{1,1}.Experimenter;
    try
        MazeOrder{d} = Dir.ExpeInfo{1,d}{1,1}.MazeOrder;
    end
end

cd('/media/nas6/ProjetEmbReact/transfer'); load('Sess.mat');
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    UMazeSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
end

for mouse=1:length(Mouse)
    
    if convertCharsToStrings(DrugType{mouse}) == 'SALINE'
        Sum_Up_Array(1,mouse) = 1;
    elseif convertCharsToStrings(DrugType{mouse}) == 'FLXCHRONIC'
        Sum_Up_Array(1,mouse) = 2;
    elseif convertCharsToStrings(DrugType{mouse}) == 'ACUTE_FLX'
        Sum_Up_Array(1,mouse) = 3;
    elseif convertCharsToStrings(DrugType{mouse}) == 'MDZ'
        Sum_Up_Array(1,mouse) = 4;
    elseif convertCharsToStrings(DrugType{mouse}) == 'DIAZEPAM'
        Sum_Up_Array(1,mouse) = 5;
    elseif convertCharsToStrings(DrugType{mouse}) == 'CHRONIC_BUS'
        Sum_Up_Array(1,mouse) = 6;
    elseif convertCharsToStrings(DrugType{mouse}) == 'BUSPIRONE'
        Sum_Up_Array(1,mouse) = 7;
    elseif convertCharsToStrings(DrugType{mouse}) == 'RIP_INHIB'
        Sum_Up_Array(1,mouse) = 8;
    elseif convertCharsToStrings(DrugType{mouse}) == 'RIP_CTRL'
        Sum_Up_Array(1,mouse) = 9;
    end
    
    if convertCharsToStrings(MazeType{mouse}) == 'UMaze1'
        Sum_Up_Array(2,mouse) = 1;
    elseif convertCharsToStrings(MazeType{mouse}) == 'UMaze2'
        Sum_Up_Array(2,mouse) = 2;
    elseif convertCharsToStrings(MazeType{mouse}) == 'UMaze3'
        Sum_Up_Array(2,mouse) = 3;
    elseif convertCharsToStrings(MazeType{mouse}) == 'UMaze4'
        Sum_Up_Array(2,mouse) = 4;
    end
    
    if convertCharsToStrings(Experimenter{mouse}) == 'SB'
        Sum_Up_Array(3,mouse) = 1;
    elseif convertCharsToStrings(Experimenter{mouse}) == 'CS'
        Sum_Up_Array(3,mouse) = 2;
    elseif convertCharsToStrings(Experimenter{mouse}) == 'BM'
        Sum_Up_Array(3,mouse) = 3;
    end
    
    try
        Sum_Up_Array(4,mouse) = MazeOrder{mouse};
    catch
        Sum_Up_Array(4,mouse) = 1;
    end
    
    if length(UMazeSleepSess.(Mouse_names{mouse}))==3 % long protocol
        Sum_Up_Array(5,mouse) = 1;
    elseif length(UMazeSleepSess.(Mouse_names{mouse}))==2 % short protocol
        Sum_Up_Array(5,mouse) = 2;
    end
end

I=[1:length(Mouse)];
Saline_ind= I(Sum_Up_Array(1,:)==1);
ChronicFlx_ind= I(Sum_Up_Array(1,:)==2);
AcuteFlx_ind= I(Sum_Up_Array(1,:)==3);
Mdz_ind= I(Sum_Up_Array(1,:)==4);
Dzp_ind= I(Sum_Up_Array(1,:)==5);
ChronicBus_ind= I(Sum_Up_Array(1,:)==6);
AcuteBus_ind= I(Sum_Up_Array(1,:)==7);
RipInhib_ind= I(Sum_Up_Array(1,:)==8);
RipControl_ind= I(Sum_Up_Array(1,:)==9);


figure
plot(Saline_ind,1,'.b','MarkerSize',30); hold on
plot(ChronicFlx_ind,1,'.r','MarkerSize',30)
plot(AcuteFlx_ind,1,'.g','MarkerSize',30)
plot(Mdz_ind,1,'.m','MarkerSize',30)
plot(Dzp_ind,1,'.','MarkerSize',30,'Color',[0.8500, 0.3250, 0.0980])
plot(ChronicBus_ind,1,'.','MarkerSize',30,'Color',[0.4940, 0.1840, 0.5560])
plot(AcuteBus_ind,1,'.c','MarkerSize',30)
plot(RipInhib_ind,1,'.','MarkerSize',30,'Color',[0.75, 0.75, 0])
plot(RipControl_ind,1,'.','MarkerSize',30,'Color',[0.6350, 0.0780, 0.1840])
plot([2 11],1,'.k','MarkerSize',30)

plot(I(Sum_Up_Array(2,:)==1) , 2, '.b','MarkerSize',30)
plot(I(Sum_Up_Array(2,:)==2) , 2, '.g','MarkerSize',30)
plot(I(Sum_Up_Array(2,:)==3) , 2, '.m','MarkerSize',30)
plot(I(Sum_Up_Array(2,:)==4) , 2, '.r','MarkerSize',30)

plot(I(Sum_Up_Array(3,:)==1) , 3, '.b','MarkerSize',30)
plot(I(Sum_Up_Array(3,:)==2) , 3, '.r','MarkerSize',30)
plot(I(Sum_Up_Array(3,:)==3) , 3, '.g','MarkerSize',30)

plot(I(Sum_Up_Array(4,:)==1) , 4, '.b','MarkerSize',30)
plot(I(Sum_Up_Array(4,:)==2) , 4, '.r','MarkerSize',30)
plot(I(Sum_Up_Array(4,:)==3) , 4, '.g','MarkerSize',30)
plot(I(Sum_Up_Array(4,:)==4) , 4, '.m','MarkerSize',30)

plot(I(Sum_Up_Array(5,:)==1) , 5, '.b','MarkerSize',30)
plot(I(Sum_Up_Array(5,:)==2) , 5, '.r','MarkerSize',30)

xticks([1:97]); xticklabels(Mouse_names); xtickangle(45)
yticks([1:5]); yticklabels({'Drug type','Maze Type','Experimenter','Maze Order','Protocol Type'})
ylim([.5 5.5])
makepretty

cd('/media/nas6/ProjetEmbReact/DataEmbReact')
load('Create_Behav_Drugs_BM.mat', 'FreezingProportion')
load('Create_Behav_Drugs_BM.mat', 'Occupancy_MiddleZone')
load('Create_Behav_Drugs_BM.mat', 'ZoneEntries')
load('Create_Behav_Drugs_BM.mat', 'ZoneOccupancy')

for mouse=1:length(Mouse)
    FreezingProportion_All(mouse) = FreezingProportion.All.Cond.(Mouse_names{mouse});
    Occupancy_MiddleZone_All(mouse) = Occupancy_MiddleZone.Cond.(Mouse_names{mouse});
    ShockZoneEntries_All(mouse) = ZoneEntries.Shock.Cond.(Mouse_names{mouse});
    ShockZoneOccupancy_All(mouse) = ZoneOccupancy.Shock.Cond.(Mouse_names{mouse});
end

clear a b; [a,b]=sort(Sum_Up_Array(1,:));
figure
plot(I(a==1) , 0, '.b','MarkerSize',30); hold on
plot(I(a==2) , 0, '.r','MarkerSize',30)
plot(I(a==3) , 0, '.g','MarkerSize',30)
plot(I(a==4) , 0, '.m','MarkerSize',30)
plot(I(a==5) , 0, '.','MarkerSize',30,'Color',[0.8500, 0.3250, 0.0980])
plot(I(a==6) , 0, '.','MarkerSize',30,'Color',[0.4940, 0.1840, 0.5560])
plot(I(a==7) , 0, '.c','MarkerSize',30)
plot(I(a==8) , 0, '.','MarkerSize',30,'Color',[0.75, 0.75, 0])
plot(I(a==9) , 0, '.','MarkerSize',30,'Color',[0.6350, 0.0780, 0.1840])

plot(runmean(FreezingProportion_All(b),3))
plot(runmean(Occupancy_MiddleZone_All(b),3))
plot(runmean(ShockZoneEntries_All(b)/4,3))
plot(runmean(ShockZoneOccupancy_All(b),3))
makepretty

f=get(gca,'Children'); legend([f(68),f(62),f(57),f(49),f(31),f(25),f(23),f(12),f(5),f(4),f(3),f(2),f(1)],'Saline','Chronic Flx','Acute Flx','MDZ','DZP','Chronic BUS','Acute BUS','Rip Inhib','Rip Control','Freezing proportion','Middle zone occupancy','Shock zone entries','Shock zone occupancy')

[a,b]=sort(Sum_Up_Array(2,:));
figure
plot(I(a==1) , 0, '.b','MarkerSize',30); hold on
plot(I(a==2) , 0, '.g','MarkerSize',30)
plot(I(a==3) , 0, '.m','MarkerSize',30)
plot(I(a==4) , 0, '.r','MarkerSize',30)

plot(runmean(FreezingProportion_All(b),3))
plot(runmean(Occupancy_MiddleZone_All(b),3))
plot(runmean(ShockZoneEntries_All(b)/4,3))
plot(runmean(ShockZoneOccupancy_All(b),3))
makepretty

f=get(gca,'Children'); legend([f(50),f(37),f(32),f(10),f(4),f(3),f(2),f(1)],'Maze1','Maze2','Maze3','Maze4','Freezing proportion','Middle zone occupancy','Shock zone entries','Shock zone occupancy')


clear a b; [a,b]=sort(Sum_Up_Array(3,:));
figure
plot(I(a==1) , 0, '.b','MarkerSize',30); hold on
plot(I(a==2) , 0, '.g','MarkerSize',30)
plot(I(a==3) , 0, '.r','MarkerSize',30)

plot(runmean(FreezingProportion_All(b),3))
plot(runmean(Occupancy_MiddleZone_All(b),3))
plot(runmean(ShockZoneEntries_All(b)/4,3))
plot(runmean(ShockZoneOccupancy_All(b),3))
makepretty

f=get(gca,'Children'); legend([f(80),f(76),f(5),f(4),f(3),f(2),f(1)],'SB','CS','BM','Freezing proportion','Middle zone occupancy','Shock zone entries','Shock zone occupancy')


clear a b; [a,b]=sort(Sum_Up_Array(4,:));
figure
plot(I(a==1) , 0, '.b','MarkerSize',30); hold on
plot(I(a==2) , 0, '.r','MarkerSize',30)
plot(I(a==3) , 0, '.g','MarkerSize',30)
plot(I(a==4) , 0, '.m','MarkerSize',30)

plot(runmean(FreezingProportion_All(b),3))
plot(runmean(Occupancy_MiddleZone_All(b),3))
plot(runmean(ShockZoneEntries_All(b)/4,3))
plot(runmean(ShockZoneOccupancy_All(b),3))
makepretty

f=get(gca,'Children'); legend([f(80),f(17),f(8),f(5),f(4),f(3),f(2),f(1)],'1st Maze','2nd Maze','3rd Maze','4th Maze','Freezing proportion','Middle zone occupancy','Shock zone entries','Shock zone occupancy')


clear a b; [a,b]=sort(Sum_Up_Array(5,:));
figure
plot(I(a==1) , 0, '.b','MarkerSize',30); hold on
plot(I(a==2) , 0, '.r','MarkerSize',30)

plot(FreezingProportion_All(b))
plot(runmean(Occupancy_MiddleZone_All(b),3))
plot(runmean(ShockZoneEntries_All(b)/4,3))
plot(runmean(ShockZoneOccupancy_All(b),3))
makepretty

f=get(gca,'Children'); legend([f(80),f(20),f(4),f(3),f(2),f(1)],'Long protocol','Short protocol','Freezing proportion','Middle zone occupancy','Shock zone entries','Shock zone occupancy')



sum(Sum_Up_Array(2,ind_saline) == 1)
sum(Sum_Up_Array(2,ind_saline) == 4)

sum(Sum_Up_Array(2,ind_dzp) == 1)
sum(Sum_Up_Array(2,ind_dzp) == 4)

sum(Sum_Up_Array(2,ind_rip) == 1)
sum(Sum_Up_Array(2,ind_rip) == 4)

sum(Sum_Up_Array(2,ind_ctrl) == 1)
sum(Sum_Up_Array(2,ind_ctrl) == 4)
sum(Sum_Up_Array(2,ind_ctrl) == 3)

sum(Sum_Up_Array(2,ind_saline2) == 1)
sum(Sum_Up_Array(2,ind_saline2) == 4)
sum(Sum_Up_Array(2,ind_saline2) == 3)


cd('/media/nas6/ProjetEmbReact/DataEmbReact')
load('Create_Behav_Drugs_BM.mat')

for mouse=1:length(Mouse)
    
    Occupancy_MiddleZone_Cond_All(mouse) = Occupancy_MiddleZone.Cond.(Mouse_names{mouse});
    FreezingProp_MiddleZone_Cond_All(mouse) = FreezingProp_MiddleZone.Cond.(Mouse_names{mouse});
    FreezingProportion_Cond_All(mouse) = FreezingProportion.All.Cond.(Mouse_names{mouse});
    ZoneOccupancy_Shock_Cond_All(mouse) = ZoneOccupancy.Shock.Cond.(Mouse_names{mouse});
    ZoneOccupancy_Shock_TestPost_All(mouse) = ZoneOccupancy.Shock.TestPost.(Mouse_names{mouse});
    ZoneEntries_Shock_Cond_All(mouse) = ZoneEntries.Shock.Cond.(Mouse_names{mouse});
    ZoneEntries_Shock_TestPost_All(mouse) = ZoneEntries.Shock.TestPost.(Mouse_names{mouse});
    
end

P(:,1) = [Occupancy_MiddleZone_Cond_All(Sum_Up_Array(2,1:89) == 1)];
P(1:length(Occupancy_MiddleZone_Cond_All(Sum_Up_Array(2,1:89)==4)),2) = [Occupancy_MiddleZone_Cond_All(Sum_Up_Array(2,1:89) == 4)];
P(P==0)=NaN;

Cols = {[.8 .8 1],[1 .8 .8]};
X = [1:2];
Legends = {'Maze1','Maze4'};
NoLegends = {'',''};

MakeSpreadAndBoxPlot2_SB(P,Cols,X,Legends,'showpoints',1,'paired',0)

%%
clear Saline_Plot Diazepam_Plot
% Saline mice either in Maze1 or 4
Saline_Plot(:,1) = [Occupancy_MiddleZone_Cond_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 1))]; % Saline mice in Maze1
Saline_Plot(1:length(Occupancy_MiddleZone_Cond_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 4))),2) = [Occupancy_MiddleZone_Cond_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 4))]; % Saline mice in Maze4
Saline_Plot(Saline_Plot==0)=NaN;

figure
subplot(121)
MakeSpreadAndBoxPlot2_SB(Saline_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Saline')


% Diazepam mice either in Maze1 or 4
Diazepam_Plot(:,1) = [Occupancy_MiddleZone_Cond_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 1))]; % Diazepam mice in Maze1
Diazepam_Plot(1:length(Occupancy_MiddleZone_Cond_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 4))),2) = [Occupancy_MiddleZone_Cond_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 4))]; % Diazepam mice in Maze4
Diazepam_Plot(Diazepam_Plot==0)=NaN;

subplot(122)
MakeSpreadAndBoxPlot2_SB(Diazepam_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Diazepam')

a=suptitle('Proportional time spent in middle zone'); a.FontSize=20;

%%
clear Saline_Plot Diazepam_Plot
% Saline mice either in Maze1 or 4
Saline_Plot(:,1) = [FreezingProp_MiddleZone_Cond_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 1))]; % Saline mice in Maze1
Saline_Plot(1:length(FreezingProp_MiddleZone_Cond_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 4))),2) = [FreezingProp_MiddleZone_Cond_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 4))]; % Saline mice in Maze4
Saline_Plot(Saline_Plot==0)=NaN;

figure
subplot(121)
MakeSpreadAndBoxPlot2_SB(Saline_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Saline')


% Diazepam mice either in Maze1 or 4
Diazepam_Plot(:,1) = [FreezingProp_MiddleZone_Cond_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 1))]; % Diazepam mice in Maze1
Diazepam_Plot(1:length(FreezingProp_MiddleZone_Cond_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 4))),2) = [FreezingProp_MiddleZone_Cond_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 4))]; % Diazepam mice in Maze4
Diazepam_Plot(Diazepam_Plot==0)=NaN;

subplot(122)
MakeSpreadAndBoxPlot2_SB(Diazepam_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Diazepam')

a=suptitle('Proportional time spent freezing in middle zone'); a.FontSize=20;


%%
clear Saline_Plot Diazepam_Plot
% Saline mice either in Maze1 or 4
Saline_Plot(:,1) = [FreezingProportion_Cond_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 1))]; % Saline mice in Maze1
Saline_Plot(1:length(FreezingProportion_Cond_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 4))),2) = [FreezingProportion_Cond_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 4))]; % Saline mice in Maze4
Saline_Plot(Saline_Plot==0)=NaN;

figure
subplot(121)
MakeSpreadAndBoxPlot2_SB(Saline_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Saline')
ylim([0 .6])

% Diazepam mice either in Maze1 or 4
Diazepam_Plot(:,1) = [FreezingProportion_Cond_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 1))]; % Diazepam mice in Maze1
Diazepam_Plot(1:length(FreezingProportion_Cond_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 4))),2) = [FreezingProportion_Cond_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 4))]; % Diazepam mice in Maze4
Diazepam_Plot(Diazepam_Plot==0)=NaN;

subplot(122)
MakeSpreadAndBoxPlot2_SB(Diazepam_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Diazepam')

a=suptitle('Proportional time spent freezing'); a.FontSize=20;


%%
clear Saline_Plot Diazepam_Plot
% Saline mice either in Maze1 or 4
Saline_Plot(:,1) = [ZoneOccupancy_Shock_Cond_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 1))]; % Saline mice in Maze1
Saline_Plot(1:length(ZoneOccupancy_Shock_Cond_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 4))),2) = [ZoneOccupancy_Shock_Cond_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 4))]; % Saline mice in Maze4
Saline_Plot(Saline_Plot==0)=NaN;

figure
subplot(121)
MakeSpreadAndBoxPlot2_SB(Saline_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Saline')
ylim([0 .35])


% Diazepam mice either in Maze1 or 4
Diazepam_Plot(:,1) = [ZoneOccupancy_Shock_Cond_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 1))]; % Diazepam mice in Maze1
Diazepam_Plot(1:length(ZoneOccupancy_Shock_Cond_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 4))),2) = [ZoneOccupancy_Shock_Cond_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 4))]; % Diazepam mice in Maze4
Diazepam_Plot(Diazepam_Plot==0)=NaN;

subplot(122)
MakeSpreadAndBoxPlot2_SB(Diazepam_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Diazepam')

a=suptitle('Shock zone occupancy, Cond sessions'); a.FontSize=20;



%%
clear Saline_Plot Diazepam_Plot
% Saline mice either in Maze1 or 4
Saline_Plot(:,1) = [ZoneOccupancy_Shock_TestPost_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 1))]; % Saline mice in Maze1
Saline_Plot(1:length(ZoneOccupancy_Shock_TestPost_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 4))),2) = [ZoneOccupancy_Shock_TestPost_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 4))]; % Saline mice in Maze4
Saline_Plot(Saline_Plot==0)=NaN;

figure
subplot(121)
MakeSpreadAndBoxPlot2_SB(Saline_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Saline')
ylim([0 .6])

% Diazepam mice either in Maze1 or 4
Diazepam_Plot(:,1) = [ZoneOccupancy_Shock_TestPost_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 1))]; % Diazepam mice in Maze1
Diazepam_Plot(1:length(ZoneOccupancy_Shock_TestPost_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 4))),2) = [ZoneOccupancy_Shock_TestPost_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 4))]; % Diazepam mice in Maze4
Diazepam_Plot(Diazepam_Plot==0)=NaN;

subplot(122)
MakeSpreadAndBoxPlot2_SB(Diazepam_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Diazepam')

a=suptitle('Shock zone occupancy, Test Post sessions'); a.FontSize=20;



%%
clear Saline_Plot Diazepam_Plot
% Saline mice either in Maze1 or 4
Saline_Plot(:,1) = [ZoneEntries_Shock_Cond_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 1))]; % Saline mice in Maze1
Saline_Plot(1:length(ZoneEntries_Shock_Cond_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 4))),2) = [ZoneEntries_Shock_Cond_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 4))]; % Saline mice in Maze4
Saline_Plot(Saline_Plot==0)=NaN;

figure
subplot(121)
MakeSpreadAndBoxPlot2_SB(Saline_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Saline')
ylim([0 3])


% Diazepam mice either in Maze1 or 4
Diazepam_Plot(:,1) = [ZoneEntries_Shock_Cond_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 1))]; % Diazepam mice in Maze1
Diazepam_Plot(1:length(ZoneEntries_Shock_Cond_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 4))),2) = [ZoneEntries_Shock_Cond_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 4))]; % Diazepam mice in Maze4
Diazepam_Plot(Diazepam_Plot==0)=NaN;

subplot(122)
MakeSpreadAndBoxPlot2_SB(Diazepam_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Diazepam')

a=suptitle('Shock zone entries, Cond sessions'); a.FontSize=20;




%%
clear Saline_Plot Diazepam_Plot
% Saline mice either in Maze1 or 4
Saline_Plot(:,1) = [ZoneEntries_Shock_TestPost_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 1))]; % Saline mice in Maze1
Saline_Plot(1:length(ZoneEntries_Shock_TestPost_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 4))),2) = [ZoneEntries_Shock_TestPost_All(and(Sum_Up_Array(1,1:89)==1 , Sum_Up_Array(2,1:89) == 4))]; % Saline mice in Maze4
Saline_Plot(Saline_Plot==0)=NaN;

figure
subplot(121)
MakeSpreadAndBoxPlot2_SB(Saline_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Saline')


% Diazepam mice either in Maze1 or 4
Diazepam_Plot(:,1) = [ZoneEntries_Shock_TestPost_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 1))]; % Diazepam mice in Maze1
Diazepam_Plot(1:length(ZoneEntries_Shock_TestPost_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 4))),2) = [ZoneEntries_Shock_TestPost_All(and(Sum_Up_Array(1,1:89)==2 , Sum_Up_Array(2,1:89) == 4))]; % Diazepam mice in Maze4
Diazepam_Plot(Diazepam_Plot==0)=NaN;

subplot(122)
MakeSpreadAndBoxPlot2_SB(Diazepam_Plot,Cols,X,Legends,'showpoints',1,'paired',0)
title('Diazepam')

a=suptitle('Shock zone entries, TestPost sessions'); a.FontSize=20;










%%

for mouse=1:36
    for sess=1:length(Sess.(Mouse_names{mouse}))
        cd(Sess.(Mouse_names{mouse}){sess})
        load('ExpeInfo.mat')
        ExpeInfo.RecordingBox = 'UMaze1';
        %     ExpeInfo.DrugInjected = 'RIP_INHIB';
        %     ExpeInfo.DrugInjected = 'RIP_CTRL';
        save('ExpeInfo.mat','ExpeInfo')
    end
end




