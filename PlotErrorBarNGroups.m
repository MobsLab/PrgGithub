function PlotErrorBarNGroups(A,newfig,CondNames,GroupNames)
% function p= PlotErrorBarN(A,newfig)
% inputs:
% - A is a cell Array, each cell is one group and contains a matrix of
% size conditions*observables
% - newfig (optional) = 1 to display in a new figure, 0 to add on existing 
%                        one (default 1)


%% CHECK INPUTS
if ~exist('newfig','var')
    newfig=1;
end
if ~exist('CondNames','var')
    CondNames={};
end
if ~exist('GroupNames','var')
    GroupNames={};
end

%% GET DATA FROM A

NumGroups=length(A);
NumCond=size(A{1},1);
Xvals=[];
for nc=1:NumCond
    val=max(max(Xvals));
    if isempty(val)
        val=0;
    end
    Xvals=[Xvals;2+val:NumGroups+val+1];
end
map=[];
map=colormap(lines)
map=map([1,7,5],:)
Cols=map;


if newfig
    figure('color',[1 1 1]),
end
for ng=1:NumGroups
       bar(-ng*10,1,'FaceColor',Cols(ng,:)),hold on
end

for nc=1:NumCond
    for ng=1:NumGroups
        nmice=size(A{ng}(nc,:),2);
    Moy(ng,nc)=nanmean(A{ng}(nc,:));
    StdE(ng,nc)=nanstd(A{ng}(nc,:))/sqrt(nmice);
    bar(Xvals(nc,ng),Moy(ng,nc),'FaceColor',Cols(ng,:)),hold on
    errorbar(Xvals(nc,ng),Moy(ng,nc),StdE(ng,nc),'k')
        plot(Xvals(nc,ng)*ones(nmice,1),A{ng}(nc,:),'ko','markerfacecolor','w')
    end
end
xlim([min(min(Xvals))-1,max(max(Xvals))+1])
set(gca,'XTick',mean(Xvals'),'XTickLabel',CondNames)
if not(isempty(GroupNames))
legend(GroupNames)
end

end


