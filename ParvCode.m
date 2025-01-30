
cd('/Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/MMN/DataMMN')
testSpecAnalysis

a=40; xlim([a a+6])
saveFigure(1,'SleepMouse036FigureEx1','/Users/karimbenchenane/Dropbox/MMNP3b')

a=88; xlim([a a+6])
saveFigure(1,'SleepMouse036FigureEx2','/Users/karimbenchenane/Dropbox/MMNP3b')
a=112; xlim([a a+6])
saveFigure(1,'SleepMouse036FigureEx3','/Users/karimbenchenane/Dropbox/MMNP3b')
a=172; xlim([a a+6])
saveFigure(1,'SleepMouse036FigureEx4','/Users/karimbenchenane/Dropbox/MMNP3b')
a=226; xlim([a a+6])
saveFigure(1,'SleepMouse036FigureEx5','/Users/karimbenchenane/Dropbox/MMNP3b')
caxis([0 5.2])
a=628; xlim([a a+6]) %theta
saveFigure(1,'SleepMouse036FigureEx6','/Users/karimbenchenane/Dropbox/MMNP3b')
a=682; xlim([a a+6]) %theta
saveFigure(1,'SleepMouse036FigureEx7','/Users/karimbenchenane/Dropbox/MMNP3b')
a=688; xlim([a a+6]) %theta
saveFigure(1,'SleepMouse036FigureEx8','/Users/karimbenchenane/Dropbox/MMNP3b')
a=712; xlim([a a+6]) %theta
saveFigure(1,'SleepMouse036FigureEx9','/Users/karimbenchenane/Dropbox/MMNP3b')
a=718; xlim([a a+6]) %theta
saveFigure(1,'SleepMouse036FigureEx10','/Users/karimbenchenane/Dropbox/MMNP3b')


%[M1,M2,ripEvt,ripples]=CompTwoChannelsRipples(LFP,15,Epoch,13,10);
%[M1,M2,ripEvt,ripples]=CompTwoChannelsRipples(LFP,13,Epoch,15,10);


FilterParam=[5 20];
%FilterParam=[90 150];
%FilterParam=[130 200];



for i=1:15
    FilRipT{i}=FilterLFP(Restrict(LFP{i},Epoch),FilterParam,512);
end

try
    FilRipT=tsdArray(FilRipT);
end













FilRip=FilterLFP(Restrict(LFP{15},Epoch),FilterParam,512);
SQR=tsd(Range(FilRip), SmoothDec(Data(FilRip).*Data(FilRip),3));
RipEpoch=thresholdIntervals(SQR,1000,'Direction','Above');

RipNoEpoch=thresholdIntervals(SQR,100,'Direction','Below');

FilRip2=FilterLFP(Restrict(LFP{10},Epoch),FilterParam,512);
SQR2=tsd(Range(FilRip2), SmoothDec(Data(FilRip2).*Data(FilRip2),3));
RipEpoch2=thresholdIntervals(SQR2,1000,'Direction','Above');



if 0
rgFil=Range(FilRip,'s');
rgFil2=Range(FilRip2,'s');
filtered=[rgFil-rgFil(1) Data(FilRip)];
filtered2=[rgFil2-rgFil2(1) Data(FilRip2)];

paramRip=[5 8];
[ripples,stdev,noise] = FindRipples(filtered,'thresholds',paramRip,'noise',filtered2);
[maps,data,stats] = RippleStats(filtered,ripples);
PlotRippleStats(ripples,maps,data,stats);

%ripEvt=intervalSet((ripples(:,2)+rgFil(1)-0.05)*1E4,(ripples(:,2)+rgFil(1)+0.05)*1E4);
ripEvt=intervalSet((ripples(:,1)+rgFil(1))*1E4,(ripples(:,3)+rgFil(1))*1E4);

ripEvt=mergecloseIntervals(ripEvt,50);

end


%RipEpoch=RipEpoch-RipEpoch2;
%RipEpoch=dropShortIntervals(RipEpoch,400);
RipEpochT=RipEpoch;

%RipEpochT=ripEvt;


Epoch1=and(RipEpoch,RipEpoch2);
Epoch2=Epoch-RipEpoch;
Epoch2=Epoch2-RipEpoch2;

Epoch1=RipEpoch;
Epoch2=RipNoEpoch;


Epoch1=dropShortIntervals(Epoch1,1000);
Epoch2=dropShortIntervals(Epoch2,1000);

i=10;
figure('color',[1 1 1]), 
subplot(2,3,1), plot(Data(Restrict(FilRip,Epoch1)), Data(Restrict(FilRipT{i},Epoch1)),'r.')
subplot(2,3,2), plot(Data(Restrict(FilRip,Epoch2)), Data(Restrict(FilRipT{i},Epoch2)),'k.')
subplot(2,3,3), hold on

plot(Data(Restrict(FilRip,Epoch1)), Data(Restrict(FilRipT{i},Epoch1)),'r.')
plot(Data(Restrict(FilRip,Epoch2)), Data(Restrict(FilRipT{i},Epoch2)),'k.')
title(num2str(i))


subplot(2,3,4), plot(Data(Restrict(LFP{15},Epoch1)), Data(Restrict(LFP{i},Epoch1)),'r.')
subplot(2,3,5), plot(Data(Restrict(LFP{15},Epoch2)), Data(Restrict(LFP{i},Epoch2)),'k.')
subplot(2,3,6), hold on

plot(Data(Restrict(LFP{15},Epoch1)), Data(Restrict(LFP{i},Epoch1)),'r.')
plot(Data(Restrict(LFP{15},Epoch2)), Data(Restrict(LFP{i},Epoch2)),'k.')
title(num2str(i))






if 0

figure('color',[1 1 1]), plot(Range(LFP{1},'s'), Data(LFP{15}))
hold on, plot(Range(FilRip,'s'), Data(FilRip),'r')
hold on, plot(Range(FilRip,'s'), Data(SQR)/10,'g','linewidth',2)
hold on, plot(Range(Restrict(LFP{15},RipEpochT),'s'), Data(Restrict(LFP{15},RipEpochT)),'c')
hold on, plot(Range(Restrict(FilRip,RipEpochT),'s'), Data(Restrict(FilRip,RipEpochT)),'m')

end



if 0
    
    

for i=1:15
figure('color',[1 1 1]), 
subplot(2,3,1), plot(Data(Restrict(FilRip,RipEpochT)), Data(Restrict(FilRipT{i},RipEpochT)),'r.')
subplot(2,3,2), plot(Data(Restrict(FilRip,RipNoEpoch)), Data(Restrict(FilRipT{i},RipNoEpoch)),'k.')
subplot(2,3,3), hold on

plot(Data(Restrict(FilRip,RipEpochT)), Data(Restrict(FilRipT{i},RipEpochT)),'r.')
plot(Data(Restrict(FilRip,RipNoEpoch)), Data(Restrict(FilRipT{i},RipNoEpoch)),'k.')
title(num2str(i))


subplot(2,3,4), plot(Data(Restrict(LFP{15},RipEpochT)), Data(Restrict(LFP{i},RipEpochT)),'r.')
subplot(2,3,5), plot(Data(Restrict(LFP{15},RipNoEpoch)), Data(Restrict(LFP{i},RipNoEpoch)),'k.')
subplot(2,3,6), hold on

plot(Data(Restrict(LFP{15},RipEpochT)), Data(Restrict(LFP{i},RipEpochT)),'r.')
plot(Data(Restrict(LFP{15},RipNoEpoch)), Data(Restrict(LFP{i},RipNoEpoch)),'k.')
title(num2str(i))



end


end






if 0



for i=1:15
figure('color',[1 1 1]), 
subplot(1,3,1), plot(Data(Restrict(FilRip,RipEpochT)), Data(Restrict(FilRipT{i},RipEpochT)),'r.')
subplot(1,3,2), plot(Data(Restrict(FilRip,Epoch-RipEpochT)), Data(Restrict(FilRipT{i},Epoch-RipEpochT)),'k.')
subplot(1,3,3), hold on
plot(Data(Restrict(FilRip,RipEpochT)), Data(Restrict(FilRipT{i},RipEpochT)),'r.')
plot(Data(Restrict(FilRip,Epoch-RipEpochT)), Data(Restrict(FilRipT{i},Epoch-RipEpochT)),'k.')

title(num2str(i))
end



for i=1:15
figure('color',[1 1 1]), 
subplot(1,3,1), plot(Data(Restrict(LFP{15},RipEpochT)), Data(Restrict(LFP{i},RipEpochT)),'r.')
subplot(1,3,2), plot(Data(Restrict(LFP{15},Epoch-RipEpochT)), Data(Restrict(LFP{i},Epoch-RipEpochT)),'k.')
subplot(1,3,3), hold on
plot(Data(Restrict(LFP{15},RipEpochT)), Data(Restrict(LFP{i},RipEpochT)),'r.')
plot(Data(Restrict(LFP{15},Epoch-RipEpochT)), Data(Restrict(LFP{i},Epoch-RipEpochT)),'k.')

title(num2str(i))
end

end

