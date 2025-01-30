% function [Res,PCArec,SWRrate,mPr,mHa,mCo,mPo,tPr,tHa,tCo,tPo,meanXYPCAHab,meanXYPCACond,PCAfreez,FiXYPCAHab,FiXYPCACond,...
%     OccHab,OccCond] = PCAreacERC2(PeriodAnalyse,num_pc,binS, dir)
function [PCArec,SWRrate,mPr,mHa,mCo,mPo,tPr,tHa,tCo,tPo,meanXYPCAHab,meanXYPCACond,PCAfreez,FiXYPCAHab,FiXYPCACond,...
    OccHab,OccCond] = PCAreacERC2(PeriodAnalyse,num_pc,binS, dir)


%% Load data
% [b, ss, r, Hab, Cond, Res, replayGtsd, composition] = LoadData_indmice_pca(dir, 'PAG', num_pc, binS, PeriodAnalyse);
[b, ss, r, Hab, Cond, replayGtsd] = LoadData_indmice_pca(dir, 'PAG', num_pc, binS, PeriodAnalyse);
PostSleep=and(b.SessionEpoch.PostSleep, ss.SWSEpoch);
PreSleep=and(b.SessionEpoch.PreSleep, ss.SWSEpoch);

%% mean RS
[mPr,~,tPr]=ETAverage(Range(Restrict(r.tRipples,PreSleep)),Range(replayGtsd),Data(replayGtsd),100,50);
[mCo,~,tCo]=ETAverage(Range(Restrict(r.tRipples,Cond)),Range(replayGtsd),Data(replayGtsd),100,50);
[mHa,~,tHa]=ETAverage(Range(Restrict(r.tRipples,Hab)),Range(replayGtsd),Data(replayGtsd),100,50);
[mPo,~,tPo]=ETAverage(Range(Restrict(r.tRipples,PostSleep)),Range(replayGtsd),Data(replayGtsd),100,50);

%% Ripples rate
SWRrate(1)=length(Range(Restrict(r.tRipples,PreSleep)))/sum(DurationEpoch(PreSleep,'s'));
SWRrate(2)=length(Range(Restrict(r.tRipples,Hab)))/sum(DurationEpoch(Hab,'s'));
SWRrate(3)=length(Range(Restrict(r.tRipples,Cond)))/sum(DurationEpoch(Cond,'s'));
SWRrate(4)=length(Range(Restrict(r.tRipples,PostSleep)))/sum(DurationEpoch(PostSleep,'s'));

Epochs = {'RipplesPreS', 'RipplesCond', 'RipplesHab', 'RipplesPostS'};

%% Plot individual figure

figure('color',[1 1 1]), 
subplot(2,4,6), hold on, 
bar(SWRrate,'k')
set(gca,'XTick',1:4,'XTickLabel',{'sleep pre','Hab','Cond','Sleep Post'});
subplot(2,4,7), hold on, 
plot(tPr,mPr,'color',[0 0 0.6],'linewidth',2)
% plot(tHa,mHa,'k','linewidth',2)
plot(tCo,mCo,'r','linewidth',2)
plot(tPo,mPo,'b','linewidth',2)
line([0 0],ylim,'color','k','linestyle',':')
xlim([tPr(1) tPr(end)])
subplot(2,4,1:3), hold on,
hold on, plot(Range(Restrict(replayGtsd,Cond),'s'),Data(Restrict(replayGtsd,Cond)),'r.')
hold on, plot(Range(Restrict(replayGtsd,Hab),'s'),Data(Restrict(replayGtsd,Hab)),'k.')
hold on, plot(Range(Restrict(replayGtsd,b.SessionEpoch.PostSleep),'s'),Data(Restrict(replayGtsd,b.SessionEpoch.PostSleep)),'.','color',[0.8 0.8 0.8])
hold on, plot(Range(Restrict(replayGtsd,b.SessionEpoch.PreSleep),'s'),Data(Restrict(replayGtsd,b.SessionEpoch.PreSleep)),'.','color',[0.8 0.8 0.8])
hold on, plot(Range(Restrict(replayGtsd,PostSleep),'s'),Data(Restrict(replayGtsd,PostSleep)),'.','color',[0 0 0.4])
hold on, plot(Range(Restrict(replayGtsd,PreSleep),'s'),Data(Restrict(replayGtsd,PreSleep)),'b.')
EpochR=or(or(Cond,Hab),or(b.SessionEpoch.PostSleep,b.SessionEpoch.PreSleep));
plot(Range(Restrict(r.tRipples,EpochR),'s'), 100, 'k.')

subplot(2,4,5)
PlotErrorBar4(Data(Restrict(replayGtsd,b.SessionEpoch.PreSleep)),Data(Restrict(replayGtsd,Hab)),...
    Data(Restrict(replayGtsd,Cond)),Data(Restrict(replayGtsd,b.SessionEpoch.PostSleep)),0,0);
set(gca,'XTick',1:4,'XTickLabel',{'sleep pre','Hab','Cond','Sleep Post'});    % Changing x-axis tick labels
set(gcf,'position', [110 359 1091 420])

% Cond1=subset(Cond,1:2);
% Cond2=subset(Cond,3:4);
PCArec=[mean(Data(Restrict(replayGtsd,b.SessionEpoch.PreSleep))),...
    mean(Data(Restrict(replayGtsd,Hab))),...
    mean(Data(Restrict(replayGtsd,Cond))),...
    mean(Data(Restrict(replayGtsd,b.SessionEpoch.PostSleep)))];

RipEpoch=intervalSet(Range(r.tRipples)-0.1*1E4,Range(r.tRipples)+0.1*1E4);

PCAfreez=[mean(Data(Restrict(replayGtsd,Cond))),...
    mean(Data(Restrict(replayGtsd,Cond-b.FreezeAccEpoch))),...
    mean(Data(Restrict(replayGtsd,and(Cond,b.FreezeAccEpoch)))),...
    mean(Data(Restrict(replayGtsd,and(Cond,RipEpoch)))),...
    mean(Data(Restrict(replayGtsd,Cond-RipEpoch)))];


%% Location of RS
% Bin the maze
i=1;
for x=0:0.05:1.2    
    EpochXd=thresholdIntervals(b.AlignedXtsd,x,'Direction','Above');
    EpochXu=thresholdIntervals(b.AlignedXtsd,x+0.05,'Direction','Below');
    EpochX=and(EpochXd,EpochXu);
    j=1;
    for y=0:0.05:1.2    
        EpochYd=thresholdIntervals(b.AlignedYtsd,y,'Direction','Above');
        EpochYu=thresholdIntervals(b.AlignedYtsd,y+0.05,'Direction','Below');
        EpochY=and(EpochYd,EpochYu);
        EpochXY{i,j}=and(EpochX,EpochY);
        j=j+1;
    end
    i=i+1;
end

% Put RS on the UMaze
limPCscore=20;
for i=1:size(EpochXY,1)
    for j=1:size(EpochXY,2)
    meanXYPCAHab(i,j)=nanmean(Data(Restrict(replayGtsd,and(Hab,EpochXY{i,j}))));    
    meanXYPCACond(i,j)=nanmean(Data(Restrict(replayGtsd,and(Cond,EpochXY{i,j}))));  
    FiXYPCAHab(i,j)=length(find(Data(Restrict(replayGtsd,and(Hab,EpochXY{i,j})))>limPCscore))/...
        sum(DurationEpoch(and(Hab,EpochXY{i,j}),'s'));    
    FiXYPCACond(i,j)=length(find(Data(Restrict(replayGtsd,and(Cond,EpochXY{i,j})))>limPCscore))/...
        sum(DurationEpoch(and(Cond,EpochXY{i,j}),'s'));    
    OccHab(i,j)=sum(DurationEpoch(and(Hab,EpochXY{i,j}),'s'))/sum(DurationEpoch(Hab,'s'));    
    OccCond(i,j)=sum(DurationEpoch(and(Cond,EpochXY{i,j}),'s'))/sum(DurationEpoch(Cond,'s'));  
    end
end

subplot(2,4,4), imagesc(meanXYPCAHab'), axis xy, ca1=caxis;
subplot(2,4,8), imagesc(meanXYPCACond'), axis xy, ca2=caxis;
colormap(hot)
% subplot(2,4,4),caxis([0 min([ca1(2),ca2(2)])]), xlim([1.5 19.5]), ylim([1.5 19.5])
% subplot(2,4,8),caxis([0 min([ca1(2),ca2(2)])]), xlim([1.5 19.5]), ylim([1.5 19.5])

end