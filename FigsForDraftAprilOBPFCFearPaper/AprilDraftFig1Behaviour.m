% Make behaviour,spectra, coherence and granger pannels for fig1
clear all
% Get data
[Dir,KeepFirstSessionOnly]=GetRightSessionsFor4HzPaper('CtrlAllData')

% Where to save
SaveFigFolder='/Users/sophiebagur/Dropbox/OB4Hz-manuscrit/FigTest/';
Date=date;
SaveFigFolder=[SaveFigFolder,Date,filesep];

% Get Parameters
CSMOINS=[122 192 257 347];
CSPLUS=[408 478 628 689 789 862 927 1007 1117 1178 1256 1320];
% CSEpoch{1}=intervalSet(CSMOINS*1e4,CSMOINS*1e4+60*1e4);
% CSEpoch{2}=intervalSet(CSPLUS(1:4)*1e4,CSPLUS(1:4)*1e4+60*1e4);
% CSEpoch{3}=intervalSet(CSPLUS(5:8)*1e4,CSPLUS(5:8)*1e4+60*1e4);
% CSEpoch{4}=intervalSet(CSPLUS(9:12)*1e4,CSPLUS(9:12)*1e4+60*1e4);

CSEpoch{1}=intervalSet(122*1e4,408*1e4); % the block of four CS-
CSEpoch{2}=intervalSet(408*1e4,789*1e4); % 1st block of four CS+
CSEpoch{3}=intervalSet(789*1e4,1117*1e4); % 2nd block of four CS+
CSEpoch{4}=intervalSet(1117*1e4,1400*1e4); % 3rd block of four CS+

num=1;
for mm=KeepFirstSessionOnly
    mm
    cd(Dir.path{mm})
    clear chH chB chP
    %©load('StateEpoch.mat')
    load('behavResources.mat')
    for ep=1:4
        FzPerc(num,ep)=100*length(Range(Restrict(Movtsd,and(FreezeEpoch,CSEpoch{ep}))))./length(Range(Restrict(Movtsd,CSEpoch{ep})));
    end
    num=num+1;
end

fig=figure;
b=bar(1,mean(FzPerc(:,1)));set(b,'FaceColor',[0.6,0.6,0.6]), hold on
errorbar(1,mean(FzPerc(:,1)),stdError(FzPerc(:,1)),'k')
b=bar([2:4],mean(FzPerc(:,2:4)));set(b,'FaceColor',[0.6 0.6 0.6]), hold on
errorbar([2:4],mean(FzPerc(:,2:4)),stdError(FzPerc(:,2:4)),'.k')
ylim([0 85])
box off
set(gca,'XTick',[1,3],'XTickLabel',{'CS-','Cs+'},'FontSize',14,'YTick',[0:20:80])
ylabel('Freezing (%)')
% for j=1:3
% [hpost{j},p1post{j},cipost{j},statspost{j}]=ttest(FzPerc(:,1),FzPerc(:,j+1));
% end
% [panova,anovatab,statsanova] = anova1(FzPerc,[],0);
% saveas(fig,[SaveFigFolder,'OverallBehav.fig'])
% save([SaveFigFolder,'OverallBehav.mat'],'hpost','p1post','cipost','statspost',...
%     'panova','anovatab','statsanova')

%% Boxplot
figure
clf
for k = 1:4
X = FzPerc(:,k);
a=iosr.statistics.boxPlot((k),X,'boxColor',[0.9 0.9 0.9],'lineColor',[0.9 0.9 0.9],'medianColor','k','boxWidth',0.5,'showOutliers',false);
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;

handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',(k),'spreadWidth',0.7), hold on;
set(handlesplot{1},'MarkerSize',22)
handlesplot=plotSpread(X,'distributionColors',[0.9 0.9 0.9],'xValues',(k),'spreadWidth',0.7), hold on;
set(handlesplot{1},'MarkerSize',12)

end

xlim([0.5 4.5])
ylim([-5 100])
set(gca,'FontSize',18,'XTick',[],'linewidth',1.5,'YTick',[0:20:100])
ylabel('% time freezing')
box off




fig=figure;
handlesplot=plotSpread(FzPerc,'distributionColors',[0.6,0.6,0.6;0.6,0.6,0.6;0.6,0.6,0.6;0.6,0.6,0.6]), hold on;
set(gca,'XTick',[1,3],'XTickLabel',{'CS-','Cs+'},'FontSize',14,'YTick',[0:20:100])
set(handlesplot{1},'MarkerSize',10)
xlim([0 5]), ylim([-5 100])
for k=1:4
   line([k-0.4 k+0.4],[1 1].*median(FzPerc(:,k)),'color','k','linewidth',3) 
end
[pFriedman,TableFriedman,statsFriedman]=friedman(FzPerc,1);
for j=1:3
[ppost{j},hpost{j},statspost{j}]=signrank(FzPerc(:,1),FzPerc(:,j+1));
end
ylabel('Freezing (%)')

figure
b=bar([1:4],median(FzPerc),'k');
set(b,'FaceColor',[0.6 0.6 0.6]), hold on
xlim([0 5]), ylim([0 60])
set(gca,'XTick',[1,3],'XTickLabel',{'CS-','Cs+'},'FontSize',14,'YTick',[0:20:100])
ylabel('Freezing (%)')
box off

%% Fig HAB
clear all,

Dir=PathForExperimentFEAR('Fear-electrophy');
CtrlEphys=[248,244,243,253,254,258,259,299,394,395,402,403,450,451];
%Dir=PathForExperimentFEAR('Fear-electrophy');
%CtrlEphys=[242,248,244,243,253,254,258,259,299,394,395,402,403,450,451];
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','HAB-NaN');

cd(Dir.path{1})
load Behavior StimInfo

int=intervalSet(StimInfo(1:end-1,1),StimInfo(2:end,1));
int2=dropShortIntervals(int,2);
CSEpoch{2}=subset(int2,[1 3 5 7]);
CSEpoch{1}=subset(int2,[2 4 6 8]);
for mm=1:length(Dir.path)
    mm
    cd(Dir.path{mm})
    try, load('behavResources.mat');catch,load('Behavior.mat'); end
    for ep=1:2
        FzPerc(mm,ep)=100*length(Range(Restrict(Movtsd,and(FreezeEpoch,CSEpoch{ep}))))./length(Range(Restrict(Movtsd,CSEpoch{ep})));
    end
    
end

a=strfind(Dir.group,'OBX');
CTRL=cellfun('isempty',a);
%  PlotErrorBarN(FzPerc(CTRL==0,:))
figure
X1=[0.8:1.2:(5-0.2)];
X2=[1.2:1.2:5+0.2];
clf
hold on
b=bar(X1,nanmean(FzPerc(CTRL==1,:)),'FaceColor',[0 0 0], 'BarWidth', 0.3), hold on
b=bar(X2,nanmean(FzPerc(CTRL==0,:)),'FaceColor',[0.5 0.5 0.5], 'BarWidth', 0.3)
errorbar(X1,nanmean(FzPerc(CTRL==1,:)),stdError(FzPerc(CTRL==1,:)),'k.')
errorbar(X2,nanmean(FzPerc(CTRL==0,:)),stdError(FzPerc(CTRL==0,:)),'k.')
xlim([0.5 5.1])
set(gca,'XTick',[1,3.4],'XTickLabel',{'CS-','Cs+'},'FontSize',14,'YTick',[0:20:80])
ylabel('Freezing (%)')







