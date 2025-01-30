
function Hypnogram_LineColor_SB(Wake,SWSEpoch,REMEpoch,t,thr)

begin=t(1)/(1e4);
endin=t(end)/(1e4);

line([begin endin],[thr thr],'linewidth',10,'color','w')

clear sleepstart sleepstop
sleepstart=Start(Wake);
sleepstop=Stop(Wake);
for k=1:length(sleepstart)
    line([sleepstart(k)/(1e4) sleepstop(k)/(1e4)],[thr thr],'color','b','linewidth',5);
end

clear sleepstart sleepstop
sleepstart=Start(SWSEpoch);
sleepstop=Stop(SWSEpoch);
for k=1:length(sleepstart)
    line([sleepstart(k)/(1e4) sleepstop(k)/(1e4)],[thr thr],'color','r','linewidth',5);
end

clear sleepstart sleepstop
sleepstart=Start(REMEpoch);
sleepstop=Stop(REMEpoch);
for k=1:length(sleepstart)
    line([sleepstart(k)/(1e4) sleepstop(k)/(1e4)],[thr thr],'color','g','linewidth',5);
end



