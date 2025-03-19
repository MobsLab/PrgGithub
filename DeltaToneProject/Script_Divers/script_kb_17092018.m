% script karim swa and down density

figure, plot(x_intervals, density_delta1)
figure, hold on, 
plot(x_intervals, density_down,'k')
plot(x_intervals, density_delta2,'b')
plot(x_intervals, density_delta3,'r')
plot(x_intervals, density_delta1,'m')
load('SpectrumDataL/Spectrum26.mat')
 
figure, imagesc(t,f,10*log10(Sp)')
figure, imagesc(t,f,10*log10(Sp)'), axis xy
hold on, plot(x_intervals*3600E4, rescale(density_down,10,20),'k')
hold on, plot(x_intervals*3600, rescale(density_down,10,20),'k') 
hold on, plot(x_intervals*3600, rescale(density_down,10,20),'k','linewidth',2)
 
id=find(f>1&f<2);
figure, plot(x_intervals*3600, rescale(density_down,0,1)
 
Did you mean:
figure, plot(x_intervals*3600, rescale(density_down,0,1))
hold on, plot(t,mean(Sp(:,id),2)','k')
hold on, plot(t,rescale(mean(Sp(:,id),2)',0,1),'k')
figure, plot(x_intervals*3600, rescale(density_down,0,1),'k')
hold on, plot(t,rescale(mean(Sp(:,id),2)',0,1),'r')
figure, plot(x_intervals*3600, rescale(density_down,0,1),'k')
hold on, plot(t,4*rescale(mean(Sp(:,id),2)',0,1),'r')
figure, plot(x_intervals*3600, rescale(density_down,0,1),'k')
hold on, plot(t,runmean(4*rescale(mean(Sp(:,id),2)',0,1),3),'r')
hold on, plot(t,runmean(4*rescale(mean(Sp(:,id),2)',0,1),30),'b')
hold on, plot(t,runmean(10*rescale(mean(Sp(:,id),2)',0,1),30),'b')
figure, plot(x_intervals*3600, rescale(density_down,0,1),'k')
hold on, plot(t,runmean(10*rescale(mean(Sp(:,id),2)',0,1),30),'b')
figure, plot(x_intervals*3600, rescale(density_down,0,1),'k')
hold on, plot(t,runmean(12*rescale(mean(Sp(:,id),2)',0,1),40),'r')
id=find(f>2&f<3);
hold on, plot(t,runmean(12*rescale(mean(Sp(:,id),2)',0,1),40),'g')
hold on, plot(t,runmean(6*rescale(mean(Sp(:,id),2)',0,1),40),'g')
hold on, plot(t,runmean(2*rescale(mean(Sp(:,id),2)',0,1),40),'g')
figure, plot(x_intervals*3600, rescale(density_down,0,1),'k')
hold on, plot(t,runmean(2*rescale(mean(Sp(:,id),2)',0,1),40),'r')
figure, plot(x_intervals*3600, rescale(density_down,0,1),'k','linewidth',4)
hold on, plot(t,runmean(2*rescale(mean(Sp(:,id),2)',0,1),40),'r')
id12=find(f>1&f<2);
hold on, plot(t,runmean(12*rescale(mean(Sp(:,id12),2)',0,1),40),'b')
id34=find(f>3&f<4);
 
hold on, plot(t,runmean(2*rescale(mean(Sp(:,id34),2)',0,1),40),'m')
figure
subplot(4,1,1), plot(x_intervals*3600, rescale(density_down,0,1),'k','linewidth',2)
  
subplot(4,1,1), plot(t, runmean(mean(Sp(:,id12),2)',40),'b','linewidth',2)
subplot(4,1,1), plot(x_intervals*3600, rescale(density_down,0,1),'k','linewidth',2)
subplot(4,1,2), plot(t, runmean(mean(Sp(:,id12),2)',40),'b','linewidth',2)
subplot(4,1,3), plot(t, runmean(mean(Sp(:,id),2)',40),'b','linewidth',2)
subplot(4,1,4), plot(t, runmean(mean(Sp(:,id34),2)',40),'b','linewidth',2)
id34=find(f>3&f<4);
id12=find(f>1&f<2);
id23=find(f>2&f<3);
id01=find(f>0.01&f<1);
id45=find(f>4&f<5);
figure
subplot(6,1,1), plot(x_intervals*3600, rescale(density_down,0,1),'k','linewidth',2) 
subplot(6,1,2), plot(t, runmean(mean(Sp(:,id01),2)',40),'b','linewidth',2)
 
ylim([0 1E4])
ylim([0 4E4])
ylim([0 6E4])
ylim([0 7E4])
subplot(6,1,3), plot(t, runmean(mean(Sp(:,id12),2)',40),'b','linewidth',2)
subplot(6,1,4), plot(t, runmean(mean(Sp(:,id23),2)',40),'b','linewidth',2)
subplot(6,1,5), plot(t, runmean(mean(Sp(:,id34),2)',40),'b','linewidth',2)
subplot(6,1,6), plot(t, runmean(mean(Sp(:,id45),2)',40),'b','linewidth',2)
ylim([0 6E4])
ylim([0 8E4])
ylim([0 10E4])
ylim([0 5E4])
Spd=Sp;
td=t;
fd=f;
load('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243/SpectrumDataL/Spectrum27.mat')

Stsd=tsd(t*1E4,runmean(mean(Sp(:,id45),2),40));
DownDens=tsd(x_intervals*3600*1E4, rescale(density_down,0,1));
test=Restrict(Stsd,DownDens);
figure, plot(Data(test),Data(DownDens),'k.')
figure, plot(Data(Restrict(tsd(t*1E4,runmean(mean(Sp(:,id12),2),40)),DownDens)),Data(DownDens),'ko','markerfacecolor','k')
subplot(2,2,1), plot(Data(Restrict(tsd(t*1E4,runmean(mean(Sp(:,id12),2),40)),DownDens)),Data(DownDens),'ko','markerfacecolor','k')
subplot(2,2,1), plot(Data(Restrict(tsd(t*1E4,runmean(mean(Sp(:,id01),2),40)),DownDens)),Data(DownDens),'ko','markerfacecolor','k')
subplot(2,2,2), plot(Data(Restrict(tsd(t*1E4,runmean(mean(Sp(:,id12),2),40)),DownDens)),Data(DownDens),'ko','markerfacecolor','k')
subplot(2,2,3), plot(Data(Restrict(tsd(t*1E4,runmean(mean(Sp(:,id23),2),40)),DownDens)),Data(DownDens),'ko','markerfacecolor','k')
subplot(2,2,4), plot(Data(Restrict(tsd(t*1E4,runmean(mean(Sp(:,id34),2),40)),DownDens)),Data(DownDens),'ko','markerfacecolor','k')
load('SleepSubstages.mat')

figure, plot(Range(test),Data(test),'k')
hold on, plot(Range(Restrict(test,or(Epoch{2},Epoch{3})),Data(Restrict(test,or(Epoch{2},Epoch{3})),'r')
 
hold on, plot(Range(Restrict(test,or(Epoch{2},Epoch{3})),Data(Restrict(test,or(Epoch{2},Epoch{3})),'r')
 
hold on, plot(Range(Restrict(test,or(Epoch{2},Epoch{3}))),Data(Restrict(test,or(Epoch{2},Epoch{3})),'r')


hold on, plot(Range(Restrict(test,or(Epoch{2},Epoch{3}))),Data(Restrict(test,or(Epoch{2},Epoch{3}))),'r')
figure, plot(Range(test),Data(test),'k')
hold on, plot(Range(Restrict(test,or(Epoch{2},Epoch{3}))),Data(Restrict(test,or(Epoch{2},Epoch{3}))),'r.')
hold on, plot(Range(Restrict(test,or(Epoch{2},Epoch{3}))),Data(Restrict(test,or(Epoch{2},Epoch{3}))),'ro','markerfacecolor','r')
test=Restrict(tsd(t*1E4,runmean(mean(Sp(:,id12),2),40)),DownDens);
figure, plot(Range(test),Data(test),'k')
hold on, plot(Range(Restrict(test,or(Epoch{2},Epoch{3}))),Data(Restrict(test,or(Epoch{2},Epoch{3}))),'ro','markerfacecolor','r')
test=Restrict(tsd(t*1E4,runmean(mean(Sp(:,id23),2),40)),DownDens);
figure, plot(Range(test),Data(test),'k'), hold on, plot(Range(Restrict(test,or(Epoch{2},Epoch{3}))),Data(Restrict(test,or(Epoch{2},Epoch{3}))),'ro','markerfacecolor','r')
test=Restrict(tsd(t*1E4,runmean(mean(Sp(:,id34),2),40)),DownDens);
figure, plot(Range(test),Data(test),'k'), hold on, plot(Range(Restrict(test,or(Epoch{2},Epoch{3}))),Data(Restrict(test,or(Epoch{2},Epoch{3}))),'ro','markerfacecolor','r')
test=Restrict(tsd(t*1E4,runmean(mean(Sp(:,id45),2),40)),DownDens);
figure, plot(Range(test),Data(test),'k'), hold on, plot(Range(Restrict(test,or(Epoch{2},Epoch{3}))),Data(Restrict(test,or(Epoch{2},Epoch{3}))),'ro','markerfacecolor','r')
id56=find(f>5&f<6);
test=Restrict(tsd(t*1E4,runmean(mean(Sp(:,id56),2),40)),DownDens);
figure, plot(Range(test),Data(test),'k'), hold on, plot(Range(Restrict(test,or(Epoch{2},Epoch{3}))),Data(Restrict(test,or(Epoch{2},Epoch{3}))),'ro','markerfacecolor','r')
figure, plot(Range(DownDens),Data(DownDens),'k'), hold on, plot(Range(Restrict(DownDens,or(Epoch{2},Epoch{3}))),Data(Restrict(DownDens,or(Epoch{2},Epoch{3}))),'ro','markerfacecolor','r')
SleepEpoch=or(Epoch{1},or(Epoch{2},Epoch{3}));
figure, plot(Range(DownDens),Data(DownDens),'k'), hold on, plot(Range(Restrict(DownDens,SleepEpoch)),Data(Restrict(DownDens,SleepEpoch)),'ro','markerfacecolor','r')
figure, plot(Range(DownDens),Data(DownDens),'k'), hold on, plot(Range(Restrict(DownDens,or(Epoch{2},Epoch{3}))),Data(Restrict(DownDens,or(Epoch{2},Epoch{3}))),'ro','markerfacecolor','r')
plot(Range(DownDens),Data(DownDens),'k'), hold on, plot(Range(Restrict(DownDens,or(Epoch{2},Epoch{3}))),Data(Restrict(DownDens,or(Epoch{2},Epoch{3}))),'bo','markerfacecolor','b')




