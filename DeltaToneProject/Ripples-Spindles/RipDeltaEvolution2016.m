function [rRip,pRip,rD,pD,rDRip,pDRip,rDNoRip,pDNoRip,NbRip,NbDown,NbDownRip,NbDownNoRip,Bs,CsRip,CeRip]=RipDeltaEvolution2016(contrlAutoCorr,DeltaByLFP,plo)

try
    contrlAutoCorr(1);
catch
    contrlAutoCorr=0;
end

try
    DeltaByLFP(1);
catch
    DeltaByLFP=1;
end

try
    plo;
catch
    plo=1;
end


smoo=3;
smoD=0;
smo=0;

bin1=10;bin2=100;
%----------------------------------------------------------------------
%----------------------------------------------------------------------
%----------------------------------------------------------------------

load StateEpochSB SWSEpoch Wake REMEpoch

try
    load RipplesdHPC25
    dHPCrip;
    rip=ts(dHPCrip(:,2)*1E4);
catch
    disp(' ')
    disp('   ________ FIND RIPPLES ________ ')
    clear dHPCrip
    clear rip
    res=pwd;
    load StateEpochSB SWSEpoch
    tempchHPC=load([res,'/ChannelsToAnalyse/dHPC_rip.mat'],'channel'); % changed by Marie 3june2015
    chHPC=tempchHPC.channel;
    eval(['tempLoad=load([res,''/LFPData/LFP',num2str(chHPC),'.mat''],''LFP'');'])
    eegRip=tempLoad.LFP;
    [dHPCrip,EpochRip]=FindRipplesKarimSB(eegRip,SWSEpoch,[2 5]);
    save([res,'/RipplesdHPC25.mat'],'dHPCrip','EpochRip','chHPC');
    clear dHPCrip EpochRip chHPC
end


if DeltaByLFP
    load newDeltaPFCx
    Down=DeltaEpoch;
end
siz=20E4;

clear doNoRip
clear doRip

do=Start(Down);

a=1;b=1;
for i=1:length(do)
    id=find(dHPCrip(:,2)*1E4<do(i));
    try
        if (do(i)-dHPCrip(id(end),2)*1E4)<0.2E4
            doRip(a)=do(i);
            a=a+1;
        else
            doNoRip(b)=do(i);
            b=b+1;
        end
    end
end

ST1{1}=ts(Start(Down));
try
    ST1=tsdArray(ST1);
end
Q=MakeQfromS(ST1,siz);
if smo>0
    QDelta=tsd(Range(Q),smooth(full(Data(Q)),smo));
else
    QDelta=tsd(Range(Q),full(Data(Q)));
end

ST2{1}=ts(doRip);
try
    ST2=tsdArray(ST2);
end
Q=MakeQfromS(ST2,siz);

if smo>0
    QDeltaRip=tsd(Range(Q),smooth(full(Data(Q)),smo));
else
    QDeltaRip=tsd(Range(Q),full(Data(Q)));
end

ST3{1}=ts(doNoRip);
try
    ST3=tsdArray(ST3);
end
Q=MakeQfromS(ST3,siz);
if smo>0
    QDeltaNoRip=tsd(Range(Q),smooth(full(Data(Q)),smo));
else
    QDeltaNoRip=tsd(Range(Q),full(Data(Q)));
end

ST4{1}=ts(dHPCrip(:,2)*1E4);
try
    ST4=tsdArray(ST4);
end
Q=MakeQfromS(ST4,siz);
if smo>0
    QRip=tsd(Range(Q),smooth(full(Data(Q)),smo));
else
    QRip=tsd(Range(Q),full(Data(Q)));
end


% Plot Sleep Stages and Delta/Ripples Quantity
if plo
    figure('color',[1 1 1])
    subplot(3,1,1), SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0);
    hold on,ylabel('Ripples'), xlabel('Time'),title('Sleep Stages Classification')
    subplot(3,1,2), hold on,
    plot(Range(QDelta,'s'),SmoothDec(Data(QDelta),smoD))
    plot(Range(QRip,'s'),SmoothDec(Data(QRip),smoD),'r'), xlabel('Time'),title('Delta (blue) & Ripples (red) Quantity')
    subplot(3,1,3), hold on,
    plot(Range(QDeltaRip,'s'),SmoothDec(Data(QDeltaRip),smoD),'k')
    plot(Range(QDeltaNoRip,'s'),SmoothDec(Data(QDeltaNoRip),smoD),'r'), xlabel('Time'),title('Delta Quantity w/without Ripples')
else
    SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch);close
end

tps1=Range(QDeltaRip,'s');
data1=Data(QDeltaRip);
tps2=Range(QDeltaNoRip,'s');
data2=Data(QDeltaNoRip);

tps3=Range(QDelta,'s');
data3=Data(QDelta);
tps4=Range(QRip,'s');
data4=Data(QRip);

id1=find(data1>0);
id2=find(data2>0);
id3=find(data3>0);
id4=find(data4>0);
[rDRip,pDRip]=corrcoef(tps1(id1),data1(id1));
[rDNoRip,pDNoRip]=corrcoef(tps2(id2),data2(id2));
[rD,pD]=corrcoef(tps3(id3),data3(id3));
[rRip,pRip]=corrcoef(tps4(id4),data4(id4));

rDRip=rDRip(2,1);
pDRip=pDRip(2,1);
rDNoRip=rDNoRip(2,1);
pDNoRip=pDNoRip(2,1);
rRip=rRip(2,1);
pRip=pRip(2,1);
rD=rD(2,1);
pD=pD(2,1);

rg=Range(SleepStages);

try
    load EpochToAnalyse
    for i=1:5
        EpochToAnalyse{i}=and(EpochToAnalyse{i},SWSEpoch);
    end
catch
   EpochToAnalyse{1}=and(intervalSet(rg(1),2*rg(end)/5),SWSEpoch);
    EpochToAnalyse{2}=and(intervalSet(2*rg(end)/5,3*rg(end)/5),SWSEpoch);
    EpochToAnalyse{3}=and(intervalSet(3*rg(end)/5,4*rg(end)/5),SWSEpoch);
    EpochToAnalyse{4}=and(intervalSet(4*rg(end)/5,rg(end)),SWSEpoch);
    EpochToAnalyse{5}=and(intervalSet(4*rg(end)/5,rg(end)),SWSEpoch);
end


for i=1:5
    NbDownRip(i)=length(Range(Restrict(ts(doRip),EpochToAnalyse{i})))/sum(End(EpochToAnalyse{i},'s')-Start(EpochToAnalyse{i},'s'));
    NbDownNoRip(i)=length(Range(Restrict(ts(doNoRip),EpochToAnalyse{i})))/sum(End(EpochToAnalyse{i},'s')-Start(EpochToAnalyse{i},'s'));
    NbDown(i)=length(Range(Restrict(ts(Start(Down)),EpochToAnalyse{i})))/sum(End(EpochToAnalyse{i},'s')-Start(EpochToAnalyse{i},'s'));
    NbRip(i)=length(Range(Restrict(rip,EpochToAnalyse{i})))/sum(End(EpochToAnalyse{i},'s')-Start(EpochToAnalyse{i},'s'));
end

clear CsRip
clear CeRip
clear CsSpk
clear CeSpk


if contrlAutoCorr
    st=Start(Down,'s');en=End(Down,'s');
    idx=find((st(2:end)-en(1:end-1)>(bin1*bin2)/1E3));%&(en(1:end-1)-st(2:end)>(bin1*bin2)/1E3));
else
    idx=1:length(Start(Down));
end

for i=1:5
    [CsRip(i,:),Bs]=CrossCorr(Start(and(subset(Down,idx),EpochToAnalyse{i})),dHPCrip(:,2)*1E4,bin1,bin2);
    [CeRip(i,:),Be]=CrossCorr(End(and(subset(Down,idx),EpochToAnalyse{i})),dHPCrip(:,2)*1E4,bin1,bin2);
end

if plo
    colorC{1}='k';
    colorC{2}='r';
    colorC{3}=[0.5 0.5 1];
    colorC{4}='m';
    colorC{5}=[0.7 0.7 0.7];
    
    figure('color',[1 1 1]),
    subplot(1,2,1), hold on
    for i=1:5
        plot(Bs/1E3,smooth(CsRip(i,:),smoo),'color',colorC{i})
    end
    yl=ylim; line([0 0],yl,'color','b')
    if contrlAutoCorr
        title('Correction No Delta burst')
    else
        title('No Correction No Delta burst')
    end
    subplot(1,2,2), hold on
    for i=1:5
        plot(Be/1E3,smooth(CeRip(i,:),smoo),'color',colorC{i})
    end
    yl=ylim; line([0 0],yl,'color','b')
    if contrlAutoCorr
        title('Correction No Delta burst')
    else
        title('No Correction No Delta burst')
    end

end


