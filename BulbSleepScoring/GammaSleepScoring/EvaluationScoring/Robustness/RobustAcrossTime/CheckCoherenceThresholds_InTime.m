CheckCoherenceThresholds_InTime_DataSet
% params
smootime=3;
mindur=3;


for m = 1:mm
    for day = 1:length( FileName{m})
        cd(FileName{m}{day})
        clear gamma_thresh smooth_ghi Epoch chB sleepper
        load('StateEpochSB.mat','chB')
        ChannelCheck{m}(day) = chB;
    end
    BestChannel(m) = mode( ChannelCheck{m});
end

for m =1:mm
    m
    for day = 1:length( FileName{m})
        cd(FileName{m}{day})
        clear gamma_thresh smooth_ghi Epoch chB sleepper
        load('StateEpochSB.mat','Epoch','chB','sleepper')
        
        if chB ==  BestChannel(m)|chB == BestChannel(m)+32|chB == BestChannel(m)-32
            load('StateEpochSB.mat','smooth_ghi','gamma_thresh','sleepper')
            
        else
            
            load('StateEpochSB_SameOBChannelForComp.mat','smooth_ghi','gamma_thresh','sleepper')
            
        end
        
        TotEpoch=intervalSet(0,max(Range(smooth_ghi)));
        
        AllGammaThresh{m}(day)= gamma_thresh;
        [Y,X] = hist(log(Data(Restrict(smooth_ghi,Epoch))),500);
        AllGammaHist{m}{day}= [X;Y];
        ChannelCheck{m}(day) = chB;
        
        Overlap_Sleep{m,day}=1;
        Kap_Sleep{m,day}=1;
        if day>1
            
            % get sleep with original threshold
            sleepper_new=thresholdIntervals(smooth_ghi,(AllGammaThresh{m}(1)),'Direction','Below');
            sleepper_new=mergeCloseIntervals(sleepper_new,mindur*1e4);
            sleepper_new=dropShortIntervals(sleepper_new,mindur*1e4);
            
            
            Agree(1)=length(Restrict(smooth_ghi,and(sleepper,sleepper_new)));
            Overall(1)=length(Restrict(smooth_ghi,sleepper_new));
            % observed agreement between observers
            Agree(2)=length(Restrict(smooth_ghi,and(TotEpoch-sleepper,TotEpoch-sleepper_new)));
            Overall(2)=length(Restrict(smooth_ghi,TotEpoch-sleepper_new));
            po=sum(Agree)/sum(Overall);
            
            % chance agreement
            Agree(1)=length(Restrict(smooth_ghi,sleepper)).*length(Restrict(smooth_ghi,sleepper_new));
            Overall(1)=length(Restrict(smooth_ghi,sleepper_new));
            Agree(2)=length(Restrict(smooth_ghi,TotEpoch-sleepper)).*length(Restrict(smooth_ghi,TotEpoch-sleepper_new));
            Overall(2)=length(Restrict(smooth_ghi,TotEpoch-sleepper_new));
            pe=sum(Agree)/(sum(Overall).^2);
            
            % Kappa
            Kap_Sleep{m,day}=(po-pe)/(1-pe);
            
            % Overall overlap
            TotAgreement = length(Restrict(smooth_ghi,and(sleepper,sleepper_new)))+length(Restrict(smooth_ghi,and(TotEpoch-sleepper,TotEpoch-sleepper_new)));
            Total = length(Restrict(smooth_ghi,TotEpoch));
            
            Overlap_Sleep{m,day} = TotAgreement ./ Total;
            
        end
    end
end

cd /media/DataMOBsRAIDN/ProjetSlSc/FiguresReview
save('SleepThresholdsInTime.mat','Overlap_Sleep','Kap_Sleep','AllGammaHist','ChannelCheck','AllGammaThresh')


clf
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
cols = jet(length(AllGammaHist{m}));
for k = 1 :length(AllGammaHist{m})
plot3(ones(1,500)*DayToDay(k),XRem(k,:),Rem(k,:)/sum(Rem(k,:)),'linewidth',3,'color',cols(k,:))
hold on
end
grid on
plot3(DayToDay,log(AllGammaThresh{m}),0.002*ones(1,length(AllGammaHist{m})),'*-k','linewidth',3)
view(100.1,36)
end


figure
for m=1:mm
    
    for day = 1:length( FileName{m})
        
        Overlap_temp(day) = Kappa_Sleep_int(m,day)
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



