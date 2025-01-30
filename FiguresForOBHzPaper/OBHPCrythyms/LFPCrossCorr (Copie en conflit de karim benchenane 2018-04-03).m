function [TimeBin,CorrVals]=LFPCrossCorr(LFP1,LFP2,Epoch,TimeLag)

% Time Lag in seconds

dt=median(diff(Range(LFP1,'s')));
NumLags=floor(TimeLag/dt);
Epoch=dropShortIntervals(Epoch,TimeLag*1.2*1e4);
Dur=Stop(Epoch,'s')-Start(Epoch,'s');
for st=1:length(Start(Epoch))
    
    dat1temp=Data(Restrict(LFP1,subset(Epoch,st)));
    dat2temp=Data(Restrict(LFP2,subset(Epoch,st)));
    [xcf(st,:),lags(st,:)] = crosscorr(dat1temp,dat2temp,NumLags);
     xcf(st,:)=xcf(st,:)*Dur(st);
end
CorrVals=mean(xcf)/sum(Dur);
TimeBin=lags(1,:);
end
% 
% 
% dt=median(diff(Range(LFP,'s')));
% NumLags=floor(TimeLag/dt);
% Epoch=dropShortIntervals(Epoch,TimeLag*1.2*1e4);
% Dur=Stop(Epoch,'s')-Start(Epoch,'s');
% for st=1:length(Start(Epoch))
%     
%     dat1temp=Data((LFPFil1{st,3}));
%     dat2temp=Data((LFPFil2{st,3}));
%     [xcf(st,:),lags(st,:)] = crosscorr(dat1temp,dat2temp,NumLags);
%      xcf(st,:)=xcf(st,:)*Dur(st);
% end
% CorrVals=mean(xcf)/sum(Dur);
% TimeBin=lags(1,:);