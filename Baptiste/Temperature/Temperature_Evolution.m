Mouse_name={'M893'};

clear sess_name
for k=1:length(FolderList.(Mouse_name{1}).Fear)
sess_name{k}={['sess' num2str(k)]};
end

%Gathering all Temperature TSD in an object
error={}; clear TT;
for ff=1:length(FolderList.(Mouse_name{1}).Fear)
    try cd([FolderList.(Mouse_name{1}).Fear{ff}  '/Temperature'])
        load('Temperature.mat')
        
       TT.(sess_name{ff}{1})=Temp.TailTemperatureTSD;
        
    catch error{ff}=FolderList.(Mouse_name{1}).Fear{ff};
    end
end

clear TempEvolutionRange; clear TempEvolutionData
for k=1:length(sess_name)
    TempEvolutionRange(1:length(Range(TT.(sess_name{k}{1}))),k)=Range(TT.(sess_name{k}{1}));
    TempEvolutionData(1:length(Range(TT.(sess_name{k}{1}))),k)=Data(TT.(sess_name{k}{1}));
end

clear TempEvolutionData_prop
for k=1:length(sess_name)
    for p=1:100
        if p==1
       % TempEvolutionRange(:,k)<max(TempEvolutionRange(:,k))/100; 1% low
    TempEvolutionData_prop(k,p)=nanmean(TempEvolutionData(TempEvolutionRange(:,k)<max(TempEvolutionRange(:,k))/100));
        else
    TempEvolutionData_prop(k,p)=nanmean(TempEvolutionData(TempEvolutionRange(:,k)<(max(TempEvolutionRange(:,k)/100)*(p+1))&(TempEvolutionRange(:,k)>(max(TempEvolutionRange(:,k))/100)*p)));
        end 
        end
end

TempEvolutionData_prop(TempEvolutionData_prop==0)=NaN;
TempEvolutionData_prop(TempEvolutionData_prop<15)=NaN;

TemperatureEvolution.(Mouse_name{1})=nanmean(TempEvolutionData_prop);


plot(TemperatureEvolution.(Mouse_name{1})); 




plot(TemperatureEvolution.M777Fear); plot(TemperatureEvolution.M779Fear);
xlabel('proportional time')
ylabel('T°')
title('Mean Tail Temperature during sessions')
legend('Mouse 688','Mouse 739','Mouse 777','Mouse 779')


save('DataTemperature688_739_777_779.mat','TemperatureEvolution','-append')


figure; plot(TemperatureEvolution.M688NoFear); hold on; plot(TemperatureEvolution.M739NoFear); 
plot(TemperatureEvolution.M777NoFear); plot(TemperatureEvolution.M779NoFear);
xlabel('proportional time')
ylabel('T°')
title('Mean Tail Temperature during NoFear sessions')
legend('Mouse 688','Mouse 739','Mouse 777','Mouse 779')






