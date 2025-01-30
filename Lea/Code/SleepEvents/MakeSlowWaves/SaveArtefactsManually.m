
%% Load TotalNoiseEpoch

% Check spectrum : 
% CheckBandpowerSpectrum

%load :
% try load StateEpochSB TotalNoiseEpoch
%     catch load Sleep TotalNoiseEpoch
% end    
% load NoiseHomeostasisLP TotalNoiseEpoch


%% Add artefact to Noise Epoch : 

% Start and End times of the artefact (in ZT time)
startZT = 11.285;
endZT= 11.32;

% Convert to ts time : 
s = startZT*3600e4 - min(Data(NewtsdZT)) ;
e = endZT*3600e4 - min(Data(NewtsdZT)) ;
artefact = intervalSet(s,e) ;

% Add artefact to TotalNoiseEpoch :
TotalNoiseEpoch = or(TotalNoiseEpoch,artefact) ;


%% Save TotalNoiseEpoch in NoiseHomeostasisLP.mat

save NoiseHomeostasisLP TotalNoiseEpoch


