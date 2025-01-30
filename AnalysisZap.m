function [Cor,P,Cros,Mat,dPeaks,dThroughs]=AnalysisZap(Mt,k,paramDis)

num1=1;
num2=2;
num=3;
try
    paramDis;
    paramDis1=paramDis(1);
    paramDis2=paramDis(2);
catch
    
paramDis1=1;
paramDis2=1;
end

%deb=floor(50-k*1.5);fin=60;
%deb=max(5,floor(50-k*5));fin=80; %OKKKKKKKKKKKKKKKKKKKKKK

deb=40;fin=80;


deb2=deb;
fin2=fin;
% deb2=1;
% fin2=100;


% 
% SignalPar=smooth(Mt{60,4,k},100);
% SignalPfc=smooth(Mt{60,3,k},100);
% SignalBO=smooth(Mt{60,2,k},100);
% SignalRespi=smooth(Mt{60,1,k},100);
% 
smo=50;
SignalPar=zscore(smooth(Mt{60,4,k},smo));
SignalPfc=zscore(smooth(Mt{60,3,k},smo));
SignalBO=zscore(smooth(Mt{60,2,k},smo));
SignalRespi=zscore(smooth(Mt{60,1,k},smo));


Mat=[rescale(SignalRespi',-1,1);rescale(SignalBO',-1,1);rescale(SignalPfc',-1,1);rescale(SignalPar',-1,1)];


try
    num;
figure(num),clf,

catch
   figure('color',[1 1 1]),  
end
imagesc(Mat)

try
    num1;
figure(num1),clf,

catch
   figure('color',[1 1 1]),  
end

% plot(zscore(SignalRespi),'linewidth',2)
% hold on, plot(zscore(SignalBO),'k')
% hold on, plot(zscore(SignalPfc),'r')
% hold on, plot(zscore(SignalPar),'m')

plot((SignalRespi),'linewidth',2)
hold on, plot((SignalBO),'k')
hold on, plot((SignalPfc),'r')
hold on, plot((SignalPar),'m')

% 
% de1=[zscore(SignalRespi); 0];
% de2=[0; zscore(SignalRespi)];

de1=[(SignalRespi); 0];
de2=[0; (SignalRespi)];


id=find(de1>0&de2<0);
z=find(id<1000);z1=id(z(end));
z=find(id>1000);z2=id(z(1));




try
    num2;
    figure(num2),clf,
catch
  figure('color',[1 1 1])  
end


M1=mETAverage(z1,1:length(SignalRespi),SignalRespi,1,100);
M2=mETAverage(z1,1:length(SignalBO),SignalBO,1,100);


[tPeaks1,Peaks1]=FindMaxPeaks([1:length(M1(deb2:fin2));M1(deb2:fin2)']');
[tPeaks2,Peaks2]=FindMaxPeaks([1:length(M2(deb2:fin2));M2(deb2:fin2)']');
%dPeaks(1)=spkd(tPeaks1,tPeaks2,paramDis);
[tTrough1,Trough1]=FindMinPeaks([1:length(M1(deb2:fin2));M1(deb2:fin2)']');
[tTrough2,Trough2]=FindMinPeaks([1:length(M2(deb2:fin2));M2(deb2:fin2)']');
%dThroughs(1)=spkd(tTrough1,tTrough2,paramDis);

dPeaks(1)=labdist_faster(tPeaks2,[1:length(tPeaks2)],tPeaks2,[1:length(tPeaks2)],paramDis1,paramDis2);
dThroughs(1)=labdist_faster(tTrough1,[1:length(tTrough1)],tTrough2,[1:length(tTrough2)],paramDis1,paramDis2);


%subplot(3,2,1), plotyy(1:length(M1),M1,1:length(M2),M2),ylabel('bulb'), hold on, plot(tPeaks1+deb2-1,Peaks1,'ko','markerfacecolor','b'), plot(tPeaks2+deb2-1,Peaks2,'ko','markerfacecolor','g'), plot(tTrough1+deb2-1,Trough1,'ko','markerfacecolor','b'), plot(tTrough2+deb2-1,Trough2,'ko','markerfacecolor','g')
subplot(3,2,1), plot(1:length(M1),M1,'b'), hold on, plot(1:length(M2),M2,'r'),ylabel('bulb'), hold on, plot(tPeaks1+deb2-1,Peaks1,'ko','markerfacecolor','b'), plot(tPeaks2+deb2-1,Peaks2,'ko','markerfacecolor','r'), plot(tTrough1+deb2-1,Trough1,'ko','markerfacecolor','c'), plot(tTrough2+deb2-1,Trough2,'ko','markerfacecolor','w')
[Cr,lag]=xcorr_mobs(M1(deb:fin),M2(deb:fin),6);
[Ma,idM]=max(abs(Cr(find(abs(lag)<5))));lag2=lag(find(abs(lag)<5));Cr2=Cr(find(abs(lag)<5));
[r,p]=corrcoef(M1(deb:fin),M2(deb:fin)); R0=r(1,2);P0=p(1,2);
Cor(1)=R0;
P(1)=P0;
title([num2str(Cr2(idM)),', ',num2str(floor(lag2(idM))),', correlation: ',num2str(R0),', ',num2str(P0)])
Cros(1)=Cr2(idM);
hold on, line([deb deb],ylim,'color','k')
hold on, line([fin fin],ylim,'color','k')


M1=mETAverage(z1,1:length(SignalRespi),SignalRespi,1,100);
M2=mETAverage(z1,1:length(SignalPfc),SignalPfc,1,100);

[tPeaks1,Peaks1]=FindMaxPeaks([1:length(M1(deb2:fin2));M1(deb2:fin2)']');
[tPeaks2,Peaks2]=FindMaxPeaks([1:length(M2(deb2:fin2));M2(deb2:fin2)']');
% dPeaks(3)=spkd(tPeaks1,tPeaks2,paramDis);
[tTrough1,Trough1]=FindMinPeaks([1:length(M1(deb2:fin2));M1(deb2:fin2)']');
[tTrough2,Trough2]=FindMinPeaks([1:length(M2(deb2:fin2));M2(deb2:fin2)']');
% dThroughs(3)=spkd(tTrough1,tTrough2,paramDis);

dPeaks(3)=labdist_faster(tPeaks2,[1:length(tPeaks2)],tPeaks2,[1:length(tPeaks2)],paramDis1,paramDis2);
dThroughs(3)=labdist_faster(tTrough1,[1:length(tTrough1)],tTrough2,[1:length(tTrough2)],paramDis1,paramDis2);

% subplot(3,2,3), plotyy(1:length(M1),M1,1:length(M2),M2),ylabel('Pfc'),
% hold on, plot(tPeaks1+deb2-1,Peaks1,'ko','markerfacecolor','b'), plot(tPeaks2+deb2-1,Peaks2,'ko','markerfacecolor','g'), plot(tTrough1+deb2-1,Trough1,'ko','markerfacecolor','b'), plot(tTrough2+deb2-1,Trough2,'ko','markerfacecolor','g')
subplot(3,2,3), plot(1:length(M1),M1,'b'), hold on, plot(1:length(M2),M2,'r'),ylabel('Pfc'), hold on, plot(tPeaks1+deb2-1,Peaks1,'ko','markerfacecolor','b'), plot(tPeaks2+deb2-1,Peaks2,'ko','markerfacecolor','r'), plot(tTrough1+deb2-1,Trough1,'ko','markerfacecolor','c'), plot(tTrough2+deb2-1,Trough2,'ko','markerfacecolor','w')
%[Cr,lag]=xcorr(M1(deb:fin),M2(deb:fin),'coeff');
[Cr,lag]=xcorr_mobs(M1(deb:fin),M2(deb:fin),6);
[Ma,idM]=max(abs(Cr(find(abs(lag)<5))));lag2=lag(find(abs(lag)<5));Cr2=Cr(find(abs(lag)<5));
[r,p]=corrcoef(M1(deb:fin),M2(deb:fin)); R0=r(1,2);P0=p(1,2);
Cor(3)=R0;
P(3)=P0;
Cros(3)=Cr2(idM);
title([num2str(Cr2(idM)),', ',num2str(floor(lag2(idM))),', correlation: ',num2str(R0),', ',num2str(P0)])
hold on, line([deb deb],ylim,'color','k')
hold on, line([fin fin],ylim,'color','k')


M1=mETAverage(z1,1:length(SignalRespi),SignalRespi,1,100);
M2=mETAverage(z1,1:length(SignalPar),SignalPar,1,100);

[tPeaks1,Peaks1]=FindMaxPeaks([1:length(M1(deb2:fin2));M1(deb2:fin2)']');
[tPeaks2,Peaks2]=FindMaxPeaks([1:length(M2(deb2:fin2));M2(deb2:fin2)']');
% dPeaks(5)=spkd(tPeaks1,tPeaks2,paramDis);
[tTrough1,Trough1]=FindMinPeaks([1:length(M1(deb2:fin2));M1(deb2:fin2)']');
[tTrough2,Trough2]=FindMinPeaks([1:length(M2(deb2:fin2));M2(deb2:fin2)']');
% dThroughs(5)=spkd(tTrough1,tTrough2,paramDis);

dPeaks(5)=labdist_faster(tPeaks2,[1:length(tPeaks2)],tPeaks2,[1:length(tPeaks2)],paramDis1,paramDis2);
dThroughs(5)=labdist_faster(tTrough1,[1:length(tTrough1)],tTrough2,[1:length(tTrough2)],paramDis1,paramDis2);

% 
% subplot(3,2,5), plotyy(1:length(M1),M1,1:length(M2),M2),title('Par'), hold on, plot(tPeaks1+deb2-1,Peaks1,'ko','markerfacecolor','b'), plot(tPeaks2+deb2-1,Peaks2,'ko','markerfacecolor','g'), plot(tTrough1+deb2-1,Trough1,'ko','markerfacecolor','b'), plot(tTrough2+deb2-1,Trough2,'ko','markerfacecolor','g')
subplot(3,2,5), plot(1:length(M1),M1,'b'), hold on, plot(1:length(M2),M2,'r'),title('Par'), hold on, plot(tPeaks1+deb2-1,Peaks1,'ko','markerfacecolor','b'), plot(tPeaks2+deb2-1,Peaks2,'ko','markerfacecolor','r'), plot(tTrough1+deb2-1,Trough1,'ko','markerfacecolor','c'), plot(tTrough2+deb2-1,Trough2,'ko','markerfacecolor','w')
%[Cr,lag]=xcorr(M1(deb:fin),M2(deb:fin),'coeff');
[Cr,lag]=xcorr_mobs(M1(deb:fin),M2(deb:fin),6);
[Ma,idM]=max(abs(Cr(find(abs(lag)<5))));lag2=lag(find(abs(lag)<5));Cr2=Cr(find(abs(lag)<5));
[r,p]=corrcoef(M1(deb:fin),M2(deb:fin)); R0=r(1,2);P0=p(1,2);
Cor(5)=R0;
P(5)=P0;
Cros(5)=Cr2(idM);
title([num2str(Cr2(idM)),', ',num2str(floor(lag2(idM))),', correlation: ',num2str(R0),', ',num2str(P0)])
hold on, line([deb deb],ylim,'color','k')
hold on, line([fin fin],ylim,'color','k')


M1=mETAverage(z2,1:length(SignalRespi),SignalRespi,1,100);
M2=mETAverage(z2,1:length(SignalBO),SignalBO,1,100);

[tPeaks1,Peaks1]=FindMaxPeaks([1:length(M1(deb2:fin2));M1(deb2:fin2)']');
[tPeaks2,Peaks2]=FindMaxPeaks([1:length(M2(deb2:fin2));M2(deb2:fin2)']');
% dPeaks(2)=spkd(tPeaks1,tPeaks2,paramDis);
[tTrough1,Trough1]=FindMinPeaks([1:length(M1(deb2:fin2));M1(deb2:fin2)']');
[tTrough2,Trough2]=FindMinPeaks([1:length(M2(deb2:fin2));M2(deb2:fin2)']');
% dThroughs(2)=spkd(tTrough1,tTrough2,paramDis);

dPeaks(2)=labdist_faster(tPeaks2,[1:length(tPeaks2)],tPeaks2,[1:length(tPeaks2)],paramDis1,paramDis2);
dThroughs(2)=labdist_faster(tTrough1,[1:length(tTrough1)],tTrough2,[1:length(tTrough2)],paramDis1,paramDis2);


% subplot(3,2,2), plotyy(1:length(M1),M1,1:length(M2),M2), hold on,
% plot(tPeaks1+deb2-1,Peaks1,'ko','markerfacecolor','b'), plot(tPeaks2+deb2-1,Peaks2,'ko','markerfacecolor','g'), plot(tTrough1+deb2-1,Trough1,'ko','markerfacecolor','b'), plot(tTrough2+deb2-1,Trough2,'ko','markerfacecolor','g')
subplot(3,2,2), plot(1:length(M1),M1,'b'), hold on, plot(1:length(M2),M2,'r'), hold on, plot(tPeaks1+deb2-1,Peaks1,'ko','markerfacecolor','b'), plot(tPeaks2+deb2-1,Peaks2,'ko','markerfacecolor','r'), plot(tTrough1+deb2-1,Trough1,'ko','markerfacecolor','c'), plot(tTrough2+deb2-1,Trough2,'ko','markerfacecolor','w')
%[Cr,lag]=xcorr(M1(deb:fin),M2(deb:fin),'coeff');
[Cr,lag]=xcorr_mobs(M1(deb:fin),M2(deb:fin),6);
[Ma,idM]=max(abs(Cr(find(abs(lag)<5))));lag2=lag(find(abs(lag)<5));Cr2=Cr(find(abs(lag)<5));
[r,p]=corrcoef(M1(deb:fin),M2(deb:fin)); R0=r(1,2);P0=p(1,2);
Cor(2)=R0;
P(2)=P0;
Cros(2)=Cr2(idM);
title([num2str(Cr2(idM)),', ',num2str(floor(lag2(idM))),', correlation: ',num2str(R0),', ',num2str(P0)])
hold on, line([deb deb],ylim,'color','k')
hold on, line([fin fin],ylim,'color','k')


M1=mETAverage(z2,1:length(SignalRespi),SignalRespi,1,100);
M2=mETAverage(z2,1:length(SignalPfc),SignalPfc,1,100);

[tPeaks1,Peaks1]=FindMaxPeaks([1:length(M1(deb2:fin2));M1(deb2:fin2)']');
[tPeaks2,Peaks2]=FindMaxPeaks([1:length(M2(deb2:fin2));M2(deb2:fin2)']');
% dPeaks(4)=spkd(tPeaks1,tPeaks2,paramDis);
[tTrough1,Trough1]=FindMinPeaks([1:length(M1(deb2:fin2));M1(deb2:fin2)']');
[tTrough2,Trough2]=FindMinPeaks([1:length(M2(deb2:fin2));M2(deb2:fin2)']');
% dThroughs(4)=spkd(tTrough1,tTrough2,paramDis);

dPeaks(4)=labdist_faster(tPeaks2,[1:length(tPeaks2)],tPeaks2,[1:length(tPeaks2)],paramDis1,paramDis2);
dThroughs(4)=labdist_faster(tTrough1,[1:length(tTrough1)],tTrough2,[1:length(tTrough2)],paramDis1,paramDis2);


% subplot(3,2,4), plotyy(1:length(M1),M1,1:length(M2),M2), hold on, plot(tPeaks1+deb2-1,Peaks1,'ko','markerfacecolor','b'), plot(tPeaks2+deb2-1,Peaks2,'ko','markerfacecolor','g'), plot(tTrough1+deb2-1,Trough1,'ko','markerfacecolor','c'), plot(tTrough2+deb2-1,Trough2,'ko','markerfacecolor','m')
subplot(3,2,4), plot(1:length(M1),M1,'b'), hold on, plot(1:length(M2),M2,'r'), hold on, plot(tPeaks1+deb2-1,Peaks1,'ko','markerfacecolor','b'), plot(tPeaks2+deb2-1,Peaks2,'ko','markerfacecolor','r'), plot(tTrough1+deb2-1,Trough1,'ko','markerfacecolor','c'), plot(tTrough2+deb2-1,Trough2,'ko','markerfacecolor','w')
%[Cr,lag]=xcorr(M1(deb:fin),M2(deb:fin),'coeff');
[Cr,lag]=xcorr_mobs(M1(deb:fin),M2(deb:fin),6);
[Ma,idM]=max(abs(Cr(find(abs(lag)<5))));lag2=lag(find(abs(lag)<5));Cr2=Cr(find(abs(lag)<5));
[r,p]=corrcoef(M1(deb:fin),M2(deb:fin)); R0=r(1,2);P0=p(1,2);
Cor(4)=R0;
P(4)=P0;
Cros(4)=Cr2(idM);
title([num2str(Cr2(idM)),', ',num2str(floor(lag2(idM))),', correlation: ',num2str(R0),', ',num2str(P0)])
hold on, line([deb deb],ylim,'color','k')
hold on, line([fin fin],ylim,'color','k')


M1=mETAverage(z2,1:length(SignalRespi),SignalRespi,1,100);
M2=mETAverage(z2,1:length(SignalPar),SignalPar,1,100);

[tPeaks1,Peaks1]=FindMaxPeaks([1:length(M1(deb2:fin2));M1(deb2:fin2)']');
[tPeaks2,Peaks2]=FindMaxPeaks([1:length(M2(deb2:fin2));M2(deb2:fin2)']');
% dPeaks(6)=spkd(tPeaks1,tPeaks2,paramDis);
[tTrough1,Trough1]=FindMinPeaks([1:length(M1(deb2:fin2));M1(deb2:fin2)']');
[tTrough2,Trough2]=FindMinPeaks([1:length(M2(deb2:fin2));M2(deb2:fin2)']');
% dThroughs(6)=spkd(tTrough1,tTrough2,paramDis);

dPeaks(6)=labdist_faster(tPeaks2,[1:length(tPeaks2)],tPeaks2,[1:length(tPeaks2)],paramDis1,paramDis2);
dThroughs(6)=labdist_faster(tTrough1,[1:length(tTrough1)],tTrough2,[1:length(tTrough2)],paramDis1,paramDis2);

% subplot(3,2,6), plotyy(1:length(M1),M1,1:length(M2),M2), hold on, plot(tPeaks1+deb2-1,Peaks1,'ko','markerfacecolor','b'), plot(tPeaks2+deb2-1,Peaks2,'ko','markerfacecolor','g'), plot(tTrough1+deb2-1,Trough1,'ko','markerfacecolor','b'), plot(tTrough2+deb2-1,Trough2,'ko','markerfacecolor','g')
subplot(3,2,6), plot(1:length(M1),M1,'b'), hold on, plot(1:length(M2),M2,'r'), hold on, plot(tPeaks1+deb2-1,Peaks1,'ko','markerfacecolor','b'), plot(tPeaks2+deb2-1,Peaks2,'ko','markerfacecolor','r'), plot(tTrough1+deb2-1,Trough1,'ko','markerfacecolor','c'), plot(tTrough2+deb2-1,Trough2,'ko','markerfacecolor','w')
%[Cr,lag]=xcorr(M1(deb:fin),M2(deb:fin),'coeff');
[Cr,lag]=xcorr_mobs(M1(deb:fin),M2(deb:fin),6);
[Ma,idM]=max(abs(Cr(find(abs(lag)<5))));lag2=lag(find(abs(lag)<5));Cr2=Cr(find(abs(lag)<5));
[r,p]=corrcoef(M1(deb:fin),M2(deb:fin)); R0=r(1,2);P0=p(1,2);
Cor(6)=R0;
P(6)=P0;
Cros(6)=Cr2(idM);
title([num2str(Cr2(idM)),', ',num2str(floor(lag2(idM))),', correlation: ',num2str(R0),', ',num2str(P0)])
hold on, line([deb deb],ylim,'color','k')
hold on, line([fin fin],ylim,'color','k')
