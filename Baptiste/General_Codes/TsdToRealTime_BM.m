function Results= TsdToRealTime_BM(Time_tsd,Data_tsd,time_max)
% cut in 0,1s

% Initialize all episodes at 0
for i=1:size(Data_tsd,2)
    Time0(:,i) =Time_tsd(:,i)-Time_tsd(1,i);
end

% put NaN
Time0(Time0<0)=NaN;


% Bin for real time
clear Inter   ; clear results
bin=0:1000:time_max*10e3;
for i=1:length(bin)-1
    Inter=Data_tsd.*(Time0<bin(i+1)&Time0>bin(i));
    Inter(Inter==0)=NaN;
    Results(i)=nanmean(nanmean(Inter));
end
end




