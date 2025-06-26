function [TuningCurves,MutInfo,CorrInfo] = CalculateTuningCurveDescriptors(SpikePerBin,ParamValuePerBin,Opts)

Distrib_Spikes = hist(SpikePerBin,Opts.NeuronBins)/(length(SpikePerBin));
MeanSpikeRate = nanmean(SpikePerBin)/Opts.TempBinsize;
AllSpkAnova = [];
AllIdAnova = [];
Opts.ParamBinLims = [-Inf,Opts.ParamBinLims,Inf];
for k=1:length(Opts.ParamBinLims)-1
    
    % Bins with right parameter value
    Bins = find(ParamValuePerBin>=Opts.ParamBinLims(k) & ParamValuePerBin<Opts.ParamBinLims(k+1));
    TuningCurves.DistribParam(k) = length(Bins);
    
    % If more than 6 bins, split into 6 blocks (to ensure time continuity),
    % if not just split in 2
    FoldValidation = 6;
    if length(Bins)>FoldValidation
        Bins = Bins(1:FoldValidation*floor(length(Bins)/FoldValidation));
        BinsSplit = reshape(Bins', (floor(length(Bins)/FoldValidation)),FoldValidation).';  % Transpose after column-wise reshape
        Bins_HalfAn = BinsSplit([1,3,5],:); Bins_HalfAn = Bins_HalfAn(:);
        Bins_HalfCV = BinsSplit([2,4,6],:); Bins_HalfCV = Bins_HalfCV(:);
        
    else
        Bins_HalfAn = Bins(1:2:end);
        Bins_HalfCV = Bins(2:2:end);
    end
    
    TuningCurves.AllData(k) = nanmean(SpikePerBin(Bins));
    Distrib_Spikes_Pos(k,:) = hist(SpikePerBin(Bins),Opts.NeuronBins)/(length(Bins));
    
    % do the anova on one half oF data, get tuning curve
    % on other
    TuningCurves.HalfAn(k) = nanmean(SpikePerBin(Bins_HalfAn));
    TuningCurves.HalfAn_STD(k) = nanstd(SpikePerBin(Bins_HalfAn));
    TuningCurves.HalfAn_Qrtiles(k) = prctile(SpikePerBin(Bins_HalfAn),75) - prctile(SpikePerBin(Bins_HalfAn),25);
    
    TuningCurves.HalfCV(k) = nanmean(SpikePerBin(Bins_HalfCV));
    TuningCurves.HalfCV_STD(k) = nanstd(SpikePerBin(Bins_HalfCV));
    TuningCurves.HalfCV_Qrtiles(k) = prctile(SpikePerBin(Bins_HalfCV),75) - prctile(SpikePerBin(Bins_HalfCV),25);
    
    
    AllSpkAnova = [AllSpkAnova;SpikePerBin(Bins_HalfAn)];
    AllIdAnova = [AllIdAnova;SpikePerBin(Bins_HalfAn)*0+k];
    
    TuningCurves.BinParamsReal(k) = nanmean(ParamValuePerBin(Bins));
end

% Perform the ANOVA
[pvalanova,tbl,stats] = anova1(AllSpkAnova,AllIdAnova,'off');
TuningCurves.AnovaInfo = pvalanova;

%% Information measures
Proba_ParamValue = (TuningCurves.DistribParam/sum(TuningCurves.DistribParam));

% Mutual information - full
% sum P(x) * P(s|x) * log2(P(s|x)/P(s))
clear pro
for k=1:length(Opts.ParamBinLims)-1
    for n = 1:length(Opts.NeuronBins)
        MIToSum(k,n) = Proba_ParamValue(k) * Distrib_Spikes_Pos(k,n) * log2(Distrib_Spikes_Pos(k,n)/Distrib_Spikes(n));
    end
end
MutInfo.MI = nansum(MIToSum(:));
MutInfo.MIPerSec = nansum(MIToSum(:))/Opts.TempBinsize;

% Mutual information - Skaggs
SpikeRatePerBin = TuningCurves.AllData;
MutInfo.SkaggsInfoPerSec = nansum(Proba_ParamValue.*SpikeRatePerBin.*log2(SpikeRatePerBin/nansum(Proba_ParamValue.*SpikeRatePerBin)))/Opts.TempBinsize; % bits per second
MutInfo.SkaggsInfoPerSpike = MutInfo.SkaggsInfoPerSec/MeanSpikeRate; % bits per spike

% Correlation
[R,P] = corrcoef(ParamValuePerBin,SpikePerBin);
CorrInfo.RSpk = R(1,2);
CorrInfo.PSpk = P(1,2);

end


