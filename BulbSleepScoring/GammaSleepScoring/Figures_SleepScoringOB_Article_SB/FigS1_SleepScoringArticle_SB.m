clear all
CheckCoherenceThresholds_InTime_DataSet
% params
smootime=3;
mindur=3;

% find most frequently used channel
for m = 1:mm
    for day = 1:length( FileName{m})
        cd(FileName{m}{day})
        clear gamma_thresh smooth_ghi Epoch chB sleepper
        load('StateEpochSB.mat','chB')
        ChannelCheck{m}(day) = chB;
    end
    BestChannel(m) = mode( ChannelCheck{m});
end

load('/media/DataMOBsRAIDN/ProjetSlSc/FiguresReview/SleepThresholdsInTime.mat')
load('/media/DataMOBsRAIDN/ProjetSlSc/FiguresReview/EvolutionInTime.mat')

figure
for m=1:mm
    
    BestChannel = mode(ChannelCheck{m});
    Rem=[];DayToDay=[];XRem=[];
    for day = 1:length( FileName{m})
        if ChannelCheck{m}(day)==BestChannel
            hold on
            Rem = [Rem;AllGammaHist{m}{day}(2,:)];
            XRem = [XRem;AllGammaHist{m}{day}(1,:)];
            DayToDay = [DayToDay,DayNum{m}(day)];
        end
    end


subplot(5,3,m)
cols = jet(sum(ChannelCheck{m}==BestChannel));
for k = 1 :sum(ChannelCheck{m}==BestChannel)
plot3(ones(1,500)*DayToDay(k),XRem(k,:),Rem(k,:)/sum(Rem(k,:)),'linewidth',3,'color',cols(k,:))
hold on
end
grid on
plot3(DayToDay,log(AllGammaThresh{m}(ChannelCheck{m}==BestChannel)),0.002*ones(1,sum(ChannelCheck{m}==BestChannel)),'*-k','linewidth',3)
view(100.1,36)
end



clf
for m=1:mm
    
    Rem=[];DayToDay=[];XRem=[];
    for day = 1:length( FileName{m})
            hold on
            Rem = [Rem;AllGammaHist{m}{day}(2,:)];
            XRem = [XRem;AllGammaHist{m}{day}(1,:)];
            DayToDay = [DayToDay,DayNum{m}(day)];
    end


subplot(5,3,m)
cols = jet(length(ChannelCheck{m}));
for k = 1 :length(ChannelCheck{m}==BestChannel)
plot3(ones(1,500)*DayToDay(k),XRem(k,:),Rem(k,:)/sum(Rem(k,:)),'linewidth',3,'color',cols(k,:))
hold on
end
grid on
plot3(DayToDay,log(AllGammaThresh{m}),0.002*ones(1,length(ChannelCheck{m}==BestChannel)),'*-k','linewidth',3)
view(100.1,36)
end

figure
m=7
clf
    Rem=[];DayToDay=[];XRem=[];
    for day = 1:length( FileName{m})
            hold on
            Rem = [Rem;AllGammaHist{m}{day}(2,:)];
            XRem = [XRem;AllGammaHist{m}{day}(1,:)];
            DayToDay = [DayToDay,DayNum{m}(day)];
    end
cols = jet(max(DayToDay)+1);
for k = 1 :length(ChannelCheck{m}==BestChannel)
plot(XRem(k,:),Rem(k,:)/sum(Rem(k,:)),'linewidth',3,'color',cols(DayToDay(k)+1,:))
hold on
end
scatter(log(AllGammaThresh{m}),[1:2:16]/1000+0.002,40,DayToDay,'filled')


figure
clear Kappa_Sleep_int
AllData=[];
for m=1:mm
    clear Kap_Sleep_temp
    for day = 1:length( FileName{m})
plot(DayDifference{m}{day},Overlap_Sleep{m}{day},'*'), hold on
AllData=[AllData,[DayDifference{m}{day};Overlap_Sleep{m}{day}]];
    end
end

clear MeanValKappa MeanStdKappa
for k=1:7
    MeanValKappa(k)=nanmean(AllData(2,AllData(1,:)==k));
    MeanStdKappa(k)=stdError(AllData(2,AllData(1,:)==k));
    PercGoodData(k)=nanmean(AllData(2,AllData(1,:)==k)>0.81);
end
for k=8:7:70
        MeanValKappa((k-8)/7+8)=nanmean(AllData(2,AllData(1,:)>k & AllData(1,:)<(k+7)));
        MeanStdKappa((k-8)/7+8)=stdError(AllData(2,AllData(1,:)>k & AllData(1,:)<(k+7)));
        PercGoodData((k-8)/7+8)=nanmean(AllData(2,AllData(1,:)>k & AllData(1,:)<(k+7))>0.81);
end

clf
errorbar(log([1:7,12:7:74]), MeanValKappa, MeanStdKappa,'linewidth',3,'color','k')
hold on 
box off
hold on,line(xlim,[0.81 0.81],'color','k')
hold on,line(xlim,[0.61 0.61],'color','k')
hold on,line(xlim,[0.41 0.41],'color','k')
xlabel('Time since first recording')
ylabel('% agreement of scoring')
ylim([0 1])

set(gca,'XTick',log([1:7,14,28,60]),...
    'XTickLabel',{'1','2','3','4','5','6','7','week2','month1','month2'})

figure
clear HistKappa
for k=1:7
    [Y,X] = hist(AllData(2,AllData(1,:)==k),[0:0.2:1]); Y = Y/sum(Y);
    HistKappa(k,:)=Y;
end
num = 8;
for k=8:7:70
        [Y,X] = hist(AllData(2,AllData(1,:)>k & AllData(1,:)<(k+7)),[0:0.2:1]); Y = Y/sum(Y);
        HistKappa(num,:)=Y;
        num=num+1;
end
clf
cols = summer(16)
for k = 1 :16
plot([0:0.2:1],HistKappa(k,:),'color',cols(k,:),'linewidth',2), hold on
end


