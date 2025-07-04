%function CalculFeaturesSpikesMClust(spikes,tps)

%for i=1:size(spikes,2)
%sp(:,:,i)=spikes(:,i,:);
%end

% try
% sp=Wo;
% tps=1:size(Wo,1);
% end

sp=spikes;
tps=1:size(spikes,1);

ttChannelValidity=ones(size(spikes,2),1);
Params=[];


% INPUTS
%    V = TT tsd
%    ttChannelValidity = nCh x 1 of booleans
%
% OUTPUTS
%    Data - nSpikes x nCh peak values
%    Names - "Peak: Ch"

%    Params = 4x1 CellArray struct with fields
%             Params{}.pc (eigenvectos),
%             Params{}.av (averages),
%             Params{}.sd (std deviations)


V=tsd(tps*1E4,sp);


[PeakData, PeakNames,PeakPars] = feature_Peak(V, ttChannelValidity);

[PeakData2, PeakNames2,PeakPars2] = feature_PeakIndex(V, ttChannelValidity);

[PeakData3, PeakNames3,PeakPars3] = feature_PEAK10to18(V, ttChannelValidity);

[energyData, energyNames, energyPars] = feature_Energy(V, ttChannelValidity);

[energyData2, energyNames2, energyPars2] = feature_EnergyD1(V, ttChannelValidity);





[wavePCData, wavePCNames, wavePCPar] = feature_WavePC1(V, ttChannelValidity);

[wavePCData2, wavePCNames2, wavePCPar2] = feature_WavePC2(V, ttChannelValidity);

[wavePCData3, wavePCNames3, wavePCPar3] = feature_WavePC3(V, ttChannelValidity);


% INPUTS:
%     WV = tsd of nSpikes x nTrodes (4) x nChannels
%
% OUTPUTS:
%     sw = nSpikes x nTrodes (4) x spike width


sw = SpikeWidth(V);

p2v = PeakToValley(V);


[PeakMinData,PeakMaxData, PeakDataMi,PeakDataMa,PeakNames,PeakPars] = SpikeFeaturesKB(V);





