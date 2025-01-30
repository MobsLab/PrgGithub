%%
totdur=zeros(5,4);
mice={'M124','M123','M60','M82','M83'};
for k=1:5
    cd(mice{k})
    load StateEpochSBlite.mat
    dur=Stop(SWSEpoch)-Start(SWSEpoch);
    EpDur{1}(k,1:5)=[nanmean(dur),nanstd(dur),min(dur),max(dur),nanmedian(dur)];
        totdur(k,1)=totdur(k,1)+sum(dur)/1E4;
        totdur(k,2)=sum(dur)/1E4;

    dur=[dur;Stop(strSleep)-Start(strSleep);Stop(MicroSleep)-Start(MicroSleep)];
    EpDur{2}(k,1:5)=[nanmean(dur),nanstd(dur),min(dur),max(dur),nanmedian(dur)];
    
    dur=Stop(REMEpoch)-Start(REMEpoch);
    EpDur{3}(k,1:5)=[nanmean(dur),nanstd(dur),min(dur),max(dur),nanmedian(dur)];
            totdur(k,1)=totdur(k,1)+sum(dur)/1E4;
        totdur(k,3)=sum(dur)/1E4;

    dur=Stop(Wake)-Start(Wake);
    EpDur{4}(k,1:5)=[nanmean(dur),nanstd(dur),min(dur),max(dur),nanmedian(dur)];
            totdur(k,1)=totdur(k,1)+sum(dur)/1E4;
        totdur(k,4)=sum(dur)/1E4;

    dur=Stop(wakeper)-Start(wakeper);
    EpDur{5}(k,1:5)=[nanmean(dur),nanstd(dur),min(dur),max(dur),nanmedian(dur)];
    
    cd ..
end

h=bar([totdur(:,2)./totdur(:,1),totdur(:,3)./totdur(:,1),totdur(:,4)./totdur(:,1)],'stacked')
    set(h(1),'FaceColor',[0.4 0.5 1],'EdgeColor','k')
set(h(2),'FaceColor',[1 0.2 0.3],'EdgeColor','k')
    set(h(3),'FaceColor',[0.6 0.6 0.6],'EdgeColor','k')


figure
which=[5,3,4];
for i=1:3
    subplot(3,1,i)
    h=bar(1,mean(EpDur{1}(:,which(i))/1E4));
    hold on
    set(h,'FaceColor',[0.4 0.5 1],'EdgeColor',[0.4 0.5 1])
    errorbar(1,mean([EpDur{1}(:,which(i))]/1E4),std([EpDur{1}(:,which(i))]/1E4)/sqrt(5),'b')
    clear h
    g=bar(2,mean(EpDur{3}(:,which(i))/1E4));
    hold on
    set(g,'FaceColor',[1 0.2 0.3],'EdgeColor',[1 0.2 0.3])
    errorbar(2,mean([EpDur{3}(:,which(i))]/1E4),std([EpDur{3}(:,which(i))]/1E4)/sqrt(5),'r')
    clear g
    
    h=bar(3,mean(EpDur{4}(:,which(i))/1E4));
    hold on
    set(h,'FaceColor',[0.6 0.6 0.6],'EdgeColor',[0.6 0.6 0.6])
    errorbar(3,mean([EpDur{4}(:,which(i))]/1E4),std([EpDur{4}(:,which(i))]/1E4)/sqrt(5),'k')
    clear h
    xlim([0 4])
    if i<3
        set(gca,'XTick',[])
        box off
    else
        set(gca,'XTick',[1 2 3],'XTickLabel',{'SWS','REM','Wake'})
        box off
    end
end
