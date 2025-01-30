function MakeSpreadAndBoxPlot_SB(A,Cols,X,Legends,ShowPoints,PairedData)
% Input variables
% A = your data in a cell format A = {Data1,Data2,Data3}
% Cols = The color for each set of data Cols = {[1 0 0],[0 0 1],[0 1 0]}
% If you don't care about colors just put {} and everything wille be grey
% X = the position to plot your data X = [1,2,3]
% If you don't care just put []
% Legends = the identity of your datasets for xlabels Legends = {'bla' 'bla' 'bla'}
% If you don't care about colors just put {} 
% ShowPoints = 0 for no points = 1 for points
%eventually formating A to cell
B=A; %data not cell
if ~iscell(A)
    tempA=A; A={};
    for i=1:size(tempA,2)
        A{i}=tempA(:,i);
    end
end

if exist('ShowPoints')==0
   ShowPoints = 0;
end

if exist('PairedData')==0
   PairedData = 0;
end

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

for k = 1 : length(A)
    if sum(isnan(A{k}))<length(A{k})
        a=iosr.statistics.boxPlot(X(k),A{k}(:),'boxColor',Cols{k},'lineColor',[0.95 0.95 0.95],'medianColor','k','boxWidth',0.5,'showOutliers',false);
        a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
        a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
        a.handles.medianLines.LineWidth = 5;
        hold on
        
        if ShowPoints
            handlesplot=plotSpread(A{k}(:),'distributionColors','k','xValues',X(k),'spreadWidth',0.8); hold on;
            set(handlesplot{1},'MarkerSize',20)
            handlesplot=plotSpread(A{k}(:),'distributionColors',Cols{k}*0.4,'xValues',X(k),'spreadWidth',0.8); hold on;
            set(handlesplot{1},'MarkerSize',10)
        end
        
       
        
    end
    
    MinA(k) = min(A{k});
    MaxA(k) = max(A{k});
    
end

if PairedData
    % Preliminary stuff,
    for k= 1: length(A)
        N=size(A{k},2); %eventually formating A to cell
        %plot points, indicating value for each individual
        temp=A{k}(~isnan(A{k}));
        plot(k+0.1,temp,'ko','markerfacecolor','w')
    end
    %if paired data, data are linked together, for each individual, with line
    M = cell2mat(A);
    if size(M,1)==1
        M=cell2mat(A')';
    end
    
    nb_individual=size(M,1); %number of indivudual
    for k=1:nb_individual
        idx = find(~isnan(M(k,:)));
        for i=1:length(idx)-1
            try
                line(0.1+[idx(i) idx(i+1)]', [M(k,idx(i)) M(k,idx(i+1))]', 'color',[0.6 0.6 0.6]);
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

    makepretty

end