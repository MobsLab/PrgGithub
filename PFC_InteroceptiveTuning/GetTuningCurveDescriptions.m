function [TuningCurves,MutInfo,CorrInfo,...
MutInfo_rand,CorrInfo_rand] = GetTuningCurveDescriptions(SpikePerBin,ParamValuePerBin,Opts)

%% Code writtedn by SV in 05/2025 to analyse tuning curves to variaous variables
%% Input
% - SpikePerBin : spike count per bin
% - ParamValuePerBin : parameter value in each bin, same size as SpikePerBin
% - Opts :
%   - NeuronBins : Bins for the calculation of mutual information
%   - TempBinsize : size of bin used to create input data (temporal)
%   - ParamBinLims : the bins to use for the parameter
%   - Num_bootstraps : number of bootstraps to run


%% Output
% - TuningCurves, structure containing tuning curves of various types
%       - AllData : calculated on all data
%       - HalfAn  : calculated on half of data after chopping data into 6
%       chunks of equal size and talking alternating chunks, this is used
%       for the anova
%       - HalfCV : the other half of data
%       - HalfAn_STD / HalfCV_STD : standard deviation around the mean
%       - HalfAn_Qrtiles / HalfCV_Qrtiles : difference between 75% and 25%
%       quartiles
%       - DistribParam : the number of bins used for each parameter value
%       - AnovaInfo : results of anova testing whether there is a signfiicant
%       effect of parameter value on the neuron firing
%   - MutInfo : Parameters related to the mutual information between the
%       spikes and the paramater
%       - MI : original calculation of mutual information
%       - SkaggsInfoPerSec : Information calculated with the formula for
%       spatial information taken from Skaggs 1993
%       - SkaggsInfoPerSpike : same but divided by spike count
%       - MI_btsrp : original calculation of mutual information
%       - SkaggsInfoPerSec_btsrp : Information calculated with the formula for
%       spatial information taken from Skaggs 1993
%       - SkaggsInfoPerSpike_btsrp : same but divided by spike count
%   - CorrInfo : info about correlation betwen spikes and parameter
%       - RSpk : correlation coefficient
%       - PSpk : pvalue for correlation
%       - RSpk_btsrp: on randomized data correlation coefficient
%       - PSpk_btsrp : on randomized data pvalue for correlation



% Distribution of spikes per bin, independant of parameter


[TuningCurves,MutInfo,CorrInfo] = CalculateTuningCurveDescriptors(SpikePerBin,ParamValuePerBin,Opts);

for btstrp = 1:Opts.Num_bootstraps
    num=ceil(rand*length(ParamValuePerBin));
    ParamValuePerBin_rand = fliplr([ParamValuePerBin(num+1:end);ParamValuePerBin(1:num)]')';
    [~,MutInfo_rand(btstrp),CorrInfo_rand(btstrp)] = CalculateTuningCurveDescriptors(SpikePerBin,ParamValuePerBin_rand,Opts);
end