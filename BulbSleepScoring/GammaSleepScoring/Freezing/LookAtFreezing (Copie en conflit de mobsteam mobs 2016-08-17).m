% Look at Freezing-related activity
m=1;
Filename{m,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150506-EXT-24h-envC/';
Filename{m,2}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150429/Breath-Mouse-243-29042015/';
m=m+1;
Filename{m,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150506-EXT-24h-envC/';
Filename{m,2}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150430/Breath-Mouse-244-30042015/';
m=m+1;
Filename{m,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015/';
Filename{m,2}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150630-SLEEPbasal/';
m=m+1;
Filename{m,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150703-EXT-24h-envC/FEAR-Mouse-254-03072015/';
Filename{m,2}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150630-SLEEPbasal/';
m=m+1;
Filename{m,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC/';
figure
timeaxis=[-5:median(diff(Range(smooth_ghi,'s'))):5];
for mm=2:m
    
%    cd(Filename{mm,2}) 
%    load('StateEpochSB.mat','gamma_thresh')
   cd(Filename{mm,1})
   load('ChannelsToAnalyse/Bulb_deep.mat','channel')
   load(['LFPData/LFP',num2str(channel),'.mat'])
   FilGamma=FilterLFP(LFP,[50 70],1024);
   HilGamma=hilbert(Data(FilGamma));
   H=abs(HilGamma);
   tot_ghi=Restrict(tsd(Range(LFP),H),Epoch);
   smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
    load('behavResources.mat','FreezeEpoch')
    if mm==4
        subplot(2,4,[1:3])
        plot(Range(smooth_ghi,'s'),Data(smooth_ghi),'b')
        hold on
        for k=1:length(Start(FreezeEpoch))
            plot(Range(Restrict(smooth_ghi,subset(FreezeEpoch,k)),'s'),Data(Restrict(smooth_ghi,subset(FreezeEpoch,k)))*0+200,'c','linewidth',5)
        end
        xlim([0 1300])
        subplot(2,4,[5:7])
        plot(Range(Movtsd,'s'),Data(Movtsd),'b')
        hold on
        for k=1:length(Start(FreezeEpoch))
            plot(Range(Restrict(smooth_ghi,subset(FreezeEpoch,k)),'s'),Data(Restrict(smooth_ghi,subset(FreezeEpoch,k)))*0+35,'c','linewidth',5)
        end
        xlim([0 1300])
    end
   subplot(234)
   hist(Data(smooth_ghi),500), hold on
%    line([gamma_thresh gamma_thresh],[0 max(get(gca,'Ylim'))],'linewidth',3)
   sleepper=thresholdIntervals(smooth_ghi,gamma_thresh,'Direction','Below');
sleepper=mergeCloseIntervals(sleepper,mindur*1e4);
sleepper=dropShortIntervals(sleepper,mindur*1e4);
title(num2str(100*length(Data(Restrict(Movtsd,sleepper)))/length(Data((Movtsd)))))
   subplot(2,4,[4,8])
   Out=TSDTransitions(smooth_ghi,FreezeEpoch,12500/2); %MicroWake(gammawake)
   temp(mm,:)=nanmean(zscore(Out')');
   %g=shadedErrorBar(timeaxis,nanmean(Out/nanmean(nanmean(Out))),[stdError(Out/nanmean(nanmean(Out)));stdError(Out/nanmean(nanmean(Out)))],'k') ,hold on
%    plot(timeaxis,mean(Out)+std(Out))
%    hold on
%    plot(timeaxis,mean(Out))
%    plot(timeaxis,mean(Out)-std(Out))
%    line([0 0],[min(get(gca,'Ylim')) max(get(gca,'Ylim'))],'linewidth',3)
%    Pos=Pos(not(isnan(Pos(:,2))),:);
%    Ghi_new=tsd(Range(Restrict(smooth_ghi,ts(Pos(:,1)*1e4))),Data(Restrict(smooth_ghi,ts(Pos(:,1)*1e4))))
%    [R,P]=corrcoef(Data(Ghi_new),[0 ;sqrt(diff(Pos(:,2)).^2+diff(Pos(:,3)).^2)])
%    a=Data(Ghi_new);
%    b=[0 ;sqrt(diff(Pos(:,2)).^2+diff(Pos(:,3)).^2)];
%      subplot(236)
%  plot(a(1:10:end),b(1:10:end),'.','MarkerSize',5)
%    set(gca,'YScale','log','XScale','log')
%    title(num2str(P(1,2)))
%    r=Range(smooth_ghi);
%    TotalEpoch=intervalSet(0*1e4,r(end));
%    Fr(mm,1)=nanmean(Data(Restrict(smooth_ghi,FreezeEpoch)));
%    Fr(mm,2)=nanmean(Data(Restrict(smooth_ghi,TotalEpoch-FreezeEpoch)));
%    pause
%    clf
end
