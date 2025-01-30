function MakeSpreadAndBoxPlot_BM(A,Cols,X,Legends,ShowPoints, PairedData)
% Input variables
% A = your data in a cell format A = {Data1,Data2,Data3}
% Cols = The color for each set of data Cols = {[1 0 0],[0 0 1],[0 1 0]}
% If you don't care about colors just put {} and everything wille be grey
% X = the position to plot your data X = [1,2,3]
% If you don't care just put []
% Legends = the identity of your datasets for xlabels Legends = {'bla' 'bla' 'bla'}
% If you don't care about colors just put {}
% ShowPoints = 0 for no points = 1 for points
%
% Modified from MakeSpreadAndBoxPlot_SB.m


if isempty(Cols)
    for i = 1:length(A)
        Cols{i} = [0.6 0.6 0.6];
    end
end

if isempty(X)
    for i = 1:length(A)
        X(i) = i*2;
    end
end

if isempty(Legends)
    for i = 1:length(A)
        Legends{i} = num2str(i);
    end
end

if exist('PairedData')==0
    PairedData = 0;
end

for k = 1 : length(A)
    if sum(isnan(A{k}))<length(A{k})
        a=iosr.statistics.boxPlot(X(k),A{k}(:),'boxColor', Cols{k}, 'lineColor',[0.95 0.95 0.95],...
            'medianColor','k','boxWidth','auto', 'LineColor', 'k', 'LineWidth', 2, 'showOutliers',false);
        a.handles.upperWhiskers.Visible='on';a.handles.upperWhiskerTips.Visible='on';
        a.handles.lowerWhiskers.Visible='on';a.handles.lowerWhiskerTips.Visible='on';
        a.handles.medianLines.LineWidth = 5;
        hold on
        if ShowPoints
            handlesplot=plotSpread(A{k}(:),'distributionColors','k','xValues',X(k),'spreadWidth',0.8); hold on;
            set(handlesplot{1},'MarkerSize',5)
            handlesplot=plotSpread(A{k}(:),'distributionColors',Cols{k}*0,'xValues',X(k),'spreadWidth',0.8); hold on;
            set(handlesplot{1},'MarkerSize',5)
            RemLoc{k} = [get(handlesplot{1},'XData');get(handlesplot{1},'YData')];
            RemHandle{k} = handlesplot;
        end
    end
    MinA(k) = min(A{k});
    MaxA(k) = max(A{k});
end

if PairedData
    % Preliminary stuff,
    for k= 1: length(A)
        N=size(A{k},2); %eventually formating A to cell
        temp{k}=A{k}(~isnan(A{k}));
    end
    %if paired data, data are linked together, for each individual, with line
    M = cell2mat(A);
    if size(M,1)==1
        M=cell2mat(A')';
    end
    
    if ShowPoints
        for k = 1:length(A)-1
            try
                %                 line([ RemLoc{k}(1,:)+.2 ; RemLoc{k+1}(1,:)-.2],[ RemLoc{k}(2,:)  ;RemLoc{k+1}(2,:)], 'color',[.85 .85 .85])
                line([ones(1,length(temp{k}))*X(k)+.3 ; ones(1,length(temp{k}))*X(k+1)-.3],[ RemLoc{k}(2,:)  ;RemLoc{k+1}(2,:)], 'color',[.85 .85 .85])
                uistack(RemHandle{k}{1},'top')
            end
        end
        uistack(RemHandle{k+1}{1},'top')
        
    else % only lines
        for k = 1:length(A)-1
            try
                ind = and(~isnan(A{k}) , ~isnan(A{k+1}));
                try
                    line([ones(1,length(A{k}(ind)))*X(k)+.3 ; ones(1,length(A{k}(ind)))*X(k+1)-.3],[A{k}(ind)  ; A{k+1}(ind)], 'color',[.7 .7 .7])
                catch
                    line([ones(1,length(A{k}(ind)))*X(k)+.3 ; ones(1,length(A{k}(ind)))*X(k+1)-.3],[A{k}(ind)'  ; A{k+1}(ind)'], 'color',[.7 .7 .7])                    
                end
            end
        end
    end
end


xlim([min(X)-1 max(X)+1])
rg = max(MaxA)-min(MinA);
if ShowPoints
    ylim([min(MinA)-rg*0.1 max(MaxA)+rg*0.1])
end
if exist('Legends')
    set(gca,'XTick',X,'XTickLabel',Legends)
    box off
    set(gca,'FontSize',10,'Linewidth',1)
end
xtickangle(45)
