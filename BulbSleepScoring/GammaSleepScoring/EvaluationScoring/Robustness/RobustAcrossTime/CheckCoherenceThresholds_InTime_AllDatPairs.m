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

% Get all Gamma thresholds
for m = 1:mm
    for day = 1:length( FileName{m})
        cd(FileName{m}{day})
        clear gamma_thresh smooth_ghi Epoch chB sleepper
        load('StateEpochSB.mat','chB')
        if chB ==  BestChannel(m)|chB == BestChannel(m)+32|chB == BestChannel(m)-32
            load('StateEpochSB.mat','gamma_thresh','sleepper')
        else
            load('StateEpochSB_SameOBChannelForComp.mat','smooth_ghi','gamma_thresh','sleepper')
        end
        AllGammaThresh{m}(day)= gamma_thresh;
    end
end


for m=1:mm
    m
    for day = 1:length( FileName{m})
        cd(FileName{m}{day})
        clear gamma_thresh smooth_ghi Epoch chB sleepper
        load('StateEpochSB.mat','Epoch','chB','sleepper')
        
        if chB ==  BestChannel(m)|chB == BestChannel(m)+32|chB == BestChannel(m)-32
            load('StateEpochSB.mat','smooth_ghi','sleepper')
        else
            load('StateEpochSB_SameOBChannelForComp.mat','smooth_ghi','sleepper')
        end
        
        TotEpoch=intervalSet(0,max(Range(smooth_ghi)));
        
        [Y,X] = hist(log(Data(Restrict(smooth_ghi,Epoch))),500);
        AllGammaHist{m}{day}= [X;Y];
%         {m}(day) = chB;
        
        for testday = 1:length( FileName{m})
            
            % get sleep preiod with this days threshold
            sleepper_new=thresholdIntervals(smooth_ghi,(AllGammaThresh{m}(testday)),'Direction','Below');
            sleepper_new=mergeCloseIntervals(sleepper_new,mindur*1e4);
            sleepper_new=dropShortIntervals(sleepper_new,mindur*1e4);
            
            % overall agreement
            Agree(1)=length(Restrict(smooth_ghi,and(sleepper,sleepper_new)));
            Overall(1)=length(Restrict(smooth_ghi,sleepper_new));
            Agree(2)=length(Restrict(smooth_ghi,and(TotEpoch-sleepper,TotEpoch-sleepper_new)));
            Overall(2)=length(Restrict(smooth_ghi,TotEpoch-sleepper_new));
            po=sum(Agree)/sum(Overall);
            Overlap_Sleep{m}{day}(testday) = po;
            
            % chance agreement
            Agree(1)=length(Restrict(smooth_ghi,sleepper)).*length(Restrict(smooth_ghi,sleepper_new));
            Overall(1)=length(Restrict(smooth_ghi,sleepper_new));
            Agree(2)=length(Restrict(smooth_ghi,TotEpoch-sleepper)).*length(Restrict(smooth_ghi,TotEpoch-sleepper_new));
            Overall(2)=length(Restrict(smooth_ghi,TotEpoch-sleepper_new));
            pe=sum(Agree)/(sum(Overall).^2);
            
            % Kappa
            Kap_Sleep{m}{day}(testday)=(po-pe)/(1-pe);
            
            % get time differenc between days
            DayDifference{m}{day}(testday) = abs(daysact(DateRecording{m}{day},DateRecording{m}{testday}));
            
            
        end
        
    end
end


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

for k = 1 :length(ChannelCheck{m}==BestChannel)
Rem(k,:) = Rem(k,:)/sum(Rem(k,:));
end

figure
for m=1:mm
    
    for day = 1:length( FileName{m})
        Overlap_temp(day) = Overlap_Sleep{m}{day};
    end
    
    plot(DayNum{m}, Overlap_temp), hold on
    Overlap_int(m,:) = interp1(DayNum{m}, Overlap_temp,[0:80]);
    clear Overlap_temp
end


figure
clear Kappa_Sleep_int
for m=1:mm
    clear Kap_Sleep_temp
    Kappa_Sleep_int(m,:) = NaN(1,100);
    for day = 1:length( FileName{m})
        Kap_Sleep_temp(day) = Kap_Sleep{m,day};
        Kappa_Sleep_int(m,DayNum{m}(day)+1)=Kap_Sleep{m,day};
    end
    
    plot(DayNum{m}, Kap_Sleep_temp), hold on
end

clear Kappa_Sleep_int_grouped
Kappa_Sleep_int_grouped(1:5,:) = Kappa_Sleep_int(:,1:5)';
Kappa_Sleep_int_grouped(6:7,:) =nan(2,14);
for k = 1:5
Kappa_Sleep_int_grouped(7+k,:) =  nanmean(Kappa_Sleep_int(:,7*k+1:7*(k+1))')';
end



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


