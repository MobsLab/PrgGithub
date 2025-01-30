clear all
%% load data
load('SpikeData.mat');
load('NeuronClassification.mat')
idx_MUA = [];
idx_SUA = [];
% Get indexes of MUA and SUA
for i = 1:length(TT)
    if TT{i}(2) == 1
        idx_MUA(i) = i;
    else
        idx_SUA(i) = i;
    end
end
idx_MUA(idx_MUA==0) = [];
idx_SUA(idx_SUA==0) = [];
firingrates = GetFiringRate(S);

Quality.IsoD = Quality.IsoDistance;
Quality.SubjectiveQuality = Quality.MyMark;
A = char(Quality.MyMark);
A(A=='A') = '1';
A(A=='B') = '2';
A(A=='C') = '3';
Quality.SubjectiveQuality = str2num(A);
BasicNeuronInfo.idx_MUA = idx_MUA;
BasicNeuronInfo.idx_SUA = idx_SUA;
BasicNeuronInfo.firingrate = firingrates;
BasicNeuronInfo.neuroclass = UnitID(:,1);
BasicNeuronInfo.Quality = Quality;

f = PlotBasicSpikeData(BasicNeuronInfo, 1);