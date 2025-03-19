% CaracterizationREMEvol

if 0
    cd /Users/Bench/Documents/Data/DataSleep244
    load('/Users/Bench/Documents/Data/DataSleep244/Sleep244.mat')
end

if 0
    res=pwd;
    tempchBulb=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
    chBulb=tempchBulb.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
    SpBulb=Sp;
    fBulb=f;
    tBulb=t;
    tempchHPC=load([res,'/ChannelsToAnalyse/dHPC_deep.mat'],'channel');
    chHPC=tempchHPC.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chHPC),'.mat'');'])
    SpHpc=Sp;
    fHpc=f;
    tHpc=t;
    tempchPFC=load([res,'/ChannelsToAnalyse/PFCx_deep.mat'],'channel');
    chPFC=tempchPFC.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chPFC),'.mat'');'])
    SpPfc=Sp;
    fPfc=f;
    tPfc=t;   
end

if 0
    
StsdH=tsd(tHpc*1E4,SpHpc);
StsdP=tsd(tPfc*1E4,SpPfc);
StsdB=tsd(tBulb*1E4,SpBulb);
TotalEpoch=intervalSet(tPfc(1)*1E4,tPfc(end)*1E4);
[Epoch,val,val2]=FindStrongOsc(SpBulb,tBulb,fBulb,TotalEpoch,1,[2 4],[0.1 1.5],[10 16]);

end

%------------------------------------------------------------------
%------------------------------------------------------------------

EpochOK=REMEpochC;
EpochOK=SWSEpochC;
EpochOK=WakeC;

StsdOK=StsdB;
fOK=fBulb;
% StsdOK=StsdP;
% fOK=fPfc;
% StsdOK=StsdH;
% fOK=fHpc;

freq=[2 4];
% freq=[6 10];
lim=20;

%------------------------------------------------------------------
%------------------------------------------------------------------


figure('color',[1 1 1]), 
subplot(1,3,1), plot(fBulb,mean(Data(Restrict(StsdB,EpochOK-Epoch{10}))))
hold on, plot(fBulb,mean(Data(Restrict(StsdB,and(EpochOK,Epoch{10})))),'r')
subplot(1,3,2), plot(fPfc,mean(Data(Restrict(StsdP,EpochOK-Epoch{10}))))
hold on, plot(fPfc,mean(Data(Restrict(StsdP,and(EpochOK,Epoch{10})))),'r')
subplot(1,3,3), plot(fHpc,mean(Data(Restrict(StsdH,EpochOK-Epoch{10}))))
hold on, plot(fHpc,mean(Data(Restrict(StsdH,and(EpochOK,Epoch{10})))),'r')

[r,p,r2,p2]=CrossFreqCoupling(SpPfc,tPfc,fPfc,SpHpc,tHpc,fHpc,EpochOK-Epoch{10});
[r,p,r2,p2]=CrossFreqCoupling(SpPfc,tPfc,fPfc,SpHpc,tHpc,fHpc,and(EpochOK,Epoch{10}));

[r,p,r2,p2]=CrossFreqCoupling(SpPfc,tPfc,fPfc,SpBulb,tBulb,fBulb,EpochOK-Epoch{10});
[r,p,r2,p2]=CrossFreqCoupling(SpPfc,tPfc,fPfc,SpBulb,tBulb,fBulb,and(EpochOK,Epoch{10}));

[r,p,r2,p2]=CrossFreqCoupling(SpBulb,tBulb,fBulb,SpHpc,tHpc,fHpc,EpochOK-Epoch{10});
[r,p,r2,p2]=CrossFreqCoupling(SpBulb,tBulb,fBulb,SpHpc,tHpc,fHpc,and(EpochOK,Epoch{10}));

clear dur
for i=1:length(Start(EpochOK))  
    dur(i)=sum(End(subset(EpochOK,i),'s')-Start(subset(EpochOK,i),'s'));
end

idREMok=find(dur>lim);
if length(idREMok)<3
    idREMok=1:length(Start(EpochOK));
end

REMok=subset(EpochOK,idREMok);


clear pow
clear PercBulbOsc
clear Per
tps=0:0.01:1;
ReNormT=zeros(length(tps),length(f));
ReNormT2=[];
for i=1:length(Start(REMok))
    clear IdxOB
    clear valEpoch
    Per(i,1)=sum(End(and(subset(REMok,i),Epoch{10}))-Start((and(subset(REMok,i),Epoch{10}))));
    Per(i,2)=sum(End((subset(REMok,i)-Epoch{10}))-Start(((subset(REMok,i)-Epoch{10}))));    
    [ReNormTemp{i},ff,tps]=RescaleSpectroram0to1(StsdOK,fOK,subset(REMok,i),tps);
    ReNormT=ReNormT+ReNormTemp{i};
    ReNormT2=[ReNormT2;ReNormTemp{i}];
    pow(i,:)=mean(ReNormTemp{i}(:,find(ff>freq(1)&ff<freq(2))),2);
    
    REMsubepoch=tsd(Range(Restrict(StsdOK,subset(REMok,i))),[1:length(Range(Restrict(StsdOK,subset(REMok,i))))]');
    rg=Range(REMsubepoch);
    IdxOB=Data(Restrict(REMsubepoch,Epoch{10}));
    valEpoch=zeros(length(Range(Restrict(StsdB,subset(REMok,i)))),1);
    valEpoch(IdxOB)=1;
    valEpochTsd=tsd((rg-rg(1))/(rg(end)-rg(1)), valEpoch);
    PercBulbOsc(i,:)=Data(Restrict(valEpochTsd,ts(tps)));
    %PercBulbOsc(i,:)=resample(valEpoch,length(tps),length(valEpoch));
end

figure('color',[1 1 1]), 
subplot(2,4,1:4), imagesc(tps,f,ReNormT'), axis xy
subplot(2,4,5), hold on, plot(Per(:,1)./(Per(:,1)+Per(:,2)),'k'), plot(Per(:,2)./(Per(:,1)+Per(:,2)),'r'), xlim([0 size(Per,1)])
subplot(2,4,6), imagesc(pow), axis xy
subplot(2,4,7), imagesc(zscore(pow)), axis xy
subplot(2,4,8), imagesc(PercBulbOsc), axis xy


