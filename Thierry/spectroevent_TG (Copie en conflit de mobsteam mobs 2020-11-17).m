% length(events)
% xlim([events(1)-1 events(1)+1])
% xlim([events(1)-10 events(1)+10])
% xlim([events(1)-20 events(1)+20])
% xlim([events(1)-30 events(1)+30])
% events
% n=1;xlim([events(n)-30 events(n)+30])
% n=n+1;xlim([events(n)-30 events(n)+30])
% n=0;
% n=n+1;xlim([events(n)-50 events(n)+50])
% n=0;
% n=n+1;xlim([events(n)-80 events(n)+50]), caxis([10 50])


load('H_Low_Spectrum.mat')
SpectroH=Spectro;
figure, 
subplot(3,1,1), imagesc(SpectroV{2},SpectroV{3},10*log10(SpectroV{1}')), axis xy
subplot(3,1,2), imagesc(SpectroH{2},SpectroH{3},10*log10(SpectroH{1}')), axis xy
subplot(3,1,3), imagesc(SpectroB{2},SpectroB{3},10*log10(SpectroB{1}')), axis xy
n=n+1;subplot(3,1,1),xlim([events(n)-80 events(n)+50]), caxis([10 50]),subplot(3,1,2),xlim([events(n)-80 events(n)+50]), caxis([10 70]),subplot(3,1,3),xlim([events(n)-80 events(n)+50]), caxis([10 70])

colormap(jet)

% goodevents=events(2:end);
load('B_High_Spectrum.mat')
SpectroB=Spectro;

ev=ts(events*1E4);
length(Range(Restrict(ev,REMEpoch)))
length(Range(Restrict(ev,SWSEpoch)))
length(Range(Restrict(ev,Wake)))
evR=Range(Restrict(ev,REMEpoch),'s');
evS=Range(Restrict(ev,SWSEpoch),'s');
n=n+1;evc=evR; 
subplot(3,1,1),xlim([evc(n)-80 evc(n)+50]), caxis([10 50]),
subplot(3,1,2),xlim([evc(n)-80 evc(n)+50]), caxis([10 70]),
subplot(3,1,3),xlim([evc(n)-80 evc(n)+50]), caxis([10 50])

ev=ts(events*1E4-30E4);
evR=Range(Restrict(ev,REMEpoch),'s');
evS=Range(Restrict(ev,SWSEpoch),'s');

length(Range(Restrict(ev,Wake)))
length(Range(Restrict(ev,SWSEpoch)))
length(Range(Restrict(ev,REMEpoch)))





