% This code generates pannels used in april draft
% It generates Fig3

clear all,close all
obx=0;
% Get data
[Dir,KeepFirstSessionOnly]=GetRightSessionsFor4HzPaper('CtrlBBXAllDataSpikes')
% Where to save
SaveFigFolder='/Users/sophiebagur/Dropbox/OB4Hz-manuscrit/FigAfterSkype/';
Date=date;
SaveFigFolder=[SaveFigFolder,Date,filesep];

%  get parameters
[params,movingwin,suffix]=SpectrumParametersML('low');
rmpath('/Users/sophiebagur/Dropbox/PrgMatlab/Fra/UtilsStats')
numNeurons=[];
num=1;
StrucNames={'OBVars' 'PFCVars' 'HPCVars'}

for mm=KeepFirstSessionOnly
    Dir.path{mm}
    cd(Dir.path{mm})
    load('SpikeData.mat')
    load('behavResources.mat')
    numtt=[]; % nb tetrodes ou montrodes du PFCx
    load LFPData/InfoLFP.mat
    chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
    
    for cc=1:length(chans)
        for tt=1:length(tetrodeChannels) % tetrodeChannels= tetrodes ou montrodes (toutes)
            if ~isempty(find(tetrodeChannels{tt}==chans(cc)))
                numtt=[numtt,tt];
            end
        end
    end
    
    numNeurons=[]; % neurones du PFCx
    for i=1:length(S);
        if ismember(TT{i}(1),numtt)
            numNeurons=[numNeurons,i];
        end
    end
    
    numMUA=[];
    for k=1:length(numNeurons)
        j=numNeurons(k);
        if TT{j}(2)==1
            numMUA=[numMUA, k];
        end
    end
    numNeurons(numMUA)=[];
    
    load LFPData/InfoLFP.mat
    chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
    load(['LFPData/LFP',num2str(chans(1)),'.mat'])
    Tmax=max(Range(LFP,'s'));
    
    for sp=1:length(numNeurons)
        AllFR{num}(sp)=length(Range(S{numNeurons(sp)}))./Tmax;
    end
        IsCtrl(num)=strcmp(Dir.group{mm},'CTRL');

    num=num+1;
    
    
    
end


FRBBX=[];FRSham=[];
for k=find(~IsCtrl)
    FRBBX=[FRBBX AllFR{k}];
end
CohSham=[];NeurModSham=[]; KappaSham=[];FRSham=[];KappaSham69=[];NeurModSham69=[];

for k=find(IsCtrl)
    FRSham=[FRSham AllFR{k}];
end

figure
handles=plotSpread({log(FRSham),log(FRBBX)}), hold on;
set(handles{1},'Color',[0.6 0.6 0.6])
line([0.7 1.3],[1 1]*nanmedian(log(FRSham)),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(log(FRBBX)),'color','k','linewidth',2)
[pbbx,hpbbx,statspbbx]=ranksum(FRSham,FRBBX);
set(gca,'XTick',[1,2],'XTickLabel',{'Ctrl','OBX'},'YTick',log([  0.02 0.14 1 8 54]),'YTickLabel',strread(num2str([  0.02 0.14 1 8 54]),'%s'))
ylim(log([0.01 55]))


cd /media/DataMOBsRAIDN/ProjetAversion/SleepStim
load('FiringRateBeforeAfter_allmice.mat')
figure
handles=plotSpread({log(FRall_2(:,3)),log(FRall_2(:,5))}), hold on;
set(handles{1},'Color',[0.6 0.6 0.6])
line([0.7 1.3],[1 1]*nanmedian(log(FRall_2(:,3))),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(log(FRall_2(:,5))),'color','k','linewidth',2)
[p10vs4,h10vs4,stats10vs4]=ranksum(FRall_2(:,3),FRall_2(:,5));
set(gca,'XTick',[1,2],'XTickLabel',{'4Hz Stim','10Hz stim'},'YTick',log([0.02 0.14 1 8 54]),'YTickLabel',strread(num2str([  0.02 0.14 1 8 54]),'%s'))
ylim(log([0.01 55]))



%% boxplot
figure
clf
Vals = {log(FRSham)'; log(FRBBX)'};
XPos = [1.1,1.9];

ColFact = [0.4,1];
for k = 1:2
X = Vals{k};
a=iosr.statistics.boxPlot(XPos(k),X,'boxColor',[0.9 0.9 0.9]*ColFact(k),'lineColor',[0.9 0.9 0.9]*ColFact(k),'medianColor','k','boxWidth',0.5,'showOutliers',false);
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;

handlesplot=plotSpread(X,'distributionColors',[0 0 0],'xValues',XPos(k),'spreadWidth',0.4), hold on;
set(handlesplot{1},'MarkerSize',22)
handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*ColFact(k),'xValues',XPos(k),'spreadWidth',0.4), hold on;
set(handlesplot{1},'MarkerSize',12)

end

xlim([0.5 2.4])
ylim([-3 5])
set(gca,'FontSize',18,'XTick',XPos,'XTickLabel',{'Sham','OBX','Sham','OBX'},'linewidth',1.5,'YTick',log([0.14 1 8 54]),'YTickLabel',{'0.14','1','8','54'})
ylabel('FR (Hz)')
box off


X=(FRall_2(:,3)-FRall_2(:,5))./(FRall_2(:,3)+FRall_2(:,5));
figure
a=iosr.statistics.boxPlot(1,X,'boxColor',[0.9 0.9 0.9],'lineColor',[0.9 0.9 0.9],'medianColor','k','boxWidth',0.5,'showOutliers',false);
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;

handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',1,'spreadWidth',0.4), hold on;
set(handlesplot{1},'MarkerSize',22)
handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6],'xValues',1,'spreadWidth',0.4), hold on;
set(handlesplot{1},'MarkerSize',12)

line(xlim,[0 0],'linestyle','--','linewidth',1,'color',[0.6 0.6 0.6])

xlim([0.5 1.5])
ylim([-1 1])
set(gca,'FontSize',18,'XTick',[1,2],'linewidth',1.5,'XTick',[],'Xcolor','w')
ylabel('FR - Kappa')
box off

cd /media/DataMOBsRAIDN/ProjetAversion/SleepStim
load('FiringRateBeforeAfter_allmice.mat')
figure
handles=plotSpread({log(FRall_2(:,3)),log(FRall_2(:,5))}), hold on;
set(handles{1},'Color',[0.6 0.6 0.6])
line([0.7 1.3],[1 1]*nanmedian(log(FRall_2(:,3))),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(log(FRall_2(:,5))),'color','k','linewidth',2)
[p10vs4,h10vs4,stats10vs4]=ranksum(FRall_2(:,3),FRall_2(:,5));
set(gca,'XTick',[1,2],'XTickLabel',{'4Hz Stim','10Hz stim'},'YTick',log([0.02 0.14 1 8 54]),'YTickLabel',strread(num2str([  0.02 0.14 1 8 54]),'%s'))
ylim(log([0.01 55]))