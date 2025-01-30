function plotLFPevents(LFP,voies,LFPevent,delay, sp,plo)

try
    Start(LFPevent);
    temp(:,1)=Start(LFPevent,'s');
    temp(:,2)=(End(LFPevent,'s')-Start(LFPevent,'s'))/2;
    temp(:,3)=End(LFPevent,'s');
    LFPevent=temp;
end
try
    plo;
catch
    plo=1;
end
try
    sp;
catch
    sp=1000;
end


LFPeventLargeEpoch=intervalSet(LFPevent(:,1)*1E4-delay*1E4,LFPevent(:,3)*1E4+delay*1E4);
LFPeventEpoch=intervalSet(LFPevent(:,1)*1E4,LFPevent(:,3)*1E4);

if plo
figure
end



for i=1:length(voies)
    try
    tps=Range(Restrict(LFP{voies(i)},LFPeventLargeEpoch),'s');
    tpssub=Range(Restrict(LFP{voies(i)},LFPeventEpoch),'s');
    hold on, 
    plot(tps-tps(1),(i-1)*sp+Data(Restrict(LFP{voies(i)},LFPeventLargeEpoch)),'k')
    plot(tpssub-tpssub(1)+delay,(i-1)*sp+Data(Restrict(LFP{voies(i)},LFPeventEpoch)),'r')
    end
end








