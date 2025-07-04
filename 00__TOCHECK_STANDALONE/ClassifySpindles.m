%ClassifySpindles

%SpiTot, SpiHigh, SpiLow, SpiULow, tDeltaT2, tDeltaP2

SpiHighLow=[];
SpiHighTot=[];
SpiHighULow=[];
SpiHighAlone=[];
SpiLowHigh=[];
SpiLowTot=[];
SpiLowULow=[];
SpiLowAlone=[];
SpiULowHigh=[];
SpiULowLow=[];
SpiULowTot=[];
SpiHighDelta=[];
SpiLowDelta=[];
SpiULowDelta=[];
SpiTotHigh=[];
SpiTotLow=[];
SpiTotULow=[];
SpiTotDelta=[];
SpiTotAlone=[];
timegap=0.5;

for i=1:length(SpiHigh)
    [val,ind]=min(abs(SpiHigh(i,2)-SpiLow(:,2)));
    if val<timegap
        SpiHighLow=[SpiHighLow; SpiHigh(i,:)];
    end
    [val2,ind]=min(abs(SpiHigh(i,2)-SpiTot(:,2)));
    if val2<timegap
        SpiHighTot=[SpiHighTot ;SpiHigh(i,:)];
    end
    [val3,ind]=min(abs(SpiHigh(i,2)-SpiULow(:,2)));
    if val3<timegap
        SpiHighULow=[SpiHighULow; SpiHigh(i,:)];
    end
    if val>timegap & val2>timegap  & val3>timegap
        SpiHighAlone=[SpiHighAlone; SpiHigh(i,:)];
    end
     [val4,ind]=min(abs(SpiHigh(i,2)-Range(tDeltaT2)/1e4));
     if val4<timegap
        SpiHighDelta=[SpiHighDelta ;SpiHigh(i,:)];
    end
end
    
for i=1:length(SpiLow)
    [val,ind]=min(abs(SpiLow(i,2)-SpiHigh(:,2)));
      if val<timegap
        SpiLowHigh=[SpiLowHigh ;SpiLow(i,:)];
    end
    [val2,ind]=min(abs(SpiLow(i,1)-SpiTot(:,2)));
    if val2<timegap
        SpiLowTot=[SpiLowTot ;SpiLow(i,:)];
    end
    [val3,ind]=min(abs(SpiLow(i,2)-SpiULow(:,2)));
    if val3<timegap
        SpiLowULow=[SpiLowULow; SpiLow(i,:)];
    end
    if val>timegap & val2>timegap & val3>timegap
        SpiLowAlone=[SpiLowAlone; SpiLow(i,:)];
    end
     [val4,ind]=min(abs(SpiLow(i,2)-Range(tDeltaT2)/1e4));
     if val4<timegap
        SpiLowDelta=[SpiLowDelta ;SpiLow(i,:)];
    end
end

    
for i=1:length(SpiULow)
    [val,ind]=min(abs(SpiULow(i,2)-SpiHigh(:,2)));
    if val<timegap
        SpiULowHigh=[SpiULowHigh ;SpiULow(i,:)];
    end
    [val2,ind]=min(abs(SpiULow(i,1)-SpiTot(:,2)));
    if val2<timegap
        SpiULowTot=[SpiULowTot ;SpiULow(i,:)];
    end
    [val3,ind]=min(abs(SpiULow(i,2)-SpiLow(:,2)));
    if val3<timegap
        SpiULowLow=[SpiULowLow ;SpiULow(i,:)];
    end
    if val>timegap & val2>timegap & val3>timegap
        SpiULowAlone=[SpiLowAlone; SpiULow(i,:)];
    end
     [val4,ind]=min(abs(SpiULow(i,2)-Range(tDeltaT2)/1e4));
     if val4<timegap
        SpiULowDelta=[SpiULowDelta ;SpiULow(i,:)];
    end
end

for i=1:length(SpiTot)
        [val,ind]=min(abs(SpiTot(i,2)-SpiHigh(:,2)));
         if val>timegap
        SpiTotHigh=[SpiTotHigh ;SpiTot(i,:)];
    end
    [val2,ind]=min(abs(SpiTot(i,1)-SpiULow(:,2)));
    if val2>timegap
        SpiTotULow=[SpiTotULow ;SpiTot(i,:)];
    end
       [val3,ind]=min(abs(SpiTot(i,2)-SpiLow(:,2)));
       if val3>timegap
        SpiTotLow=[SpiTotLow ;SpiTot(i,:)];
    end
    if val>timegap & val2>timegap & val3>timegap
        SpiTotAlone=[SpiTotAlone ;SpiTot(i,:)];
    end
     [val4,ind]=min(abs(SpiTot(i,2)-Range(tDeltaT2)/1e4));
     if val4<timegap
        SpiTotDelta=[SpiTotDelta ;SpiTot(i,:)];
    end
end

binsizedel=200;
nbinsdel=100;
[C1,B1]=CrossCorr(SpiHigh(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
[C,B]=CrossCorr(SpiHighLow(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
figure, subplot(2,2,1),plot(B/1E3,C,'b','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('HighLow')
[C,B]=CrossCorr(SpiHighTot(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,2),plot(B/1E3,C,'r','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('HighTot')
[C,B]=CrossCorr(SpiHighULow(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,3),plot(B/1E3,C,'m','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('HighULow')
[C,B]=CrossCorr(SpiHighAlone(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,4),plot(B/1E3,C,'c','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('HighAlone')
% legend('AllHigh','HighLow','HighTot','HighULow','HighAlone')


[C1,B1]=CrossCorr(SpiLow(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
figure
[C,B]=CrossCorr(SpiLowHigh(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,1),plot(B/1E3,C,'b','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('HighLow')
[C,B]=CrossCorr(SpiLowTot(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,2),plot(B/1E3,C,'r','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('LowTot')
[C,B]=CrossCorr(SpiLowULow(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,3),plot(B/1E3,C,'m','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('LowULow')
[C,B]=CrossCorr(SpiLowAlone(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,4),plot(B/1E3,C,'c','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('LowAlone')
% title('LowAlone')legend('AllLow','HighLow','LowTot','LowULow','LowAlone')

[C1,B1]=CrossCorr(SpiULow(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
figure
[C,B]=CrossCorr(SpiULowHigh(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,1),plot(B/1E3,C,'b','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('HighULow')
[C,B]=CrossCorr(SpiULowTot(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,2),plot(B/1E3,C,'r','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('ULowTot')
[C,B]=CrossCorr(SpiULowLow(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,3),plot(B/1E3,C,'m','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('LowULow')
[C,B]=CrossCorr(SpiULowAlone(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,4),plot(B/1E3,C,'c','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('ULowalone')

[C1,B1]=CrossCorr(SpiTot(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
figure
[C,B]=CrossCorr(SpiTotHigh(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,1),plot(B/1E3,C,'b','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('TotHigh')
[C,B]=CrossCorr(SpiTotLow(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,2),plot(B/1E3,C,'r','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('TotLow')
[C,B]=CrossCorr(SpiTotULow(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,3),plot(B/1E3,C,'m','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('TotULow')
[C,B]=CrossCorr(SpiTotAlone(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,4),plot(B/1E3,C,'c','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('Totalone')

% %Ripple
% binsizerip=50;
% nbinsizerip=40;
% spicol=1;
% 
% [C1,B1]=CrossCorr(SpiHigh(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% [C,B]=CrossCorr(SpiHighLow(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% figure, subplot(2,2,1),plot(B/1E3,C,'b','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('HighLow')
% [C,B]=CrossCorr(SpiHighTot(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,2),plot(B/1E3,C,'r','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('HighTot')
% [C,B]=CrossCorr(SpiHighULow(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,3),plot(B/1E3,C,'m','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('HighULow')
% [C,B]=CrossCorr(SpiHighAlone(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,4),plot(B/1E3,C,'c','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('HighAlone')
% % legend('AllHigh','HighLow','HighTot','HighULow','HighAlone')
% 
% 
% [C1,B1]=CrossCorr(SpiLow(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% figure
% [C,B]=CrossCorr(SpiLowHigh(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,1),plot(B/1E3,C,'b','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('HighLow')
% [C,B]=CrossCorr(SpiLowTot(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,2),plot(B/1E3,C,'r','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('LowTot')
% [C,B]=CrossCorr(SpiLowULow(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,3),plot(B/1E3,C,'m','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('LowULow')
% [C,B]=CrossCorr(SpiLowAlone(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,4),plot(B/1E3,C,'c','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% % title('LowAlone')legend('AllLow','HighLow','LowTot','LowULow','LowAlone')
% 
% [C1,B1]=CrossCorr(SpiULow(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% figure
% [C,B]=CrossCorr(SpiULowHigh(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,1),plot(B/1E3,C,'b','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('HighULow')
% [C,B]=CrossCorr(SpiULowTot(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,2),plot(B/1E3,C,'r','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('ULowTot')
% [C,B]=CrossCorr(SpiULowLow(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,3),plot(B/1E3,C,'m','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('LowULow')
% [C,B]=CrossCorr(SpiULowAlone(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,4),plot(B/1E3,C,'c','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('ULowalone')
% 
% [C1,B1]=CrossCorr(SpiTot(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% figure
% [C,B]=CrossCorr(SpiTotHigh(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,1),plot(B/1E3,C,'b','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('TotHigh')
% [C,B]=CrossCorr(SpiTotLow(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,2),plot(B/1E3,C,'r','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('TotLow')
% [C,B]=CrossCorr(SpiTotULow(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,3),plot(B/1E3,C,'m','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('TotULow')
% [C,B]=CrossCorr(SpiTotAlone(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,4),plot(B/1E3,C,'c','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('Totalone')
% 
% figure
% [C1,B1]=CrossCorr(SpiTot(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% [C,B]=CrossCorr(SpiTotDelta(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,1),plot(B/1E3,C,'b','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('TotDelta')
% [C1,B1]=CrossCorr(SpiHigh(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% [C,B]=CrossCorr(SpiHighDelta(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,2),plot(B/1E3,C,'r','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('HighDelta')
% [C1,B1]=CrossCorr(SpiLow(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% [C,B]=CrossCorr(SpiLowDelta(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,3),plot(B/1E3,C,'m','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('LowDelta')
% [C1,B1]=CrossCorr(SpiULow(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% [C,B]=CrossCorr(SpiULowDelta(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,4),plot(B/1E3,C,'c','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('ULowDelta')
% 
% %Ripple
% binsizerip=50;
% nbinsizerip=40;
% spicol=2;
% 
% [C1,B1]=CrossCorr(SpiHigh(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% [C,B]=CrossCorr(SpiHighLow(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% figure, subplot(2,2,1),plot(B/1E3,C,'b','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('HighLow')
% [C,B]=CrossCorr(SpiHighTot(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,2),plot(B/1E3,C,'r','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('HighTot')
% [C,B]=CrossCorr(SpiHighULow(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,3),plot(B/1E3,C,'m','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('HighULow')
% [C,B]=CrossCorr(SpiHighAlone(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,4),plot(B/1E3,C,'c','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('HighAlone')
% % legend('AllHigh','HighLow','HighTot','HighULow','HighAlone')
% 
% 
% [C1,B1]=CrossCorr(SpiLow(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% figure
% [C,B]=CrossCorr(SpiLowHigh(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,1),plot(B/1E3,C,'b','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('HighLow')
% [C,B]=CrossCorr(SpiLowTot(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,2),plot(B/1E3,C,'r','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('LowTot')
% [C,B]=CrossCorr(SpiLowULow(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,3),plot(B/1E3,C,'m','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('LowULow')
% [C,B]=CrossCorr(SpiLowAlone(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,4),plot(B/1E3,C,'c','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% % title('LowAlone')legend('AllLow','HighLow','LowTot','LowULow','LowAlone')
% 
% [C1,B1]=CrossCorr(SpiULow(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% figure
% [C,B]=CrossCorr(SpiULowHigh(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,1),plot(B/1E3,C,'b','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('HighULow')
% [C,B]=CrossCorr(SpiULowTot(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,2),plot(B/1E3,C,'r','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('ULowTot')
% [C,B]=CrossCorr(SpiULowLow(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,3),plot(B/1E3,C,'m','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('LowULow')
% [C,B]=CrossCorr(SpiULowAlone(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,4),plot(B/1E3,C,'c','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('ULowalone')
% 
% [C1,B1]=CrossCorr(SpiTot(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% figure
% [C,B]=CrossCorr(SpiTotHigh(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,1),plot(B/1E3,C,'b','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('TotHigh')
% [C,B]=CrossCorr(SpiTotLow(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,2),plot(B/1E3,C,'r','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('TotLow')
% [C,B]=CrossCorr(SpiTotULow(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,3),plot(B/1E3,C,'m','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('TotULow')
% [C,B]=CrossCorr(SpiTotAlone(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,4),plot(B/1E3,C,'c','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('Totalone')
% 
% figure
% [C1,B1]=CrossCorr(SpiTot(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% [C,B]=CrossCorr(SpiTotDelta(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,1),plot(B/1E3,C,'b','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('TotDelta')
% [C1,B1]=CrossCorr(SpiHigh(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% [C,B]=CrossCorr(SpiHighDelta(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,2),plot(B/1E3,C,'r','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('HighDelta')
% [C1,B1]=CrossCorr(SpiLow(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% [C,B]=CrossCorr(SpiLowDelta(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,3),plot(B/1E3,C,'m','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('LowDelta')
% [C1,B1]=CrossCorr(SpiULow(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% [C,B]=CrossCorr(SpiULowDelta(:,spicol)*1e4,Rip(:,1)*1e4,binsizerip,nbinsizerip);
% subplot(2,2,4),plot(B/1E3,C,'c','linewidth',2)
% hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
% title('ULowDelta')
% 

binsizedel=200;
nbinsdel=50;
[C1,B1]=CrossCorr(SpiHigh(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
[C,B]=CrossCorr(SpiHighLow(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
figure, subplot(2,2,1),plot(B/1E3,C,'b','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('HighLow')
[C,B]=CrossCorr(SpiHighTot(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,2),plot(B/1E3,C,'r','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('HighTot')
[C,B]=CrossCorr(SpiHighULow(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,3),plot(B/1E3,C,'m','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('HighULow')
[C,B]=CrossCorr(SpiHighAlone(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,4),plot(B/1E3,C,'c','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('HighAlone')
% legend('AllHigh','HighLow','HighTot','HighULow','HighAlone')


[C1,B1]=CrossCorr(SpiLow(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
figure
[C,B]=CrossCorr(SpiLowHigh(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,1),plot(B/1E3,C,'b','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('HighLow')
[C,B]=CrossCorr(SpiLowTot(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,2),plot(B/1E3,C,'r','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('LowTot')
[C,B]=CrossCorr(SpiLowULow(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,3),plot(B/1E3,C,'m','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('LowULow')
[C,B]=CrossCorr(SpiLowAlone(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,4),plot(B/1E3,C,'c','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('LowAlone')
% title('LowAlone')legend('AllLow','HighLow','LowTot','LowULow','LowAlone')

[C1,B1]=CrossCorr(SpiULow(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
figure
[C,B]=CrossCorr(SpiULowHigh(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,1),plot(B/1E3,C,'b','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('HighULow')
[C,B]=CrossCorr(SpiULowTot(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,2),plot(B/1E3,C,'r','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('ULowTot')
[C,B]=CrossCorr(SpiULowLow(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,3),plot(B/1E3,C,'m','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('LowULow')
[C,B]=CrossCorr(SpiULowAlone(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,4),plot(B/1E3,C,'c','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('ULowalone')

[C1,B1]=CrossCorr(SpiTot(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
figure
[C,B]=CrossCorr(SpiTotHigh(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,1),plot(B/1E3,C,'b','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('TotHigh')
[C,B]=CrossCorr(SpiTotLow(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,2),plot(B/1E3,C,'r','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('TotLow')
[C,B]=CrossCorr(SpiTotULow(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,3),plot(B/1E3,C,'m','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('TotULow')
[C,B]=CrossCorr(SpiTotAlone(:,2)*1e4,Range(tDeltaT2),binsizedel,nbinsdel);
subplot(2,2,4),plot(B/1E3,C,'c','linewidth',2)
hold on, plot(B1/1E3,C1,'--','color','k','linewidth',2)
title('Totalone')