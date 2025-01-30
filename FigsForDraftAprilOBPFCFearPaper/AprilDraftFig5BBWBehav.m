clear all,
Dir=PathForExperimentFEAR('FearCBNov15');
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-envC');
% Dir=RestrictPathForExperiment(Dir,'nMice',[,280:285:290,]);

% Dir=PathForExperimentFEAR('ManipFeb15Bulbectomie');
% Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-envC');

CSMOINS=[122 192 257 347];
CSPLUS=[408 478 628 689 789 862 927 1007 1117 1178 1256 1320];
% CSEpoch{1}=intervalSet(122*1e4,408*1e4); % the block of four CS-
% CSEpoch{2}=intervalSet(408*1e4,789*1e4); % 1st block of four CS+
% CSEpoch{3}=intervalSet(789*1e4,1117*1e4); % 2nd block of four CS+
% CSEpoch{4}=intervalSet(1117*1e4,1400*1e4); % 3rd block of four CS+

CSEpoch{1}=intervalSet(CSMOINS*1e4,CSMOINS*1e4+60*1e4);
CSEpoch{2}=intervalSet(CSPLUS(1:4)*1e4,CSPLUS(1:4)*1e4+60*1e4);
CSEpoch{3}=intervalSet(CSPLUS(5:8)*1e4,CSPLUS(5:8)*1e4+60*1e4);
CSEpoch{4}=intervalSet(CSPLUS(9:12)*1e4,CSPLUS(9:12)*1e4+60*1e4);
% 
% 
% CSEpoch{1}=intervalSet(CSMOINS(1)*1e4,CSMOINS(4)*1e4+30*1e4);
% CSEpoch{2}=intervalSet(CSPLUS(1)*1e4,CSPLUS(4)*1e4+30*1e4);
% CSEpoch{3}=intervalSet(CSPLUS(5)*1e4,CSPLUS(8)*1e4+30*1e4);
% CSEpoch{4}=intervalSet(CSPLUS(9)*1e4,CSPLUS(12)*1e4+30*1e4);

for mm=1:length(Dir.path)
    mm
    cd(Dir.path{mm})
    clear chH chB chP
    try, load('behavResources.mat');catch,load('Behavior.mat'); end
    TotEpoch = intervalSet(0,max(Range(Movtsd)));
    for ep=1:4
        FzPerc(mm,ep)=100*length(Range(Restrict(Movtsd,and(FreezeEpoch,CSEpoch{ep}))))./length(Range(Restrict(Movtsd,CSEpoch{ep})));
    end
    FzDur{mm}=Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s');
    NoFzDur{mm}=Stop(TotEpoch-FreezeEpoch,'s')-Start(TotEpoch-FreezeEpoch,'s');
    MouseNum(mm) = eval(Dir.name{mm}(6:end));
end

a=strfind(Dir.group,'OBX');
CTRL=cellfun('isempty',a);

%  PlotErrorBarN(FzPerc(CTRL==0,:))
figure
hold on
CTRLFz=[];BBXFz=[];
for k=1:length(CTRL)
    if CTRL(k)==1
        [Y,X]=hist(FzDur{k},[0:1:150]);
        plot(X,cumsum(Y)./sum(Y),'k')
        
        CTRLFz=[CTRLFz;FzDur{k}];
    else
        [Y,X]=hist(FzDur{k},[0:1:150]);
        plot(X,cumsum(Y)./sum(Y),'r')
        
        BBXFz=[BBXFz;FzDur{k}];
    end
end

figure
hold on
CTRLFz=[];BBXFz=[];
for k=1:length(CTRL)
    if CTRL(k)==1
        [Y,X]=hist(NoFzDur{k},[0:1:150]);
        plot(X,cumsum(Y)./sum(Y),'k')
        
        CTRLFz=[CTRLFz;NoFzDur{k}];
    else
        [Y,X]=hist(NoFzDur{k},[0:1:150]);
        plot(X,cumsum(Y)./sum(Y),'r')
        
        BBXFz=[BBXFz;NoFzDur{k}];
    end
end


figure
X1=[0.8:0.8:3.8];
X2=[1.2:0.8:4+0.2]-0.1;
clf
hold on
b=bar(X1,nanmean(FzPerc(CTRL==1,:)),'FaceColor',[0 0 0], 'BarWidth', 0.3), hold on
b=bar(X2,nanmean(FzPerc(CTRL==0,:)),'FaceColor',[0.5 0.5 0.5], 'BarWidth', 0.3)
errorbar(X1,nanmean(FzPerc(CTRL==1,:)),stdError(FzPerc(CTRL==1,:)),'k.')
errorbar(X2,nanmean(FzPerc(CTRL==0,:)),stdError(FzPerc(CTRL==0,:)),'k.')
xlim([0.5 5.1])
set(gca,'XTick',[1,3.4],'XTickLabel',{'CS-','Cs+'},'FontSize',14,'YTick',[0:20:80])
ylabel('Freezing (%)')

%% spread plot and median
fig=figure;
handlesplot=plotSpread(FzPerc(CTRL==1,:),'distributionColors',[0.6,0.6,0.6],'xValues',X1,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',10)
handlesplot=plotSpread(FzPerc(CTRL==0,:),'distributionColors',[0.4,0.4,0.4],'xValues',X2,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',10)
set(gca,'XTick',[1,3.5],'XTickLabel',{'CS-','Cs+'},'FontSize',14,'YTick',[0:20:100])
xlim([0 5.5]), ylim([-5 90])
for k=1:4
   line([X1(k)-0.15 X1(k)+0.15],[1 1]*median(FzPerc(CTRL==1,k)),'color',[0.6,0.6,0.6],'linewidth',4) 
end
for k=1:4
   line([X2(k)-0.15 X2(k)+0.15],[1 1]*median(FzPerc(CTRL==0,k)),'color',[0.4,0.4,0.4],'linewidth',4) 
end
ylabel('Freezing (%)')
for k=1:4
[ppost{k},hpost{k},statspost{k}]=ranksum(FzPerc(CTRL==1,k),FzPerc(CTRL==0,k));
end

%% spread plot and median (bargraph)
figure
X1=[0.8:0.8:3.8];
X2=[1.2:0.8:4]-0.1;
b=bar(X1,median(FzPerc(CTRL==1,:))); hold on
b(1).FaceColor=[0.6 0.6 0.6];
b.BarWidth=0.3;
b=bar(X2,median(FzPerc(CTRL==0,:)));
b(1).FaceColor=[0.9,0.9,0.9]
b.BarWidth=0.3;
box off
ylabel('Freezing (%)')
set(gca,'XTick',[1,3.5],'XTickLabel',{'CS-','Cs+'},'FontSize',14,'YTick',[0:20:100])
xlim([0.5 4.5]), ylim([0 40])
handlesplot=plotSpread(FzPerc(CTRL==1,:),'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',X1,'spreadWidth',0.5), hold on;
set(handlesplot{1},'MarkerSize',30)
handlesplot=plotSpread(FzPerc(CTRL==1,:),'distributionColors',[0.6,0.6,0.6],'xValues',X1,'spreadWidth',0.5), hold on;
set(handlesplot{1},'MarkerSize',20)
handlesplot=plotSpread(FzPerc(CTRL==0,:),'distributionColors',[0.8,0.8,0.8]*0.2,'xValues',X2,'spreadWidth',0.5), hold on;
set(handlesplot{1},'MarkerSize',30)
handlesplot=plotSpread(FzPerc(CTRL==0,:),'distributionColors',[0.8,0.8,0.8],'xValues',X2,'spreadWidth',0.5), hold on;
set(handlesplot{1},'MarkerSize',20)
set(gca,'XTick',[1,2.5],'XTickLabel',{'CS-','Cs+'},'FontSize',14,'YTick',[0:20:100])
xlim([0.5 4]), ylim([-5 100])


%% Calculation of effect sizes
Ctrl_freezing = FzPerc(CTRL==1,:);
BBX_freezing = FzPerc(CTRL==0,:);
for sessnum = 1:4
s_cohen_num = (length(Ctrl_freezing(:,sessnum))-1)*var(Ctrl_freezing(:,sessnum))+(length(BBX_freezing(:,sessnum))-1)*var(BBX_freezing(:,sessnum));
s_cohen_denom = length(Ctrl_freezing(:,sessnum)) + length(BBX_freezing(:,sessnum))-2;
s_cohen = sqrt(s_cohen_num./s_cohen_denom);
Size_Effect = (nanmean(Ctrl_freezing(:,sessnum))-nanmean(BBX_freezing(:,sessnum)))./s_cohen
end



% 
% CTRlFz=(FzPerc(CTRL==1,:));
% for k= 1 :4
%     line([1 1]*X1(k),[prctile(CTRlFz(:,k),25),prctile(CTRlFz(:,k),75)],'color','k')
% end
% 
% CTRlFz=(FzPerc(CTRL==0,:));
% for k= 1 :4
%     line([1 1]*X2(k),[prctile(CTRlFz(:,k),25),prctile(CTRlFz(:,k),75)],'color','k')
% end


if sav
    cd('/home/mobs/Dropbox/SophiesOB4HzManusciptFolder/Fig6-B/BBX/'); res=pwd;
    saveas(gcf,'OBX.eps')
    saveFigure(gcf,'OBX',res)
end
%stats
if 1
    MouseNum=[CTRL;CTRL;CTRL;CTRL]';
    SessNum=[[1:4]'*ones(1,length(CTRL))]';
    [p_an,table_an,stats_an] = anovan(FzPerc(:),{MouseNum(:),SessNum(:)},'model' ,'interaction');
    [Pkw_g,table_kw_g]= kruskalwallis(FzPerc(:), MouseNum(:));
    for i=1:4
        [p(i),h(i)]=ranksum(FzPerc(CTRL,i),FzPerc(CTRL==0,i));
    end
end


figure
CTRlFz=(FzPerc(CTRL==1,:));
for k= 1 :4
    a=iosr.statistics.boxPlot(k*2-0.8,CTRlFz(:,k),'boxColor',[0.8 0.8 0.8],'lineColor',[0.8 0.8 0.8],'medianColor','k','boxWidth',0.5,'showOutliers',false);
    a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
    a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
    a.handles.medianLines.LineWidth = 5;
    hold on
end

CTRlFz=(FzPerc(CTRL==0,:));
for k= 1 :4
    a=iosr.statistics.boxPlot(k*2-0.2,CTRlFz(:,k),'boxColor',[0.95 0.95 0.95],'lineColor',[0.95 0.95 0.95],'medianColor','k','boxWidth',0.5,'showOutliers',false);
    a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
    a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
     a.handles.medianLines.LineWidth = 5;

    hold on
end

handlesplot=plotSpread(FzPerc(CTRL==1,:),'distributionColors','k','xValues',[1:2:7]+0.2,'spreadWidth',0.8), hold on;
set(handlesplot{1},'MarkerSize',30)
handlesplot=plotSpread(FzPerc(CTRL==1,:),'distributionColors',[0.6,0.6,0.6]*0.4,'xValues',[1:2:7]+0.2,'spreadWidth',0.8), hold on;
set(handlesplot{1},'MarkerSize',20)
handlesplot=plotSpread(FzPerc(CTRL==0,:),'distributionColors','k','xValues',[2:2:8]-0.2,'spreadWidth',0.8), hold on;
set(handlesplot{1},'MarkerSize',30)
handlesplot=plotSpread(FzPerc(CTRL==0,:),'distributionColors',[0.6,0.6,0.6],'xValues',[2:2:8]-0.2,'spreadWidth',0.8), hold on;
set(handlesplot{1},'MarkerSize',20)
xlim([0 9])
set(gca,'FontSize',18,'XTick',[],'linewidth',1.5,'YTick',[0:20:100])
ylabel('% time freezing')
ylim([-5 90])