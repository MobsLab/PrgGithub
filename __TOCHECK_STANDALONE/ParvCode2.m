function R=ParvCode2(a,b,FilterParam,thquanL,thquanH)



% 
% a=15;
% b=10;


load('/Users/karimbenchenane/Dropbox/LFPDatadata03MMN.mat')

rg=Range(LFP{1});
%Epoch=intervalSet(0,rg(end));

%  %Epoch=intervalSet(100*1E4,230*1E4); % slow wave sleep
%  %Epoch=intervalSet(172*1E4,230*1E4); % slow wave sleep
%  %Epoch=intervalSet(40*1E4,230*1E4); % slow wave sleep



Epoch=intervalSet(180*1E4,210*1E4); % slow wave sleep
%Epoch=intervalSet(620*1E4,720*1E4); % Theta


en=End(Epoch);


th=1200;

clear badEpoch

badEpochUp=thresholdIntervals(LFP{a},th,'Direction','Above');
badEpochDown=thresholdIntervals(LFP{a},-th,'Direction','Below');
badEpochTemp=or(badEpochUp,badEpochDown);
badEpochTemp=dropShortIntervals(badEpochTemp,1E3);

badEpoch=intervalSet((Start(badEpochTemp)-1*1E4), (End(badEpochTemp)+1*1E4));
try
badEpoch=mergeCloseIntervals(badEpoch,1E2);
catch
badEpoch=mergeCloseIntervals(badEpochTemp,1E2);    
end


GoodEpoch=Epoch-badEpoch;

GoodEpoch=dropShortIntervals(GoodEpoch,1E3);



try
    FilterParam;
catch

%FilterParam=[2 5];

%FilterParam=[5 10];

% FilterParam=[10 20];

%FilterParam=[20 40];

FilterParam=[60 90];
%FilterParam=[90 130];

%FilterParam=[130 200];

end





% 
% 
% for i=1:15
%     FilRipT{i}=FilterLFP(Restrict(LFP{i},Epoch),FilterParam,1024);
% end
% 
% try
%     FilRipT=tsdArray(FilRipT);
% end





FilRip=FilterLFP(Restrict(LFP{a},Epoch),FilterParam,1024);
SQR=tsd(Range(FilRip), SmoothDec(Data(FilRip).*Data(FilRip),3));
thH1=quantile(Data(Restrict(SQR,Epoch)),thquanH);
thL1=quantile(Data(Restrict(SQR,Epoch)),thquanL);
RipEpoch1=thresholdIntervals(SQR,thH1,'Direction','Above');
RipNoEpoch1=thresholdIntervals(SQR,thL1,'Direction','Below');

FilRip2=FilterLFP(Restrict(LFP{b},Epoch),FilterParam,1024);
SQR2=tsd(Range(FilRip2), SmoothDec(Data(FilRip2).*Data(FilRip2),3));
thH2=quantile(Data(Restrict(SQR2,Epoch)),thquanH);
thL2=quantile(Data(Restrict(SQR2,Epoch)),thquanL);
RipEpoch2=thresholdIntervals(SQR2,thH2,'Direction','Above');
RipNoEpoch2=thresholdIntervals(SQR2,thL2,'Direction','Below');




Epoch1=and(RipEpoch1,RipEpoch2);
Epoch2=and(RipNoEpoch1,RipNoEpoch2);

%Epoch1=RipEpoch1;
%Epoch2=RipNoEpoch1;
% 
%  Epoch1=RipEpoch2;
% Epoch2=RipNoEpoch2;
% 
Epoch1=or(RipEpoch1,RipEpoch2);
Epoch2=or(RipNoEpoch1,RipNoEpoch2);
% 
% Epoch1=or(RipEpoch1,RipEpoch2)-and(RipEpoch1,RipEpoch2);
% Epoch2=or(RipNoEpoch1,RipNoEpoch2)-and(RipNoEpoch1,RipNoEpoch2);
% 

Epoch1=dropShortIntervals(Epoch1,1E2);
Epoch2=dropShortIntervals(Epoch2,1E2);

Epoch1=mergeCloseIntervals(Epoch1,1E2);
Epoch2=mergeCloseIntervals(Epoch2,1E2);

Epoch1=dropShortIntervals(Epoch1,1E3);
Epoch2=dropShortIntervals(Epoch2,1E3);

Epoch1=and(Epoch1,GoodEpoch);
Epoch2=and(Epoch2,GoodEpoch);




LFP=Restrict(LFP,GoodEpoch);


if 0
figure('color',[1 1 1]), 
plot(Range(LFP{1},'s'), Data(LFP{15}),'k')
hold on, plot(Range(FilRip,'s'), Data(FilRip),'k')
hold on, plot(Range(FilRip,'s'), Data(SQR)/max(Data(SQR))*1000,'g','linewidth',2)
hold on, plot(Range(Restrict(LFP{15},Epoch1),'s'), Data(Restrict(LFP{15},Epoch1)),'r')
hold on, plot(Range(Restrict(FilRip,Epoch1),'s'), Data(Restrict(FilRip,Epoch1)),'r')

hold on, plot(Range(Restrict(LFP{15},Epoch2),'s'), Data(Restrict(LFP{15},Epoch2)),'b')
hold on, plot(Range(Restrict(FilRip,Epoch2),'s'), Data(Restrict(FilRip,Epoch2)),'b')
end


figure('color',[1 1 1]), 
subplot(1,3,1), hold on
plot(Data(Restrict(FilRip,Epoch1)), Data(Restrict(FilRip2,Epoch1)),'r.')
xl=xlim;
yl=ylim;
line([min(xl(1),yl(1)) max(xl(2),yl(2))],[min(xl(1),yl(1)) max(xl(2),yl(2))],'color','b')

[r,p]=corrcoef(Data(Restrict(FilRip,Epoch1)), Data(Restrict(FilRip2,Epoch1)));
title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])

subplot(1,3,2), hold on,
plot(Data(Restrict(FilRip,Epoch2)), Data(Restrict(FilRip2,Epoch2)),'k.')
xl=xlim;
yl=ylim;
line([min(xl(1),yl(1)) max(xl(2),yl(2))],[min(xl(1),yl(1)) max(xl(2),yl(2))],'color','b')
[r2,p2]=corrcoef(Data(Restrict(FilRip,Epoch2)), Data(Restrict(FilRip2,Epoch2)));
title(['r=',num2str(r2(2,1)),', p=',num2str(p2(2,1))])


subplot(1,3,3), hold on

plot(Data(Restrict(FilRip,Epoch1)), Data(Restrict(FilRip2,Epoch1)),'r.')
plot(Data(Restrict(FilRip,Epoch2)), Data(Restrict(FilRip2,Epoch2)),'k.')
xl=xlim;
yl=ylim;
line([min(xl(1),yl(1)) max(xl(2),yl(2))],[min(xl(1),yl(1)) max(xl(2),yl(2))],'color','b')
title([num2str(a), ' vs. ',num2str(b), ', frequency : ', num2str(FilterParam), ' Hz'])
% 
% 
% subplot(2,3,4), plot(Data(Restrict(LFP{a},Epoch1)), Data(Restrict(LFP{b},Epoch1)),'r.')
% subplot(2,3,5), plot(Data(Restrict(LFP{a},Epoch2)), Data(Restrict(LFP{b},Epoch2)),'k.')
% title([num2str(a), ' vs. ',num2str(b), ', frequency : ', num2str(FilterParam),' Hz'])
% subplot(2,3,6), hold on
% 
% plot(Data(Restrict(LFP{15},Epoch1)), Data(Restrict(LFP{b},Epoch1)),'r.')
% plot(Data(Restrict(LFP{15},Epoch2)), Data(Restrict(LFP{b},Epoch2)),'k.')
% 
% 

% if isnan(r(2,1))
%     keyboard
% end

R(1)=r(2,1);
R(2)=r2(2,1);
R(3)=p(2,1);
R(4)=p2(2,1);

