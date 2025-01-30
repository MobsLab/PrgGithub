function [PeakMinData,PeakMaxData, PeakDataMi,PeakDataMa,PeakNames,PeakPars] = SpikeFeaturesKB(V)

% MClust
% [PeakData, PeakNames] = SpikeFeaturesKB(V, ttChannelValidity)
% Calculate peak feature max value for each channel
%
% INPUTS
%    V = TT tsd
%    ttChannelValidity = nCh x 1 of booleans
%
% OUTPUTS
%    Data - nSpikes x nCh peak values
%    Names - "Peak6to11: Ch"
%

% ADR April 1998
% version M1.0
% RELEASED as part of MClust 2.0
% See standard disclaimer in Contents.m



TTData = Data(V);

[nSpikes, nCh, nSamp] = size(TTData);





PeakData = zeros(nSpikes, nSamp);

PeakNames = cell(nSamp, 1);
PeakPars = {};
PeakDataMi = squeeze(min(TTData(:, :, 14), [], 3));
PeakDataMa = squeeze(max(TTData(:, :, 18:26), [], 3));
[PeakMinData,id] = min(PeakDataMi');

for i=1:size(TTData,1)
PeakMaxData(i) = squeeze(max(TTData(i, id(i), 18:26), [], 3));
end


for iCh = 1:nSamp
   PeakNames{iCh} = ['Peak14: ' num2str(iCh)];
end
