function [theta,t,r,C5,lag5,pval5,ac]=GridFrancesca(fhist,x,y,lim1,lim2,beta)

% Load data : Rum GiocomoEtAl2007
%disp('*** GridFrancesca ***')

opt='coef';
%opt='unbiased';


%clear
%close all

% try
%    DoData;
% catch
%     DoData=0;
% end
% 
% if DoData==0
% GiocomoEtAl2007

%spk=floor(spikeTimes*50);
[BE,spk]=find(fhist>2);

x=rescale(x,0,200)';
y=rescale(y,0,200)';
% DoData=1;
% end

% 
% lim1=75;
% lim2=85;
dis=sqrt((x-100).*(x-100)+(y-100).*(y-100));

%subplot(1,6,1),scatter(x,y,20, dis),colorbar


fhist2=fhist;
fhist2(fhist2<2)=0;
fhist2(fhist2>2)=1;

id2=ismember(spk,find(dis>lim1&dis<lim2));
%id2=ismember(floor(spikeTimes*50),find(dis>lim1&dis<lim2));

%subplot(1,5,3), plot(x,y), hold on, plot(x(floor(spikeTimes*50)),y(floor(spikeTimes*50)),'r.')


fhist2=zeros(1,length(x));
fhist2(spk(id2))=1;

%subplot(1,6,2), plot(fhist), hold on, plot(fhist2,'r')

ac = spaceAutoCorr(fhist2, x', y', 1, 200, 1000);
%subplot(1,6,3), imagesc(ac), axis xy%, colorbar

ac=ac';
ac(isnan(ac))=0;ac(isinf(ac))=0; 



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

figure(2), clf, 
subplot(1,6,3), imagesc(SmoothDec(ac,[2 2])), axis xy%, colorbar


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

x2=rescale(x,-1,1);y2=rescale(y,-1,1);


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


[theta,rho] = cart2pol(x2(spk(id2)),y2(spk(id2)));
[t,r]=hist([-pi;theta;pi],360*2);

t(1)=t(1)-1;
t(end)=t(end)-1;



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


subplot(1,6,1:2), 
hold on,plot(x,y),
plot(x(spk),y(spk),'k.')
hold on, scatter(x(spk(id2)),y(spk(id2)),30,theta,'filled')

ang=0:0.01:2*pi;
plot(lim1*sin(ang)+100,lim1*cos(ang)+100,'color',[0.7 0.7 0.7])
plot(lim2*sin(ang)+100,lim2*cos(ang)+100,'color',[0.7 0.7 0.7])

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


[C1,B1]=crosscorr(theta,theta,1,5E6);C1(B1==0)=0;

%[C2,lag2]=xcorr(theta,'coeff');
[C2,lag2]=xcorr(theta,opt); C2(abs(lag2)<1)=0;



[C2b,lag2b]=xcorr([theta;theta;theta;theta],opt);


%[C3,lag3]=xcorr([r,r,r,r],'coef');
[C3,lag3]=xcorr([r,r,r,r],opt);


[C4,lag4,pval4]=xcirccorr(theta,theta);
[C5,lag5,pval5]=xcirccorr(t',t'); C5(lag5<1)=0;

% t = data in radians;
% z = exp(i*t); % z = cos(t) + sqrt(-1)*sin(t)
% Z = fft(z);
% A = ifft(abs(Z).^2);

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

th=0.05;

%subplot(1,6,6), plot(lag2,C2), hold on, plot(lag2b,C2b,'r') ,plot(lag2,C2), xlim([lag2b(1) lag2b(end)])
subplot(1,6,4:5), 
%plot(lag4,C4,'k'),hold on,plot(lag4(pval4<0.05),C4(pval4<0.05),'r.'),xlim([0 180])
%plot(lag5,C5,'b'),hold on,plot(lag5(pval5<0.05),C5(pval5<0.05),'m.'),xlim([0 180])
plot(lag5,C5,'k'),
%hold on,plot(lag5(pval5<0.05),C5(pval5<0.05),'r.'),xlim([0 180])
hold on,scatter(lag5(pval5<th),C5(pval5<th),20,pval5(pval5<th),'filled'),xlim([0 180]),colorbar


params.tapers=[1 2];
%params.Fs=2*360;

params.Fs=1;
[S,f]=mtspectrumpt(lag5(pval5<th),params);
params.Fs=4;
[S1,f1]=mtspectrumc(C5-min(C5),params);
%[S1,f1]=mtspectrumpt([lag5(pval5<th),lag5(pval5<th),lag5(pval5<th),lag5(pval5<th),lag5(pval5<th)],params,1);

smo=4;
subplot(1,6,6), hold on, 
plot(f1,smooth(rescale(f1'.*S1,0,max(f'.*S)),smo),'k','linewidth',2)
plot(f,smooth(f'.*S,smo),'b','linewidth',1), 

%plot(f2,S2,'color',[0.7 0.7 0.7]),
hold on, line([0.055 0.055]*beta/0.385,[0 max(f'.*S)+max(f'.*S)/5],'color','r') 
xlim([0 0.135])%max(f)])
%0.2])%



figure(3),clf, subplot(1,4,1), hist(theta*180/pi,20)
subplot(1,5,2), rose(theta,20), hold on, polar(r,t*5,'r'),  
subplot(1,5,3),hold on,
%plot(lag4,C4,'k'),hold on,plot(lag4(pval4<0.05),C4(pval4<0.05),'r.'),xlim([0 180])
plot(lag5,C5,'b'),hold on,
plot([-lag5,lag5],[C5(end:-1:1),C5],'color',[0.5 0.5 0.5]),
plot(lag5(pval5<0.05),C5(pval5<0.05),'m.'),xlim([-180 180])
subplot(1,5,4),hold on,
plot(lag2/length(lag2)*360,C2,'k'),title(['max:',num2str(max(theta)),', min:',num2str(max(theta))]),xlim([-180 180])
subplot(1,5,5),hold on,
plot([-lag5,lag5],[C5(end:-1:1),C5],'b'),
plot(lag2/length(lag2)*360,C2,'k'),title(['max:',num2str(max(theta)),', min:',num2str(max(theta))]),xlim([-120 120])


figure(2)