% CrossCorrRiplplesDelta
% CrossCorrelogram Ripples vs (Delta waves or Down states)
% Reproduce figure


%%

try
    load SleepScoring_OBGamma SWSEpoch Wake REMEpoch
    SWSEpoch;
catch  
    load StateEpochSB SWSEpoch Wake REMEpoch
    SWSEpoch;
end

try
load SleepSubstages Epoch
N1=Epoch{1};
N2=Epoch{2};
N3=Epoch{3};
clear Epoch
end

 Epoch=SWSEpoch;
% Epoch=or(N2,N3);
%Epoch=or(N2,or(N1,N3));
%Epoch=N2;



%%
load Ripples 

try
    Ripples;
    if exist('Epoch')
    rip=ts(Ripples(:,2)*10);
    rip=Restrict(rip,Epoch);
    clear Ripples
    Ripples(:,1)=Range(rip,'ms');
    Ripples(:,2)=Range(rip,'ms');
    end
catch
    if exist('Epoch')
    [test,idx]=Restrict(tRipples,Epoch);
    st=Start(RipplesEpoch,'ms');
    en=End(RipplesEpoch,'ms');
    Ripples(:,1)=st(idx);
    Ripples(:,3)=en(idx);
    Ripples(:,2)=Range(Restrict(tRipples,Epoch),'ms');
    else
    Ripples(:,1)=Start(RipplesEpoch,'ms');
    Ripples(:,3)=End(RipplesEpoch,'ms');
    Ripples(:,2)=Range(tRipples,'ms');
    end
end

try
    load DownState down_PFCx
end
load DeltaWaves deltas_PFCx
if exist('Epoch')
deltas_PFCx=and(deltas_PFCx,Epoch);
end

%%
[C,B]=CrossCorr(Start(deltas_PFCx),Ripples(:,2)*10,10,100);
[C1,B1]=CrossCorr(Start(deltas_PFCx),Ripples(:,2)*10,100,100);
[C2,B2]=CrossCorr(Start(deltas_PFCx),Ripples(:,2)*10,1000,100);
[Ce,Be]=CrossCorr(End(deltas_PFCx),Ripples(:,2)*10,10,100);
[C1e,B1e]=CrossCorr(End(deltas_PFCx),Ripples(:,2)*10,100,100);
[C2e,B2e]=CrossCorr(End(deltas_PFCx),Ripples(:,2)*10,1000,100);


figure, 
subplot(3,2,1), plot(B/1E3,C,'k'), line([0 0],ylim,'color',[0.8 0.8 0.8]), title(pwd)
subplot(3,2,3), plot(B1/1E3,C1,'k'), line([0 0],ylim,'color',[0.8 0.8 0.8])
subplot(3,2,5), plot(B2/1E3,C2,'k'), line([0 0],ylim,'color',[0.8 0.8 0.8])
subplot(3,2,2), plot(Be/1E3,Ce,'k'), line([0 0],ylim,'color',[0.8 0.8 0.8])
subplot(3,2,4), plot(B1e/1E3,C1e,'k'), line([0 0],ylim,'color',[0.8 0.8 0.8])
subplot(3,2,6), plot(B2e/1E3,C2e,'k'), line([0 0],ylim,'color',[0.8 0.8 0.8])



