clear all
% experiment 2 - give right names
Dir_All.All{2} = PathForExperimentFEAR('ManipFeb15Bulbectomie','explo');
Dir_All.PostFear{2}.path = [Dir_All.All{2}.path(2:4:end)];
Dir_All.PostFear{2}.name = [Dir_All.All{2}.name(2:4:end)];
Dir_All.PostFear{2}.group = [Dir_All.All{2}.group(2:4:end)];

Dir_All.Week3{2}.path = [Dir_All.All{2}.path(4:4:end)];
Dir_All.Week3{2}.name = [Dir_All.All{2}.name(4:4:end)];
Dir_All.Week3{2}.group = [Dir_All.All{2}.group(4:4:end)];

Dir_All.All{3} = PathForExperimentFEAR('ManipDec14Bulbectomie','explo');
Dir_All.PostFear{3}.path = [Dir_All.All{3}.path(2:4:end)];
Dir_All.PostFear{3}.name = [Dir_All.All{3}.name(2:4:end)];
Dir_All.PostFear{3}.group = [Dir_All.All{3}.group(2:4:end)];

Dir_All.Week3{3}.path = [Dir_All.All{3}.path(4:4:end)];
Dir_All.Week3{3}.name = [Dir_All.All{3}.name(4:4:end)];
Dir_All.Week3{3}.group = [Dir_All.All{3}.group(4:4:end)];


SessionTypes = {'PostFear','Week3'};

clear TotalDist
for ss = 1:length(SessionTypes)
    
    Dir = MergePathForExperiment(Dir_All.(SessionTypes{ss}){3},Dir_All.(SessionTypes{ss}){2});
                Dir.path(find(strcmp(Dir.name,'Mouse214'))) = [];
            Dir.group(find(strcmp(Dir.name,'Mouse214'))) = [];
            Dir.manipe(find(strcmp(Dir.name,'Mouse214'))) = [];
            Dir.name(find(strcmp(Dir.name,'Mouse214'))) = [];

    for mm=1:length(Dir.path)
        try
            cd(Dir.path{mm})
            
            clear PosMat Ratio_IMAonREAL
            if exist('PosMat.mat')>0
                load('PosMat.mat')
                load('DoubleTrack.mat')
                PosMat(:,2:3)=PosMat(:,2:3)/Ratio_IMAonREAL;
            else
                load('Behavior.mat')
            end
            PosMat(PosMat(:,1)>600,:) = [];
            
            % interpolate PosMat
            %% X
            PosMatInt=PosMat;
            x=PosMatInt(:,2);
            nanx = isnan(x);
            t    = 1:numel(x);
            x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));
            
            % Check if there are still NaNs on the edges taken from Sophie's check all behavior 02.04.2018 Dima
            if isnan(x(1))
                x(1:find(not(isnan(x)),1,'first'))=x(find(not(isnan(x)),1,'first'));
            end
            if isnan(x(end))
                x(find(not(isnan(x)),1,'last'):end)=x(find(not(isnan(x)),1,'last'));
            end
            
            PosMatInt(:,2)=x;
            
            %% Y
            x=PosMatInt(:,3);
            nanx = isnan(x);
            t    = 1:numel(x);
            x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));
            
            % Check if there are still NaNs on the edges taken from Sophie's check all behavior 02.04.2018 Dima
            if isnan(x(1))
                x(1:find(not(isnan(x)),1,'first'))=x(find(not(isnan(x)),1,'first'));
            end
            if isnan(x(end))
                x(find(not(isnan(x)),1,'last'):end)=x(find(not(isnan(x)),1,'last'));
            end
            
            PosMatInt(:,3)=x;
            PosMat=PosMatInt;
            
            
            Sp = (sqrt(diff(PosMat(:,2)).^2 + (diff(PosMat(:,3))).^2))./diff(PosMat(:,1));
            Dist = (Sp.*diff(PosMat(:,1)));
            % The way Julie seems to have calculated it
            %                         TimeBetween2Measure=0.1270;
            %                         Sp = (sqrt(diff(PosMat(:,2)).^2 + (diff(PosMat(:,3))).^2))./TimeBetween2Measure;
            %                         Dist = (Sp.*TimeBetween2Measure);
            
            TotalDist(ss,mm) = nansum(Dist(Sp>2.5 & Sp<70))/100;
        catch
            disp(Dir.path{mm})
            TotalDist(ss,mm) = NaN;
        end
        
    end
end
    
a=strfind(Dir.group,'OBX');
CTRL=cellfun('isempty',a);
OBX=~cellfun('isempty',a);

Vals = {TotalDist(1,CTRL)'; TotalDist(1,OBX)'; TotalDist(2,CTRL)'; TotalDist(2,OBX)'};
XPos = [1.1,1.9,3.5,4.4];

Cols = {[0.8 0.8 0.8],[1 0.4 0.4],[0.8 0.8 0.8],[1 0.4 0.4]};

A = Vals;
Legends = {'Sham','OBX','Sham','OBX'};
X = [1 2 4 5];
figure
MakeSpreadAndBoxPlot_SB(Vals,Cols,X,Legends)
ylabel('Travelled distance(m)')
        [pearly,hearly,cearly]=ranksum(TotalDist(1,CTRL==1)',TotalDist(1,CTRL==0)');
        [plate,hlate,clate]=ranksum(TotalDist(2,CTRL==1)',TotalDist(2,CTRL==0)');



    a=strfind(Dir.group,'OBX');
    CTRL=cellfun('isempty',a);
    
    CTRlFz=(TotalDist(:,CTRL==1));
    for k= 1 :length(SessionTypes)
        a=iosr.statistics.boxPlot(k*2-0.8,CTRlFz(k,:)','boxColor',[0.8 0.8 0.8],'lineColor',[0.8 0.8 0.8],'medianColor','k','boxWidth',0.5,'showOutliers',false);
        a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
        a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
        a.handles.medianLines.LineWidth = 5;
        hold on
    end
    
    CTRlFz=(TotalDist(:,CTRL==0));
    for k= 1 :length(SessionTypes)
        a=iosr.statistics.boxPlot(k*2-0.2,CTRlFz(k,:)','boxColor',[0.95 0.95 0.95],'lineColor',[0.95 0.95 0.95],'medianColor','k','boxWidth',0.5,'showOutliers',false);
        a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
        a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
        a.handles.medianLines.LineWidth = 5;
        hold on
    end
    
    handlesplot=plotSpread(TotalDist(:,CTRL==1)','distributionColors','k','xValues',[1:2:length(SessionTypes)*2-1]+0.2,'spreadWidth',0.8); hold on;
    set(handlesplot{1},'MarkerSize',30)
    handlesplot=plotSpread(TotalDist(:,CTRL==1)','distributionColors',[0.6,0.6,0.6]*0.4,'xValues',[1:2:length(SessionTypes)*2-1]+0.2,'spreadWidth',0.8); hold on;
    set(handlesplot{1},'MarkerSize',20)
    handlesplot=plotSpread(TotalDist(:,CTRL==0)','distributionColors','k','xValues',[2:2:length(SessionTypes)*2]-0.2,'spreadWidth',0.8); hold on;
    set(handlesplot{1},'MarkerSize',30)
    handlesplot=plotSpread(TotalDist(:,CTRL==0)','distributionColors',[0.6,0.6,0.6],'xValues',[2:2:length(SessionTypes)*2]-0.2,'spreadWidth',0.8); hold on;
    set(handlesplot{1},'MarkerSize',20)
    xlim([0 length(SessionTypes)*2+1])
    set(gca,'FontSize',18,'XTick',[],'linewidth',1.5)
    ylabel('distance travelled')
    
    for k= 1 :length(SessionTypes)
        [p1,h,ci]=ranksum(TotalDist(k,CTRL==1)',TotalDist(k,CTRL==0)');
        text(k*2-0.5,max(ylim)*0.9,num2str(p1,2))
    end
    
    set(gca,'XTick',[1.5,3.5,5.5,7.5],'XTickLabel',SessionTypes)
    
    
end
