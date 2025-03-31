function [PercFirstHalf, PercSecHalf, PercFirstThird,PercSecThird,PercLastThird]=PercREMFirstSecHalf(REMEpoch,SWSEpoch,Wake,pas,plo)
%SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1);

try
    pas;
catch
    pas=500;
end

try
    plo;
catch
    plo=0;
end


maxlim=max([max(End(Wake)),max(End(REMEpoch)), max(End(SWSEpoch))]);

numpoints=floor(maxlim/pas/1E4)+1;

for i=1:numpoints
    per(i)=FindPercREM(REMEpoch,SWSEpoch, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tps(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end

if plo
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1);
hold on, plot(tps/1E4,rescale(per,-1,2),'ro-')
end

PercFirstHalf=nanmean(per(1:length(per)/2));
PercSecHalf=nanmean(per(length(per)/2:end));


PercFirstThird=nanmean(per(1:length(per)/3))
PercSecThird=nanmean(per(length(per)/3:2*length(per)/3))
PercLastThird=nanmean(per(2*length(per)/3:end))

%%%%
for i=1:1000
    
    per(i)=FindPercREM(REMEpoch,SWSEpoch, intervalSet((i-1)*1000E4,i*1000E4));
    tps(i)=(i*1000E4+(i-1)*1000E4)/2;
    
end
    
% % à trier
% SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1);
% hold on, plot(tps/1E4,rescale(per,1,3),'ro-')
% 
% nanmean(per(length(per)/2:end))
% 
% ans =
% 
%           10.3898081818243
% 
% nanmean(per(1:length(per)/2))
% 
% ans =
% 
%           17.3312864054557
% 
% max(End(SWSEpoch))
% 
% ans =
% 
%    421285008
% 
%  
% numpoints=floor(maxlim/pas)+1;
% 
% Error in PercREMFirstSecHalf (line 17)
% maxlim=max([max(End(Wake)),max(End(REMEpoch)), max(End(SWSEpoch))]);
%  
% [max(End(Wake)),max(End(REMEpoch)), max(End(SWSEpoch))]
% 
% ans =
% 
%    419475904   408297480   421285008
% 
% max([max(End(Wake)),max(End(REMEpoch)), max(End(SWSEpoch))])
% 
% ans =
% 
%    421285008
% 
% maxlim=max([max(End(Wake)),max(End(REMEpoch)), max(End(SWSEpoch))]);
% maxlim=max([max(End(Wake)),max(End(REMEpoch)), max(End(SWSEpoch))])
% 
% maxlim =
% 
%    421285008
% 
% 
%  
% 
%  
% PercFirstHalf,PercSecHalf, PercFirstThird,PercSecThird,PercLastThird
% 
% PercFirstHalf =
% 
%           14.9382651580436
% 
% 
% PercSecHalf =
% 
%            13.653482942405
% 
