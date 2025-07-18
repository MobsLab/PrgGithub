function Res=plotSingleLocalGlobalLight(LFP, elec, th, smo,LFPnames)


thNoise=950;

try 
    LFPnames;
catch
    LFPnames{elec}=['Ch ',num2str(elec)];
end


load Newstim


rg=Range(LFP{elec});
Epoch=intervalSet(rg(1),rg(end));


badEpochUp=thresholdIntervals(LFP{elec},th,'Direction','Above');
badEpochDown=thresholdIntervals(LFP{elec},-th,'Direction','Below');
badEpochTemp=or(badEpochUp,badEpochDown);

badEpoch=intervalSet(max(Start(badEpochTemp)-1*1E4,0), min(End(badEpochTemp)+1*1E4,rg(end)));
badEpoch=mergeCloseIntervals(badEpoch,1E2);


Fil=FilterLFP(LFP{10},[200 500],1024);
Fil=FilterLFP(LFP{elec},[200 500],1024);

badEpochUp2=thresholdIntervals(Fil,thNoise,'Direction','Above');
badEpochDown2=thresholdIntervals(Fil,-thNoise,'Direction','Below');
badEpochTemp2=or(badEpochUp2,badEpochDown2);
badEpochTemp2=dropShortIntervals(badEpochTemp2,15);
badEpoch2=intervalSet(max(Start(badEpochTemp2)-2*1E4,0), min(End(badEpochTemp2)+2*1E4,rg(end)));
badEpoch2=mergeCloseIntervals(badEpoch2,1E4);

GoodEpoch=Epoch-badEpoch;

try
GoodEpoch=GoodEpoch-badEpoch2;
end

GoodEpoch=mergeCloseIntervals(GoodEpoch,100);

        
[a1,b1,c1] = mETAverage(Range(Restrict(ts(sort(TlocalSTD)),GoodEpoch)),Range(LFP{elec}),Data(LFP{elec}),1,2000);
[a2,b2,c2] = mETAverage(Range(Restrict(ts(sort(TlocalDEV)),GoodEpoch)),Range(LFP{elec}),Data(LFP{elec}),1,2000);


[a3,b3,c3] = mETAverage(Range(Restrict(ts(sort(TStdXYall)),GoodEpoch)),Range(LFP{elec}),Data(LFP{elec}),1,2000);
[a4,b4,c4] = mETAverage(Range(Restrict(ts(sort(TDevXYall)),GoodEpoch)),Range(LFP{elec}),Data(LFP{elec}),1,2000);


[a5,b5,c5] = mETAverage(Range(Restrict(ts(sort(TglobalSTD)),GoodEpoch)),Range(LFP{elec}),Data(LFP{elec}),1,2000);
[a6,b6,c6] = mETAverage(Range(Restrict(ts(sort(TglobalDEV)),GoodEpoch)),Range(LFP{elec}),Data(LFP{elec}),1,2000);


n1=length(Range(Restrict(ts(TlocalSTD),GoodEpoch)));
n2=length(Range(Restrict(ts(TlocalDEV),GoodEpoch)));
n3=length(Range(Restrict(ts(TStdXYall),GoodEpoch)));
n4=length(Range(Restrict(ts(TDevXYall),GoodEpoch)));
n5=length(Range(Restrict(ts(TglobalSTD),GoodEpoch)));
n6=length(Range(Restrict(ts(TglobalDEV),GoodEpoch)));

figure('color',[1 1 1])
subplot(3,1,1), plot(c1,SmoothDec(a1,smo))
hold on, plot(c2,SmoothDec(a2,smo),'r')
yl=ylim;
hold on, line([0 0],yl,'color','k')
title([LFPnames{elec},' std n=',num2str(n1),', dev n=',num2str(n2)])
xlim([-600 600])

subplot(3,1,2), plot(c3,SmoothDec(a3,smo))
hold on, plot(c4,SmoothDec(a4,smo),'r')
yl=ylim;
hold on, line([0 0],yl,'color','k')
title([LFPnames{elec},' std n=',num2str(n3),', dev n=',num2str(n4)])
xlim([-600 600])

subplot(3,1,3), plot(c5,SmoothDec(a5,smo))
hold on, plot(c6,SmoothDec(a6,smo),'r')
yl=ylim;
hold on, line([0 0],yl,'color','k')
title([LFPnames{elec},' std n=',num2str(n5),', dev n=',num2str(n6)])
xlim([-600 600])


Res{1}=a1;
Res{2}=b1;
Res{3}=c1;
Res{4}=n1;

Res{5}=a2;
Res{6}=b2;
Res{7}=c2;
Res{8}=n2;

Res{9}=a3;
Res{10}=b3;
Res{11}=c3;
Res{12}=n3;

Res{13}=a4;
Res{14}=b4;
Res{15}=c4;
Res{16}=n4;

Res{17}=a5;
Res{18}=b5;
Res{19}=c5;
Res{20}=n5;

Res{21}=a6;
Res{22}=b6;
Res{23}=c6;
Res{24}=n6;

