figure
load('dHPC_sup_Low_Spectrum')
events=Start(TTLEpoch_merged)/1E4;
events=ts(events*1e4);
events=Restrict(events,REMEpoch);
events = Range(events);
clear M S
for i=1:length(Spectro{3})
    for  k =1:length(events)
 
    [M(i,k,:),S(i,k,:),t]=mETAverage(events(k),Range(sptsd),Spectro{1}(:,i),500,300);
    end
end

% figure
% plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
% hold on 
% plot(t,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)

Data_Mat=squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)));
hold on
shadedErrorBar(t,Data_Mat,{@mean,@stdError},'-k',1); 