function GetStimDelay_AF(AllTimes)

for tt = 1:length(AllTimes)-1
    time1 = datetime(AllTimes{tt}(1:end-4),'InputFormat' ,'dd-MM-yyyy HH:mm:SS');
    time2 =  datetime(AllTimes{tt+1}(1:end-4),'InputFormat' ,'dd-MM-yyyy HH:mm:SS');
    DeltaT(tt) = seconds(time(between(time1,time2)));
end


end