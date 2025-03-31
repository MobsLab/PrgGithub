function [MM,D]=QuantifSwsRemWakeAfterSounds



clear tone1
clear tone2
clear detectD
clear detectNoD

load StateEpochSB SWSEpoch Wake REMEpoch
load DeltaSleepEvent
a=1;
for i=1:length(TONEtime1)
id=find(TONEtime2>TONEtime1(i));
if TONEtime2(id(1))-TONEtime1(i)<0.2E4
tone2(a)=TONEtime2(id(1));
tone1(a)=TONEtime1(i);
a=a+1;
end
end
tone1=tone1';
tone2=tone2';

a=1;b=1;
for i=1:length(DeltaDetect)
    id=find(tone1>DeltaDetect(i));
    if tone1(id)-DeltaDetect(i)<0.1E4
    detectD(a)=DeltaDetect(i);
    a=a+1;
    end
    
    if tone1(id)-DeltaDetect(i)>0.6E4
    detectNoD(b)=DeltaDetect(i);
    b=b+1;
    end
    
end


% LongTones=FindLongPeriodsEvents(tone1,60);
LongTones=FindLongPeriodsEvents(tone1,100);



SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch);
[SleepStagesC3, SWSEpochC3, REMEpochC3, WakeC3, Noise, TotalNoiseEpoch]=CleanSleepStages;


NoSleepEpoch=or(TotalNoiseEpoch,WakeC3);
NoSleepEpoch=mergeCloseIntervals(NoSleepEpoch,100E4);
rg=Range(SleepStagesC3);
TotalEpoch=intervalSet(rg(1),rg(end));
LongSWS1=TotalEpoch-NoSleepEpoch;

LongSWS2=FindLongPeriodsEpoch(SWSEpoch,[100 300]);
LongSWS=or(LongSWS1,LongSWS2);

hold on, line([Start(LongTones,'s') End(LongTones,'s')],[0 0],'color','g','linewidth',2)
hold on, line([Start(LongSWS,'s') End(LongSWS,'s')],[0.5 0.5],'color','c','linewidth',2)




% SWSEpochC3=SWSEpoch;
% REMEpochC3=REMEpoch;
% WakeC3=Wake;


MM(1,1)=sum(End(and(WakeC3,LongSWS),'s')-Start(and(WakeC3,LongSWS),'s'))/sum(End(LongSWS,'s')-Start(LongSWS,'s'))*100;
MM(1,2)=sum(End(and(WakeC3,and(LongSWS,LongTones)),'s')-Start(and(WakeC3,and(LongSWS,LongTones)),'s'))/sum(End(and(LongSWS,LongTones),'s')-Start(and(LongSWS,LongTones),'s'))*100;
MM(1,3)=sum(End(and(WakeC3,(LongSWS-LongTones)),'s')-Start(and(WakeC3,(LongSWS-LongTones)),'s'))/sum(End((LongSWS-LongTones),'s')-Start((LongSWS-LongTones),'s'))*100;
MM(2,1)=sum(End(and(SWSEpochC3,LongSWS),'s')-Start(and(SWSEpochC3,LongSWS),'s'))/sum(End(LongSWS,'s')-Start(LongSWS,'s'))*100;
MM(2,2)=sum(End(and(SWSEpochC3,and(LongSWS,LongTones)),'s')-Start(and(SWSEpochC3,and(LongSWS,LongTones)),'s'))/sum(End(and(LongSWS,LongTones),'s')-Start(and(LongSWS,LongTones),'s'))*100;
MM(2,3)=sum(End(and(SWSEpochC3,(LongSWS-LongTones)),'s')-Start(and(SWSEpochC3,(LongSWS-LongTones)),'s'))/sum(End((LongSWS-LongTones),'s')-Start((LongSWS-LongTones),'s'))*100;
MM(3,1)=sum(End(and(REMEpochC3,LongSWS),'s')-Start(and(REMEpochC3,LongSWS),'s'))/sum(End(LongSWS,'s')-Start(LongSWS,'s'))*100;
MM(3,2)=sum(End(and(REMEpochC3,and(LongSWS,LongTones)),'s')-Start(and(REMEpochC3,and(LongSWS,LongTones)),'s'))/sum(End(and(LongSWS,LongTones),'s')-Start(and(LongSWS,LongTones),'s'))*100;
MM(3,3)=sum(End(and(REMEpochC3,(LongSWS-LongTones)),'s')-Start(and(REMEpochC3,(LongSWS-LongTones)),'s'))/sum(End((LongSWS-LongTones),'s')-Start((LongSWS-LongTones),'s'))*100;
floor(MM*100)/100

load newDeltaPFCx
Dpfc=ts(tDelta);
load newDeltaPaCx
Dpac=ts(tDelta);
D(1,1)=length(Range(Restrict(Dpfc,LongSWS)))/sum(End(LongSWS,'s')-Start(LongSWS,'s'));
D(1,2)=length(Range(Restrict(Dpfc,and(LongSWS,LongTones))))/sum(End(and(LongSWS,LongTones),'s')-Start(and(LongSWS,LongTones),'s'));
D(1,3)=length(Range(Restrict(Dpfc,LongSWS-LongTones)))/sum(End((LongSWS-LongTones),'s')-Start((LongSWS-LongTones),'s'));
D(2,1)=length(Range(Restrict(Dpac,LongSWS)))/sum(End(LongSWS,'s')-Start(LongSWS,'s'));
D(2,2)=length(Range(Restrict(Dpac,and(LongSWS,LongTones))))/sum(End(and(LongSWS,LongTones),'s')-Start(and(LongSWS,LongTones),'s'));
D(2,3)=length(Range(Restrict(Dpac,LongSWS-LongTones)))/sum(End((LongSWS-LongTones),'s')-Start((LongSWS-LongTones),'s'));
floor(D*1000)/1000

%------------------------------------------------------------------------
%------------------------------------------------------------------------

if 0

        load SpikeData
        load StateEpochSB SWSEpoch REMEpoch Wake


        load ChannelsToAnalyse/PFCx_deep
            eval(['load LFPData/LFP',num2str(channel)])
            LFPd=LFP;
            clear LFP

           load ChannelsToAnalyse/PFCx_sup
            eval(['load LFPData/LFP',num2str(channel)])
            LFPs=LFP;
            clear LFP

        [Spfc,NumNeurons]=GetSpikesFromStructure('PFCx');
        [Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons,SWSEpoch,10,0.01,1,1,[0 70],1);close

        [M3,T3]=PlotRipRaw(Qt,DeltaDetect/1E4,1800);close
        [M2,T2]=PlotRipRaw(Qt,tone2/1E4,1800);close

        [M,T]=PlotRipRaw(Qt,tone1/1E4,1800);close
        [Mb,Tb]=PlotRipRaw(LFPd,tone1/1E4,1800);close
        [Mc,Tc]=PlotRipRaw(tsd(Range(LFPd),Data(LFPd)-Data(LFPs)),tone1/1E4,1800);close

        figure('color',[1 1 1]), 
        plot(M(:,1),smooth(M(:,2),3))
        %hold on, plot(M2(:,1),smooth(M2(:,2),3),'r')
        hold on, plot(M3(:,1),smooth(M3(:,2),3),'k')



        for i=1:length(tone1)
            temp=Start(Down)-tone1(i); del(i)=min(temp(temp>0));
            temp2=tone1(i)-End(Down); try del2(i)=min(temp2(temp2>0)); catch del2(i)=5E4; end
            temp3=tone1(i)-Start(Down); try del3(i)=min(temp3(temp3>0)); catch del3(i)=5E4; end
        end
        [BE,id]=sort(del);
        [BE,id3]=sort(del3);
        [BE,id2]=sort(del2);
        [BE,id4]=sort(mean(T(:,205:210),2));

        smo=[2 2];
        figure('color',[1 1 1]), 
        subplot(4,3,1), imagesc(Mb(:,1),1:length(tone1),SmoothDec(Tb(id,:),smo)),caxis([-2000 2000]),xlim([-0.5 0.5])
        subplot(4,3,4), imagesc(Mb(:,1),1:length(tone1),SmoothDec(Tb(id2,:),smo)),caxis([-2000 2000]),xlim([-0.5 0.5])
        subplot(4,3,7), imagesc(Mb(:,1),1:length(tone1),SmoothDec(Tb(id3,:),smo)),caxis([-2000 2000]),xlim([-0.5 0.5])
        subplot(4,3,10), imagesc(Mb(:,1),1:length(tone1),SmoothDec(Tb(id4,:),smo)),caxis([-2000 2000]),xlim([-0.5 0.5])

        subplot(4,3,2), imagesc(Mc(:,1),1:length(tone1),SmoothDec(Tc(id,:),smo)),xlim([-0.5 0.5])
        subplot(4,3,5), imagesc(Mc(:,1),1:length(tone1),SmoothDec(Tc(id2,:),smo)),xlim([-0.5 0.5])
        subplot(4,3,8), imagesc(Mc(:,1),1:length(tone1),SmoothDec(Tc(id3,:),smo)),xlim([-0.5 0.5])
        subplot(4,3,11), imagesc(Mc(:,1),1:length(tone1),SmoothDec(Tc(id4,:),smo)),xlim([-0.5 0.5])

        subplot(4,3,3), imagesc(M(:,1),1:length(tone1),SmoothDec(T(id,:),smo)),xlim([-0.5 0.5])
        subplot(4,3,6), imagesc(M(:,1),1:length(tone1),SmoothDec(T(id2,:),smo)),xlim([-0.5 0.5])
        subplot(4,3,9), imagesc(M(:,1),1:length(tone1),SmoothDec(T(id3,:),smo)),xlim([-0.5 0.5])
        subplot(4,3,12), imagesc(M(:,1),1:length(tone1),SmoothDec(T(id4,:),smo)),xlim([-0.5 0.5])



        figure('color',[1 1 1]), 
        subplot(4,1,1), imagesc(M(:,1),1:length(tone1),T(id,:))
        subplot(4,1,2), imagesc(M(:,1),1:length(tone1),T(id2,:))
        subplot(4,1,3), imagesc(M(:,1),1:length(tone1),T(id3,:))
        subplot(4,1,4), imagesc(M(:,1),1:length(tone1),T(id4,:))

        [r,p]=corrcoef(T(id4,:));

        figure('color',[1 1 1]), 
        subplot(2,1,1), imagesc(M(:,1),1:length(tone1),T(id4,:)), xlim([-0.2 0.5])
        subplot(2,1,2), imagesc(M(:,1),M(:,1),r)
        ylim([-0.2 0.5])
        xlim([-0.2 0.5])

        figure, plot(M(:,1),mean(T(id4(1:800),:)))
        hold on, plot(M(:,1),mean(T(id4(800:1600),:)),'r')


        % 
        % [r,p]=corrcoef(T(id4,1:180)');
        % [r,p]=corrcoef(T(id4,250:360)');
        % figure('color',[1 1 1]), 
        % subplot(1,2,1), imagesc(M(:,1),1:length(tone1),T(id4,:))
        % subplot(1,2,2), imagesc(M(:,1),M(:,1),SmoothDec(r,[2,2]))
        % subplot(1,2,2), imagesc(M(:,1),M(:,1),r)


end
