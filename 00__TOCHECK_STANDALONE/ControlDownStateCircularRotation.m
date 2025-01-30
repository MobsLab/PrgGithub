%ControlDownStateCircularRotation

del=[0.02 0.1 0.5 2 50 500 1000];
 del=[0.02 0.1 0.5 2 50 500 1000];
load SpikeData
load DownSpk NumNeurons
load StateEpochSB SWSEpoch
[Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons,SWSEpoch,10,0.01,1,0,[0 70],1);title('No Delay')


for i=1:7
    
    [Sc,delc]=CircularRotationSpikeTrain(S,del(i));
    [Down,Qt,B,h1(i+1,:),b1(i+1,:),h2(i+1,:),b2(i+1,:),h3(i+1,:),b3(i+1,:),h4(i+1,:),b4(i+1,:)]=FindDown(Sc,NumNeurons,SWSEpoch,10,0.01,1,0,[0 70],1);title(['Delay: ',num2str(del(i)*100),'ms'])
    
end



figure('color',[1 1 1]), 
subplot(2,2,1), hold on
plot(b1(1,:),h1,'r')
plot(b1(1,:),h1(1,:),'r','linewidth',2)
plot(b2(1,:),h2(1,:),'k','linewidth',2)
set(gca,'yscale','log')
set(gca,'xscale','log')

subplot(2,2,3), hold on
plot(b2(1,:),h2,'k')
plot(b2(1,:),h2(1,:),'k','linewidth',2)
plot(b1(1,:),h1(1,:),'r','linewidth',2)
set(gca,'yscale','log')
set(gca,'xscale','log')

subplot(2,2,2), hold on
plot(b3(1,:),h3,'r')
plot(b3(1,:),h3(1,:),'r','linewidth',2)
plot(b4(1,:),h4(1,:),'k','linewidth',2)
set(gca,'yscale','log')
set(gca,'xscale','log')

subplot(2,2,4), hold on
plot(b4(1,:),h4,'k')
plot(b4(1,:),h4(1,:),'k','linewidth',2)
plot(b3(1,:),h3(1,:),'r','linewidth',2)
set(gca,'yscale','log')
set(gca,'xscale','log')
