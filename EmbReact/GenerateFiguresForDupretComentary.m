Ep = intervalSet(15221.3*1e4,15223.2*1e4);
for k = 14:length(Subgroups)
load(['/media/vador/DataMOBS89/Moue793/M793_SleepBaselin_180926_084618/LFPData/LFP',num2str(Subgroups(k)),'.mat'])
plot(Range(Restrict(LFP,Ep),'s'),Data(Restrict(LFP,Ep))-1200*k,'color','k'), hold on
end

figure
Ep = intervalSet(33187*1e4,33188.5*1e4);
Ep = intervalSet(33168.5*1e4,33169.5*1e4);

for k = 15:length(Subgroups)
load(['/media/vador/DataMOBS89/Moue793/M793_SleepBaselin_180926_084618/LFPData/LFP',num2str(Subgroups(k)),'.mat'])
plot(Range(Restrict(LFP,Ep),'s'),Data(Restrict(LFP,Ep))-1200*k,'color','k'), hold on
end

clf
for k = 15:length(Subgroups)
    [data, ind] = GetWideBandData(Subgroups(k),'intervals',[33187 33188.5]);
plot(data(:,2)-1500*k,'color','k'), hold on
end
xlim([3203.25250471904          5089.06635690431])


Ep = intervalSet(15221.3*1e4,15223.2*1e4);
for k = 14:length(Subgroups)
load(['/media/vador/DataMOBS89/Moue793/M793_SleepBaselin_180926_084618/LFPData/LFP',num2str(Subgroups(k)),'.mat'])
[M,T] = PlotRipRaw(LFP,Ripples(1:100,2)/1000,50,0,0);
plot(M(:,1),M(:,2)-1500*k,'color','k'), hold on
end

clf
for k = 14:length(Subgroups)
ToPlot = find(hpc_channels==Subgroups(k));
plot(ripples_curves{ToPlot}(:,2)-400*k,'color','k'), hold on
    
end

clf
Ep = intervalSet(15221.3*1e4,15223.2*1e4);
for k = 14:length(Subgroups)
        [data, ind] = GetWideBandData(Subgroups(k),'intervals',[15221.3 15223.2]);
plot(data(:,1),data(:,2)-1200*k,'color','k'), hold on

end
