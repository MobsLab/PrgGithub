%ReviewPLosOne
%tic

%--------------------------------------------------------------------------

%num=2;
ch=[24,29,35,37,58,1,9,13,17,45,49,53,61];

Cortex=[24,29,35,37]; 
Inter=[45,49,53,58];
Hpc=[1,9,13,17,61];

try 
    LFP2;
    LFP=LFP2;
    ch=1:length(LFP2);
end

for k=5%1:length(ch)%7R

    close all
    
num=ch(k);

disp(' ')
disp(['channel: ',num2str(num)])
disp(' ')

%--------------------------------------------------------------------------

filtParam=0.25;
VitTH=40;

%--------------------------------------------------------------------------

% Epoch=intervalSet(1900*1E4,2000*1E4);
Epoch=intervalSet(1555*1E4,1745*1E4);

%--------------------------------------------------------------------------


lfp=ResampleTSD(Restrict(LFP{num},Epoch),250);

Fil =FilterLFP(Restrict(lfp,Epoch),[6 12],1024);
th=tsd(Range(Fil),abs(hilbert(Data(Fil))));

X2=ResampleTSD(X,630);
Y2=ResampleTSD(Y,630);

V2=ResampleTSD(V,630);
V2=FilterLFP(V2,[0.000001 filtParam],2048);


Ac=diff(Data(V2));
Ac(length(Ac)+1)=Ac(end);
Ac=tsd(Range(V2),Ac);
AC=ResampleTSD(Ac,630);
AC=FilterLFP(AC,[0.000001 filtParam],2048);

TH=ResampleTSD(th,630);



% figure, scatter(Data(Restrict(X2,Epoch)),Data(Restrict(Y2,Epoch)),30,Data(Restrict(V2,Epoch)),'filled'), title('Speed')
% figure, scatter(Data(Restrict(X2,Epoch)),Data(Restrict(Y2,Epoch)),30,Data(Restrict(AC,Epoch)),'filled'), title('Acceleration')
% figure, scatter(Data(Restrict(X2,Epoch)),Data(Restrict(Y2,Epoch)),30,1:length(Data(Restrict(V2,Epoch))),'filled'), title('time')

figure('color',[1 1 1]), hold on
plot(Range(Restrict(lfp,Epoch)),Data(Restrict(lfp,Epoch)),'linewidth',1)
plot(Range(Restrict(Fil,Epoch)),Data(Restrict(Fil,Epoch)),'r','linewidth',1)
plot(Range(Restrict(TH,Epoch)),Data(Restrict(TH,Epoch)),'m','linewidth',2)
plot(Range(Restrict(V2,Epoch)),Data(Restrict(V2,Epoch))*40,'k','linewidth',2)
plot(Range(Restrict(X2,Epoch)),Data(Restrict(X2,Epoch))*40,'color',[0.7 0.7 0.7],'linewidth',2)
plot(Range(Restrict(AC,Epoch)),Data(Restrict(AC,Epoch))*1000,'g','linewidth',2)


figure, subplot(2,2,1),scatter(Data(Restrict(X2,Epoch)),Data(Restrict(Y2,Epoch)),30,Data(Restrict(V2,Epoch)),'filled'), colorbar,title('Speed')
subplot(2,2,2),scatter(Data(Restrict(X2,Epoch)),Data(Restrict(Y2,Epoch)),30,Data(Restrict(AC,Epoch)),'filled'), colorbar,title('Acceleration')
%figure, scatter(Data(Restrict(X2,Epoch)),Data(Restrict(Y2,Epoch)),30,1:length(Data(Restrict(V2,Epoch))),'filled'), title('time')

Mouv=thresholdIntervals(V2,VitTH,'Direction','Above');

subplot(2,2,3),scatter(Data(Restrict(X2,and(Epoch,Mouv))),Data(Restrict(Y2,and(Epoch,Mouv))),30,Data(Restrict(V2,and(Epoch,Mouv))),'filled'), colorbar,title('Speed')
subplot(2,2,4),scatter(Data(Restrict(X2,and(Epoch,Mouv))),Data(Restrict(Y2,and(Epoch,Mouv))),30,Data(Restrict(AC,and(Epoch,Mouv))),'filled'), colorbar,title('Acceleration')
%figure, scatter(Data(Restrict(X2,Epoch)),Data(Restrict(Y2,Epoch)),30,1:length(Data(Restrict(V2,Epoch))),'filled'), title('time')

params.Fs=1/median(diff(Range(lfp,'s')));
params.tapers=[3 5];
params.pad=1;
params.fpass=[0 25];
[S,f]=mtspectrumc(Data(Restrict(lfp,Epoch)),params);
[S2,f2]=mtspectrumc(Data(Restrict(lfp,and(Epoch,Mouv))),params);
figure, plot(f,SmoothDec(S,3)),hold on,plot(f2,SmoothDec(S2,3),'r'),title(num2str(num))


THe=Restrict(TH,and(Epoch,Mouv));

val1=Data(Restrict(V2,THe));
val2=Data(Restrict(AC,THe));
val3=Data(THe);

val1(isnan(val1))=[];
val2(isnan(val1))=[];
val3(isnan(val1))=[];

val1(isnan(val2))=[];
val2(isnan(val2))=[];
val3(isnan(val2))=[];

val1(isnan(val3))=[];
val2(isnan(val3))=[];
val3(isnan(val3))=[];

try
    le=size(R,1);
catch
    le=0;
end

[r1,p1]=corrcoef(val1,val3);%R(1+le,:)=[1 filtParam VitTH num r(2,1) r(2,1)^2 p(2,1)];
[r2,p2]=corrcoef(val2(val2>0),val3(val2>0));%R(2+le,:)=[2 filtParam VitTH num r(2,1) r(2,1)^2 p(2,1)];
[r3,p3]=corrcoef(val2(val2<0),val3(val2<0));%R(3+le,:)=[3 filtParam VitTH num r(2,1) r(2,1)^2 p(2,1)];

R(1+le,:)=[2 filtParam VitTH num mean(S(f>7.5&f<8.5))/1E5 mean(S2(f2>7.5&f2<8.5))/1E5 r1(2,1) r2(2,1) r3(2,1) r1(2,1)^2 r2(2,1)^2 r3(2,1)^2 p1(2,1) p2(2,1) p3(2,1)];


figure, subplot(2,1,1), plot(Data(Restrict(V2,THe)),Data(THe), 'k.')
subplot(2,1,2), plot(Data(Restrict(AC,THe)),Data(THe), 'k.')

[r,p,var,accumulated,MAP]=PlotCorrelationDensity(Restrict(V2,THe),THe,100,0,350);
[r,p,var,accumulated,MAP]=PlotCorrelationDensity(val2(val2>0),val3(val2>0),100,0,350);
[r,p,var,accumulated,MAP]=PlotCorrelationDensity(val2(val2<0),val3(val2<0),100,0,350);

end

%toc
figure, scatter(R(:,8),R(:,9),40,R(:,6)-R(:,5),'filled'), hold on, line([-0.5 0.3],[-0.5 0.3],'color','r')
figure, scatter(R(:,11),R(:,12),40,R(:,6)-R(:,5),'filled'), hold on, line([0 0.12],[0 0.12],'color','r'), colorbar
figure, scatter(R(:,6),R(:,6)-R(:,5),40,R(:,3),'filled')
