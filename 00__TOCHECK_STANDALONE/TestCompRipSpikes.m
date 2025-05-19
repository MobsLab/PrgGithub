function [R,P]=TestCompRipSpikes(S,LFP,ripples,k)

% k=2;


tet{1}=1:7;
tet{2}=2:29;
tet{3}=30:45;
tet{4}=46:70;
tet{5}=71:75;
tet{6}=76:82;
tet{7}=83:92;
tet{8}=93:99;
tet{9}=100:108;
tet{10}=109:123;
tet{11}=124:148;
tet{12}=149:169;



figure, [fh, rasterAx, histAx, matValRip] = ImagePETH(LFP{53}, ts(ripples(:,2)*1E4), -2000, +2000,'BinSize',10);
close

MRip=Data(matValRip);
tpsRip=Range(matValRip);
MRipf=FilterLFP(tsdArray(tsd(tpsRip,MRip)),[100 250],12);
H=hilbert(Data(MRipf{1}));
Ha=abs(H);
si=size(Ha,1);
Val=mean(Ha(floor(si/2)-25:floor(si/2)+25,:));


Qs = MakeQfromS(tsdArray(poolNeurons(S,tet{k})),50);
ratek=Qs;
rate = Data(ratek);
ratek = tsd(Range(ratek),rate);
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(ratek, ts((ripples(:,2)*1E4)), -1000, +1000,'BinSize',10);
close

M=Data(matVal);
si=size(M,1);
Val2=sum(M(floor(si/2)-4:floor(si/2)+4,:));
%Val2=sum(M(18:24,:));


figure, 
subplot(3,4,[[1:2],[5:6]]),plot(Val,Val2,'k.')
xl=xlim;
xlim([0 xl(2)+200])
[r,p]=corrcoef(Val,Val2);
R=r(2,1);
P=p(2,1);

[BE,id]=sort(Val);
subplot(3,4,[9,10]),plot(Val(id)./max(Val),'k'), hold on, plot(Val2(id)./max(Val2),'r')


subplot(3,4,[3,7,11]),imagesc(SmoothDec(M(:,id)',[0.05,1])),axis xy
subplot(3,4,[4,8,12]),imagesc(Ha(:,id)'),axis xy

