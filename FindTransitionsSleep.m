function [transitiontimes,idxtransition, SleepStages]=FindTransitionsSleep(Epoch,stage1,stage2,plo,NoiseEpoch)

%[transitiontimes,idxtransition, SleepStages]=FindTransitionsSleep(Epoch,stage1,stage2,plo,NoiseEpoch)
%
% load('SleepSubstages.mat')
% Epoch{4}=mergeCloseIntervals(Epoch{4},10E4);
% Epoch{1}=Epoch{1}-Epoch{4};
% Epoch{2}=Epoch{2}-Epoch{4};
% Epoch{3}=Epoch{3}-Epoch{4};
% Epoch{5}=Epoch{5}-Epoch{4};
% Epoch{7}=Epoch{7}-Epoch{4};

try
    plo;
catch
    plo=0;
end
   
switch stage1(1:2)
    case 'Wa'
        i=4;
    case 'SW'
        i=1;
    case 'RE'
        i=3;
    case 'N1'
        i=2;
    case 'N2'
        i=1.5;
    case 'N3'
        i=1;
    case 'an'
        i=nan;
end
 
switch stage2(1:2)
    case 'Wa'
        j=4;
    case 'SW'
        j=1;
    case 'RE'
        j=3;
    case 'N1'
        j=2;
    case 'N2'
        j=1.5;
    case 'N3'
        j=1;
    case 'an'
        j=nan;
end
    
if length(Epoch)>3
    Wake=Epoch{5};
    REMEpoch=Epoch{4};
    SWSEpoch=or(Epoch{1},or(Epoch{2},Epoch{3}));    
%     SWSEpoch=Epoch{7};
    N1=Epoch{1};
    N2=Epoch{2};
    N3=Epoch{3};
elseif length(Epoch)==3
    Wake=Epoch{5};
    REMEpoch=Epoch{4};
    SWSEpoch=Epoch{7};  
end

st=min([Start(Wake,'s');Start(REMEpoch,'s');Start(SWSEpoch,'s')]);
en=max([End(Wake,'s');End(REMEpoch,'s');End(SWSEpoch,'s')]);
timeTsd=tsd(st*1E4:500:en*1E4,zeros(length(st*1E4:500:en*1E4),1));

SleepStages=5*ones(1,length(Range(timeTsd)));
rg=Range(timeTsd);

rgREM=Range(Restrict(timeTsd,REMEpoch));
idREM=(find(ismember(rg,rgREM)==1));
rgwake=Range(Restrict(timeTsd,Wake));
idwake=(find(ismember(rg,rgwake)==1));
rgSWS=Range(Restrict(timeTsd,SWSEpoch));
idSWS=(find(ismember(rg,rgSWS)==1));
rgN1=Range(Restrict(timeTsd,N1));
idN1=(find(ismember(rg,rgN1)==1));
rgN2=Range(Restrict(timeTsd,N2));
idN2=(find(ismember(rg,rgN2)==1));
rgN3=Range(Restrict(timeTsd,N3));
idN3=(find(ismember(rg,rgN3)==1));

try
    SleepStages(idwake)=4;
end
try
    SleepStages(idREM)=3;
end
if length(Epoch)==3
    try
        SleepStages(idSWS)=1;
    end
elseif length(Epoch)>3
    try
        SleepStages(idN1)=2;
    end
    try
        SleepStages(idN2)=1.5;        
    end
    try
        SleepStages(idN3)=1;
    end
end
    
idx=find(diff(SleepStages)~=0);
if ~isnan(j)
tr=find(SleepStages(idx+1)==j);
else
tr=find(SleepStages(idx+1)<10);    
end

if ~isnan(i)
idxtransition=find(SleepStages(idx(tr))==i);
else
idxtransition=find(SleepStages(idx(tr))<10);   
end

%%

idxtr=idx(tr(idxtransition));
transitiontimes=rg(idx(tr(idxtransition))+1);


%%

if plo
    
figure('color',[1 1 1]), 
subplot(4,1,1:3), hold on
line([transitiontimes transitiontimes]',[zeros(length(transitiontimes),1) 5*ones(length(transitiontimes),1)]','color',[0 0.6 0],'linewidth',1)
plot(rg, SleepStages,'.-','color',[0.7 0.7 0.7])
plot(rg(SleepStages==4),SleepStages(SleepStages==4),'.','color','k') %wake
plot(rg(SleepStages==3),SleepStages(SleepStages==3),'.','color','r') % REM
if length(Epoch)==3
plot(rg(SleepStages==2),SleepStages(SleepStages==2),'.','color','b') % SWS
set(gca,'ytick',[2 3 4])
set(gca,'yticklabel',{'SWS','REM','Wake'})
else
plot(rg(SleepStages==2),SleepStages(SleepStages==2),'.','color','c') % N1
plot(rg(SleepStages==1.5),SleepStages(SleepStages==1.5),'.','color','b') % N2
plot(rg(SleepStages==1),SleepStages(SleepStages==1),'.','color',[0 0 0.6]) % N3
set(gca,'ytick',[1,1.5 2 3 4])
set(gca,'yticklabel',{'N3','N2','N1','REM','Wake'})
end
ylim([0.5 5]),xlim([rg(1) rg(end)])
plot(transitiontimes,5,'.','color',[0 0.6 0])
title([stage1,' to ',stage2, ', n=',num2str(length(idxtransition))])
subplot(4,1,4), hold on
plot(transitiontimes,cumsum(transitiontimes)/max(cumsum(transitiontimes)),'color',[0 0.6 0],'linewidth',2)
plot([0:60E4:rg(end)],hist(transitiontimes,[0:60E4:rg(end)])/max(hist(transitiontimes,[0:60E4:rg(end)])),'k')
ylim([0 1])
xlim([rg(1) rg(end)])
end

SleepStages=tsd(rg,SleepStages');
