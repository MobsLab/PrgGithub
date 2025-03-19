%ParcoursFindDeltaBurst

clear 
NameDir={'BASAL'};

a=1;
b=1;
timWT=[];
timKO=[];

for i=1:length(NameDir)
Dir=PathForExperimentsML(NameDir{i});
for man=1:length(Dir.path)
disp('  ')
disp(Dir.path{man})
disp(Dir.group{man})
disp(' ')
cd(Dir.path{man})
try
    
    clear SWSEpoch 
    clear Wake 
    clear REMEpoch 
    clear TotalNoiseEpoch
    load StateEpochSB SWSEpoch Wake REMEpoch TotalNoiseEpoch
    
    clear TimeEndRec
    load behavResources Movtsd PreEpoch DPCPXEpoch TimeEndRec tpsdeb tpsfin
    try
    TimeEndRec;
    durRec1=(tpsfin{1}-tpsdeb{1})/3600;
    catch
    
    disp('No timeRec')
	TimeEndRec;
    end
    
    
 if Dir.group{man}(1)=='W'
          clear BurstDeltaEpoch
          clear NbD
         [BurstDeltaEpoch,NbD]=FindDeltaBurst(SWSEpoch);
         DurWT(a,1)=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
         DurWT(a,2)=sum(End(BurstDeltaEpoch,'s')-Start(BurstDeltaEpoch,'s'));
         id=find(NbD(:,4)>3);
         DurWT(a,3)=sum(End(subset(BurstDeltaEpoch,id),'s')-Start(subset(BurstDeltaEpoch,id),'s'));
         DurWT(a,4)=size(NbD,1);
         DurWT(a,5)=length(id);
         DurWT(a,6)=mean(NbD(:,1));
         DurWT(a,7)=mean(NbD(:,2));
         DurWT(a,8)=mean(NbD(:,3));
         DurWT(a,9)=mean(NbD(:,4));
         DurWT(a,10)=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
         DurWT(a,11)=sum(End(Wake,'s')-Start(Wake,'s'));
         
         timWT=[timWT; [Start(BurstDeltaEpoch,'s') TimeEndRec(1,1)+TimeEndRec(1,2)/60+Start(BurstDeltaEpoch,'s')/3600-durRec1 NbD]];
         
         [Hwt1(a,:),B]=hist(NbD(:,1),0:50);
         [Hwt2(a,:),B]=hist(NbD(:,2),0:50);
         [Hwt3(a,:),B]=hist(NbD(:,3),0:50);
         [Hwt4(a,:),B]=hist(NbD(:,4),0:50);
         a=a+1;
 else
          clear BurstDeltaEpoch
          clear NbD
          [BurstDeltaEpoch,NbD]=FindDeltaBurst(SWSEpoch);
         DurKO(b,1)=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
         DurKO(b,2)=sum(End(BurstDeltaEpoch,'s')-Start(BurstDeltaEpoch,'s'));
         id=find(NbD(:,4)>3);
         DurKO(b,3)=sum(End(subset(BurstDeltaEpoch,id),'s')-Start(subset(BurstDeltaEpoch,id),'s'));
         DurKO(b,4)=size(NbD,1);
         DurKO(b,5)=length(id);
         DurKO(b,6)=mean(NbD(:,1));
         DurKO(b,7)=mean(NbD(:,2));
         DurKO(b,8)=mean(NbD(:,3));
         DurKO(b,9)=mean(NbD(:,4));
         DurKO(b,10)=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
         DurKO(b,11)=sum(End(Wake,'s')-Start(Wake,'s'));
         
         timKO=[timKO; [Start(BurstDeltaEpoch,'s') TimeEndRec(1,1)+TimeEndRec(1,2)/60+Start(BurstDeltaEpoch,'s')/3600-durRec1 NbD]];
         
         [Hko1(b,:),B]=hist(NbD(:,1),0:50);
         [Hko2(b,:),B]=hist(NbD(:,2),0:50);
         [Hko3(b,:),B]=hist(NbD(:,3),0:50);
         [Hko4(b,:),B]=hist(NbD(:,4),0:50);
         b=b+1;
     
 end
end
end
end



 figure('color',[1 1 1])
 for i=1:11
     subplot(2,6,i), PlotErrorBar2(DurWT(:,i),DurKO(:,i),0,1)
 end
 
figure('color',[1 1 1]), hold on, 
i=1;
for j=1:4
    subplot(2,4,j), hold on,plot(timWT(:,i),timWT(:,j+2),'k.'), plot(timKO(:,i),timKO(:,j+2),'r.')
end
i=2;
for j=1:4
    subplot(2,4,j+4), hold on,plot(timWT(:,i),timWT(:,j+2),'k.'), plot(timKO(:,i),timKO(:,j+2),'r.')
end


[H,h1,h2]=hist2d(timWT(:,i),timWT(:,j+2),10:20,0:50);
figure, contourf(h1-0.5,h2-5,SmoothDec(H',[1 1]),[0:0.1:9],'linestyle','none'), axis xy

  
 figure('color',[1 1 1])
 subplot(4,2,1), plot(B,Hwt1,'k'), hold on, plot(B,Hko1,'r')
 subplot(4,2,3), plot(B,Hwt2,'k'), hold on, plot(B,Hko2,'r')
 subplot(4,2,5), plot(B,Hwt3,'k'), hold on, plot(B,Hko3,'r')
 subplot(4,2,7), plot(B,Hwt4,'k'), hold on, plot(B,Hko4,'r')
 
 subplot(4,2,2), plot(B,mean(Hwt1),'k'), hold on, plot(B,mean(Hko1),'r')
 subplot(4,2,4), plot(B,mean(Hwt2),'k'), hold on, plot(B,mean(Hko2),'r')
 subplot(4,2,6), plot(B,mean(Hwt3),'k'), hold on, plot(B,mean(Hko3),'r')
 subplot(4,2,8), plot(B,mean(Hwt4),'k'), hold on, plot(B,mean(Hko4),'r') 
 
 
 
 
 figure('color',[1 1 1]), hold on, 
for i=1:11
for j=1:11
    subplot(11,11,MatXY(i,j,11)), hold on,plot(DurWT(:,i),DurWT(:,j),'k.'), plot(DurKO(:,i),DurKO(:,j),'r.')
end
end



