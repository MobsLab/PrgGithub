% After Trajectories_Function_Maze_BM
% or
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Trajectories2.mat')

load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Trajectories2.mat')


figure
GetEmbReactMiceFolderList_BM
clear D
for i=1:4
    Pos{i} = ConcatenateDataFromFolders_SB(HabSess.M688(i),'AlignedPosition');
    D{i}=Data(Pos{i});
end

subplot(181)
clear D; D = Data(Restrict(Pos{1} , intervalSet(0e4,300e4)));
plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
xlim([0 1]); ylim([0 1])
axis off, axis square
Maze_Frame_BM2

subplot(182)
clear D; D = Data(Restrict(Position_tsd.M688.TestPre , intervalSet(0e4,360e4)));
plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
xlim([0 1]); ylim([0 1])
axis off, axis square
Maze_Frame_BM2

subplot(183)
clear D; D = Data(Restrict(Position_tsd.M688.Cond , intervalSet(0,480e4))); D(or(D<0,D>1))=NaN;
plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
xlim([0 1]); ylim([0 1])
axis off, axis square
Maze_Frame_BM2
hold on, plot(PositionStimExplo.M688.Cond(1,1) , PositionStimExplo.M688.Cond(1,2),'.r','MarkerSize',40);

subplot(284)
clear D; D = Data(Restrict(Position_tsd.M688.Cond , intervalSet((970)*1e4,(1260)*1e4))); D(or(D<0,D>1))=NaN;
plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]); 
xlim([0 1]); ylim([0 1])
axis off, axis square
Maze_Frame_BM2
hold on, plot(PositionStimExplo.M688.Cond(2:5,1) , PositionStimExplo.M688.Cond(2:5,2),'.r','MarkerSize',40);
line([0 .35],[.55 .55], 'Color' , 'k' , 'LineWidth' ,2)

subplot(2,8,12)
clear D; D = Data(Restrict(Position_tsd.M688.Cond , intervalSet((1260)*1e4,(1440)*1e4))); D(or(D<0,D>1))=NaN;
plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
xlim([0 1]); ylim([0 1])
axis off, axis square
Maze_Frame_BM2

subplot(285)
clear D; D = Data(Restrict(Position_tsd.M688.Cond , intervalSet((1921)*1e4,(2220)*1e4))); D(or(D<0,D>1))=NaN;
plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
xlim([0 1]); ylim([0 1])
axis off, axis square
Maze_Frame_BM2
hold on, line([.65 1],[.55 .55], 'Color' , 'k' , 'LineWidth' ,2)

subplot(2,8,13)
clear D; D = Data(Restrict(Position_tsd.M688.Cond , intervalSet((2221)*1e4,(2400)*1e4))); D(or(D<0,D>1))=NaN;
plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
xlim([0 1]); ylim([0 1])
axis off, axis square
Maze_Frame_BM2

subplot(186)
clear D; D = Data(Restrict(Position_tsd.M688.TestPost , intervalSet(0e4,360e4)));
plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
xlim([0 1]); ylim([0 1])
axis off, axis square
Maze_Frame_BM2


clear D
for i=1:4
    Pos{i} = ConcatenateDataFromFolders_SB(ExtSess.M688(i),'AlignedPosition');
    D{i}=Data(Pos{i});
end

subplot(287)
clear D; D = Data(Restrict(Pos{1} , intervalSet(0e4,300e4)));
plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
xlim([0 1]); ylim([0 1])
axis off, axis square
Maze_Frame_BM2
hold on, line([0 .35],[.55 .55], 'Color' , 'k' , 'LineWidth' ,2)

subplot(2,8,15)
clear D; D = Data(Restrict(Pos{1} , intervalSet(301e4,480e4)));
plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
xlim([0 1]); ylim([0 1])
axis off, axis square
Maze_Frame_BM2


subplot(288)
clear D; D = Data(Restrict(Pos{2} , intervalSet(0e4,300e4)));
plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
xlim([0 1]); ylim([0 1])
axis off, axis square
Maze_Frame_BM2
hold on, line([.65 1],[.55 .55], 'Color' , 'k' , 'LineWidth' ,2)

subplot(2,8,16)
clear D; D = Data(Restrict(Pos{2} , intervalSet(301e4,480e4)));
plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
xlim([0 1]); ylim([0 1])
axis off, axis square
Maze_Frame_BM2



%%
figure
subplot(141)
% fill([0 0 .35 .35],[0 .75 .75 0],[1 .5 .5],'FaceAlpha',0.3)
% hold on
clear D; D = Data(Restrict(Position_tsd.M688.TestPre , intervalSet(0e4,720e4)));
plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
xlim([0 1]); ylim([0 1])
axis off, axis square
Maze_Frame_BM2

subplot(142)
fill([0 0 .35 .35],[0 .75 .75 0],[1 .5 .5],'FaceAlpha',0.3)
hold on
for i=1:4
    clear D; D = Data(Restrict(Position_tsd.M688.Cond   , intervalSet(0e4+(i-1)*1440e4,480e4+(i-1)*1440e4)));
    D(or(D<0,D>1))=NaN;
    if i==2
        plot(D(1:126,1) , D(1:126,2),'Color',[.3 .3 .3]); hold on, plot(D(129:end,1) , D(129:end,2),'Color',[.3 .3 .3]);
    elseif i==4
        plot(D(1:415,1) , D(1:415,2),'Color',[.3 .3 .3]); hold on, plot(D(417:end,1) , D(417:end,2),'Color',[.3 .3 .3]);
    else
        plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
    end
    hold on
    clear D; D = Data(Restrict(Position_tsd.M688.Cond   , intervalSet(800e4+(i-1)*1440e4,960e4+(i-1)*1440e4)));
    D(or(D<0,D>1))=NaN;
    plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
    clear D; D = Data(Restrict(Position_tsd.M688.Cond   , intervalSet(1270e4+(i-1)*1440e4,1440e4+(i-1)*1440e4)));
    D(or(D<0,D>1))=NaN;
    plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
end
n=1; clear a
for i=1:length(PositionStimExplo.M688.Cond)
    if isempty(find(PositionStimBlocked.M688.Cond==PositionStimExplo.M688.Cond(i,:)))
        a(n)=i;
        n=n+1;
    end
end
plot(PositionStimExplo.M688.Cond(a,1) , PositionStimExplo.M688.Cond(a,2),'.r','MarkerSize',40);
xlim([0 1]); ylim([0 1])
axis off
Maze_Frame_BM2

subplot(143)
fill([0 0 .35 .35],[0 .75 .75 0],[1 .5 .5],'FaceAlpha',0.3)
hold on
clear D; D = Data(Restrict(Position_tsd.M688.TestPost , intervalSet(0e4,720e4)));
plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
xlim([0 1]); ylim([0 1])
axis off
Maze_Frame_BM2


clear D
for i=1:4
    Pos{i} = ConcatenateDataFromFolders_SB(ExtSess.M688(i),'AlignedPosition');
    D{i}=Data(Pos{i});
end


subplot(144)
fill([0 0 .35 .35],[0 .75 .75 0],[1 .5 .5],'FaceAlpha',0.3), hold on
for i=1:4
    if or(i==1,i==2)
        plot(D{i}(1:5e3,1) , D{i}(1:5e3,2),'Color',[.3 .3 .3]);
    else
        plot(D{i}(:,1) , D{i}(:,2),'Color',[.3 .3 .3]);
    end
    hold on
end
xlim([0 1]); ylim([0 1])
axis off
Maze_Frame_BM2



%%
figure
subplot(131)
fill([0 0 .35 .35],[0 .75 .75 0],[1 .5 .5],'FaceAlpha',0.3)
hold on
clear D; D = Data(Restrict(Position_tsd.M688.TestPre , intervalSet(0e4,720e4)));
plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
xlim([0 1]); ylim([0 1])
axis off
Maze_Frame_BM2

subplot(132)
fill([0 0 .35 .35],[0 .75 .75 0],[1 .5 .5],'FaceAlpha',0.3)
hold on
for i=1:4
    clear D; D = Data(Restrict(Position_tsd_Unblocked.M688.Cond   , intervalSet(0e4+(i-1)*1440e4,480e4+(i-1)*1440e4)));
    D(or(D<0,D>1))=NaN;
    plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
    hold on
    clear D; D = Data(Restrict(Position_tsd_Unblocked.M688.Cond   , intervalSet(800e4+(i-1)*1440e4,960e4+(i-1)*1440e4)));
    D(or(D<0,D>1))=NaN;
    plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
    clear D; D = Data(Restrict(Position_tsd_Unblocked.M688.Cond   , intervalSet(1270e4+(i-1)*1440e4,1440e4+(i-1)*1440e4)));
    D(or(D<0,D>1))=NaN;
    plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
end
n=1; clear a
for i=1:length(PositionStimExplo.M688.Cond)
    if isempty(find(PositionStimBlocked.M688.Cond==PositionStimExplo.M688.Cond(i,:)))
        a(n)=i;
        n=n+1;
    end
end
plot(PositionStimExplo.M688.Cond(a,1) , PositionStimExplo.M688.Cond(a,2),'.r','MarkerSize',40);
xlim([0 1]); ylim([0 1])
axis off
Maze_Frame_BM2

subplot(133)
fill([0 0 .35 .35],[0 .75 .75 0],[1 .5 .5],'FaceAlpha',0.3)
hold on
clear D; D = Data(Restrict(Position_tsd.M688.TestPost , intervalSet(0e4,720e4)));
plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
xlim([0 1]); ylim([0 1])
axis off
Maze_Frame_BM2





%% Freezing occup maps
% load('/media/nas7/ProjetEmbReact/DataEmbReact/Trajectories_AllSaline_Fear.mat','OccupMap_squeeze')
load('/media/nas7/ProjetEmbReact/DataEmbReact/Trajectories_Eyelid_Cond.mat','OccupMap_squeeze')
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/FreezingDuration.mat','FreezingShock_prop','FreezingSafe_prop','FzShockDur','FzSafeDur')

clear D
A = OccupMap_squeeze.Freeze.Cond{1}./OccupMap_squeeze.All.Cond{1};
for i=1:10
    for ii=1:10
        
        D(i,ii) = nanmean(nanmean(A((i-1)*10+1:i*10,(ii-1)*10+1:ii*10)));
        
    end
end
D(1:8,5:6)=NaN;

Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};


figure
subplot(121)
imagesc(D)
axis xy, axis off, hold on, axis square, caxis([0 2]), c=caxis; 
sizeMap=10; Maze_Frame_BM
u=colorbar; u.Ticks=[c(1) c(2)]; u.TickLabels={'0','1'}; u.FontSize=15; u.Label.String = 'occupancy (a.u.)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)
colormap magma

a=area([4.6 6.4],[8.4 8.4]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;


A(isnan(A))=0;
subplot(122)
imagesc(SmoothDec(A,2))
axis xy, axis off, hold on, axis square, caxis([0 2]), c=caxis; 
sizeMap=100; Maze_Frame_BM
u=colorbar; u.Ticks=[c(1) c(2)]; u.TickLabels={'0','1'}; u.FontSize=15; u.Label.String = 'occupancy (a.u.)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)

a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;


figure
subplot(121)
imagesc(SmoothDec(OccupMap_squeeze.Freeze_Blocked.Cond{1},2))
axis xy, axis off, hold on, axis square, c=caxis; %caxis([0 1e-3])
sizeMap=100; Maze_Frame_BM
u=colorbar; u.Ticks=[c(1) c(2)]; u.TickLabels={'0','1'}; u.FontSize=15; u.Label.String = 'occupancy (a.u.)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)
title('Blocked')

a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;

subplot(122)
imagesc(SmoothDec(OccupMap_squeeze.Freeze_Unblocked.Cond{1},2))
axis xy, axis off, hold on, axis square, c=caxis; %caxis([0 1e-3])
sizeMap=100; Maze_Frame_BM
u=colorbar; u.Ticks=[c(1) c(2)]; u.TickLabels={'0','1'}; u.FontSize=15; u.Label.String = 'occupancy (a.u.)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)
title('Unblocked')

a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;

colormap magma




%%
load('/media/nas7/ProjetEmbReact/DataEmbReact/Trajectories_Eyelid_Cond.mat', 'Position_tsd_Active_Unblocked')
GetAllSalineSessions_BM

n=1;
for group=22
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse = 1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        Speed = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'speed');
        NewSpeed=tsd(Range(Speed),runmean(Data(Speed),10));
        Moving=thresholdIntervals(NewSpeed,3,'Direction','Above');
        Moving=mergeCloseIntervals(Moving,0.3*1e4);
        Moving=dropShortIntervals(Moving,0.3*1e4);
        Pos_Moving = Restrict(Position_tsd_Active_Unblocked.(Mouse_names{mouse}).Cond , Moving);
        D = Data(Pos_Moving);
        OccupMap(mouse,:,:) = hist2d([D(:,1) ;0; 0; 1; 1] , [D(:,2);0;1;0;1] , 100 , 100);
        OccupMap2(mouse,:,:) = OccupMap(mouse,:,:)/sum(sum(squeeze(OccupMap(mouse,:,:))));
        OccupMap3(mouse,:,:) = squeeze(OccupMap2(mouse,:,:))';
        
        disp(Mouse(mouse))
    end
end


figure
A = squeeze(nanmean(OccupMap3));
A(isnan(A))=0;
imagesc(SmoothDec(A,2))
axis xy, axis off, hold on, axis square, caxis([0 2e-4]), c=caxis;
sizeMap=100; Maze_Frame_BM
u=colorbar; u.Ticks=[c(1) c(2)]; u.TickLabels={'0','1'}; u.FontSize=15; u.Label.String = 'occupancy (a.u.)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)

a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;


