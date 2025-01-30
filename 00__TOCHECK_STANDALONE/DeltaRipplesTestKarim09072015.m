
load RipplesdHPC25
load newDeltaPFCx
Dpfc=ts(tDelta);
load newDeltaPaCx
Dpac=ts(tDelta);
load SpikeData
load StateEpochSB SWSEpoch REMEpoch Wake

[Spfc,NumNeurons]=GetSpikesFromStructure('PFCx');


limDownBurst=0.6; %0.6
binSize=10;
limSizDown=75;


[Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons,SWSEpoch,binSize,0.01,1,0,[0 limSizDown],0);
%[Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons,SWSEpoch,binSize,0.01,1,0,[20 limSizDown],0);

Down=and(Down,SWSEpoch);


rip=dHPCrip(:,2)*1E4;
% 
% rip=ts(dHPCrip(:,2)*1E4);
% rip=Range(Restrict(rip,SWSEpoch-Down));



st=Start(Down,'s');
en=End(Down,'s');
mid=st+(en-st)/2;

inter=en(1:end-1)-st(2:end);

id=find(diff(st)<limDownBurst);
id2=find(diff(st)>limDownBurst);

% id=find(diff(inter)<limDownBurst);
% id2=find(diff(inter)>limDownBurst);
% id1=id1(id1>1)+1;
% id2=id2(id2>1)+1;

smo=2;bin1=5;bin2=400;

idx=id;
[A,B,C]=mjPETH(rip,st(idx)*1E4,en(idx)*1E4,bin1,bin2,smo,2);close
figure('color',[1 1 1]), 
subplot(3,3,[4 5 7 8]), imagesc(B,B,SmoothDec(A(:,end:-1:1),[smo,smo])),axis xy, yl=ylim;  xl=xlim;line([0 0],yl,'color','w'),line(xl,[0 0],'color','w')
[C,B]=CrossCorr(st(idx)*1E4,rip,bin1,bin2);
subplot(3,3,1:2), plot(B,SmoothDec(C,smo),'k','linewidth',2), xlim([B(1),B(end)]), yl=ylim; line([0 0],yl,'color','r')
[C,B]=CrossCorr(en(idx)*1E4,rip,bin1,bin2);
subplot(3,3,[6 9]), plot(SmoothDec(C(end:-1:1),smo),B,'k','linewidth',2), ylim([B(1),B(end)]), xl=xlim; line(xl,[0 0],'color','r')


idx=id2;

[A,B,C]=mjPETH(rip,st(idx)*1E4,en(idx)*1E4,bin1,bin2,smo,2);close
figure('color',[1 1 1]), 
subplot(3,3,[4 5 7 8]), imagesc(B,B,SmoothDec(A(:,end:-1:1),[smo,smo])),axis xy, yl=ylim;  xl=xlim;line([0 0],yl,'color','w'),line(xl,[0 0],'color','w')
[C,B]=CrossCorr(st(idx)*1E4,rip,bin1,bin2);
subplot(3,3,1:2), plot(B,SmoothDec(C,smo),'k','linewidth',2), xlim([B(1),B(end)]), yl=ylim; line([0 0],yl,'color','r')
[C,B]=CrossCorr(en(idx)*1E4,rip,bin1,bin2);
subplot(3,3,[6 9]), plot(SmoothDec(C(end:-1:1),smo),B,'k','linewidth',2), ylim([B(1),B(end)]), xl=xlim; line(xl,[0 0],'color','r')

%st=mid;

tps=st;

[M1,T1]=PlotRipRaw(Qt,tps(id),3000,1);close
[M2,T2]=PlotRipRaw(Qt,tps(id2),3000,1);close

[BE,idx1]=sort(mean(T1(:,320:340),2));
[BE,idx2]=sort(mean(T2(:,320:340),2));

[BE,idx1]=sort(inter(id));
[BE,idx2]=sort(inter(id2));


[C1,B1]=CrossCorr(tps(id)*1E4,rip,10,600);
[C2,B2]=CrossCorr(tps(id2)*1E4,rip,10,600);

[C,B]=CrossCorr(tps*1E4,tps*1E4,10,600);C(B==0)=0;
[Ca,Ba]=CrossCorr(tps(id)*1E4,tps(id)*1E4,10,600);Ca(Ba==0)=0;
[Cb,Bb]=CrossCorr(tps(id2)*1E4,tps(id2)*1E4,10,600);Cb(Bb==0)=0;

figure('color',[1 1 1]), subplot(2,2,1:2), hold on, plot(M1(:,1),M1(:,2),'b'),plot(M2(:,1),M2(:,2),'r')
subplot(2,2,3), imagesc(T1(idx1,:))
subplot(2,2,4), imagesc(T2(idx2,:))

smo=5;

figure('color',[1 1 1]), 
subplot(4,1,1), 
hold on, plot(B/1E3,C,'k'),plot(Ba/1E3,Ca,'b'),plot(Bb/1E3,Cb,'m'), ylim([0 5])
subplot(4,1,2), 
hold on, plot(M1(:,1),M1(:,2),'b'),plot(M2(:,1),M2(:,2),'m')
subplot(4,1,3), 
hold on, plot(M1(:,1),M1(:,2),'b'),plot(M2(:,1),M2(:,2),'m')
plot(B1/1E3,smooth(C1/10,smo),'k'), hold on, plot(B2/1E3,smooth(C2/10,smo),'r'), xlim([-3 3])
subplot(4,1,4), 
plot(B1/1E3,C1,'k'), hold on, plot(B2/1E3,C2,'r')



tps=en;

[M1,T1]=PlotRipRaw(Qt,tps(id),3000,1);close
[M2,T2]=PlotRipRaw(Qt,tps(id2),3000,1);close

[BE,idx1]=sort(mean(T1(:,320:340),2));
[BE,idx2]=sort(mean(T2(:,320:340),2));

[BE,idx1]=sort(inter(id));
[BE,idx2]=sort(inter(id2));


[C1,B1]=CrossCorr(tps(id)*1E4,rip,10,600);
[C2,B2]=CrossCorr(tps(id2)*1E4,rip,10,600);

[C,B]=CrossCorr(tps*1E4,tps*1E4,10,600);C(B==0)=0;
[Ca,Ba]=CrossCorr(tps(id)*1E4,tps(id)*1E4,10,600);Ca(Ba==0)=0;
[Cb,Bb]=CrossCorr(tps(id2)*1E4,tps(id2)*1E4,10,600);Cb(Bb==0)=0;

figure('color',[1 1 1]), subplot(2,2,1:2), hold on, plot(M1(:,1),M1(:,2),'b'),plot(M2(:,1),M2(:,2),'r')
subplot(2,2,3), imagesc(T1(idx1,:))
subplot(2,2,4), imagesc(T2(idx2,:))

smo=5;

figure('color',[1 1 1]), 
subplot(4,1,1), 
hold on, plot(B/1E3,C,'k'),plot(Ba/1E3,Ca,'b'),plot(Bb/1E3,Cb,'m'), ylim([0 5])
subplot(4,1,2), 
hold on, plot(M1(:,1),M1(:,2),'b'),plot(M2(:,1),M2(:,2),'m')
subplot(4,1,3), 
hold on, plot(M1(:,1),M1(:,2),'b'),plot(M2(:,1),M2(:,2),'m')
plot(B1/1E3,smooth(C1/10,smo),'k'), hold on, plot(B2/1E3,smooth(C2/10,smo),'r'), xlim([-3 3])
subplot(4,1,4), 
plot(B1/1E3,C1,'k'), hold on, plot(B2/1E3,C2,'r')


 load ChannelsToAnalyse/PFCx_deep
    eval(['load LFPData/LFP',num2str(channel)])
    LFPd=LFP;
    clear LFP
    
   load ChannelsToAnalyse/PFCx_sup
    eval(['load LFPData/LFP',num2str(channel)])
    LFPs=LFP;
    clear LFP


[MripDt,TripDt]=PlotRipRaw(LFPd,rip/1E4,800);close
[MripSt,TripSt]=PlotRipRaw(LFPs,rip/1E4,800);close

[MdeltaD,TdeltaD]=PlotRipRaw(LFPd,Range(Dpfc,'s'),800);close
[MdeltaS,TdeltaS]=PlotRipRaw(LFPs,Range(Dpfc,'s'),800);close


figure('color',[1 1 1]),
subplot(2,1,1), plot(MripDt(:,1), MripDt(:,2),'k'), hold on, plot(MripSt(:,1), MripSt(:,2),'r'),
subplot(2,1,2), plot(MdeltaD(:,1), MdeltaD(:,2),'k'), hold on, plot(MdeltaS(:,1), MdeltaS(:,2),'r'),



rip2=ts(rip);
EpochPreDelta=intervalSet(Range(Dpfc)-0.5E4,Range(Dpfc));
EpochPostDelta=intervalSet(Range(Dpfc),Range(Dpfc)+0.5E4);
EpochPreDelta=mergeCloseIntervals(EpochPreDelta,10);
EpochPostDelta=mergeCloseIntervals(EpochPostDelta,10);

[MripNoD,TripNoD]=PlotRipRaw(LFPd,Range(Restrict(rip2,SWSEpoch-EpochPreDelta-EpochPostDelta),'s'),800);close
[MripNoS,TripNoS]=PlotRipRaw(LFPs,Range(Restrict(rip2,SWSEpoch-EpochPreDelta-EpochPostDelta),'s'),800);close

[MripD,TripD]=PlotRipRaw(LFPd,Range(Restrict(rip2,or(EpochPreDelta,EpochPostDelta)),'s'),800);close
[MripS,TripS]=PlotRipRaw(LFPs,Range(Restrict(rip2,or(EpochPreDelta,EpochPostDelta)),'s'),800);close

[MripPrD,TripPrD]=PlotRipRaw(LFPd,Range(Restrict(rip2,EpochPreDelta),'s'),800);close
[MripPrS,TripPrS]=PlotRipRaw(LFPs,Range(Restrict(rip2,EpochPreDelta),'s'),800);close

[MripPoD,TripPoD]=PlotRipRaw(LFPd,Range(Restrict(rip2,EpochPostDelta),'s'),800);close
[MripPoS,TripPoS]=PlotRipRaw(LFPs,Range(Restrict(rip2,EpochPostDelta),'s'),800);close

le=size(MripNoD(:,2),1)-50;

figure('color',[1 1 1]),
subplot(4,2,1), plot(MripNoD(:,1), MripNoD(:,2),'b'), hold on, plot(MripNoS(:,1), MripNoS(:,2),'m'), yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7]), ylim([-400 400])
subplot(4,2,2), plot(MripNoD(:,1), MripNoD(:,2)-MripNoD(floor(le/2),2),'b'), hold on, plot(MripNoS(:,1), MripNoS(:,2)-MripNoS(floor(le/2),2),'m'), yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7]), ylim([-400 400])

subplot(4,2,3), plot(MripD(:,1), MripD(:,2),'b'), hold on, plot(MripS(:,1), MripS(:,2),'m'), yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7]), ylim([-400 400])
subplot(4,2,4), plot(MripD(:,1), MripD(:,2)-MripD(floor(le/2),2),'b'), hold on, plot(MripS(:,1), MripS(:,2)-MripS(floor(le/2),2),'m'), yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7]), ylim([-400 400])

subplot(4,2,5), plot(MripPrD(:,1), MripPrD(:,2),'k'), hold on, plot(MripPrS(:,1), MripPrS(:,2),'r'), yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7]), ylim([-400 400])
subplot(4,2,6), plot(MripPrD(:,1), MripPrD(:,2)-MripPrD(floor(le/2),2),'k'), hold on, plot(MripPrS(:,1), MripPrS(:,2)-MripPrS(floor(le/2),2),'r'), yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7]), ylim([-300 300])

subplot(4,2,7), plot(MripPoD(:,1), MripPoD(:,2),'k'), hold on, plot(MripPoS(:,1), MripPoS(:,2),'r'), yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7]), ylim([-400 400])
subplot(4,2,8), plot(MripPoD(:,1), MripPoD(:,2)-MripPoD(floor(le/2),2),'k'), hold on, plot(MripPoS(:,1), MripPoS(:,2)-MripPoS(floor(le/2),2),'r'), yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7]), ylim([-400 400])


a=1;
for i=1:length(Start(SWSEpoch))
rip3=Restrict(rip2,subset(SWSEpoch,i));
[Cspk(a,:),Bspk]=CrossCorr(Range(Restrict(rip3,or(EpochPreDelta,EpochPostDelta))),Range(PoolNeurons(S,NumNeurons)),50,100);
[Cspk2(a,:),Bspk2]=CrossCorr(Range(Restrict(rip3,subset(SWSEpoch,i)-EpochPreDelta-EpochPostDelta)),Range(PoolNeurons(S,NumNeurons)),50,100);

if length(find(isnan(Cspk2(a,:))))==0 & length(find(isnan(Cspk2(a,:))))==0
a=a+1;
end

end

figure, plot(Bspk/1E3,Cspk,'k'), hold on, plot(Bspk2/1E3,Cspk2,'r'), yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])


