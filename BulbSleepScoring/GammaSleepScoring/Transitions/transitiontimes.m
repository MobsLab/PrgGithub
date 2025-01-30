function [delta,goodper,good]=transitiontimes(data,sizedt,thresholds)
% data is transition periods, centered on sizedt, thresholds correspond to
% first and second half of thresholds

subdat1=log(data(:,1:sizedt));
subdat2=log(data(:,sizedt:end));

if thresholds(1)<thresholds(2)
logdat1=subdat1<thresholds(1);
logdat2=subdat2>thresholds(2);
else
logdat1=subdat1>thresholds(1);
logdat2=subdat2<thresholds(2);
end

good=find(any(logdat1,2)&any(logdat2,2));

uptime=[];
downtime=[];
for k=1:length(good)
uptime=[uptime,find(logdat1(good(k),:),1,'last')];
downtime=[downtime,find(logdat2(good(k),:),1,'first')];
end
downtime=downtime+sizedt;
delta=(downtime-uptime);

goodper=length(good)/size(data,1);
end