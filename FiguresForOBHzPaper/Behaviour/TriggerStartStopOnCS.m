%29.11.2017

cd  /media/DataMOBsRAIDN/ProjetAversion/OptoFear/Fear_Mar2-July-Oct2017
res=pwd;
load(['EXT-24_fullperiod_close2sound_acc2'], 'bilan','gfpmice','chr2mice','StepName', 'Dir','period','bilanMovAccSmotsd','optionfullper','bilanMovAccSmotsd','bilanFreezeAccEpoch',...
    'csm','csp','CSplInt','CSmiInt')

load('EXT-24_fullperiod_close2sound_acc_epochs','CsminPer','CspluPer0','CspluPer1','CspluPer2','CspluPer3','NosoundNoLaserPer','NosoundWithLaserPer','csm','csp','CSplInt','CSmiInt')

Times=[-10:2.5:40];

figure
subplot(211)
FZTime_GFP=[];
for k=1:length(gfpmice)
    
    FzStart=ts(Stop(bilanFreezeAccEpoch{gfpmice(k)}));
    
    tps=Start(CSplInt);
    for int=1:2
        Ep=intervalSet(tps(int)-10*1e4,tps(int)+40*1e4);
        FZTime_GFP=[FZTime_GFP;Range(Restrict(FzStart,Ep))-tps(int)];
    end

end


FZTime_CHR2=[];
for k=1:length(chr2mice)
    
    FzStart=ts(Stop(bilanFreezeAccEpoch{chr2mice(k)}));
    
    tps=Start(CSplInt);
    for int=1:2
        Ep=intervalSet(tps(int)-10*1e4,tps(int)+40*1e4);
        FZTime_CHR2=[FZTime_CHR2;Range(Restrict(FzStart,Ep))-tps(int)];
    end

end

[Y_GFP,X]=hist(FZTime_GFP/1e4,Times);
[Y_CHR2,X]=hist(FZTime_CHR2/1e4,Times);
plot(X,Y_GFP,'k','linewidth',2), hold on
plot(X,Y_CHR2,'b','linewidth',2)

subplot(212)
FZTime_GFP=[];
for k=1:length(gfpmice)
    
    FzStart=ts(Stop(bilanFreezeAccEpoch{gfpmice(k)}));
    
    tps=Start(CSplInt);
    for int=3:4
        Ep=intervalSet(tps(int)-10*1e4,tps(int)+40*1e4);
        FZTime_GFP=[FZTime_GFP;Range(Restrict(FzStart,Ep))-tps(int)];
    end

end


FZTime_CHR2=[];
for k=1:length(chr2mice)
    
    FzStart=ts(Stop(bilanFreezeAccEpoch{chr2mice(k)}));
    
    tps=Start(CSplInt);
    for int=3:4
        Ep=intervalSet(tps(int)-10*1e4,tps(int)+40*1e4);
        FZTime_CHR2=[FZTime_CHR2;Range(Restrict(FzStart,Ep))-tps(int)];
    end

end
[Y_GFP,X]=hist(FZTime_GFP/1e4,Times);
[Y_CHR2,X]=hist(FZTime_CHR2/1e4,Times);
plot(X,Y_GFP,'k','linewidth',2), hold on
plot(X,Y_CHR2,'b','linewidth',2)




figure
FZTime_GFP=[];
for k=1:length(gfpmice)
    
    FzStart=ts(Stop(bilanFreezeAccEpoch{gfpmice(k)}));
    tps=Start(CSplInt);
    for int=3:length(tps)
        Ep=intervalSet(tps(int)-10*1e4,tps(int)+40*1e4);
        FZTime_GFP=[FZTime_GFP;Range(Restrict(FzStart,Ep))-tps(int)];
    end

end

FZTime_CHR2=[];
for k=1:length(chr2mice)
    
    FzStart=ts(Stop(bilanFreezeAccEpoch{chr2mice(k)}));
    
    tps=Start(CSplInt);
    for int=3:length(tps)
        Ep=intervalSet(tps(int)-10*1e4,tps(int)+40*1e4);
        FZTime_CHR2=[FZTime_CHR2;Range(Restrict(FzStart,Ep))-tps(int)];
    end

end

[Y_GFP,X]=hist(FZTime_GFP/1e4,Times);
[Y_CHR2,X]=hist(FZTime_CHR2/1e4,Times);
plot(X,Y_GFP,'k','linewidth',2), hold on
plot(X,Y_CHR2,'b','linewidth',2)

