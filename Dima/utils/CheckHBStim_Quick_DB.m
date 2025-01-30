StimTime = Start(TTLInfo.StimEpoch)/1e4;

for i=1:length(StimTime)
    figure
    plot(Range(EKG.LFP,'s'),Data(EKG.LFP))
    xlim([StimTime(i)-1 StimTime(i)+1])
    yl = ylim;
    hold on
    temp = Restrict(EKG.HBTimes,intervalSet(StimTime*1e4-3*1e4,StimTime*1e4+3*1e4));
    Times = Range(temp);
    Beats = linspace((yl(2)-yl(2)*0.2),(yl(2)-yl(2)*0.2),length(Times));
    scatter(Times(1:end)/1e4,Beats,'*')
    
    clear yl temp Times Beats
end