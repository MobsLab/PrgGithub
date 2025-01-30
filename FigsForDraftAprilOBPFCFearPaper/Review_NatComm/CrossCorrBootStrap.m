function [Resp,B] = CrossCorrBootStrap(Times,Spikes,BinSize,Dur)
%% This function performs multiple CrossCorr
%% while resampling half of your trial multiple times to get some idea of variability
HalfTimes = floor(length(Times)/2);

for perm = 1:1000
    Rand = randperm(length(Times));
    SubSampleTimes = Times(Rand(1:HalfTimes));
    [Resp(perm,:), B] = CrossCorr(SubSampleTimes,Spikes,BinSize,Dur);
end

end