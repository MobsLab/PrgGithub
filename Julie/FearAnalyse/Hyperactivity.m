function Hyperactivity(datalocation,manipname,CorrWidth,varargin)
% 08.01.2015
% datalocation can be 'manip' or 'server'
% manipname can be 'ManipFeb15Bulbectomie' or 'ManipDec14Bulbectomie' or 'ManipNov15Bulbectomie' 
% CorrWidth is the width of the peripheral zone for anxiety
% save data as Hyperactivity_5.mat (5 being the width of the peripheral
% zone)
info=[]; %for BarPlotBulbSham
indifg=1;
gpfg=1;
addpath /home/mobs/Dropbox/Kteam/PgrMatlabJulie/PlaceCell7
addpath /home/mobs/Dropbox/Kteam/PgrMatlabJulie/nat
addpath /home/mobs/Dropbox/Kteam/PgrMatlabJulie/NAT/GoTracking
addpath('/home/mobs/Dropbox/Kteam/PgrMatlabJulie/6 - Place_cell_10_20160905')
savglobal=0;
sav=0;

 for i = 1:2:length(varargin),

      switch(lower(varargin{i})),

        case 'indivfig',
          indifg= varargin{i+1};
          
          if ~isa(indifg,'numeric'),
            error('Incorrect value for property ''figure'' ');
          end   

        case 'groupfig',
        gpfg= varargin{i+1};
        if ~isa(gpfg,'numeric'),
        error('Incorrect value for property ''figure'' ');
        end

        case 'save global',
          savglobal = varargin{i+1};            
        case 'save',
                  sav = varargin{i+1}; 
      end
 end
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define the filenames for each step and each mouse
[FileInfo,FolderPath]=DefinePath(manipname, datalocation, 'explo');

StepName{1}='pre';StepName{2}='post';StepName{3}='+6j';StepName{4}='+2wk';StepName{5}='+3wk';

if strcmp(manipname,'ManipDec14Bulbectomie')
    sham=[211;212;213;217;218;219;220];
    bulb=[207;208;209;210;214;215;216];
elseif strcmp(manipname,'ManipFeb15Bulbectomie')
    sham=[223;224;225;227;229;233;235;237;239];
    bulb=[222;226;228;232;234;236;238;240];
   
elseif strcmp(manipname,'ManipNov15Bulbectomie')
    sham=[280:290];
    bulb=[269:279];

end

%NbOfMicePerGp=[size(sham,1) size(bulb,1)];

time_window=600;
TimeBetween2Measure=0.1270;
time_wind=[1 time_window/TimeBetween2Measure+1];

% colours for plotting 
StimCols(1,:)=[0 1 0]; % CS- in green
StimCols(2,:)=[1 0.5 0]; % CS+ in orange
StimCols(3,:)=[1 0 0]; % shock in red

expgroup={sham, bulb};
groupname={'sham','bulb'};
Gpcolor={[0.7 0.7 0.7], 'k'};
if gpfg
    bilanFig=figure;
    bilanFig2=figure;
    groupFig=figure;
    groupFig2=figure;
    set(bilanFig,'color',[1 1 1],'Position',[1 1 600 800])
    set(bilanFig2,'color',[1 1 1],'Position',[1 1 600 800])
    set(groupFig,'color',[1 1 1],'Position',[1 20 500 1000])
    set(groupFig2,'color',[1 1 1],'Position',[1 20 500 1000])
end

cd(['/media/DataMOBsRAID/ProjetAversion/' manipname '/Hyperactivity'])
try
    load([ 'Hyperactivity_' num2str(CorrWidth) '.mat'])
catch
    for  g=1:2
        group=expgroup{g};
        %clear TotalDistanceTable TotalTimeTable StopNbTable
        for mousenb=1:length(group)
            m=group(mousenb);
            if indifg
                mouseindifg=figure;
                set(mouseindifg,'color',[1 1 1],'Position',[500 1 600 1000])
            end
            for step=1:length(StepName)
                %try
                    cd(FileInfo{step,m})
                    if strcmp(manipname,'ManipNov15Bulbectomie')
                        load('PosMat.mat')
                        load('DoubleTrack.mat')
                        PosMat(:,2:3)=PosMat(:,2:3)/Ratio_IMAonREAL;
                    else
                        load('Behavior.mat')
                    end

                    rawTime=PosMat(:,1);
                    rawPosX=PosMat(:,2);
                    rawPosY=PosMat(:,3);
                    if size(rawPosX,1)>=time_wind(2)
                       rawTime=rawTime(time_wind(1):time_wind(2));
                       rawPosX=rawPosX(time_wind(1):time_wind(2));
                       rawPosY=rawPosY(time_wind(1):time_wind(2));
                    end
                    Zone=ones(length(rawTime),1);

                    % Speed filter
                    lowSpeedThreshold=2.5;
                    highSpeedThreshold=100;
                    [PosX,PosY,Time]=SpeedThreshold(rawPosX, rawPosY, rawTime, lowSpeedThreshold, highSpeedThreshold); % fct in F:\disque C\6 - Place_cell_7_20140905

                    % Compute the NUMBER OF STOPS 
                    StopThreshold=1; % below 1sec the NaN segment is not considered as a stop event 
                    %TimeBetween2Measure=median(diff(PosMat(:,1))); % 0.1270 sur un exemple
                    DayPath=FileInfo{step,m}; 
                    FileName=[]; % nonused variable
                    Nb_of_Stops=ComputeNbofStops(Time, PosX, PosY, DayPath, FileName, TimeBetween2Measure,StopThreshold);


                    PosY(isnan(PosX))=[]; % required because NAT deals with segments and not with NAN
                    Time(isnan(PosX))=[];
                    Zone(isnan(PosX))=[];
                    PosX(isnan(PosX))=[];
                    data=[Time PosX PosY Zone];


                    FileName=[ 'm' num2str(m) '_' StepName{step}];
                    TotalDistance =ComputeTotalDist(Time, PosX, PosY, DayPath, FileName, TimeBetween2Measure,'bulb'); 


                    TotalTime=ComputeTotalTime (Time, PosX, PosY, DayPath, FileName, 0, TimeBetween2Measure,'bulb');

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Percent of time in peripheral zone & distance from the center
                    %DayPath=[];
                    ExperimentName=[];
                    % may be required to define them early in the code (in case of restricted temporal window)
                    ArenaCenterCoord=[min(PosX)+(max(PosX)-min(PosX))/2  min(PosY)+(max(PosY)-min(PosY))/2];
                    ArenaXwidth=(max(PosX)-min(PosX));
                    ArenaYwidth=(max(PosY)-min(PosY));

                    % coordinates defined from upleft corner, turning right 
                    % External square
                    ExtSquare=[ArenaCenterCoord(1)-ArenaXwidth/2  ArenaCenterCoord(2)+ArenaYwidth/2; 
                        ArenaCenterCoord(1)+ArenaXwidth/2 ArenaCenterCoord(2)+ArenaYwidth/2;
                        ArenaCenterCoord(1)+ArenaXwidth/2 ArenaCenterCoord(2)-ArenaYwidth/2; 
                        ArenaCenterCoord(1)-ArenaXwidth/2 ArenaCenterCoord(2)-ArenaYwidth/2;
                        ArenaCenterCoord(1)-ArenaXwidth/2  ArenaCenterCoord(2)+ArenaYwidth/2];
                    marg=1; % with a margin
                    ExtSquareMarg=[ArenaCenterCoord(1)-ArenaXwidth/2-marg  ArenaCenterCoord(2)+ArenaYwidth/2+marg; 
                        ArenaCenterCoord(1)+ArenaXwidth/2+marg ArenaCenterCoord(2)+ArenaYwidth/2+marg; 
                        ArenaCenterCoord(1)+ArenaXwidth/2+marg ArenaCenterCoord(2)-ArenaYwidth/2-marg; 
                        ArenaCenterCoord(1)-ArenaXwidth/2-marg ArenaCenterCoord(2)-ArenaYwidth/2-marg; 
                        ArenaCenterCoord(1)-ArenaXwidth/2-marg  ArenaCenterCoord(2)+ArenaYwidth/2+marg];
                    % Internal square
                    IntSquare=[ArenaCenterCoord(1)-ArenaXwidth/2+CorrWidth  ArenaCenterCoord(2)+ArenaYwidth/2-CorrWidth; 
                        ArenaCenterCoord(1)+ArenaXwidth/2-CorrWidth ArenaCenterCoord(2)+ArenaYwidth/2-CorrWidth; 
                        ArenaCenterCoord(1)+ArenaXwidth/2-CorrWidth ArenaCenterCoord(2)-ArenaYwidth/2+CorrWidth; 
                        ArenaCenterCoord(1)-ArenaXwidth/2+CorrWidth ArenaCenterCoord(2)-ArenaYwidth/2+CorrWidth; 
                        ArenaCenterCoord(1)-ArenaXwidth/2+CorrWidth  ArenaCenterCoord(2)+ArenaYwidth/2-CorrWidth];

                    % Distance from the center
                    ArenaDiameter=0; % with 0, the fct gives the opposite if the distance from the center (with a minus)
                    MeanDistFromTheCenter=-ComputeDistFromWall_Ju (ArenaCenterCoord,ArenaDiameter,...
                                             Time, PosX, PosY, DayPath,...
                                             FileName, ExperimentName, 0, TimeBetween2Measure); % 0 is for showflag
                    % Percent of time
                    user='bulb';
                    if CorrWidth==8
                        ZOI=2;
                    elseif CorrWidth==5
                        ZOI=3;
                    end

                    [EntryZoneCol, time_of_1st_entryCol]=ComputeEntryZone ( Time, PosX, PosY, DayPath, FileName, TimeBetween2Measure, user, 0,manipname,ExtSquareMarg,IntSquare); % sav=0
                    NbEntriesCenter=EntryZoneCol(ZOI);

                    [PercentOfTimeCol, duration_of_1st_entryCol]=ComputePercentOfTimeInZOI ( Time, PosX, PosY, DayPath, FileName,TimeBetween2Measure,user,0,manipname,ExtSquareMarg,IntSquare);% sav=0
                    % for Manip Dec 14 and Feb15
                    % zone1=ExtSquareMarg  zone2= IntSquare (CorrWidth=5) zone3= IntSquare (CorrWidth=8) 
                    % for Manip Nov 15
                    % zone1=ExtSquareMarg  zone2= IntSquare (CorrWidth) zone3= IntSquare (CorrWidth) (zone2 et zone3 identiques)   
                    PercentTimePeriph=PercentOfTimeCol(1)-PercentOfTimeCol(ZOI);
                    PercentTimeCenter=PercentOfTimeCol(ZOI);

                   if indifg % plot individual figure
                        subplot(length(StepName),2,1+(step-1)*2)
%                         plot(rawPosX,rawPosY,'r'), hold on
%                         plot(PosX,PosY,'k'), 
                        plot(rawPosX,rawPosY,'k'), hold on
                        
                        title(StepName{step});
                        %xlim([5 65])
                        %ylim([0 45])
                        
%                         plot(ArenaCenterCoord(1), ArenaCenterCoord(2),'.g', 'LineWidth', 10)
                        plot(ExtSquareMarg(:,1),ExtSquareMarg(:,2),'-b', 'LineWidth', 1)
%                         plot(IntSquare(:,1),IntSquare(:,2),'-r', 'LineWidth', 2)

%                         subplot(length(StepName),2,2+(step-1)*2)
%                         scatter(PosX,PosY,'b'), hold on
%                         plot(rawPosX,rawPosY,'r'), hold on
%                         plot(PosX,PosY,'k'), 
% 
%                         title(StepName{step});
                        
                        %xlim([5 65])
                        %ylim([0 45])
                        %set(gca, 'XTickLabel', [], 'YTickLabel', [])
                        Y1=ylim;
                        if step==1
                            text(-10,1.3*Y1(2),[ 'M' num2str(m) ' ' groupname{g}], 'FontSize', 15)
                        end
                   end


                    StopNbTable{g}(mousenb,step)=Nb_of_Stops;
                    TotalTimeTable{g}(mousenb,step)=TotalTime;
                    TotalDistanceTable{g}(mousenb,step)=TotalDistance;
                    MeanDistFromTheCenterTable{g}(mousenb,step)=MeanDistFromTheCenter;
                    PercentTimePeriphTable{g}(mousenb,step)=PercentTimePeriph;
                    PercentTimeCenterTable{g}(mousenb,step)=PercentTimeCenter;
                    NbEntriesCenterTable{g}(mousenb,step)=NbEntriesCenter;

                %catch 
    %                 disp(FileInfo{step,m})
    %                 StopNbTable{g}(mousenb,step)=NaN;
    %                 TotalTimeTable{g}(mousenb,step)=NaN;
    %                 TotalDistanceTable{g}(mousenb,step)=NaN;
    %                 MeanDistFromTheCenterTable{g}(mousenb,step)=NaN;
    %                 PercentTimePeriphTable{g}(mousenb,step)=NaN;
    %                 PercentTimeCenterTable{g}(mousenb,step)=NaN;
    %                 NbEntriesCenterTable{g}(mousenb,step)=NaN;
                %end % end try
            end % end loop step

    %         if indifg % plot individual figure
    %             subplot(4,2,2+(step-1)*2)
    %             ploter l'activit� pour les differents step
    %         end


            cd ..
            cd ..
            cd([FolderPath manipname])
            if indifg && sav
                set(gcf, 'PaperPosition', [1 1 14 21])
                saveas(mouseindifg,['M',num2str(m),'Explo.fig'])
                saveas(mouseindifg,['M',num2str(m),'Explo.png'])
                currFold=pwd;
                saveFigure(mouseindifg, ['M',num2str(m),'Explo'], currFold)
            end
        end

        % Normalize the nb of entries
        NbEntriesCenterNormTable{g}=NbEntriesCenterTable{g}./TotalDistanceTable{g};
        

        if savglobal
            file2save=([ 'Hyperactivity_' num2str(CorrWidth) '.mat']);
            %save Hyperactivity.mat StopNbTable TotalTimeTable TotalDistanceTable MeanDistFromTheCenterTable PercentTimePeriphTable PercentTimeCenterTable NbEntriesCenterTable NbEntriesCenterNormTable
            save(file2save, 'expgroup', 'groupname','StepName','StopNbTable', 'TotalTimeTable', 'TotalDistanceTable','MeanDistFromTheCenterTable','PercentTimePeriphTable','PercentTimeCenterTable','NbEntriesCenterTable','NbEntriesCenterNormTable')
        end
    end
end
    
%% BAR PLOT %%%%%%%%%%%%%%
for g=1:2
    
    %%%%%% hyperactivity
    figure(bilanFig) 
    subplot(3,2,g)
    PlotErrorBarN(TotalDistanceTable{1,g},0,1,'ranksum');
    ylabel('Traveled distance')
    title(groupname{g})
    ylim([0 5000])
    subplot(3,2,2+g)
    PlotErrorBarN(TotalTimeTable{1,g},0,1,'ranksum');
    ylabel('Running Time')
    ylim([0 400])
    subplot(3,2,4+g)
    PlotErrorBarN(StopNbTable{1,g},0,1,'ranksum');
    ylabel('Nb of stops')
    ylim([0 120])
    if savglobal
        set(gcf, 'PaperPosition', [1 1 13 21])
        saveas(bilanFig,['HyperactivityBar.fig'])
        saveas(bilanFig,['HyperactivityBar.png'])
        currFold=pwd;
        saveFigure(bilanFig, 'HyperactivityBar', currFold)
    end
    
    %%%%%% Anxiety : Percent of time in cental zone, nb entries in central zone, distance from the center
    figure(bilanFig2) 
    subplot(3,2,g)
    PlotErrorBarN(PercentTimeCenterTable{1,g},0,1,'ranksum')
    ylabel('Percent of Time in the Center')
    title(groupname{g})
    ylim([0 60])
    subplot(3,2,2+g)
    % PlotErrorBarN(NbEntriesCenterTable{1,g},0,1,'ranksum')
    % ylabel('Nb of Entries in the Center')
    PlotErrorBarN(NbEntriesCenterNormTable{1,g},0,1,'ranksum')
    ylabel('Nb Entries in Center (norm by dist)')
    ylim([0 0.03])
    subplot(3,2,4+g)
    PlotErrorBarN(MeanDistFromTheCenterTable{1,g},0,1,'ranksum')
    ylabel('Distance From the Center')
    ylim([0 25])
    if savglobal
        set(gcf, 'PaperPosition', [1 1 13 21])
        saveas(bilanFig2,['Hyperact_centerBar.fig'])
        saveas(bilanFig2,['Hyperact_centerBar.png'])
        currFold=pwd;
        saveFigure(bilanFig2, 'Hyperact_centerBar', currFold)
    end
    %%   Line Plot for both groups  %%%%%%%%%%
    
    %%%%%% hyperactivity
    figure(groupFig)
    StdPlotBulbSham(TotalDistanceTable,'Traveled distance',[0 7000], 7, Gpcolor,1,g)
    StdPlotBulbSham(TotalTimeTable,'Running Time',[0 400], 7, Gpcolor,2,g)
    StdPlotBulbSham(StopNbTable,'Running Time',[0 120], 7, Gpcolor,3,g)

    hleg=legend (groupname);
    set(hleg, 'Location', 'SouthEast')
    if savglobal
        set(gcf, 'PaperPosition', [1 1 11 21])
        saveas(groupFig,['HyperactivityErrorBar.fig'])
        saveas(groupFig,['HyperactivityErrorBar.png'])
        currFold=pwd;
        saveFigure(groupFig, 'HyperactivityErrorBar', currFold)
    end

    %%%%%% Anxiety
    figure(groupFig2)
    StdPlotBulbSham(PercentTimeCenterTable,'Percent of Time in the Center',[0 60], 7, Gpcolor,1,g)
    title (['periph wd' num2str(CorrWidth) ' cm'])
    StdPlotBulbSham(NbEntriesCenterNormTable,'NbEntries in the Center (norm by dist)',[0 0.03], 7, Gpcolor,2,g)
    StdPlotBulbSham(MeanDistFromTheCenterTable,'Dist from the Center',[0 25], 7, Gpcolor,3,g)

    hleg=legend (groupname);
    set(hleg, 'Location', 'SouthEast')

end % en of group loop

if savglobal
    set(gcf, 'PaperPosition', [1 1 11 21])
    saveas(groupFig2,['Hyperact_periphErrorBar_' num2str(CorrWidth) '.fig'])
    saveas(groupFig2,['Hyperact_periphErrorBar_' num2str(CorrWidth) '.png'])
    currFold=pwd;
    saveFigure(groupFig2, ['Hyperact_periphErrorBar_' num2str(CorrWidth) ], currFold)
end

%% BARPLOT COMPARATIVE BETWEEN GROUPS
barcompfig=figure('Color',[1 1 1]); 
set(gcf,'color',[1 1 1],'Position',[1200 20 500 1000])
test='ranksum';
%test='kruskal';
BarPlotBulbSham(TotalDistanceTable,'TotalDistance',Gpcolor,test,3,1,1,info) % first 1 is for savestats
BarPlotBulbSham(TotalTimeTable,'TotalTime',Gpcolor,test,3,1,2,info)
BarPlotBulbSham(StopNbTable,'StopNb',Gpcolor,test,3,1,3,info)

if savglobal
    set(gcf, 'PaperPosition', [1 1 13 21])
    saveas(barcompfig,['HyperactivityBarComp_' test '.fig'])
    saveas(barcompfig,['HyperactivityBarComp_' test '.png'])
    currFold=pwd;
    saveFigure(barcompfig, ['HyperactivityBarComp_' test ], currFold)
end

barcompfig2=figure('Color',[1 1 1]); 
set(gcf,'color',[1 1 1],'Position',[1200 20 500 1000])
test='ranksum';
%test='kruskal';
BarPlotBulbSham(PercentTimeCenterTable,'Percent Time in Center',Gpcolor,test,3,1,1,info), text (-0.1, 80, ['periph wd' num2str(CorrWidth) ' cm'])
%BarPlotBulbSham(NbEntriesCenterTable,'Nb Entries in Center',test,3,1,2)
BarPlotBulbSham(NbEntriesCenterNormTable,'Nb Entries in Center (norm by dist)',Gpcolor,test,3,1,2,info)
BarPlotBulbSham(MeanDistFromTheCenterTable,'Dist From The Center',Gpcolor,test,3,1,3,info)

if savglobal
    set(gcf, 'PaperPosition', [1 1 13 21])
    saveas(barcompfig2,['Hyperact_periphBarComp_' test '_' num2str(CorrWidth) '.fig'])
    saveas(barcompfig2,['Hyperact_periphBarComp_' test '_' num2str(CorrWidth) '.png'])
    currFold=pwd;
    saveFigure(barcompfig2, ['Hyperact_periphBarComp_' test '_' num2str(CorrWidth)  ], currFold)
end

end

function StdPlotBulbSham(Table,TableName,ylimit, NbOfMice,Gpcolor, j,g)
    subplot(3,1,j)
    errorbar(nanmean(Table{1,g}), nanstd(Table{1,g})./sqrt(NbOfMice), 'Color',Gpcolor{g}, 'LineWidth', 2), hold on
    ylabel(TableName)
    ylim(ylimit)
    set(gca, 'XTick', [1 2 3 4 5], 'XTickLabel', {'Pre', 'Post', '+6j','+2wk','+3wk'}) % , '+3wk'}
    
    
    % stars
    for i=1:size(Table{1,1},2)
        x=Table{1,1}(:,i);
        y=Table{1,2}(:,i);
        if sum(~isnan(x))==0 ||sum(~isnan(y))==0
            Pmw=NaN; 
        else
            [Pmw,h_mw,table_mw] = ranksum(x(~isnan(x)), y(~isnan(y)));
        end
        p_mw(i)=Pmw;
        stats_mw(i)=table_mw;
        max=ylim;
        if Pmw<0.01
            text(i,0.9*max(2),'**','Color','r', 'FontSize', 20)
        elseif Pmw<0.05
            text(i,0.9*max(2),'*','Color','r', 'FontSize', 20)

        end  
    end
    
    
end

%         % % global figure all mice
%         % suplot the results for one individual mouse
%         if gpfg % make a group figure
%             figure(bilanFig) 
%             % Plethysmo 
%             subplot(NbOfMice+1,2,(mousenb-1)*2+1)
% 
%             try
%             bar(bilan{3}(mousenb,:))
%             end
%             xlim([0 6])
%             ylim([0 1])
%             yLabel(['M',num2str(m)])
%             if mousenb==1
%                 text(-0.5,1.5, groupname{g}, 'FontSize', 20);
%                 title('Plethysmo')
%             end
%             % EnvB
%             subplot(NbOfMice+1,2,(mousenb)*2)
%             try
%             bar(bilan{4}(mousenb,:))
%             end
%             xlim([0 6])
%             ylim([0 1])
%             if mousenb==1
%                 text(4.5,1.5, ['th ' num2str(freezeTh)], 'FontSize', 15);
%                 title('Env B')
%             end
%         end
%     end
%     
%     % plot the average bars    
%     cd .. % back to 'ManipBulbectomie folder
%     if gpfg
%         subplot(NbOfMice+1,2,(NbOfMice+1)*2-1)
%         PlotErrorBarN((bilan{3}),0,1)
%         title('Plethysmo')
%         ylim([0 1])
%         set(gca,'XTick',[1 2 3 4],'XTickLabel',{'noS','CS-','CS+1','CS+2','CS+3'})
%         subplot(NbOfMice+1,2,(NbOfMice+1)*2)
%         PlotErrorBarN((bilan{4}),0,1)
%         title('Env B')
%         ylim([0 1])
%         set(gca,'XTick',[1 2 3 4],'XTickLabel',{'noS','CS-','CS+1','CS+2','CS+3'})
%         set(gcf, 'PaperPosition', [1 1 13 22])
%         saveas(bilanFig,[groupname{g} 'AllMiceAverage_' num2str(freezeTh) '.fig'])
%         saveas(bilanFig,[groupname{g} 'AllMiceAverage_' num2str(freezeTh) '.png'])
%         set(gcf, 'PaperPosition', [1 1 13 42])
%         if sav
%             saveas(bilanFig,[groupname{g} 'AllMiceAverageL_' num2str(freezeTh) '.fig'])
%             saveas(bilanFig,[groupname{g} 'AllMiceAverageL_' num2str(freezeTh) '.png'])
%         end
%     end
% 
%     % same but only average
%     if gpfg
%         figure(groupFig)
%         set(groupFig,'color',[1 1 1],'Position',[81 324 560 420])
% 
%         % EXT pleth
%         subplot(1,2,1)
%         PlotErrorBarN((bilan{3}),0,1) % test : paired ranksum relative to column 1
%         title('Plethysmo')
%         ylim([0 1])
%         set(gca,'XTick',[1 2 3 4],'XTickLabel',{'noS','CS-','CS+1','CS+2','CS+3'})
%         text(-1.5,1.05, groupname{g}, 'FontSize', 15);
%         % EXT envB
%         subplot(1,2,2)
%         PlotErrorBarN((bilan{4}),0,1)
%         title('Env B')
%         ylim([0 1])
%         set(gca,'XTick',[1 2 3 4],'XTickLabel',{'noS','CS-','CS+1','CS+2','CS+3'})
%         text(4.5,1.05, ['th ' num2str(freezeTh)], 'FontSize', 15);
%         set(groupFig, 'PaperPosition', [1 1 13 9])
%         if sav
%             saveas(groupFig,[groupname{g} 'Average_' num2str(freezeTh) '.fig'])
%             saveas(groupFig,[groupname{g} 'Average_' num2str(freezeTh) '.png'])
% 
%             % save the data
%             save([groupname{g} 'AllMiceBilan_' num2str(freezeTh) '.mat'],  'bilan', 'freezeTh')
%         end
%     end
% end
% 
% end