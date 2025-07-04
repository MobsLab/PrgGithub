%RelationDeltaBulb

clear tDeltaT2
clear LFP
clear InfoLFP
clear T

load LFPData/InfoLFP
listBulb=InfoLFP.channel(strcmp(InfoLFP.structure,'Bulb'));


load DeltaPaCx

clear T
for i=1:15
eval(['load LFPData/LFP',num2str(i+1),'.mat'])
T{i}=PlotRipRaw(LFP,Range(tDeltaT2,'s'),500);title(InfoLFP.structure(i)),close
end

figure('color',[1 1 1]),
for i=1:15
subplot(2,2,1), hold on, plot(T{i}(:,1),T{i}(:,2),'color',[i/15 0 0])
end
title('PaCx')

for i=listBulb-1
subplot(2,2,2), hold on, plot(T{i}(:,1),T{i}(:,2),'color',[i/15 0 0])
end
title('PaCx (only Bulb)')


clear tDeltaT2
clear LFP
clear T


load DeltaPFCx

clear T
for i=1:15
eval(['load LFPData/LFP',num2str(i+1),'.mat'])
T{i}=PlotRipRaw(LFP,Range(tDeltaT2,'s'),500);title(InfoLFP.structure(i)),close
end

for i=1:15
subplot(2,2,3),hold on, plot(T{i}(:,1),T{i}(:,2),'color',[i/15 0 0])
end
title('PFCx')

for i=listBulb-1
subplot(2,2,4),hold on, plot(T{i}(:,1),T{i}(:,2),'color',[i/15 0 0])
end
title('PFCx (only Bulb)')

